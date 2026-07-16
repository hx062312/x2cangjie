import unittest

from src.java.translation.reset_fragment_results import reset_schema


class ResetFragmentResultsTests(unittest.TestCase):
    def test_resets_results_and_preserves_type_metadata(self):
        type_translations = {
            "types": {
                "String": {
                    "translated": True,
                    "translated_target_type": "String",
                }
            }
        }
        schema = {
            "classes": {
                "1-10:Demo": {
                    "fields": {
                        "2-2:value": {
                            "types": ["String"],
                            "type_translations": type_translations,
                            "translation": "let value = translated",
                            "translation_status": "completed",
                            "cangjie_compilation": {"outcome": "success"},
                            "test_execution": {"outcome": "success"},
                            "elapsed_time": 12.5,
                            "generation_timestamp": "now",
                            "model_name": "model",
                            "partial_translation": ["translated"],
                            "original_budget": {"syntactic": 2},
                            "final_budget": {"syntactic": 1},
                        }
                    },
                    "methods": {},
                    "static_initializers": {},
                }
            }
        }

        count = reset_schema(schema)
        fragment = schema["classes"]["1-10:Demo"]["fields"]["2-2:value"]

        self.assertEqual(count, 1)
        self.assertEqual(fragment["translation"], [])
        self.assertEqual(fragment["translation_status"], "pending")
        self.assertEqual(fragment["cangjie_compilation"], "pending")
        self.assertEqual(fragment["test_execution"], "pending")
        self.assertEqual(fragment["elapsed_time"], 0)
        self.assertEqual(fragment["partial_translation"], [])
        self.assertNotIn("original_budget", fragment)
        self.assertNotIn("final_budget", fragment)
        self.assertIs(fragment["type_translations"], type_translations)


if __name__ == "__main__":
    unittest.main()
