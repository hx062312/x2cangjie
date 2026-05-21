#!/bin/bash

# Usage: ./scripts/java/translate_fragment.sh <project> <model> <suffix> <temperature> <use_rag> <skip_mock>
# Example: ./scripts/java/translate_fragment.sh JavaFeatureTest gpt-4o-2024-11-20 "" 0.0 true false
# use_rag: "true" or "false" (default: false)
# skip_mock: "true" or "false" (default: false)

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/translate_fragment.sh <project> <model> <suffix> <temperature> [use_rag] [skip_mock]"
  exit 1
fi

project=$1
model=$2
suffix=$3
temperature=$4
use_rag=${5:-false}
skip_mock=${6:-false}

if [ "$use_rag" != "true" ] && [ "$use_rag" != "false" ]; then
  echo "Invalid use_rag value: $use_rag (expected true or false)"
  exit 1
fi

if [ "$skip_mock" != "true" ] && [ "$skip_mock" != "false" ]; then
  echo "Invalid skip_mock value: $skip_mock (expected true or false)"
  exit 1
fi

export PYTHONPATH=$(pwd)
python src/java/translation/compositional_translation_validation.py \
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
    --skip_mock=$skip_mock \
    --recursion_depth=2 \
    --include_implementation
