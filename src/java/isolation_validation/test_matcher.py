"""按 fragment 的 class/method 在 staging 中精确匹配 focal-call 测试。

`script.py` 生成的每个 `_test.cj` 头部都有形如
    // focal call: <pkg>.<Class>.<method>
的注释。本模块即按 fragment 的 class_name + fragment_name 严格比对该字段，
仅返回 focal 完全命中的测试，绝不放过 callgraph 间接命中（与设计 #7、#12 一致）。
"""

from __future__ import annotations

import re
from pathlib import Path

# focal call 注释只允许使用 <pkg>.<Class>.<method> 三段式；类名首字母约定大写。
_FOCAL_RE = re.compile(r"//\s*focal call:\s*([\w.$]+)\.(\w+)\.(\w+)")


def _strip_position_prefix(name: str) -> str:
    """schema 内 fragment_name / class_name 形如 '14-17:Calculator'，剥掉位置前缀。"""
    if not name:
        return ""
    if ":" in name:
        return name.rsplit(":", 1)[-1]
    return name


def _normalize_method(name: str, is_constructor: bool) -> str:
    """`script.py` 把 Java 构造器 <init> emit 成 'init'；本端规范化保持一致。"""
    if is_constructor:
        return "init"
    if name in ("<init>", "init"):
        return "init"
    return name


def find_focal_tests(fragment: dict, staging_dir: Path) -> list[tuple[Path, Path | None]]:
    """返回 [(test_cj, workflow_json|None)]；只保留 focal 完全匹配本 fragment 的测试。"""
    target_class = _strip_position_prefix(fragment.get("class_name", ""))
    target_method = _normalize_method(
        _strip_position_prefix(fragment.get("fragment_name", "")),
        bool(fragment.get("is_constructor", False)),
    )
    if not target_class or not target_method:
        return []

    matched: list[tuple[Path, Path | None]] = []
    for test_cj in sorted(staging_dir.glob("*_test.cj")):
        try:
            with test_cj.open("r", encoding="utf-8") as f:
                head = "".join([f.readline() for _ in range(64)])
        except OSError:
            continue
        m = _FOCAL_RE.search(head)
        if not m:
            continue
        cls, mth = m.group(2), m.group(3)
        if cls != target_class or mth != target_method:
            continue
        stem = test_cj.name[:-len("_test.cj")]
        wf = staging_dir / f"{stem}.workflow.json"
        matched.append((test_cj, wf if wf.exists() else None))
    return matched
