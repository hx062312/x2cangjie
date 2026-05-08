"""
插桩工具：在每个 _test.cj 执行前，根据工作日志找出有真实 side effect 的被拦截依赖方法，
在被测方法（focal method）的 Cangjie 源文件中，对应依赖调用语句之后插入赋值语句回放 side effect。
测试结束后通过 deinstrument 扫描并清除所有 stub 块。

插桩逻辑：
  - Static Fields Changed → 静态字段赋值语句
  - Instance Final       → 对 receiver 变量的字段赋值
  - Args Final（真实 mutation）→ 对调用点实参变量的赋值
  以上均插入到 focal method 源文件中对应 callee 调用语句的正后方。
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

STUB_OPEN  = "// __SIDEEFFECT_STUB_BEGIN__"
STUB_CLOSE = "// __SIDEEFFECT_STUB_END__"

_THIS_DIR = Path(__file__).parent
if str(_THIS_DIR) not in sys.path:
    sys.path.insert(0, str(_THIS_DIR))

from mock_helper import (
    _deep_equal,
    _is_mutable_snapshot,
    render_in_place_mutation,
    update_static_fields,
)


# ===========================================================================
# 从测试文件提取 focal method 信息
# ===========================================================================

def _extract_focal_info(test_cj_path: str) -> tuple[str, str] | None:
    """从 _test.cj 的 '// focal call: ...' 注释中提取 class 名和 method 名。"""
    for line in Path(test_cj_path).read_text(encoding="utf-8").splitlines():
        m = re.search(r"//\s*focal call:\s*[\w.$]+\.(\w+)\.(\w+)", line)
        if m:
            return m.group(1), m.group(2)
    return None


# ===========================================================================
# 查找 focal class 所在的 Cangjie 源文件
# ===========================================================================

def _find_source_file(cj_main_dir: str, class_name: str) -> Path | None:
    root = Path(cj_main_dir)
    for p in root.rglob(f"{class_name}.cj"):
        return p
    for p in root.rglob("*.cj"):
        if re.search(rf'\bclass\s+{re.escape(class_name)}\b', p.read_text(encoding="utf-8")):
            return p
    return None


# ===========================================================================
# 定位 focal method 体的行范围
# ===========================================================================

def _find_method_body_range(lines: list[str], method_name: str) -> tuple[int, int]:
    """返回 focal method 体的 [start, end)，找不到返回 (-1, -1)。"""
    pat = re.compile(rf'\bfunc\s+{re.escape(method_name)}\b')
    for i, line in enumerate(lines):
        if pat.search(line):
            depth = 0
            body_start = -1
            for j in range(i, len(lines)):
                for c in lines[j]:
                    if c == '{':
                        if depth == 0:
                            body_start = j
                        depth += 1
                    elif c == '}':
                        depth -= 1
                        if depth == 0:
                            return body_start, j + 1
            break
    return -1, -1


# ===========================================================================
# 在方法体内查找 callee 调用行
# ===========================================================================

def _find_call_line(
    lines: list[str],
    body_start: int,
    body_end: int,
    short_name: str,
    occurrence_idx: int,
) -> int:
    """找第 occurrence_idx 次调用 short_name( 的全局行号，找不到返回 -1。"""
    pat = re.compile(rf'\b{re.escape(short_name)}\s*\(')
    found = 0
    for i in range(body_start, body_end):
        if pat.search(lines[i]):
            if found == occurrence_idx:
                return i
            found += 1
    return -1


# ===========================================================================
# 解析调用实参和 receiver
# ===========================================================================

def _parse_call_args(line: str, short_name: str) -> list[str]:
    """从调用行中提取实参列表，正确处理嵌套括号。"""
    pat = re.compile(rf'\b{re.escape(short_name)}\s*\(')
    m = pat.search(line)
    if not m:
        return []
    i = m.end()
    depth, current, args = 1, [], []
    while i < len(line) and depth > 0:
        c = line[i]
        if c in "([{":
            depth += 1
            current.append(c)
        elif c in ")]}":
            depth -= 1
            if depth == 0:
                args.append("".join(current).strip())
            else:
                current.append(c)
        elif c == "," and depth == 1:
            args.append("".join(current).strip())
            current = []
        else:
            current.append(c)
        i += 1
    return [a for a in args if a]


def _parse_receiver(line: str, short_name: str) -> str | None:
    """提取 receiver.short_name(...) 中的 receiver；静态调用（类名.方法名）返回 None。"""
    pat = re.compile(rf'(\w[\w.]*)\s*\.\s*{re.escape(short_name)}\s*\(')
    m = pat.search(line)
    if not m:
        return None
    candidate = m.group(1)
    # 类名首字母大写视为静态调用，不算 receiver
    if candidate and candidate[0].isupper():
        return None
    return candidate


# ===========================================================================
# 判断是否有真实 side effect
# ===========================================================================

def _minimize_to_changed_fields(initial: Any, final: Any) -> Any:
    """
    返回 final 的"变更子集"快照：仅保留 instance_fields 中与 initial 不同的字段。
    集合类型（ArrayList 等）原样返回，因为它们走的是 reset 整体替换路径。
    """
    if not isinstance(initial, dict) or not isinstance(final, dict):
        return final
    init_fields = initial.get("instance_fields")
    final_fields = final.get("instance_fields")
    if not isinstance(init_fields, dict) or not isinstance(final_fields, dict):
        return final
    changed: dict[str, Any] = {}
    for fname, ffinal in final_fields.items():
        finit = init_fields.get(fname)
        if finit is None:
            changed[fname] = ffinal
            continue
        if _deep_equal(finit, ffinal):
            continue
        changed[fname] = _minimize_to_changed_fields(finit, ffinal)
    result = dict(final)
    result["instance_fields"] = changed
    return result


def _real_arg_mutations(method_dict: dict) -> dict[int, Any]:
    initial_map = {int(idx): snap for idx, snap in method_dict.get("Args Initial", [])}
    result: dict[int, Any] = {}
    for idx_str, final_snap in method_dict.get("Args Final", []):
        idx = int(idx_str)
        initial_snap = initial_map.get(idx)
        if initial_snap is None:
            continue
        if _deep_equal(initial_snap, final_snap):
            continue
        if not _is_mutable_snapshot(final_snap):
            continue
        result[idx] = _minimize_to_changed_fields(initial_snap, final_snap)
    return result


def _has_real_side_effects(method_dict: dict) -> bool:
    return bool(
        method_dict.get("Static Fields Changed")
        or method_dict.get("Instance Final")
        or _real_arg_mutations(method_dict)
    )


# ===========================================================================
# 生成 stub 赋值语句
# ===========================================================================

def _gen_stub_lines(
    method_dict: dict,
    call_args: list[str],
    receiver: str | None,
) -> list[str]:
    body: list[str] = []

    static_lines = update_static_fields(method_dict.get("Static Fields Changed", []))
    body.extend(static_lines)

    instance_final = method_dict.get("Instance Final")
    instance_initial = method_dict.get("Instance Initial")
    if instance_final and receiver and not _deep_equal(instance_initial, instance_final):
        minimized = _minimize_to_changed_fields(instance_initial, instance_final)
        mut_lines, _ = render_in_place_mutation(receiver, minimized)
        body.extend(mut_lines)

    for arg_idx, final_snap in _real_arg_mutations(method_dict).items():
        if arg_idx < len(call_args):
            mut_lines, _ = render_in_place_mutation(call_args[arg_idx], final_snap)
            body.extend(mut_lines)

    if not body:
        return []
    return [STUB_OPEN, *body, STUB_CLOSE]


# ===========================================================================
# 一次性应用编辑
# ===========================================================================

def _is_return_call_line(line: str) -> bool:
    """判断该行是否形如 `return <expr>(...)` —— 此时桩必须插在该行之前。"""
    return bool(re.match(r'\s*return\s+\S', line))


def _apply_edits(
    original_lines: list[str],
    inserts_before: dict[int, list[str]],
    inserts_after: dict[int, list[str]],
) -> str:
    result: list[str] = []
    for i, line in enumerate(original_lines):
        indent = line[: len(line) - len(line.lstrip())]
        if i in inserts_before:
            for stub_line in inserts_before[i]:
                result.append(f"{indent}{stub_line}\n")
        result.append(line)
        if i in inserts_after:
            for stub_line in inserts_after[i]:
                result.append(f"{indent}{stub_line}\n")
    return "".join(result)


# ===========================================================================
# 主接口
# ===========================================================================

def instrument(test_cj_path: str, workflow_json_path: str, cj_main_dir: str) -> str | None:
    """
    在 focal method 源文件中对每个有 side effect 的 callee 调用后插桩。
    返回被修改的源文件路径，无需插桩时返回 None。
    """
    focal_info = _extract_focal_info(test_cj_path)
    if not focal_info:
        return None
    class_name, method_name = focal_info

    src_file = _find_source_file(cj_main_dir, class_name)
    if not src_file:
        return None

    workflow: list[dict] = json.loads(Path(workflow_json_path).read_text(encoding="utf-8"))
    if not any(_has_real_side_effects(m) for m in workflow):
        return None

    lines = src_file.read_text(encoding="utf-8").splitlines(keepends=True)
    body_start, body_end = _find_method_body_range(lines, method_name)
    if body_start < 0:
        return None

    inserts_before: dict[int, list[str]] = {}
    inserts_after: dict[int, list[str]] = {}
    occ_ctr: dict[str, int] = {}

    for method_dict in workflow:
        mname = method_dict.get("method_name", "")
        short = mname.rpartition(".")[2]
        occ = occ_ctr.get(mname, 0)
        occ_ctr[mname] = occ + 1

        if not _has_real_side_effects(method_dict):
            continue

        call_line = _find_call_line(lines, body_start, body_end, short, occ)
        if call_line < 0:
            continue

        call_args = _parse_call_args(lines[call_line], short)
        receiver = _parse_receiver(lines[call_line], short)

        stub = _gen_stub_lines(method_dict, call_args, receiver)
        if stub:
            if _is_return_call_line(lines[call_line]):
                inserts_before.setdefault(call_line, []).extend(stub)
            else:
                inserts_after.setdefault(call_line, []).extend(stub)

    if not inserts_before and not inserts_after:
        return None

    src_file.write_text(_apply_edits(lines, inserts_before, inserts_after), encoding="utf-8")
    return str(src_file)


def deinstrument(*paths: str) -> None:
    """清除指定文件或目录下所有 .cj 文件中的 STUB 块。"""
    def _clean(p: Path) -> None:
        lines = p.read_text(encoding="utf-8").splitlines(keepends=True)
        result, inside = [], False
        for line in lines:
            s = line.strip()
            if s == STUB_OPEN:
                inside = True
            elif inside:
                if s == STUB_CLOSE:
                    inside = False
            else:
                result.append(line)
        p.write_text("".join(result), encoding="utf-8")

    for path_str in paths:
        p = Path(path_str)
        if p.is_dir():
            for cj in p.rglob("*.cj"):
                _clean(cj)
        elif p.is_file():
            _clean(p)


# ===========================================================================
# CLI 入口
# ===========================================================================

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="对 focal method 源文件插桩/去桩以回放 side effect")
    sub = parser.add_subparsers(dest="cmd")

    p_ins = sub.add_parser("instrument")
    p_ins.add_argument("test_cj")
    p_ins.add_argument("workflow_json")
    p_ins.add_argument("cj_main_dir")

    p_dei = sub.add_parser("deinstrument")
    p_dei.add_argument("paths", nargs="+")

    args = parser.parse_args()
    if args.cmd == "instrument":
        result = instrument(args.test_cj, args.workflow_json, args.cj_main_dir)
        if result:
            print(f"[side_effect] instrumented: {result}")
        else:
            print("[side_effect] no side effects to instrument")
    elif args.cmd == "deinstrument":
        deinstrument(*args.paths)
        print(f"[side_effect] deinstrumented: {args.paths}")
    else:
        parser.print_help()
