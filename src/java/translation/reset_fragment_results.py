"""Reset fragment translation outcomes while preserving schema/type metadata."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


FRAGMENT_COLLECTIONS = ("fields", "methods", "static_initializers")
RESULT_DEFAULTS = {
    "translation": [],
    "translation_status": "pending",
    "syntactic_validation": "pending",
    "cangjie_compilation": "pending",
    "test_execution": "pending",
    "elapsed_time": 0,
    "generation_timestamp": 0,
    "model_name": "",
    "partial_translation": [],
}
RESULT_ONLY_KEYS = ("original_budget", "final_budget")


def reset_fragment(fragment: dict) -> None:
    for key, value in RESULT_DEFAULTS.items():
        fragment[key] = list(value) if isinstance(value, list) else value
    for key in RESULT_ONLY_KEYS:
        fragment.pop(key, None)


def reset_schema(schema: dict) -> int:
    count = 0
    for class_info in schema.get("classes", {}).values():
        if not isinstance(class_info, dict):
            continue
        for collection_name in FRAGMENT_COLLECTIONS:
            fragments = class_info.get(collection_name, {})
            if not isinstance(fragments, dict):
                continue
            for fragment in fragments.values():
                if not isinstance(fragment, dict):
                    continue
                reset_fragment(fragment)
                count += 1
    return count


def reset_schema_directory(schema_dir: Path) -> tuple[int, int]:
    if not schema_dir.is_dir():
        raise FileNotFoundError(f"Schema directory not found: {schema_dir}")

    file_count = 0
    fragment_count = 0
    for schema_path in sorted(schema_dir.glob("*.json")):
        with schema_path.open("r", encoding="utf-8") as handle:
            schema = json.load(handle)
        reset_count = reset_schema(schema)
        if reset_count == 0:
            continue

        temp_path = schema_path.with_suffix(".json.tmp")
        with temp_path.open("w", encoding="utf-8") as handle:
            json.dump(schema, handle, indent=4)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temp_path, schema_path)
        file_count += 1
        fragment_count += reset_count

    return file_count, fragment_count


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Reset fragment translation results without clearing type translations"
    )
    parser.add_argument("--project", required=True)
    parser.add_argument("--model", default="deepseek-chat")
    parser.add_argument("--temperature", default="0.0")
    parser.add_argument("--suffix", default="_evosuite_cleaned_base")
    args = parser.parse_args()

    schema_dir = Path(
        f"data/java/schemas{args.suffix}/{args.model}/{args.temperature}/{args.project}"
    )
    file_count, fragment_count = reset_schema_directory(schema_dir)
    print(
        f"Reset {fragment_count} fragments across {file_count} schema files: "
        f"{schema_dir}"
    )


if __name__ == "__main__":
    main()
