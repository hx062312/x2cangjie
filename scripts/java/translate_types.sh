#!/bin/bash

# Usage: ./scripts/java/translate_types.sh <project> <model_name> <temperature> <suffix> <use_llm> <use_rag> <translate_tests> <use_progressive_kb>
# Example: ./scripts/java/translate_types.sh commons-cli gpt-4o-2024-11-20 0.0 "" true true false true
# use_llm: "true" or "false" (default: true). If false, only fixed_type_map and custom types are used.
# use_rag: "true" or "false" (default: true). Only takes effect when use_llm is also true.
# translate_tests: "true" or "false" (default: false)
# use_progressive_kb: "true" or "false" (default: true). Enables Progressive KB for few-shot type translation.

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/translate_types.sh <project> <model_name> <temperature> <suffix> [use_llm] [use_rag] [translate_tests] [use_progressive_kb]"
  exit 1
fi

project=$1
model_name=$2
temperature=$3
suffix=$4
use_llm=${5:-true}
use_rag=${6:-true}
translate_tests=${7:-false}
use_progressive_kb=${8:-true}

if [ "$translate_tests" != "true" ] && [ "$translate_tests" != "false" ]; then
  echo "Invalid translate_tests value: $translate_tests (expected true or false)"
  exit 1
fi

if [ "$use_progressive_kb" != "true" ] && [ "$use_progressive_kb" != "false" ]; then
  echo "Invalid use_progressive_kb value: $use_progressive_kb (expected true or false)"
  exit 1
fi

echo "Translating types for $project (use_llm=$use_llm, use_rag=$use_rag, translate_tests=$translate_tests, use_progressive_kb=$use_progressive_kb)"
export PYTHONPATH=$(pwd)
python src/java/type_resolution/translate_type_rag.py \
    --project_name=$project \
    --model_name=$model_name \
    --temperature=$temperature \
    --suffix=$suffix \
    --prompt_type=description \
    --source_language=Java \
    --target_language=Cangjie \
    --budget=3 \
    --use_llm=$use_llm \
    --use_rag=$use_rag \
    --translate_tests=$translate_tests \
    --use_progressive_kb=$use_progressive_kb \
    --debug
