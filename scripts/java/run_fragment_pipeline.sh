#!/usr/bin/env bash

# Run fragment translation followed by the standard error analysis report.
#
# Minimal usage:
#   bash scripts/java/run_fragment_pipeline.sh --projectname commons-csv

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

PROJECT=""
MODEL="deepseek-chat"
TEMPERATURE="0.0"
SUFFIX="_evosuite_cleaned_base"
USE_RAG="true"
SKIP_MOCK="true"
TRANSLATE_TESTS="false"
USE_PROGRESSIVE_KB="true"
USE_PSEUDOCODE="false"
USE_GRAMMAR_PROMPT="false"
USE_SYNTAX_RAG="false"
SKIP_ANALYSIS_BUILD="false"
ANALYSIS_OUTPUT=""
ABLATION="false"
ABLATION_ROOT=""

usage() {
    cat <<'EOF'
Usage:
  bash scripts/java/run_fragment_pipeline.sh --projectname <project> [options]

Required:
  --projectname <name>          Project name, for example commons-csv

Options:
  --model <name>                Model name (default: deepseek-chat)
  --temperature <value>         Model temperature (default: 0.0)
  --suffix <value>              Schema suffix (default: _evosuite_cleaned_base)
  --with-mock                   Enable mock validation and build missing mock corpus
  --use-rag <true|false>        Error-context RAG (default: true)
  --translate-tests <true|false>
  --use-progressive-kb <true|false>
  --use-pseudocode <true|false>
  --use-grammar-prompt <true|false>
  --use-syntax-rag <true|false>
  --analysis-output <path>      Override the analysis report path
  --skip-analysis-build         Do not run the final cjpm build in analyze_errors
  --ablation                   Run 5 cases with Progressive KB disabled:
                               baseline, each enhancement alone, and all enabled
  --ablation-root <path>       Override the five-run ablation output directory
  -h, --help                    Show this help
EOF
}

require_value() {
    local option="$1"
    local value="${2:-}"
    if [[ -z "$value" || "$value" == --* ]]; then
        echo "Missing value for $option" >&2
        usage >&2
        exit 2
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --projectname|--project-name)
            require_value "$1" "${2:-}"
            PROJECT="$2"
            shift 2
            ;;
        --projectname=*|--project-name=*)
            PROJECT="${1#*=}"
            shift
            ;;
        --model)
            require_value "$1" "${2:-}"
            MODEL="$2"
            shift 2
            ;;
        --temperature)
            require_value "$1" "${2:-}"
            TEMPERATURE="$2"
            shift 2
            ;;
        --suffix)
            require_value "$1" "${2:-}"
            SUFFIX="$2"
            shift 2
            ;;
        --with-mock)
            SKIP_MOCK="false"
            shift
            ;;
        --use-rag)
            require_value "$1" "${2:-}"
            USE_RAG="$2"
            shift 2
            ;;
        --translate-tests)
            require_value "$1" "${2:-}"
            TRANSLATE_TESTS="$2"
            shift 2
            ;;
        --use-progressive-kb)
            require_value "$1" "${2:-}"
            USE_PROGRESSIVE_KB="$2"
            shift 2
            ;;
        --use-pseudocode)
            require_value "$1" "${2:-}"
            USE_PSEUDOCODE="$2"
            shift 2
            ;;
        --use-grammar-prompt)
            require_value "$1" "${2:-}"
            USE_GRAMMAR_PROMPT="$2"
            shift 2
            ;;
        --use-syntax-rag)
            require_value "$1" "${2:-}"
            USE_SYNTAX_RAG="$2"
            shift 2
            ;;
        --analysis-output)
            require_value "$1" "${2:-}"
            ANALYSIS_OUTPUT="$2"
            shift 2
            ;;
        --skip-analysis-build)
            SKIP_ANALYSIS_BUILD="true"
            shift
            ;;
        --ablation)
            ABLATION="true"
            shift
            ;;
        --ablation-root)
            require_value "$1" "${2:-}"
            ABLATION_ROOT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if [[ -z "$PROJECT" ]]; then
    echo "--projectname is required" >&2
    usage >&2
    exit 2
fi

validate_bool() {
    local name="$1"
    local value="$2"
    if [[ "$value" != "true" && "$value" != "false" ]]; then
        echo "$name must be true or false, got: $value" >&2
        exit 2
    fi
}

validate_bool "--use-rag" "$USE_RAG"
validate_bool "--translate-tests" "$TRANSLATE_TESTS"
validate_bool "--use-progressive-kb" "$USE_PROGRESSIVE_KB"
validate_bool "--use-pseudocode" "$USE_PSEUDOCODE"
validate_bool "--use-grammar-prompt" "$USE_GRAMMAR_PROMPT"
validate_bool "--use-syntax-rag" "$USE_SYNTAX_RAG"

SCHEMA_DIR="data/java/schemas${SUFFIX}/${MODEL}/${TEMPERATURE}/${PROJECT}"
SKELETON_DIR="data/java/skeletons/${PROJECT}"
MOCK_DIR="/tmp/cangjie_mock/${PROJECT}"

if [[ ! -d "$SCHEMA_DIR" ]]; then
    echo "Schema directory not found: $SCHEMA_DIR" >&2
    echo "Run create_schema.sh and translate_types.sh first." >&2
    exit 2
fi

if [[ ! -f "$SKELETON_DIR/cjpm.toml" ]]; then
    echo "Skeleton project not found: $SKELETON_DIR/cjpm.toml" >&2
    echo "Run create_skeleton.sh first." >&2
    exit 2
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_DIR="logs/fragment_pipeline"
mkdir -p "$LOG_DIR" "data/java/analysis"
LOG_FILE="$LOG_DIR/${PROJECT}_${MODEL}_${TEMPERATURE}_${TIMESTAMP}.log"

if [[ -z "$ANALYSIS_OUTPUT" ]]; then
    ANALYSIS_OUTPUT="data/java/analysis/${PROJECT}_${MODEL}_${TEMPERATURE}${SUFFIX}_errors.txt"
fi

run_logged() {
    "$@" 2>&1 | tee -a "$LOG_FILE"
    return "${PIPESTATUS[0]}"
}

reset_run_state() {
    local tag="$1"
    echo "[ablation:$tag] Resetting fragment results" | tee -a "$LOG_FILE"
    run_logged python -m src.java.translation.reset_fragment_results \
        --project "$PROJECT" \
        --model "$MODEL" \
        --temperature "$TEMPERATURE" \
        --suffix "$SUFFIX" || return $?

    echo "[ablation:$tag] Regenerating clean skeletons" | tee -a "$LOG_FILE"
    run_logged bash scripts/java/create_skeleton.sh \
        "$PROJECT" "$MODEL" "$SUFFIX" "$TEMPERATURE" "$TRANSLATE_TESTS"
}

snapshot_ablation_run() {
    local run_dir="$1"
    local translation_skeleton_dir=
    translation_skeleton_dir="data/java/skeletons/translations/${MODEL}/${TEMPERATURE}/${PROJECT}"

    cp "$SCHEMA_DIR"/*.json "$run_dir"/ || return $?
    if [[ -d "$translation_skeleton_dir" ]]; then
        mkdir -p "$run_dir/skeletons" || return $?
        cp -r "$translation_skeleton_dir"/. "$run_dir/skeletons"/ || return $?
    fi
}

run_ablation_case() {
    local tag="$1"
    local use_pseudocode="$2"
    local use_grammar_prompt="$3"
    local use_syntax_rag="$4"
    local run_dir="$ABLATION_ROOT/$tag"
    local case_status=0

    mkdir -p "$run_dir" || return $?

    {
        echo "project=$PROJECT"
        echo "model=$MODEL"
        echo "temperature=$TEMPERATURE"
        echo "suffix=$SUFFIX"
        echo "use_rag=$USE_RAG"
        echo "use_progressive_kb=$USE_PROGRESSIVE_KB"
        echo "use_pseudocode=$use_pseudocode"
        echo "use_grammar_prompt=$use_grammar_prompt"
        echo "use_syntax_rag=$use_syntax_rag"
    } > "$run_dir/config.env" || return $?

    reset_run_state "$tag" || return $?

    echo "[ablation:$tag] Starting pipeline" | tee -a "$LOG_FILE"
    local child_args=(
        bash scripts/java/run_fragment_pipeline.sh
        --projectname "$PROJECT"
        --model "$MODEL"
        --temperature "$TEMPERATURE"
        --suffix "$SUFFIX"
        --use-rag "$USE_RAG"
        --translate-tests "$TRANSLATE_TESTS"
        --use-progressive-kb "$USE_PROGRESSIVE_KB"
        --use-pseudocode "$use_pseudocode"
        --use-grammar-prompt "$use_grammar_prompt"
        --use-syntax-rag "$use_syntax_rag"
        --analysis-output "$run_dir/errors.txt"
    )
    if [[ "$SKIP_MOCK" == "false" ]]; then
        child_args+=(--with-mock)
    fi
    if [[ "$SKIP_ANALYSIS_BUILD" == "true" ]]; then
        child_args+=(--skip-analysis-build)
    fi

    "${child_args[@]}" 2>&1 | tee -a "$LOG_FILE" "$run_dir/pipeline.log"
    case_status="${PIPESTATUS[0]}"

    snapshot_ablation_run "$run_dir" || return $?
    echo "[ablation:$tag] Finished with status $case_status" | tee -a "$LOG_FILE"
    return "$case_status"
}

if [[ "$ABLATION" == "true" ]]; then
    # Progressive KB grows during a run, making later prompts depend on earlier
    # stochastic results. Keep it disabled for every ablation case so the five
    # runs differ only in the Part 1/2/3 enhancement flags.
    USE_PROGRESSIVE_KB="false"

    if [[ -z "$ABLATION_ROOT" ]]; then
        ABLATION_ROOT="data/java/ablation/${PROJECT}_${MODEL}_${TEMPERATURE}${SUFFIX}/five_run_${TIMESTAMP}"
    fi
    if [[ -e "$ABLATION_ROOT" ]]; then
        echo "Ablation output already exists: $ABLATION_ROOT" >&2
        echo "Choose a new --ablation-root or remove the existing directory." >&2
        exit 2
    fi

    echo "[ablation] Output root: $ABLATION_ROOT" | tee -a "$LOG_FILE"
    echo "[ablation] Progressive KB: disabled for all cases" | tee -a "$LOG_FILE"
    baseline_status=0
    pseudo_status=0
    grammar_status=0
    syntax_status=0
    all_status=0
    compare_status=0

    run_ablation_case "baseline" false false false || baseline_status=$?
    run_ablation_case "pseudo" true false false || pseudo_status=$?
    run_ablation_case "grammar" false true false || grammar_status=$?
    run_ablation_case "syntax" false false true || syntax_status=$?
    run_ablation_case "all" true true true || all_status=$?

    echo "[ablation] Generating comparison report" | tee -a "$LOG_FILE"
    run_logged python -m src.java.analysis.ablation_compare \
        --project "$PROJECT" \
        --model "$MODEL" \
        --temperature "$TEMPERATURE" \
        --suffix "$SUFFIX" \
        --ablation-root "$ABLATION_ROOT" || compare_status=$?

    echo "[ablation] baseline status: $baseline_status" | tee -a "$LOG_FILE"
    echo "[ablation] pseudo status:   $pseudo_status" | tee -a "$LOG_FILE"
    echo "[ablation] grammar status:  $grammar_status" | tee -a "$LOG_FILE"
    echo "[ablation] syntax status:   $syntax_status" | tee -a "$LOG_FILE"
    echo "[ablation] all status:      $all_status" | tee -a "$LOG_FILE"
    echo "[ablation] report:          $ABLATION_ROOT/report.md" | tee -a "$LOG_FILE"
    echo "[ablation] metrics:         $ABLATION_ROOT/metrics.csv" | tee -a "$LOG_FILE"

    if [[ $baseline_status -ne 0 || $pseudo_status -ne 0 || \
          $grammar_status -ne 0 || $syntax_status -ne 0 || \
          $all_status -ne 0 || $compare_status -ne 0 ]]; then
        exit 1
    fi
    exit 0
fi

{
    echo "Fragment translation pipeline"
    echo "project=$PROJECT"
    echo "model=$MODEL"
    echo "temperature=$TEMPERATURE"
    echo "suffix=$SUFFIX"
    echo "use_rag=$USE_RAG"
    echo "skip_mock=$SKIP_MOCK"
    echo "translate_tests=$TRANSLATE_TESTS"
    echo "use_progressive_kb=$USE_PROGRESSIVE_KB"
    echo "use_pseudocode=$USE_PSEUDOCODE"
    echo "use_grammar_prompt=$USE_GRAMMAR_PROMPT"
    echo "use_syntax_rag=$USE_SYNTAX_RAG"
    echo "started_at=$(date -Is)"
} | tee "$LOG_FILE"

translation_status=0

if [[ "$SKIP_MOCK" == "false" && ! -d "$MOCK_DIR" ]]; then
    echo "[pipeline] Building missing mock corpus: $MOCK_DIR" | tee -a "$LOG_FILE"
    run_logged bash scripts/java/build_mock_corpus.sh "$PROJECT"
    mock_status=$?
    if [[ $mock_status -ne 0 ]]; then
        echo "[pipeline] Mock corpus build failed with status $mock_status" | tee -a "$LOG_FILE"
        translation_status=$mock_status
    fi
fi

if [[ $translation_status -eq 0 ]]; then
    echo "[pipeline] Starting fragment translation" | tee -a "$LOG_FILE"
    run_logged bash scripts/java/translate_fragment.sh \
        "$PROJECT" "$MODEL" "$SUFFIX" "$TEMPERATURE" \
        "$USE_RAG" "$SKIP_MOCK" "$TRANSLATE_TESTS" \
        "$USE_PROGRESSIVE_KB" "$USE_PSEUDOCODE" \
        "$USE_GRAMMAR_PROMPT" "$USE_SYNTAX_RAG"
    translation_status=$?
    echo "[pipeline] Fragment translation exited with status $translation_status" | tee -a "$LOG_FILE"
fi

echo "[pipeline] Starting error analysis" | tee -a "$LOG_FILE"
analysis_args=(
    bash scripts/java/analyze_errors.sh
    "$PROJECT" "$MODEL" "$TEMPERATURE" "$SUFFIX" "$ANALYSIS_OUTPUT"
)
if [[ "$SKIP_ANALYSIS_BUILD" == "true" ]]; then
    analysis_args+=(--skip-build)
fi

run_logged "${analysis_args[@]}"
analysis_status=$?
echo "[pipeline] Error analysis exited with status $analysis_status" | tee -a "$LOG_FILE"

{
    echo "finished_at=$(date -Is)"
    echo "translation_status=$translation_status"
    echo "analysis_status=$analysis_status"
    echo "report=$ANALYSIS_OUTPUT"
    echo "log=$LOG_FILE"
} | tee -a "$LOG_FILE"

echo "[pipeline] Report: $ANALYSIS_OUTPUT"
echo "[pipeline] Log:    $LOG_FILE"

if [[ $translation_status -ne 0 || $analysis_status -ne 0 ]]; then
    exit 1
fi
