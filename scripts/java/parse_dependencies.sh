#!/bin/bash

# Usage: ./scripts/java/parse_dependencies.sh <project> <suffix>
# Example: ./scripts/java/parse_dependencies.sh JavaFeatureTest ""

if [ $# -ne 2 ]; then
  echo "Usage: ./scripts/java/parse_dependencies.sh <project> <suffix>"
  exit 1
fi

project=$1
suffix=$2

echo "extracting dependencies for $project"
python src/java/skeleton/parse_dependencies.py --project_name=$project --function=parse_dependencies --suffix=$suffix
