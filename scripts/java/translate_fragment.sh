#!/bin/bash

# Usage: ./scripts/java/translate_fragment.sh <project> <model> <suffix> <temperature> <use_rag> <skip_mock> <translate_tests> <use_progressive_kb> <use_pseudocode> <use_grammar_prompt> <use_syntax_rag>
# Example: ./scripts/java/translate_fragment.sh JavaFeatureTest gpt-4o-2024-11-20 "" 0.0 true false false true true true true
# use_rag:            "true" or "false" (default: false)
# skip_mock:          "true" or "false" (default: false)
# translate_tests:    "true" or "false" (default: false)
# use_progressive_kb: "true" or "false" (default: true).  Progressive KB few-shot.
# use_pseudocode:     "true" or "false" (default: false).  Part 1: Java→pseudocode→Cangjie two-phase translation.
# use_grammar_prompt: "true" or "false" (default: false).  Part 2: inject Cangjie EBNF grammar excerpt.
# use_syntax_rag:     "true" or "false" (default: false).  Part 3: retrieve structurally-similar Cangjie snippets.

if [ $# -lt 4 ]; then
  echo "Usage: ./scripts/java/translate_fragment.sh <project> <model> <suffix> <temperature> [use_rag] [skip_mock] [translate_tests] [use_progressive_kb] [use_pseudocode] [use_grammar_prompt] [use_syntax_rag]"
  exit 1
fi

project=$1
model=$2
suffix=$3
temperature=$4
use_rag=${5:-false}
skip_mock=${6:-false}
translate_tests=${7:-false}
use_progressive_kb=${8:-true}
use_pseudocode=${9:-false}
use_grammar_prompt=${10:-false}
use_syntax_rag=${11:-false}

if [ "$use_rag" != "true" ] && [ "$use_rag" != "false" ]; then
  echo "Invalid use_rag value: $use_rag (expected true or false)"
  exit 1
fi

if [ "$skip_mock" != "true" ] && [ "$skip_mock" != "false" ]; then
  echo "Invalid skip_mock value: $skip_mock (expected true or false)"
  exit 1
fi

if [ "$translate_tests" != "true" ] && [ "$translate_tests" != "false" ]; then
  echo "Invalid translate_tests value: $translate_tests (expected true or false)"
  exit 1
fi

if [ "$use_progressive_kb" != "true" ] && [ "$use_progressive_kb" != "false" ]; then
  echo "Invalid use_progressive_kb value: $use_progressive_kb (expected true or false)"
  exit 1
fi

if [ "$use_pseudocode" != "true" ] && [ "$use_pseudocode" != "false" ]; then
  echo "Invalid use_pseudocode value: $use_pseudocode (expected true or false)"
  exit 1
fi

if [ "$use_grammar_prompt" != "true" ] && [ "$use_grammar_prompt" != "false" ]; then
  echo "Invalid use_grammar_prompt value: $use_grammar_prompt (expected true or false)"
  exit 1
fi

if [ "$use_syntax_rag" != "true" ] && [ "$use_syntax_rag" != "false" ]; then
  echo "Invalid use_syntax_rag value: $use_syntax_rag (expected true or false)"
  exit 1
fi

export PYTHONPATH=$(pwd)
python src/java/translation/compositional_translation_validation.py \
    --model=$model \
    --project=$project \
    --from_lang=Java \
    --to_lang=Cangjie \
    --include_call_graph \
    --debug \
    --suffix=$suffix \
    --temperature=$temperature \
    --validate_by_cangjie \
    --use_rag=$use_rag \
    --skip_mock=$skip_mock \
    --translate_tests=$translate_tests \
    --use_progressive_kb=$use_progressive_kb \
    --use_pseudocode=$use_pseudocode \
    --use_grammar_prompt=$use_grammar_prompt \
    --use_syntax_rag=$use_syntax_rag \
    --recursion_depth=2 \
    --include_implementation
