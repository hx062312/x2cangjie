import unittest

from src.java.type_resolution.reset_type_results import reset_type_results


class ResetTypeResultsTests(unittest.TestCase):
    def test_resets_outcomes_and_preserves_source_metadata(self):
        schema = {
            "classes": {
                "1-3:Demo": {
                    "fields": {
                        "2-2:values": {
                            "types": ["List<String>"],
                            "type_translations": {
                                "types": {
                                    "List<String>": {
                                        "identifier": "List<String>",
                                        "source_type": "List<String>",
                                        "translated": True,
                                        "attempted": True,
                                        "translated_target_type": "Any",
                                        "feedback": "old failure",
                                    }
                                }
                            },
                        }
                    },
                    "methods": {},
                }
            }
        }

        count = reset_type_results(schema)
        result = schema["classes"]["1-3:Demo"]["fields"]["2-2:values"][
            "type_translations"
        ]["types"]["List<String>"]

        self.assertEqual(count, 1)
        self.assertFalse(result["translated"])
        self.assertFalse(result["attempted"])
        self.assertEqual(result["translated_target_type"], "")
        self.assertEqual(result["feedback"], "")
        self.assertEqual(result["source_type"], "List<String>")
        self.assertEqual(result["identifier"], "List<String>")
        self.assertEqual(result["type_variation"], "types")


if __name__ == "__main__":
    unittest.main()
