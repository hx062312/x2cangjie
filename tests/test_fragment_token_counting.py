import math
import unittest
from argparse import Namespace
from unittest.mock import Mock, patch

from src.java.translation import compositional_translation_validation as translation


class FragmentTokenCountingTests(unittest.TestCase):
    def setUp(self):
        translation._TOKEN_ENCODINGS.clear()
        translation._FAILED_TOKENIZER_MODELS.clear()
        translation._TOKEN_COUNT_NOTICES.clear()

    def test_non_openai_model_uses_offline_estimate(self):
        prompt = "translate this Java fragment"
        args = Namespace(model="deepseek-chat")
        model_info = {
            "deepseek-chat": {"model_id": "deepseek-chat", "total": 128000}
        }

        with patch.object(translation.tiktoken, "encoding_for_model") as loader:
            count = translation.get_total_input_tokens(prompt, args, model_info)

        self.assertEqual(count, math.ceil(len(prompt.encode("utf-8")) / 3))
        loader.assert_not_called()

    def test_openai_encoding_is_cached(self):
        args = Namespace(model="gpt-4o-2024-11-20")
        model_info = {
            "gpt-4o-2024-11-20": {
                "model_id": "gpt-4o-2024-11-20",
                "total": 128000,
            }
        }
        encoding = Mock()
        encoding.encode.return_value = [1, 2, 3]

        with patch.object(
            translation.tiktoken, "encoding_for_model", return_value=encoding
        ) as loader:
            first = translation.get_total_input_tokens("one", args, model_info)
            second = translation.get_total_input_tokens("two", args, model_info)

        self.assertEqual((first, second), (3, 3))
        loader.assert_called_once_with("gpt-4o")

    def test_tokenizer_download_failure_retries_then_stays_offline(self):
        prompt = "class Example {}"
        args = Namespace(model="gpt-4o-2024-11-20")
        model_info = {
            "gpt-4o-2024-11-20": {
                "model_id": "gpt-4o-2024-11-20",
                "total": 128000,
            }
        }

        with (
            patch.object(
                translation.tiktoken,
                "encoding_for_model",
                side_effect=OSError("connection interrupted"),
            ) as loader,
            patch.object(translation.time, "sleep") as sleep,
        ):
            first = translation.get_total_input_tokens(prompt, args, model_info)
            second = translation.get_total_input_tokens(prompt, args, model_info)

        expected = math.ceil(len(prompt.encode("utf-8")) / 3)
        self.assertEqual((first, second), (expected, expected))
        self.assertEqual(loader.call_count, 3)
        self.assertEqual(sleep.call_count, 2)


if __name__ == "__main__":
    unittest.main()
