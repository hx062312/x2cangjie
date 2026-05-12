#!/bin/bash

# Usage: ./scripts/java/translate_types.sh <project> <model_name> <temperature> <suffix> <use_llm> <use_rag>
# Example: ./scripts/java/translate_types.sh commons-cli gpt-4o-2024-11-20 0.0 "" true true
# use_llm: "true" or "false" (default: true). If false, only fixed_type_map and custom types are used.
# use_rag: "true" or "false" (default: true). Only takes effect when use_llm is also true.

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/translate_types.sh <project> <model_name> <temperature> <suffix> [use_llm] [use_rag]"
  exit 1
fi

project=$1
model_name=$2
temperature=$3
suffix=$4
use_llm=${5:-true}
use_rag=${6:-true}

echo "Translating types for $project (use_llm=$use_llm, use_rag=$use_rag)"
export PYTHONPATH=$(pwd)
python3 src/java/type_resolution/translate_type_rag.py \
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
    --debug
