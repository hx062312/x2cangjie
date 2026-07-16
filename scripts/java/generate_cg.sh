#!/bin/bash

# Usage: ./scripts/java/generate_cg.sh <project>

if [ $# -ne 1 ]; then
  echo "Usage: ./generate_cg.sh <project>"
  exit 1
fi

script_dir=$(dirname "$(realpath "$0")")

project="$1"
project_dir="./projects/java/name_handled/$project"

if [ ! -d "$project_dir" ]; then
  echo "Error: Directory '$project_dir' does not exist."
  exit 1
fi

cd "$project_dir" || exit 1

TARGET_DIR="target"

MAIN_JAR=$(find "$TARGET_DIR" -maxdepth 1 -type f -name "*.jar" \
  ! -name "*-tests.jar" ! -name "*-sources.jar" \
  ! -name "*-test-sources.jar" ! -name "*-javadoc.jar" \
  ! -name "*-merged.jar" ! -name "original-*.jar" -print -quit)

if [ -z "$MAIN_JAR" ]; then
  echo "Error: Main JAR file not found in $TARGET_DIR."
  exit 1
fi

MERGED_JAR="$TARGET_DIR/$(basename "$MAIN_JAR" .jar)-merged.jar"

if [ ! -f "$MERGED_JAR" ]; then
  echo "Error: Merged JAR file not found: $MERGED_JAR"
  exit 1
fi

JAVACG_PATH="$script_dir/../../misc/java-callgraph/target/javacg-0.1-SNAPSHOT-static.jar"

if [ ! -f "$JAVACG_PATH" ]; then
  echo "Error: javacg-0.1-SNAPSHOT-static.jar not found at $JAVACG_PATH."
  exit 1
fi

echo "Generating call graph for $MERGED_JAR..."
CALLGRAPH_TMP="callgraph.txt.tmp"
if ! java -jar "$JAVACG_PATH" "$MERGED_JAR" > "$CALLGRAPH_TMP"; then
  rm -f "$CALLGRAPH_TMP"
  echo "Error: Java call graph generation failed."
  exit 1
fi
if [ ! -s "$CALLGRAPH_TMP" ]; then
  rm -f "$CALLGRAPH_TMP"
  echo "Error: Java call graph generation produced no output."
  exit 1
fi
mv "$CALLGRAPH_TMP" callgraph.txt

echo "Call graph saved to callgraph.txt."

# Also copy to data/java/call_graphs/ for downstream scripts (create_schema.py, get_dependencies.py)
DATA_DIR="$script_dir/../../data/java/call_graphs/$project"
mkdir -p "$DATA_DIR"
cp callgraph.txt "$DATA_DIR/callgraph.txt"
echo "Call graph also copied to $DATA_DIR/callgraph.txt."
