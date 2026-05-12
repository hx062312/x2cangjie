#!/bin/bash

# Usage: ./scripts/java/get_dependencies.sh <project> <suffix>
# Example: ./scripts/java/get_dependencies.sh JavaFeatureTest ""

if [ $# -ne 2 ]; then
  echo "Usage: ./scripts/java/get_dependencies.sh <project> <suffix>"
  exit 1
fi

project=$1
suffix=$2

echo "extracting dependencies for $project"
python3 src/java/utils/parse_dependencies.py --project=$project --function=parse_dependencies --suffix=$suffix
