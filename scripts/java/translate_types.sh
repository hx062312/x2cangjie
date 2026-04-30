#!/bin/bash

# Usage: ./scripts/java/translate_types.sh <project> <model_name> <temperature> <suffix>
# Example: ./scripts/java/translate_types.sh commons-cli gpt-4o-2024-11-20 0.0 ""

if [ $# -ne 4 ]; then
  echo "Usage: ./scripts/java/translate_types.sh <project> <model_name> <temperature> <suffix>"
  exit 1
fi

project=$1
model_name=$2
temperature=$3
suffix=$4

echo "Translating types for $project"
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
    --debug
