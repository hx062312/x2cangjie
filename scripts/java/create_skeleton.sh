#!/bin/bash

# Usage: ./scripts/java/create_skeleton.sh <project> <model> <suffix> <temperature> <translate_tests>
# Example: ./scripts/java/create_skeleton.sh JavaFeatureTest gpt-4o-2024-11-20 "" 0.0
# translate_tests: "true" or "false" (default: false)

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/create_skeleton.sh <project> <model> <suffix> <temperature> [translate_tests]"
  exit 1
fi

project=$1
model=$2
suffix=$3
temperature=$4
translate_tests=${5:-false}

if [ "$translate_tests" != "true" ] && [ "$translate_tests" != "false" ]; then
  echo "Invalid translate_tests value: $translate_tests (expected true or false)"
  exit 1
fi

echo "Creating skeleton for $project"
export PYTHONPATH=$(pwd)
python src/java/translation/create_skeleton.py --project=$project --model=$model --suffix=$suffix --temperature=$temperature --translate_tests=$translate_tests
