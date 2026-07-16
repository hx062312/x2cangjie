"""Regression tests for pseudocode reuse across compilation retries."""

import contextlib
import unittest
from types import SimpleNamespace
from unittest.mock import Mock, patch

from src.java.translation import compositional_translation_validation as translation


class _PromptGenerator:
    seen_pseudocode = []

    def __init__(self, **kwargs):
        self.seen_pseudocode.append(kwargs["pseudocode"])

    def generate_prompt(self):
        return "translation prompt"


class PseudocodeRetryStabilityTests(unittest.TestCase):
    def test_pseudocode_prompt_keeps_skeleton_and_java_authoritative(self):
        prompt = translation.PromptGenerator.__new__(translation.PromptGenerator)
        prompt.prompt = ""
        prompt.pseudocode_context = "supplementary steps"

        prompt.add_pseudocode_bridge()

        self.assertIn("partial Cangjie skeleton is authoritative", prompt.prompt)
        self.assertIn("Java source is authoritative", prompt.prompt)
        self.assertIn("supplementary guidance", prompt.prompt)
        self.assertNotIn("authoritative description of WHAT", prompt.prompt)

    def test_pseudocode_is_generated_once_and_reused_after_compile_failure(self):
        args = SimpleNamespace(
            model="deepseek-chat",
            temperature=0.0,
            use_pseudocode="true",
            use_rag="false",
            skip_mock="true",
        )
        fragment = {
            "schema_name": "project.src.main.Example",
            "class_name": "Example",
            "fragment_name": "1-3:value",
            "fragment_type": "method",
            "is_test_method": False,
            "is_constructor": False,
        }
        budget = {"syntactic": 2, "cangjie_compilation": 2, "test_execution": 2}
        pseudocode = Mock(return_value="stable pseudocode")
        _PromptGenerator.seen_pseudocode = []

        patches = (
            patch.object(
                translation.yaml,
                "safe_load",
                return_value={
                    "models": {
                        "deepseek-chat": {
                            "model_id": "model",
                            "total": 1000,
                            "max_new_tokens": 100,
                        }
                    }
                },
            ),
            patch.object(translation, "OpenAI", return_value=Mock()),
            patch.object(translation, "_generate_pseudocode", pseudocode),
            patch.object(translation, "PromptGenerator", _PromptGenerator),
            patch.object(
                translation,
                "redirect_stdout_to_body_log",
                return_value=contextlib.nullcontext(),
            ),
            patch.object(translation, "get_total_input_tokens", return_value=10),
            patch.object(translation, "prompt_model", return_value="generation"),
            patch.object(
                translation,
                "extract_json_translation",
                return_value=(True, ["func value(): Unit {}"], ""),
            ),
            patch.object(
                translation,
                "rewrite_flattened_custom_type_access",
                side_effect=lambda code, args: code,
            ),
            patch.object(
                translation,
                "rewrite_static_import_member_access",
                side_effect=lambda code, fragment, args: code,
            ),
            patch.object(
                translation,
                "cangjie_compilation_validation",
                side_effect=[
                    (1, "compile feedback", "failure"),
                    (translation.SUCCESS, "", "success"),
                ],
            ),
            patch.object(translation, "update_labels"),
            patch.object(translation, "update_budget"),
            patch.object(translation, "log_detail"),
            patch.object(translation, "terminal_attempt"),
            patch.object(translation, "terminal_result"),
            patch.object(translation, "_store_translation_pair_to_kb"),
        )

        with contextlib.ExitStack() as stack:
            for item in patches:
                stack.enter_context(item)
            translation.translate(fragment, args, [], budget=budget)

        pseudocode.assert_called_once()
        self.assertEqual(
            _PromptGenerator.seen_pseudocode,
            ["stable pseudocode", "stable pseudocode"],
        )


if __name__ == "__main__":
    unittest.main()
