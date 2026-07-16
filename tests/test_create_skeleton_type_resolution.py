import unittest

from src.java.translation.create_skeleton import (
    generate_field_skeleton,
    get_fragment_cangjie_type,
    get_method_params,
    get_method_return_type,
    get_parameter_cangjie_type,
)


def translation(source_type, target_type, translated=True):
    return {
        "translated": translated,
        "source_type": source_type,
        "translated_target_type": target_type,
    }


class CreateSkeletonTypeResolutionTests(unittest.TestCase):
    def setUp(self):
        self.type_map = {
            "LegacyType": "DeterministicType",
            "LegacyParam": "DeterministicParam",
            "LegacyReturn": "DeterministicReturn",
        }

    def test_field_uses_translated_target_type(self):
        field_info = {
            "types": ["LegacyType"],
            "modifiers": [],
            "type_translations": {
                "types": {
                    "LegacyType": translation("LegacyType", "ResolvedType"),
                }
            },
        }

        skeleton, _ = generate_field_skeleton(
            field_info, "1-1:value", self.type_map
        )

        self.assertIn("value: ResolvedType", skeleton)

    def test_method_parameter_and_return_use_translated_targets(self):
        param = {"modifier": "final", "type": "LegacyParam", "name": "value"}
        method_info = {
            "parameters": [param],
            "return_types": ["LegacyReturn"],
            "type_translations": {
                "parameters": {
                    "final|LegacyParam|value": translation(
                        "LegacyParam", "ResolvedParam"
                    ),
                },
                "return_types": {
                    "LegacyReturn": translation(
                        "LegacyReturn", "ResolvedReturn"
                    ),
                },
            },
        }

        self.assertEqual(
            get_parameter_cangjie_type(method_info, param, self.type_map),
            "ResolvedParam",
        )
        self.assertEqual(
            get_method_params(method_info, self.type_map),
            ["value: ResolvedParam"],
        )
        self.assertEqual(
            get_method_return_type(method_info, self.type_map),
            "ResolvedReturn",
        )

    def test_explicit_any_translation_is_authoritative(self):
        fragment_info = {
            "type_translations": {
                "types": {
                    "LegacyType": translation("LegacyType", "Any"),
                }
            }
        }

        self.assertEqual(
            get_fragment_cangjie_type(
                fragment_info, "types", "LegacyType", self.type_map
            ),
            "Any",
        )

    def test_incomplete_or_mismatched_translation_uses_fallback(self):
        incomplete = {
            "type_translations": {
                "types": {
                    "LegacyType": translation(
                        "LegacyType", "ResolvedType", translated=False
                    ),
                }
            }
        }
        mismatched = {
            "type_translations": {
                "types": {
                    "LegacyType": translation("OtherType", "ResolvedType"),
                }
            }
        }

        self.assertEqual(
            get_fragment_cangjie_type(
                incomplete, "types", "LegacyType", self.type_map
            ),
            "DeterministicType",
        )
        self.assertEqual(
            get_fragment_cangjie_type(
                mismatched, "types", "LegacyType", self.type_map
            ),
            "DeterministicType",
        )


if __name__ == "__main__":
    unittest.main()
