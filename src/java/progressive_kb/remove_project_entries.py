"""Remove translation examples produced by one project from a progressive KB."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


def _write_json(path: Path, value: object) -> None:
    temp_path = path.with_suffix(path.suffix + ".tmp")
    with temp_path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, ensure_ascii=False, indent=2)
        handle.write("\n")
        handle.flush()
        os.fsync(handle.fileno())
    os.replace(temp_path, path)


def remove_project_entries(storage_dir: Path, project: str) -> int:
    pool_path = storage_dir / "translation_pool.json"
    if not pool_path.is_file():
        return 0

    with pool_path.open("r", encoding="utf-8") as handle:
        pairs = json.load(handle)
    if not isinstance(pairs, list):
        raise ValueError(f"Expected a list in {pool_path}")

    retained_pairs = [
        pair
        for pair in pairs
        if not isinstance(pair, dict) or pair.get("source_project") != project
    ]
    removed_count = len(pairs) - len(retained_pairs)
    if removed_count == 0:
        return 0

    _write_json(pool_path, retained_pairs)

    scenario_path = storage_dir / "scenarios.json"
    if scenario_path.is_file():
        with scenario_path.open("r", encoding="utf-8") as handle:
            scenario_index = json.load(handle)
        if not isinstance(scenario_index, dict):
            raise ValueError(f"Expected an object in {scenario_path}")

        retained_ids = {
            pair.get("pair_id")
            for pair in retained_pairs
            if isinstance(pair, dict) and pair.get("pair_id")
        }
        filtered_index = {
            scenario: [pair_id for pair_id in pair_ids if pair_id in retained_ids]
            for scenario, pair_ids in scenario_index.items()
            if isinstance(pair_ids, list)
        }
        _write_json(scenario_path, filtered_index)

    return removed_count


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Remove one project's examples from a progressive KB copy"
    )
    parser.add_argument("--storage-dir", required=True, type=Path)
    parser.add_argument("--project", required=True)
    args = parser.parse_args()

    removed_count = remove_project_entries(args.storage_dir, args.project)
    print(
        f"Removed {removed_count} progressive KB entries for {args.project}: "
        f"{args.storage_dir}"
    )


if __name__ == "__main__":
    main()
