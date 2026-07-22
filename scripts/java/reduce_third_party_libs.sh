#!/bin/bash

# Usage: ./scripts/java/reduce_third_party_libs.sh <project>

if [ $# -ne 1 ]; then
  echo "Usage: ./scripts/java/reduce_third_party_libs.sh <project>"
  exit 1
fi

project="$1"

export PYTHONPATH=$(pwd)
python ./src/java/preprocessing/reduce_third_party_libs.py "$project"

rm -rf "projects/java/cleaned_final_projects/$project"
mkdir -p "projects/java/cleaned_final_projects"
cp -r "projects/java/reduced_libs/$project" "projects/java/cleaned_final_projects/$project"  || { echo "copy cleaned_final project failed"; exit 1; }
