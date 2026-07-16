import os
import tempfile
import unittest

from src.java.type_resolution.translate_type_rag import validate_deterministic_type_map
from src.java.type_resolution.type_expression import (
    PRIMITIVE_TYPE_MAP,
    build_default_type_map,
    get_cangjie_type,
)


class TypeResolutionAssetTests(unittest.TestCase):
    def test_core_generic_maps_load_outside_repository_cwd(self):
        original_cwd = os.getcwd()
        try:
            with tempfile.TemporaryDirectory() as temp_dir:
                os.chdir(temp_dir)
                type_map = build_default_type_map()
        finally:
            os.chdir(original_cwd)

        self.assertEqual(get_cangjie_type("List<String>", type_map), "ArrayList<String>")
        self.assertEqual(
            get_cangjie_type("Map<String, String>", type_map),
            "HashMap<String, String>",
        )
        self.assertEqual(get_cangjie_type("ArrayList<>", type_map), "ArrayList<Any>")
        self.assertEqual(
            get_cangjie_type("HashSet<>", type_map), "HashSet<AnyHashable>"
        )
        validate_deterministic_type_map(type_map)

    def test_validation_rejects_missing_generic_assets(self):
        with self.assertRaisesRegex(RuntimeError, "java_generic_type_map.json"):
            validate_deterministic_type_map(dict(PRIMITIVE_TYPE_MAP))


if __name__ == "__main__":
    unittest.main()
