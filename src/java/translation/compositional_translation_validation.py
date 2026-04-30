import argparse
import datetime
import json
import math
import os
import re
import time

import tiktoken
import tqdm
import yaml
from openai import OpenAI
from src.java.translation.cangjie_compilation_validation import cangjie_compilation_validation
from src.java.translation.get_reverse_traversal import get_reverse_traversal
from src.java.translation.prompt_generator import PromptGenerator

# Status constants for translation validation
ERROR = "error"
SUCCESS = "success"
FAILURE = "failure"
NOT_EXERCISED = "not-exercised"


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


def extract_cangjie_code(
    generation: str, class_name: str = None, method_name: str = None
):
    """
    Extract Cangjie code from markdown code blocks.
    """
    generation = generation.replace("```cangjie", "```")
    generation = generation.replace("```cj", "```")
    generation = generation.replace("```java", "```")

    pattern = r"(?:```\s*)+(.+?)(?:\s*```)+"
    match = re.search(pattern, generation, re.DOTALL)

    if match:
        extracted = match.group(1).strip()

        if method_name:
            extracted = extract_method_from_code(extracted, method_name, class_name)

        extracted = post_process_cangjie_code(extracted, class_name)

        return extracted

    lines = generation.split("\n")
    code_lines = []
    in_code = False

    for line in lines:
        if any(
            keyword in line
            for keyword in [
                "func ",
                "class ",
                "let ",
                "var ",
                "pub ",
                "priv ",
                "import ",
                "package ",
            ]
        ):
            in_code = True
            code_lines.append(line)
        elif in_code and (
            line.strip() == ""
            or line.strip().startswith("//")
            or line.strip().startswith("#")
        ):
            code_lines.append(line)
        elif in_code and not line.startswith(" ") and not line.startswith("\t"):
            if line.strip():
                break
            code_lines.append(line)

    if code_lines:
        extracted = "\n".join(code_lines).strip()

        if method_name:
            extracted = extract_method_from_code(extracted, method_name, class_name)

        extracted = post_process_cangjie_code(extracted, class_name)

        return extracted

    return None


def extract_method_from_code(
    code: str, method_name: str, class_name: str = None
) -> str:
    """
    Extract a specific method from the generated code.
    """
    clean_method_name = method_name
    if ":" in method_name:
        clean_method_name = method_name.split(":")[-1]

    method_patterns = [
        rf"(public\s+|private\s+|protected\s+|static\s+|internal\s+|override\s+)*func\s+{re.escape(clean_method_name)}\s*\(",
        rf"func\s+{re.escape(clean_method_name)}\s*\(",
    ]

    # Cangjie main() doesn't use 'func' keyword, add pattern for it
    if clean_method_name == "main":
        method_patterns.insert(0, rf"main\s*\(")

    for pattern in method_patterns:
        match = re.search(pattern, code)
        if match:
            start_pos = match.start()

            brace_count = 0
            in_method = False
            end_pos = start_pos

            for i in range(start_pos, len(code)):
                if code[i] == "{":
                    brace_count += 1
                    in_method = True
                elif code[i] == "}":
                    brace_count -= 1
                    if in_method and brace_count == 0:
                        end_pos = i + 1
                        break

            extracted_method = code[start_pos:end_pos].strip()
            return extracted_method

    return code


def post_process_cangjie_code(code: str, class_name: str = None) -> str:
    """
    Post-process extracted Cangjie code to fix common issues.
    """
    if class_name and "class " not in code:
        if "func " in code:
            # Don't wrap main() - it's a top-level function in Cangjie
            if "main(" not in code:
                code = f"class {class_name} {{\n{code}\n}}"

    lines = code.split("\n")
    processed_lines = []
    brace_count = 0
    in_class = False

    for line in lines:
        processed_lines.append(line)
        brace_count += line.count("{") - line.count("}")

        if "{" in line and "class " in line:
            in_class = True

        if in_class and brace_count == 0 and "}" not in line:
            if processed_lines and "}" not in processed_lines[-1]:
                processed_lines.append("}")

    code = "\n".join(processed_lines)

    return code


def extract_code_for_translation(generation: str, fragment: dict, args):
    """
    Extract Cangjie code from markdown and prepare for compilation.
    """
    class_name = fragment.get("class_name", None)
    # Extract actual class name (without line number prefix like "4-38:")
    if class_name and ":" in class_name:
        class_name = class_name.split(":")[-1]
    method_name = fragment.get("fragment_name", None)
    fragment_type = fragment.get("fragment_type", "unknown")

    extracted_code = extract_cangjie_code(generation, class_name, method_name)

    if extracted_code is None:
        return False, None, "the model did not generate any code"

    code_lines = extracted_code.split("\n")

    meaningful_lines = [
        line
        for line in code_lines
        if line.strip() and not line.strip().startswith("//")
    ]

    if not meaningful_lines:
        return False, None, "the model did not generate any code"

    has_function = any("func " in line or "main(" in line or "static init()" in line or "init(" in line for line in code_lines)
    has_class = any("class " in line for line in code_lines)
    has_var = any("var " in line for line in code_lines)
    has_let = any("let " in line for line in code_lines)

    if not (has_function or has_class or has_var or has_let):
        return (
            False,
            None,
            "the generated code does not appear to be valid Cangjie code",
        )

    return True, extracted_code.split("\n"), None


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
                print(f"[WARN] Skipping partial_translation update for {fragment['fragment_name']}: contains full class declaration")
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

    return 5 if not feedback else 1


def get_total_input_tokens(prompt, args, model_info):
    if args.model == "gpt-4o-2024-11-20":
        encoding = tiktoken.encoding_for_model("gpt-4o")
        total_tokens = len(encoding.encode(prompt))
    else:
        encoding = tiktoken.encoding_for_model("gpt-4o")
        total_tokens = len(encoding.encode(prompt))

    return total_tokens


def prompt_model(model_info, client, prompt, total_input_tokens, args):
    max_new_tokens = model_info[args.model]["total"] - total_input_tokens
    max_new_tokens = min(max_new_tokens, model_info[args.model]["max_new_tokens"])

    completion = client.chat.completions.create(
        model=model_info[args.model]["model_id"],
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt},
        ],
        max_tokens=max_new_tokens,
        temperature=args.temperature,
        top_p=1.0,
        frequency_penalty=0.0,
        presence_penalty=0.0,
    )

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


def translate(
    fragment, args, processed_fragments, budget={}, feedback=None, recursion_depth=2
):

    if recursion_depth == 0:
        return

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
    start_time = time.time()

    while budget[current_budget] > 0:
        ############################ <TRANSLATION> ############################
        prompt_gen = PromptGenerator(
            is_feedback=True if feedback else False,
            args=args,
            fragment_details=fragment,
            feedback=feedback,
        )
        prompt = prompt_gen.generate_prompt()

        if args.debug:
            print("=======================PROMPT=======================", flush=True)
            print(prompt, flush=True)
            print(
                "=======================GENERATING=======================", flush=True
            )

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
            break

        generation = prompt_model(model_info, client, prompt, total_input_tokens, args)

        if args.debug:
            print(generation, flush=True)
            print("---" * 50, flush=True)
        ############################ </TRANSLATION> ############################

        ############################ <EXTRACT CODE> ############################
        syntactic_status, extracted_code, syntactic_feedback = (
            extract_code_for_translation(generation, fragment, args)
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
                break

            budget["syntactic"] -= 1
            if args.debug:
                print(
                    "=======================CODE EXTRACTION FAILED - REPROMPTING=======================",
                    f"Feedback: {syntactic_feedback}",
                    flush=True,
                )
            # Update feedback for next iteration
            if not feedback:
                feedback = syntactic_feedback
            else:
                feedback = f"{feedback}\n{syntactic_feedback}"
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
                break

            if args.debug:
                print(
                    "=======================CANGJIE COMPILATION FAILED - REPROMPTING=======================",
                    f"Feedback: {compilation_feedback}",
                    flush=True,
                )

            budget[current_budget] -= 1
            # Update feedback for next iteration - append to existing feedback
            if not feedback:
                feedback = compilation_feedback
            else:
                feedback = f"{feedback}\n{compilation_feedback}"
            continue

        cangjie_compilation_status = "success"
        update_labels(
            args=args,
            fragment=fragment,
            translation=generation,
            translation_status="completed",
            cangjie_compilation={"outcome": "success", "message": message},
            test_execution="pending",
            elapsed_time=time.time() - start_time,
        )
        update_budget(fragment, args, budget, type_="final")

        if fragment["is_test_method"]:
            return

        if fragment["fragment_type"] in ["field", "static_initializer"]:
            break
        ############################ </CANGJIE COMPILATION VALIDATION> ############################

        ############################ <TEST EXECUTION> ############################
        current_budget = "test_execution"

        update_labels(
            args=args,
            fragment=fragment,
            translation=generation,
            translation_status="completed",
            cangjie_compilation={
                "outcome": "success",
                "message": message,
            },
            test_execution="not-exercised",
            elapsed_time=time.time() - start_time,
        )
        update_budget(fragment, args, budget, type_="final")
        break
        ############################ </TEST EXECUTION> ############################


def main(args):

    args.prompt_type = "body" if args.include_implementation else "signature"
    args.translation_dir = f"data/java/schemas{args.suffix}/{args.model}/{args.temperature}/{args.project}"

    fragment_traversal = get_reverse_traversal(args)

    processed_fragments, pending_fragments = get_pending_fragments(
        fragment_traversal, args
    )

    for fragment in tqdm.tqdm(pending_fragments):
        frag_key = f"{fragment['schema_name']}|{fragment['class_name']}|{fragment['fragment_name']}"
        if frag_key in processed_fragments:
            continue

        if fragment["fragment_type"] == "field":
            if is_field_already_translated(fragment, args):
                processed_fragments.append(frag_key)
                continue

        translate(
            fragment, args, processed_fragments, recursion_depth=args.recursion_depth
        )
        processed_fragments.append(frag_key)


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
    args = parser_.parse_args()
    main(args)
