#!/bin/bash

# Usage: ./scripts/java/type_translation.sh <project> <model_name> <temperature> <suffix>
# Example: ./scripts/java/type_translation.sh commons-cli deepseek-v4-pro 0.0 ""

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/type_translation.sh <project> <model_name> <temperature> <suffix>"
  exit 1
fi

project=$1
model_name=$2
temperature=$3
suffix=$4

log_dir="data/java/type_translation/logs"
mkdir -p "$log_dir"
log_file="$log_dir/${project}.log"

echo "=== type_translation: $project (model=$model_name, temp=$temperature, suffix=${suffix:-none}) ===" | tee "$log_file"
export PYTHONPATH=$(pwd)
# Ensure cjc is on PATH for compile-check validation
export PATH="$(pwd)/misc/cangjie/bin:$PATH"
# Suppress "No PyTorch/TensorFlow/Flax found" warning from transformers
export TRANSFORMERS_VERBOSITY=error
python src/java/type_translation/graph/runner.py \
    --project_name="$project" \
    --model_name="$model_name" \
    --temperature="$temperature" \
    --suffix="$suffix" 2>&1 | tee -a "$log_file"
