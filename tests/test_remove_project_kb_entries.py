import json
import tempfile
import unittest
from pathlib import Path

from src.java.progressive_kb.remove_project_entries import remove_project_entries


class RemoveProjectKBEntriesTests(unittest.TestCase):
    def test_removes_project_pairs_and_stale_scenario_ids(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            storage_dir = Path(temp_dir)
            pairs = [
                {"pair_id": "csv-1", "source_project": "commons-csv"},
                {"pair_id": "cli-1", "source_project": "commons-cli"},
            ]
            scenarios = {
                "general": ["csv-1", "cli-1"],
                "method_body": ["csv-1"],
            }
            (storage_dir / "translation_pool.json").write_text(
                json.dumps(pairs), encoding="utf-8"
            )
            (storage_dir / "scenarios.json").write_text(
                json.dumps(scenarios), encoding="utf-8"
            )

            removed = remove_project_entries(storage_dir, "commons-csv")

            self.assertEqual(removed, 1)
            retained_pairs = json.loads(
                (storage_dir / "translation_pool.json").read_text(encoding="utf-8")
            )
            filtered_scenarios = json.loads(
                (storage_dir / "scenarios.json").read_text(encoding="utf-8")
            )
            self.assertEqual([pair["pair_id"] for pair in retained_pairs], ["cli-1"])
            self.assertEqual(filtered_scenarios["general"], ["cli-1"])
            self.assertEqual(filtered_scenarios["method_body"], [])


if __name__ == "__main__":
    unittest.main()
