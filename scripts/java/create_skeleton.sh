#!/bin/bash

# Usage: ./scripts/java/create_skeleton.sh <project> <model> <suffix> <temperature>
# Example: ./scripts/java/create_skeleton.sh JavaFeatureTest gpt-4o-2024-11-20 "" 0.0

if [ $# -ne 4 ]; then
  echo "Usage: ./scripts/java/create_skeleton.sh <project> <model> <suffix> <temperature>"
  exit 1
fi

project=$1
model=$2
suffix=$3
temperature=$4

echo "Creating skeleton for $project"
export PYTHONPATH=$(pwd)
python src/java/translation/create_skeleton.py --project=$project --model=$model --suffix=$suffix --temperature=$temperature
