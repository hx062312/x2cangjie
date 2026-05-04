#!/bin/bash

# Usage: ./scripts/java/translate_fragment.sh <project> <model> <suffix> <temperature> <use_rag>
# Example: ./scripts/java/translate_fragment.sh JavaFeatureTest gpt-4o-2024-11-20 "" 0.0 true
# use_rag: "true" or "false" (default: true)

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/translate_fragment.sh <project> <model> <suffix> <temperature> [use_rag]"
  exit 1
fi

project=$1
model=$2
suffix=$3
temperature=$4
use_rag=${5:-true}

export PYTHONPATH=$(pwd)
python3 src/java/translation/compositional_translation_validation.py \
    --model=$model \
    --project=$project \
    --from_lang=Java \
    --to_lang=Cangjie \
    --include_call_graph \
    --debug \
    --suffix=$suffix \
    --temperature=$temperature \
    --validate_by_cangjie \
    --use_rag=$use_rag \
    --recursion_depth=2 \
    --include_implementation | tee ${project}_${model}_body.log
