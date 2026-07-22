#!/bin/bash

# Usage: ./scripts/java/handle_keyword_conflicts.sh <project>
# Example: ./scripts/java/handle_keyword_conflicts.sh commons-cli
#
# Uses the new JDT-inspired JavaRenamer (src/java/preprocessing/java_renamer/)
# instead of the old tree-sitter-heuristic-based handle_keyword_conflicts.py.
#
# Key improvements over the old script:
#   - Scope-based symbol resolution (not heuristic name-matching)
#   - Import-aware type resolution (not "first letter uppercase" guessing)
#   - Full reference tracking across files (not single-file guessing)
#   - Proper handling of same-named field+method pairs
#   - Static import resolution for project-internal symbols

if [ $# -ne 1 ]; then
  echo "Usage: ./scripts/java/handle_keyword_conflicts.sh <project>"
  exit 1
fi

project="$1"
input_dir="projects/java/automated_reduced_projects/$project"
output_dir="projects/java/keyword_handled/$project"

if [ ! -d "$input_dir" ]; then
  echo "Error: Input directory not found: $input_dir"
  exit 1
fi

echo "=== Step 1.2: Handling Cangjie keyword conflicts for $project ==="
echo "  Input:  $input_dir"
echo "  Output: $output_dir"

# Copy project to output directory
if [ -d "$output_dir" ]; then
  rm -rf "$output_dir"
fi
cp -a "$input_dir" "$output_dir"

# Run the new JDT-inspired renamer
export PYTHONPATH=$(pwd)
python3 -c "
import sys
sys.path.insert(0, '.')
from src.java.preprocessing.java_renamer import rename_keyword_conflicts

count = rename_keyword_conflicts(
    project_dir='$output_dir',
    keywords={'type', 'init', 'in', 'is', 'func', 'match'},
    dry_run=False,
)
print(f'\nDone: {count} file(s) modified')
print(f'Output: $output_dir')
"
