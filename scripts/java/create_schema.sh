#!/bin/bash

# Usage: ./scripts/java/create_schema.sh <project> <model_name> <temperature> <suffix>
# Example: ./scripts/java/create_schema.sh JavaFeatureTest gpt-4o-2024-11-20 0.0 ""

if [ $# -ne 4 ]; then
  echo "Usage: ./scripts/java/create_schema.sh <project> <model_name> <temperature> <suffix>"
  exit 1
fi

project=$1
model_name=$2
temperature=$3
suffix=$4

echo "Creating schema for $project"
export PYTHONPATH=$(pwd)
python src/java/decomposition/create_schema.py --project_name=$project --suffix=$suffix --model_name=$model_name --temperature=$temperature
