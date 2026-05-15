import argparse
import contextlib
import datetime
import json
import math
import os
import re
import sys
import time
from pathlib import Path

import tiktoken
import yaml
from openai import OpenAI
from src.java.translation.cangjie_compilation_validation import cangjie_compilation_validation
from src.java.translation.get_reverse_traversal import get_reverse_traversal
from src.java.translation.prompt_generator import PromptGenerator
from src.java.rag import get_rag_engine
from src.java.isolation_validation.test_runner import (
    run_mock_tests_for_fragment,
    session_clean,
    session_inject,
)

# response_format configuration
JSON_OUTPUT_SCHEMA = {
    "type": "json_object"
}

# Status constants for translation validation
ERROR = "error"
SUCCESS = "success"
FAILURE = "failure"
NOT_EXERCISED = "not-exercised"


def init_body_log(args):
    log_path = f"{args.project}_{args.model}_{args.prompt_type}.log"
    with open(log_path, "w") as f:
        f.write("=" * 80 + "\n")
        f.write(f"Body translation run started at {datetime.datetime.now().isoformat()}\n")
        f.write(f"project={args.project}, model={args.model}, temperature={args.temperature}\n")
        f.write("=" * 80 + "\n")
    return log_path


def log_detail(args, title, content=""):
    log_path = getattr(args, "body_log_path", None)
    if not log_path:
        return
    with open(log_path, "a") as f:
        f.write(f"\n{'=' * 24} {title} {'=' * 24}\n")
        if content is not None:
            f.write(str(content))
            if not str(content).endswith("\n"):
                f.write("\n")


@contextlib.contextmanager
def redirect_stdout_to_body_log(args):
    log_path = getattr(args, "body_log_path", None)
    if not log_path:
        yield
        return
    with open(log_path, "a") as log_file, contextlib.redirect_stdout(log_file):
        yield


def strip_ansi(text):
    return re.sub(r"\x1b\[[0-9;]*m", "", str(text or ""))


def summarize_feedback(feedback):
    text = strip_ansi(feedback)
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        lower = stripped.lower()
        if lower.startswith("error: failed to compile package") or lower.startswith("error: cjpm build failed"):
            continue
        return stripped[:140]
    return "no details"


def simple_name(name):
    return str(name or "").split(":")[-1]


def fragment_display_name(fragment):
    return f"{simple_name(fragment.get('class_name'))}.{simple_name(fragment.get('fragment_name'))}"


def terminal_fragment_header(index, total, fragment):
    width = max(3, len(str(total)))
    print(
        f"[{index:0{width}d}/{total:0{width}d}] "
        f"{fragment_display_name(fragment)} | {fragment.get('fragment_type')}",
        flush=True,
    )


def terminal_attempt(stage, attempt, total, passed, detail=""):
    icon = "✅" if passed else "❌"
    suffix = f" {summarize_feedback(detail)}" if detail else ""
    print(f"  {stage:<7} {attempt}/{total} {icon}{suffix}", flush=True)


def terminal_result(passed, reason):
    icon = "✅" if passed else "❌"
    print(f"  result  {icon} {reason}", flush=True)


def get_fragment_schema_data(fragment, args):
    with open(f"{args.translation_dir}/{fragment['schema_name']}.json", "r") as f:
        return json.load(f)


def get_fragment_file_info(fragment, args):
    try:
        schema_data = get_fragment_schema_data(fragment, args)
    except Exception:
        return ("<unknown>", simple_name(fragment.get("class_name")))

    path = (
        schema_data.get("cangjie_translations_skeleton_path")
        or schema_data.get("cangjie_skeleton_path")
        or "<unknown>"
    )
    project_marker = f"/{args.project}/src/"
    if project_marker in path:
        display_path = f"{args.project}/src/{path.split(project_marker, 1)[1]}"
    else:
        display_path = path
    return (display_path, simple_name(fragment.get("class_name")))


def find_class_key(classes_dict, class_name):
    """Find a class key that matches the given class_name pattern.

    Handles both full keys (e.g., '4-26:BaseClass') and simple names (e.g., 'BaseClass').
    """
    for key in classes_dict:
        if key == class_name or key.endswith(f":{class_name}"):
            return key
    return None


def find_method_key(methods_dict, method_name):
    """Find a method key that matches the given method_name pattern.

    Handles both full keys (e.g., '11-13:BaseClass') and simple names (e.g., 'BaseClass').
    """
    for key in methods_dict:
        if key == method_name or key.endswith(f":{method_name}"):
            return key
    return None


def get_pending_fragments(fragment_traversal, args):
    """
    Extract all pending fragments which require translation
    """

    processed_fragments, pending_fragments = [], []

    for fragment in fragment_traversal:
        schema_data = {}
        with open(
            f"{args.translation_dir}/{fragment['schema_name']}.json",
            "r",
        ) as f:
            schema_data = json.load(f)

        class_key = find_class_key(schema_data["classes"], fragment["class_name"])
        if not class_key:
            continue

        frag_info = schema_data["classes"][class_key][
            f"{fragment['fragment_type']}s"
        ].get(fragment["fragment_name"])
        if not frag_info:
            continue

        translation_status = frag_info.get("translation_status", "")
        translation = frag_info.get("translation", [])

        if translation_status == "completed" and translation:
            processed_fragments.append(
                f"{fragment['schema_name']}|{fragment['class_name']}|{fragment['fragment_name']}"
            )
            continue

        pending_fragments.append(fragment)

    return processed_fragments, pending_fragments


def update_labels(
    args,
    fragment,
    translation,
    translation_status,
    cangjie_compilation,
    test_execution,
    elapsed_time,
    update_test_execution=False,
):
    """
    Update the labels of the fragment in the schema file.
    """
    schema_data = {}
    schema_file = (
        f"{args.translation_dir}/{fragment['schema_name']}.json"
    )
    with open(schema_file, "r") as f:
        schema_data = json.load(f)

    class_key = find_class_key(schema_data["classes"], fragment["class_name"])
    if not class_key:
        return

    frag_dict = schema_data["classes"][class_key][
        f"{fragment['fragment_type']}s"
    ].get(fragment["fragment_name"])
    if not frag_dict:
        return

    if update_test_execution:
        if isinstance(frag_dict.get("test_execution"), dict):
            frag_dict["test_execution"].update(test_execution)
        else:
            frag_dict["test_execution"] = test_execution
    else:
        if translation == "<translated>":
            if "partial_translation" in frag_dict:
                translation = frag_dict.get("partial_translation", [])
            else:
                translation = []

        # Update partial_translation after successful translation
        # Only update if translation is valid (not a placeholder and doesn't contain class declaration)
        if translation_status == "completed" and translation:
            translation_str = "\n".join(translation) if isinstance(translation, list) else str(translation)
            # Skip if translation contains class declaration (indicates AI outputted full class instead of method)
            if "class " in translation_str and "{" in translation_str and "}" in translation_str:
                log_detail(args, "WARN", f"Skipping partial_translation update for {fragment['fragment_name']}: contains full class declaration")
            else:
                frag_dict["partial_translation"] = translation

        frag_dict["translation"] = translation
        frag_dict["translation_status"] = translation_status
        frag_dict["cangjie_compilation"] = cangjie_compilation

        if "test_execution" in frag_dict and (
            isinstance(frag_dict["test_execution"], dict) or
            frag_dict["test_execution"] in ("pending", "not-exercised")
        ):
            pass
        else:
            frag_dict["test_execution"] = test_execution
        frag_dict["elapsed_time"] = elapsed_time
        frag_dict["generation_timestamp"] = datetime.datetime.now().isoformat()

    with open(schema_file, "w") as f:
        json.dump(schema_data, f, indent=4)
        f.flush()
        os.fsync(f.fileno())


def update_budget(fragment, args, budget, type_="original"):
    schema_data = {}
    with open(
        f"{args.translation_dir}/{fragment['schema_name']}.json", "r"
    ) as f:
        schema_data = json.load(f)

    class_key = find_class_key(schema_data["classes"], fragment["class_name"])
    if not class_key:
        return

    schema_data["classes"][class_key][f"{fragment['fragment_type']}s"][
        fragment["fragment_name"]
    ][f"{type_}_budget"] = budget

    with open(
        f"{args.translation_dir}/{fragment['schema_name']}.json", "w"
    ) as f:
        json.dump(schema_data, f, indent=4)
        f.flush()
        os.fsync(f.fileno())


def is_field_already_translated(fragment, args):
    """
    Check if a field is already deterministically translated
    """
    with redirect_stdout_to_body_log(args):
        prompt_generator = PromptGenerator(
            is_feedback=False, args=args, fragment_details=fragment
        )

    if (
        fragment["fragment_type"] == "field"
        and prompt_generator.prompt_status == "translated"
    ):
        update_budget(
            fragment,
            args,
            budget={
                "cangjie_compilation": -1,
                "test_execution": -1,
            },
            type_="original",
        )
        update_budget(
            fragment,
            args,
            budget={
                "cangjie_compilation": -1,
                "test_execution": -1,
            },
            type_="final",
        )
        update_labels(
            args=args,
            fragment=fragment,
            translation=f"<{prompt_generator.prompt_status}>",
            translation_status="attempted",
            cangjie_compilation="success",
            test_execution="pending",
            elapsed_time=0,
        )
        return True

    return False


def get_adaptive_budget(fragment, args, feedback=False):
    """
    Get adaptive budget for translation based on dynamic analysis.
    """
    if fragment["fragment_type"] in ["field", "static_initializer"]:
        return 2 if not feedback else 1
    elif fragment["fragment_type"] == "method" and fragment["is_test_method"]:
        return 2 if not feedback else 1

    # Shared pool: 4 attempts cover both compilation failures AND mock-test
    # failures for normal methods (constructors included).
    return 4 if not feedback else 1


def get_total_input_tokens(prompt, args, model_info):
    if args.model == "gpt-4o-2024-11-20":
        encoding = tiktoken.encoding_for_model("gpt-4o")
        total_tokens = len(encoding.encode(prompt))
    else:
        encoding = tiktoken.encoding_for_model("gpt-4o")
        total_tokens = len(encoding.encode(prompt))

    return total_tokens


def prompt_model(model_info, client, prompt, total_input_tokens, args, response_format=None):
    max_new_tokens = model_info[args.model]["total"] - total_input_tokens
    max_new_tokens = min(max_new_tokens, model_info[args.model]["max_new_tokens"])

    kwargs = dict(
        model=model_info[args.model]["model_id"],
        messages=[
            {"role": "system", "content": "You are a Java to Cangjie code translation expert. You output only valid JSON."},
            {"role": "user", "content": prompt},
        ],
        max_tokens=max_new_tokens,
        temperature=args.temperature,
        top_p=1.0,
        frequency_penalty=0.0,
        presence_penalty=0.0,
    )
    if response_format:
        kwargs["response_format"] = response_format

    completion = client.chat.completions.create(**kwargs)

    generation = completion.choices[0].message.content

    if args.model == "deepseek-coder-33b-instruct":
        if generation.strip().startswith("```"):
            pass
        elif generation.count("```") % 2 == 0:
            pass
        else:
            generation = prompt + generation.strip()
            generation = generation[generation.find("### Response:") :]

    return generation


def extract_json_translation(generation: str, fragment: dict, args) -> tuple:
    """
    Extract translation from JSON output.
    Returns (success, code_lines_or_body, error_message).

    The JSON is expected to have fields:
      - "class": (optional) the complete class definition
      - "method": the translated method (with signature). Used by extract_method_body.
      - "reasoning": (optional) model's reasoning
      - "imports": (optional) additional imports needed
    """
    try:
        response = json.loads(generation)
    except json.JSONDecodeError as e:
        return False, None, f"the model did not output valid JSON: {e}"

    # Try 'method' first, fall back to 'code' for backward compatibility
    content = response.get("method") or response.get("code") or ""
    if not content or not content.strip():
        return False, None, "the 'method' field in JSON output is empty"

    imports = response.get("imports", "")
    if imports and imports.strip():
        log_detail(args, "JSON IMPORTS", imports)

    fragment_type = fragment.get("fragment_type", "method")
    if fragment_type in ("method", "static_initializer"):
        from src.java.translation.cangjie_compilation_validation import extract_method_body
        body = extract_method_body(content, fragment)
        if not body or not body.strip():
            return False, None, "extracted method body is empty"
        return True, body.split("\n"), None
    else:
        return True, content.split("\n"), None


def translate(
    fragment, args, processed_fragments, budget={}, feedback=None, recursion_depth=2
):

    if recursion_depth == 0:
        return

    log_detail(
        args,
        "FRAGMENT",
        (
            f"{fragment.get('schema_name')}|{fragment.get('class_name')}|{fragment.get('fragment_name')} "
            f"(type={fragment.get('fragment_type')}, "
            f"test={fragment.get('is_test_method')}, "
            f"ctor={fragment.get('is_constructor')})"
        ),
    )

    model_info = yaml.safe_load(open("configs/model_configs.yaml", "r"))["models"]

    client = OpenAI(
        **{
            k: v
            for k, v in model_info[args.model].items()
            if k in ["api_key", "base_url", "default_headers"]
        }
    )

    if budget == {}:
        adaptive_budget = get_adaptive_budget(fragment, args)
        budget = {
            "syntactic": adaptive_budget,
            "cangjie_compilation": adaptive_budget,
            "test_execution": adaptive_budget,
        }
        adaptive_budget_feedback = get_adaptive_budget(fragment, args, feedback=True)
        feedback_budget = {
            "syntactic": adaptive_budget_feedback,
            "cangjie_compilation": adaptive_budget_feedback,
            "test_execution": adaptive_budget_feedback,
        }

        update_budget(fragment, args, budget, type_="original")

    current_budget = "cangjie_compilation"
    shared_budget_total = budget.get("cangjie_compilation", get_adaptive_budget(fragment, args))
    start_time = time.time()

    while budget[current_budget] > 0:
        shared_attempt = shared_budget_total - budget.get("cangjie_compilation", shared_budget_total) + 1
        ############################ <TRANSLATION> ############################
        with redirect_stdout_to_body_log(args):
            prompt_gen = PromptGenerator(
                is_feedback=True if feedback else False,
                args=args,
                fragment_details=fragment,
                feedback=feedback,
            )
            prompt = prompt_gen.generate_prompt()

        log_detail(args, "PROMPT", prompt)

        total_input_tokens = get_total_input_tokens(prompt, args, model_info)

        if total_input_tokens >= model_info[args.model]["total"]:
            update_labels(
                args=args,
                fragment=fragment,
                translation="<translated>",
                translation_status="out_of_context",
                cangjie_compilation="pending",
                test_execution="pending",
                elapsed_time=0,
            )
            update_budget(fragment, args, budget, type_="final")
            terminal_result(False, "fallback:out_of_context")
            break

        with redirect_stdout_to_body_log(args):
            generation = prompt_model(
                model_info, client, prompt, total_input_tokens, args,
                response_format=JSON_OUTPUT_SCHEMA,
            )

        log_detail(args, "GENERATION", generation)
        ############################ </TRANSLATION> ############################

        ############################ <EXTRACT CODE> ############################
        syntactic_status, extracted_code, syntactic_feedback = (
            extract_json_translation(generation, fragment, args)
        )

        if not syntactic_status:
            if budget["syntactic"] - 1 == 0:
                update_labels(
                    args=args,
                    fragment=fragment,
                    translation="<translated>",
                    translation_status="attempted",
                    cangjie_compilation={
                        "outcome": "error",
                        "message": syntactic_feedback,
                    },
                    test_execution="pending",
                    elapsed_time=time.time() - start_time,
                )
                update_budget(fragment, args, budget, type_="final")
                terminal_attempt("compile", shared_attempt, shared_budget_total, False, syntactic_feedback)
                terminal_result(False, "fallback:syntactic")
                break

            budget["syntactic"] -= 1
            terminal_attempt("compile", shared_attempt, shared_budget_total, False, syntactic_feedback)
            log_detail(args, "CODE EXTRACTION FAILED - REPROMPTING", syntactic_feedback)
            # Update feedback for next iteration
            if not feedback:
                feedback = f"The output must be valid JSON with 'code' and 'reasoning' fields: {syntactic_feedback}"
            else:
                feedback = f"{feedback}\nThe output must be valid JSON with 'code' and 'reasoning' fields: {syntactic_feedback}"
            continue

        if isinstance(extracted_code, str):
            generation_lines = extracted_code.split("\n")
        else:
            generation_lines = extracted_code

        generation = "\n".join(generation_lines)

        if "syntactic" not in budget:
            budget["syntactic"] = 2

        update_labels(
            args=args,
            fragment=fragment,
            translation=generation_lines,
            translation_status="attempted",
            cangjie_compilation={
                "outcome": "pending",
                "message": "waiting for compilation",
            },
            test_execution="pending",
            elapsed_time=time.time() - start_time,
        )
        ############################ </EXTRACT CODE> ############################

        ############################ <CANGJIE COMPILATION VALIDATION> ############################
        current_budget = "cangjie_compilation"
        cangjie_compilation_status = "pending"
        status, compilation_feedback, message = cangjie_compilation_validation(generation, fragment, args)

        if status != SUCCESS:
            terminal_attempt("compile", shared_attempt, shared_budget_total, False, compilation_feedback)
            if budget[current_budget] - 1 == 0:
                update_labels(
                    args=args,
                    fragment=fragment,
                    translation="<translated>",
                    translation_status="attempted",
                    cangjie_compilation={"outcome": "error", "message": message},
                    test_execution="pending",
                    elapsed_time=time.time() - start_time,
                )
                update_budget(fragment, args, budget, type_="final")
                terminal_result(False, "fallback:compile_validation")
                break

            log_detail(args, "CANGJIE COMPILATION FAILED - REPROMPTING", compilation_feedback)

            budget[current_budget] -= 1
            # RAG error context injection on compilation failure
            if hasattr(args, 'use_rag') and args.use_rag == 'true':
                try:
                    with redirect_stdout_to_body_log(args):
                        rag_engine = get_rag_engine()
                        error_ctx = rag_engine.inject_error_context(compilation_feedback)
                    if error_ctx:
                        compilation_feedback = error_ctx + "\n\n" + compilation_feedback
                except Exception as e:
                    log_detail(args, "RAG WARNING", f"Compilation error RAG injection failed: {e}")
            # Update feedback for next iteration - append to existing feedback
            if not feedback:
                feedback = compilation_feedback
            else:
                feedback = f"{feedback}\n{compilation_feedback}"
            continue

        cangjie_compilation_status = "success"
        terminal_attempt("compile", shared_attempt, shared_budget_total, True)
        # Intermediate state: compile passed, mock test pending. Final
        # translation_status flips to "completed" only after mock-test resolves
        # (or is skipped for non-normal-method fragments).
        update_labels(
            args=args,
            fragment=fragment,
            translation=generation,
            translation_status="attempted",
            cangjie_compilation={"outcome": "success", "message": message},
            test_execution="pending",
            elapsed_time=time.time() - start_time,
        )
        ############################ </CANGJIE COMPILATION VALIDATION> ############################

        ############################ <TEST EXECUTION> ############################
        # Mock test runs only for "normal" methods: not test, not constructor,
        # and not field/static_initializer. For other fragment shapes we keep
        # the previous behavior (test_execution = not-exercised / pending).
        is_normal_method = (
            fragment["fragment_type"] == "method"
            and not fragment["is_test_method"]
            and not fragment.get("is_constructor")
        )

        if not is_normal_method:
            update_labels(
                args=args,
                fragment=fragment,
                translation=generation,
                translation_status="completed",
                cangjie_compilation={"outcome": "success", "message": message},
                test_execution=("pending" if fragment["is_test_method"] else "not-exercised"),
                elapsed_time=time.time() - start_time,
            )
            update_budget(fragment, args, budget, type_="final")
            terminal_attempt("test", shared_attempt, shared_budget_total, True, "skipped")
            terminal_result(True, "llm")
            if fragment["is_test_method"]:
                return
            break

        with redirect_stdout_to_body_log(args):
            mock_status, mock_message = run_mock_tests_for_fragment(
                fragment=fragment,
                skeleton_dir=args.skeleton_dir,
                staging_dir=args.staging_dir,
            )

        if mock_status in ("no-tests", "success"):
            terminal_attempt(
                "test",
                shared_attempt,
                shared_budget_total,
                True,
                "no-tests" if mock_status == "no-tests" else "",
            )
            update_labels(
                args=args,
                fragment=fragment,
                translation=generation,
                translation_status="completed",
                cangjie_compilation={"outcome": "success", "message": message},
                test_execution=(
                    "not-exercised"
                    if mock_status == "no-tests"
                    else {"outcome": "success", "message": mock_message}
                ),
                elapsed_time=time.time() - start_time,
            )
            update_budget(fragment, args, budget, type_="final")
            terminal_result(True, "llm")
            break

        # mock_status == "failure": share the cangjie_compilation budget pool.
        terminal_attempt("test", shared_attempt, shared_budget_total, False, mock_message)
        if budget["cangjie_compilation"] - 1 == 0:
            # Exhausted. Per spec H(ii): compile succeeded → status=completed,
            # only test_execution carries the failure.
            update_labels(
                args=args,
                fragment=fragment,
                translation=generation,
                translation_status="completed",
                cangjie_compilation={"outcome": "success", "message": message},
                test_execution={"outcome": "failure", "message": mock_message},
                elapsed_time=time.time() - start_time,
            )
            update_budget(fragment, args, budget, type_="final")
            terminal_result(False, "fallback:test_validation")
            break

        budget["cangjie_compilation"] -= 1
        log_detail(args, "MOCK TEST FAILED - REPROMPTING", mock_message)
        # Mark intermediate retry state so the schema reflects the rollback.
        update_labels(
            args=args,
            fragment=fragment,
            translation=generation,
            translation_status="attempted",
            cangjie_compilation={"outcome": "success", "message": message},
            test_execution={"outcome": "failure", "message": mock_message},
            elapsed_time=time.time() - start_time,
        )
        if not feedback:
            feedback = mock_message
        else:
            feedback = f"{feedback}\n{mock_message}"
        continue
        ############################ </TEST EXECUTION> ############################


def main(args):

    args.prompt_type = "body" if args.include_implementation else "signature"
    args.translation_dir = f"data/java/schemas{args.suffix}/{args.model}/{args.temperature}/{args.project}"
    args.body_log_path = init_body_log(args)

    args.skeleton_dir = Path(f"data/java/skeletons/{args.project}")
    args.staging_dir = Path(f"/tmp/cangjie_mock/{args.project}")

    if not args.skeleton_dir.is_dir() or not (args.skeleton_dir / "cjpm.toml").is_file():
        print(
            f"[mock] skeleton project not found: {args.skeleton_dir} (cjpm.toml required). "
            f"Run create_skeleton.sh {args.project} first.",
            file=sys.stderr,
        )
        sys.exit(1)

    if not args.staging_dir.is_dir():
        print(
            f"[mock] staging dir not found: {args.staging_dir}. "
            f"Run scripts/java/build_mock_corpus.sh {args.project} first.",
            file=sys.stderr,
        )
        sys.exit(1)

    fragment_traversal = get_reverse_traversal(args)

    processed_fragments, pending_fragments = get_pending_fragments(
        fragment_traversal, args
    )

    session_inject(args.skeleton_dir)
    try:
        current_file = None
        total_fragments = len(pending_fragments)
        file_info_cache = {}

        def cached_file_info(fragment):
            key = f"{fragment['schema_name']}|{fragment['class_name']}"
            if key not in file_info_cache:
                file_info_cache[key] = get_fragment_file_info(fragment, args)
            return file_info_cache[key]

        for fragment_index, fragment in enumerate(pending_fragments, start=1):
            frag_key = f"{fragment['schema_name']}|{fragment['class_name']}|{fragment['fragment_name']}"
            if frag_key in processed_fragments:
                continue

            file_info = cached_file_info(fragment)
            if file_info != current_file:
                current_file = file_info
                file_path, class_name = file_info
                fragment_count = sum(
                    1 for pending in pending_fragments
                    if cached_file_info(pending) == current_file
                )
                print(f"\n[file] {file_path} | class {class_name} | {fragment_count} fragments", flush=True)

            terminal_fragment_header(fragment_index, total_fragments, fragment)

            if fragment["fragment_type"] == "field":
                if is_field_already_translated(fragment, args):
                    processed_fragments.append(frag_key)
                    terminal_result(True, "fixed")
                    continue

            translate(
                fragment, args, processed_fragments, recursion_depth=args.recursion_depth
            )
            processed_fragments.append(frag_key)
    finally:
        session_clean(args.skeleton_dir)


if __name__ == "__main__":
    parser_ = argparse.ArgumentParser(
        description="Translate java types to cangjie types"
    )
    parser_.add_argument(
        "--model",
        type=str,
        dest="model",
        help="model name to use for translation",
    )
    parser_.add_argument(
        "--project",
        type=str,
        dest="project",
        help="project name to translate",
    )
    parser_.add_argument(
        "--from_lang", type=str, dest="from_lang", help="language to translate from"
    )
    parser_.add_argument(
        "--to_lang", type=str, dest="to_lang", help="language to translate to"
    )
    parser_.add_argument(
        "--include_call_graph",
        action="store_true",
        help="include call graph in translation",
    )
    parser_.add_argument(
        "--include_implementation",
        action="store_true",
        help="include implementation of dependent methods",
    )
    parser_.add_argument(
        "--validate_by_cangjie",
        action="store_true",
        help="validate translation by Cangjie compiler",
    )
    parser_.add_argument(
        "--translate_evosuite",
        action="store_true",
        help="translate evosuite generated tests",
    )
    parser_.add_argument("--debug", action="store_true", help="debug mode")
    parser_.add_argument(
        "--temperature",
        type=float,
        dest="temperature",
        help="temperature for generation",
    )
    parser_.add_argument(
        "--suffix", type=str, dest="suffix", help="suffix for the translated files"
    )
    parser_.add_argument(
        "--recursion_depth",
        type=int,
        dest="recursion_depth",
        help="depth of recursion for translation",
    )
    parser_.add_argument(
        "--use_rag",
        type=str,
        default="false",
        help="Enable RAG context on compilation errors (true/false)",
    )
    args = parser_.parse_args()
    main(args)
