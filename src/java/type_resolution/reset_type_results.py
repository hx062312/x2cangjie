"""Reset schema type-resolution outcomes while preserving extracted Java types."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


FRAGMENT_COLLECTIONS = ("fields", "methods")
TYPE_VARIATIONS = ("types", "return_types", "parameters", "body_types")
RESULT_DEFAULTS = {
    "translated": False,
    "attempted": False,
    "timestamp": "",
    "generation": "",
    "imports": "",
    "translated_target_type": "",
    "reasoning": "",
    "prompt": "",
    "feedback": "",
}


def _is_test_schema(path: Path) -> bool:
    name = path.name
    return ".src.test." in name or ".evosuite-tests." in name


def reset_type_results(schema: dict) -> int:
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
                translations = fragment.get("type_translations", {})
                if not isinstance(translations, dict):
                    continue
                for variation in TYPE_VARIATIONS:
                    entries = translations.get(variation, {})
                    if not isinstance(entries, dict):
                        continue
                    for identifier, result in entries.items():
                        if not isinstance(result, dict):
                            continue
                        result["identifier"] = identifier
                        result["type_variation"] = variation
                        for key, value in RESULT_DEFAULTS.items():
                            result[key] = value
                        count += 1
    return count


def reset_schema_directory(schema_dir: Path, include_tests: bool = False) -> tuple[int, int]:
    if not schema_dir.is_dir():
        raise FileNotFoundError(f"Schema directory not found: {schema_dir}")

    file_count = 0
    result_count = 0
    for schema_path in sorted(schema_dir.glob("*.json")):
        if not include_tests and _is_test_schema(schema_path):
            continue
        with schema_path.open("r", encoding="utf-8") as handle:
            schema = json.load(handle)
        reset_count = reset_type_results(schema)
        if reset_count == 0:
            continue

        temp_path = schema_path.with_suffix(".json.tmp")
        with temp_path.open("w", encoding="utf-8") as handle:
            json.dump(schema, handle, indent=4)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temp_path, schema_path)
        file_count += 1
        result_count += reset_count

    return file_count, result_count


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Reset type-resolution results without rebuilding Java schemas"
    )
    parser.add_argument("--project", required=True)
    parser.add_argument("--model", default="deepseek-chat")
    parser.add_argument("--temperature", default="0.0")
    parser.add_argument("--suffix", default="_evosuite_cleaned_base")
    parser.add_argument("--include-tests", action="store_true")
    args = parser.parse_args()

    schema_dir = Path(
        f"data/java/schemas{args.suffix}/{args.model}/{args.temperature}/{args.project}"
    )
    file_count, result_count = reset_schema_directory(
        schema_dir, include_tests=args.include_tests
    )
    print(
        f"Reset {result_count} type results across {file_count} schema files: "
        f"{schema_dir}"
    )


if __name__ == "__main__":
    main()
