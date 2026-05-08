#!/usr/bin/env bash
# 用法: build_mock_corpus.sh <project>
#
# 生成 mock 测试样本到 /tmp/cangjie_mock/<project>/，作为 translate_fragment.sh
# 执行前的一次性前置步骤。流程：
#   1. 复制 Java 项目到工作副本，注入 AspectJ + LoggingAspect
#   2. 自动枚举 src/test/java/**/*Test.java（含 *Tests.java）中的 @Test 方法
#   3. 逐个 mvn -Dtest=<FQCN>#<method>，解析日志 emit *_test.cj + *.workflow.json
#
# 之前的 mock.sh 把 TEST_CLASS 硬编码为单个测试类，本脚本自动扫描所有测试类。
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <project>" >&2
    exit 1
fi

PROJECT="$1"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ISOL="$ROOT/src/java/isolation_validation"
WORK="$ISOL/$PROJECT"
JAVA_SRC="$ROOT/projects/java/original_projects/$PROJECT"
CJ_PROJECT="$ROOT/projects/cangjie/original_projects/$PROJECT"
CJPM_SRC="$CJ_PROJECT/cjpm.toml"
STAGING="/tmp/cangjie_mock/$PROJECT"

[[ -d "$JAVA_SRC" ]] || { echo "Java project not found: $JAVA_SRC" >&2; exit 1; }

JAVA_TESTS_DIR="$JAVA_SRC/src/test/java"
[[ -d "$JAVA_TESTS_DIR" ]] || { echo "Java tests not found: $JAVA_TESTS_DIR" >&2; exit 1; }

# 1. 准备工作区与 staging 目录
rm -rf "$WORK"
cp -r "$JAVA_SRC" "$WORK"
rm -rf "$STAGING"
mkdir -p "$STAGING"

# 2. 注入 AspectJ 依赖 + 添加 LoggingAspect/CustomToStringConverter 到各包
for f in modify_pom.py add_java_files.py clean_evosuite_tests.py; do
    [[ -f "$ISOL/$f" ]] && cp "$ISOL/$f" "$WORK/"
done
(cd "$WORK" && python3 modify_pom.py && python3 add_java_files.py)

# 3. 拷贝 emitter 脚本与 cjpm.toml（让 detect_project_name 读到正确包名）
for f in script.py mock_helper.py log_parser.py reflection.py add_macro.py; do
    [[ -f "$ISOL/$f" ]] && cp "$ISOL/$f" "$WORK/"
done
[[ -f "$CJPM_SRC" ]] && cp "$CJPM_SRC" "$WORK/cjpm.toml"

# 4. 自动枚举所有 *Test.java / *Tests.java
mapfile -t TEST_FILES < <(
    find "$JAVA_TESTS_DIR" -type f \( -name '*Test.java' -o -name '*Tests.java' \) | sort -u
)

if [[ ${#TEST_FILES[@]} -eq 0 ]]; then
    echo "No *Test.java / *Tests.java under $JAVA_TESTS_DIR" >&2
    exit 1
fi

echo "=== Found ${#TEST_FILES[@]} test class(es) ==="

TOTAL_RUN=0
TOTAL_OK=0
TOTAL_SKIP=0

for TEST_FILE in "${TEST_FILES[@]}"; do
    PKG=$(grep -E '^\s*package\s+' "$TEST_FILE" | head -1 \
        | sed -E 's/^\s*package\s+([^;]+);.*/\1/')
    CLASS_FILE=$(basename "$TEST_FILE" .java)
    if [[ -n "$PKG" ]]; then
        TEST_CLASS="${PKG}.${CLASS_FILE}"
    else
        TEST_CLASS="$CLASS_FILE"
    fi

    METHODS=$(grep -A1 "@Test" "$TEST_FILE" | grep "void " \
        | sed 's/.*void \([a-zA-Z0-9_]*\).*/\1/' | sort -u)

    if [[ -z "${METHODS//[[:space:]]/}" ]]; then
        echo "  SKIP (no @Test methods): $TEST_CLASS"
        continue
    fi

    for METHOD in $METHODS; do
        TOTAL_RUN=$((TOTAL_RUN + 1))
        echo "=== [$TOTAL_RUN] $TEST_CLASS#$METHOD ==="
        if (cd "$WORK" && mvn clean install \
                -Drat.skip -Dgpg.skip -Dmaven.javadoc.skip \
                "-Dtest=${TEST_CLASS}#${METHOD}" -q); then
            for LOG in "$WORK"/*.log; do
                [[ -f "$LOG" ]] || continue
                echo "  Emitting: $(basename "$LOG")"
                (cd "$WORK" && python3 script.py "$(basename "$LOG")" --output-dir "$STAGING") || true
                rm -f "$LOG"
            done
            TOTAL_OK=$((TOTAL_OK + 1))
        else
            echo "  SKIP (maven failed): $TEST_CLASS#$METHOD"
            rm -f "$WORK"/*.log
            TOTAL_SKIP=$((TOTAL_SKIP + 1))
        fi
    done
done

CJ_COUNT=$(ls "$STAGING"/*.cj 2>/dev/null | wc -l)
echo ""
echo "=== Summary ==="
echo "  test methods executed : $TOTAL_RUN"
echo "  successful            : $TOTAL_OK"
echo "  skipped (mvn failed)  : $TOTAL_SKIP"
echo "  generated _test.cj    : $CJ_COUNT  (in $STAGING)"
