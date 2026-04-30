#!/bin/bash

# Usage: ./scripts/java/handle_keyword_conflicts.sh <project>
# Example: ./scripts/java/handle_keyword_conflicts.sh commons-cli

if [ $# -ne 1 ]; then
  echo "Usage: ./scripts/java/handle_keyword_conflicts.sh <project>"
  exit 1
fi

project="$1"

echo "Handling Cangjie keyword conflicts for $project"
export PYTHONPATH=$(pwd)
python3 ./src/java/preprocessing/handle_keyword_conflicts.py --project "$project"
