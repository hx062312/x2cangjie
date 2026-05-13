import json
import os
import re
import subprocess
import tempfile

# Status constants for compilation validation
ERROR = "error"
SUCCESS = "success"
FAILURE = "failure"
NOT_EXERCISED = "not-exercised"


def get_skeleton_path(fragment: dict, args) -> str:
    """
    Get the skeleton file path from fragment metadata or schema file.

    Args:
        fragment: Fragment metadata containing schema_name, class_name, fragment_name, is_test_method
        args: Command line arguments with model, prompt_type, temperature, project

    Returns:
        str: Path to the skeleton file (from cangjie_translations_skeleton_path in schema)
    """
    # First try to get from fragment directly
    path = fragment.get("cangjie_translations_skeleton_path", "")
    if path:
        return path

    # Fallback: load from schema file
    schema_file = f"{args.translation_dir}/{fragment['schema_name']}.json"
    try:
        with open(schema_file, "r") as f:
            schema_data = json.load(f)
        return schema_data.get("cangjie_translations_skeleton_path", "")
    except:
        return ""


def get_original_skeleton_path(fragment: dict, args) -> str:
    """
    Get the path to the original (baseline) skeleton file before any translations.
    Uses cangjie_skeleton_path from schema, which is the original skeleton.

    Args:
        fragment: Fragment metadata
        args: Command line arguments

    Returns:
        str: Path to the original skeleton file
    """
    # First try to get from fragment directly
    path = fragment.get("cangjie_skeleton_path", "")
    if path:
        return path

    # Fallback: load from schema file
    schema_file = f"{args.translation_dir}/{fragment['schema_name']}.json"
    try:
        with open(schema_file, "r") as f:
            schema_data = json.load(f)
        return schema_data.get("cangjie_skeleton_path", "")
    except:
        return ""


# Global type_map for Java to Cangjie type conversion
_type_map = None


def get_type_map():
    """Load and return the type map for Java to Cangjie type conversion."""
    global _type_map
    if _type_map is not None:
        return _type_map

    _type_map = {}

    # Load fixed_type_map.json
    fixed_map_path = "data/java/type_resolution/fixed_type_map.json"
    if os.path.exists(fixed_map_path):
        with open(fixed_map_path, 'r') as f:
            fixed_map = json.load(f)
            _type_map.update(fixed_map)

    # Load universal_type_map_final.json
    universal_map_path = "data/java/type_resolution/universal_type_map_final.json"
    if os.path.exists(universal_map_path):
        with open(universal_map_path, 'r') as f:
            universal_map = json.load(f)
            for k, v in universal_map.items():
                if v:
                    _type_map[k] = v

    return _type_map


def get_cangjie_type(java_type, type_map):
    """
    Convert Java type to Cangjie type using type_map.
    Handles generic types like List<String> -> ArrayList<String>.
    """
    if not java_type:
        return "Any"

    java_type = java_type.strip()

    # Handle generics like ArrayList<String>
    if '<' in java_type and java_type.endswith('>'):
        base_type = java_type[:java_type.index('<')]
        generic_part = java_type[java_type.index('<')+1:java_type.rindex('>')]
        generic_parts = []
        depth = 0
        current = ""
        for c in generic_part:
            if c == '<':
                depth += 1
                current += c
            elif c == '>':
                depth -= 1
                current += c
            elif c == ',' and depth == 0:
                generic_parts.append(current.strip())
                current = ""
            else:
                current += c
        if current.strip():
            generic_parts.append(current.strip())

        generic_cangjie = ', '.join([get_cangjie_type(g, type_map) for g in generic_parts])

        if base_type in type_map:
            base_cangjie = type_map[base_type]
            if '<' in base_cangjie:
                base_cangjie = base_cangjie.split('<')[0]
            return f"{base_cangjie}<{generic_cangjie}>"
        else:
            return f"{base_type}<{generic_cangjie}>"

    # Simple type lookup
    if java_type in type_map:
        result = type_map[java_type]
        if '<' in result:
            return result
        return result

    # Handle primitive arrays like int[] -> Array<Int64>
    if java_type.endswith('[]'):
        element_type = java_type[:-2]
        return f"Array<{get_cangjie_type(element_type, type_map)}>"

    # Default to Any for unknown types
    return "Any"


def extract_param_types_from_signature(signature: str) -> str:
    """
    Extract parameter types from Java method signature.

    Handles generics by using stack matching for brackets (e.g., Map<String, List<Int64>>).

    Args:
        signature: Java method signature, e.g., "add( boolean stderr,  File f)"

    Returns:
        Cangjie-style parameter type list, e.g., "boolean, File"
    """
    if not signature:
        return ""

    match = re.search(r'\((.*)\)', signature)
    if not match:
        return ""
    params_str = match.group(1)

    if not params_str.strip():
        return ""

    # Use stack matching to split parameters (handles generics with commas)
    result = []
    depth = 0
    current = ""
    for char in params_str:
        if char == '<':
            depth += 1
            current += char
        elif char == '>':
            depth -= 1
            current += char
        elif char == ',' and depth == 0:
            # Split parameter at comma outside generics
            param = current.strip()
            if param:
                # Extract type: for "TypeName paramName" format
                # Find last space - everything before is the type
                last_space_idx = param.rfind(' ')
                if last_space_idx > 0:
                    param_type = param[:last_space_idx].strip()
                    result.append(param_type)
                else:
                    result.append(param)  # Fallback
            current = ""
        else:
            current += char

    # Handle last parameter
    if current.strip():
        param = current.strip()
        last_space_idx = param.rfind(' ')
        if last_space_idx > 0:
            result.append(param[:last_space_idx].strip())
        else:
            result.append(param)

    return ", ".join(result)


def extract_param_types_list(signature: str) -> list:
    """Extract parameter types as a list from Java method signature.

    Args:
        signature: Java method signature, e.g., "add( int a,  int b)"

    Returns:
        List of Java parameter types, e.g., ["int", "int"]
    """
    if not signature:
        return []

    match = re.search(r'\((.*)\)', signature)
    if not match:
        return []
    params_str = match.group(1)

    if not params_str.strip():
        return []

    result = []
    depth = 0
    current = ""
    for char in params_str:
        if char == '<':
            depth += 1
            current += char
        elif char == '>':
            depth -= 1
            current += char
        elif char == ',' and depth == 0:
            param = current.strip()
            if param:
                last_space_idx = param.rfind(' ')
                if last_space_idx > 0:
                    param_type = param[:last_space_idx].strip()
                    result.append(param_type)
                else:
                    result.append(param)
            current = ""
        else:
            current += char

    if current.strip():
        param = current.strip()
        last_space_idx = param.rfind(' ')
        if last_space_idx > 0:
            result.append(param[:last_space_idx].strip())
        else:
            result.append(param)

    return result


def find_field_in_skeleton(skeleton_content: str, field_name: str) -> tuple:
    """Find field pattern in skeleton. Returns (field_pattern, start, end) or (None, None, None)."""
    pattern = rf"(?:static\s+)?(?:var|let)\s+{re.escape(field_name)}\s*:\s*[^\=]*=\s*throw Exception\('TODO'\)"
    match = re.search(pattern, skeleton_content)
    if match:
        return (match.group(), match.start(), match.end())
    return (None, None, None)


def find_matching_brace(content: str, open_brace_pos: int) -> int:
    """Find matching closing brace position using stack matching. Returns -1 if not found."""
    brace_count = 1
    pos = open_brace_pos + 1
    while pos < len(content) and brace_count > 0:
        if content[pos] == '{':
            brace_count += 1
        elif content[pos] == '}':
            brace_count -= 1
        pos += 1
    return pos - 1 if brace_count == 0 else -1


def find_static_initializer_in_skeleton(skeleton_content: str) -> tuple:
    """Find static initializer pattern in skeleton. Returns (sig, start, end) or (None, None, None)."""
    pattern = rf"static init\(\)\s*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}"
    match = re.search(pattern, skeleton_content, re.MULTILINE | re.DOTALL)
    if match:
        return ("static init()", match.start(), match.end())
    return (None, None, None)


def find_method_in_skeleton(skeleton_content: str, method_name: str, signature: str, is_test: bool, is_constructor: bool) -> tuple:
    """Find method pattern in skeleton. Returns (sig, start, end) or (None, None, None)."""
    # main() is a top-level function without 'func' keyword in Cangjie
    if method_name == "main":
        patterns = [
            rf"^main\s*\([^)]*\)\s*:\s*[^\{{]*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}",
            rf"^main\s*\([^)]*\)\s*:\s*[^\{{]*\{{[\s\S]*?\}}",
        ]
        for pattern in patterns:
            match = re.search(pattern, skeleton_content, re.MULTILINE | re.DOTALL)
            if match:
                return ("main", match.start(), match.end())
        return (None, None, None)

    # Extract parameter types from signature for precise matching
    param_types = extract_param_types_from_signature(signature)

    # Build pattern based on whether we have parameter types for precise matching
    # Note: Cangjie uses "public open func" or "open public func" or just "public func"
    # Note: Java signature param format (Float64 a) differs from Cangjie (a: Float64),
    # so we use flexible param matching [^)]* instead of exact type matching
    # 如果是构造函数，搜索 "init(" 而不是 "func {method_name}("
    # 注意：构造函数必须是 public|private|protected init，不能是 static init
    modifier_opt = r"((open\s+)?(public|private|protected)(\s+open)?\s+)?"
    # Use non-capturing groups so group 1 is always the params
    modifier_for_sig = r"(?:open\s+)?(?:public|private|protected)(?:\s+open)?"
    if is_constructor:
        modifier_required = r"((open\s+)?(public|private|protected)(\s+open)?\s+)"
        pattern = rf"{modifier_required}init\s*\([^)]*\)\s*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}"

        # If signature has parameters, use re.finditer to find all matches and select correct overload
        java_param_types = extract_param_types_list(signature)
        type_map = get_type_map()
        expected_cangjie_types = [get_cangjie_type(t, type_map) for t in java_param_types]

        if expected_cangjie_types:
            # Find all init() matches and select the correct one based on params
            all_matches = list(re.finditer(pattern, skeleton_content, re.MULTILINE | re.DOTALL))

            for match in all_matches:
                matched_text = match.group()
                # Extract parameter list from matched signature
                sig_pattern = rf"{modifier_for_sig}\s+init\s*\(([^)]*)\)"
                sig_match = re.search(sig_pattern, matched_text)
                if not sig_match:
                    continue

                param_str = sig_match.group(1)
                # Parse Cangjie params: "name: String" -> ["String"]
                cangjie_param_types = []
                for param in param_str.split(','):
                    param = param.strip()
                    if ':' in param:
                        cangjie_param_types.append(param.split(':')[-1].strip())

                if cangjie_param_types == expected_cangjie_types:
                    sig_full_match = re.match(rf"{modifier_required}init\s*\([^)]*\)", matched_text)
                    if sig_full_match:
                        return (sig_full_match.group().strip(), match.start(), match.end())

            # If no exact match found, return first match (fallback)
            if all_matches:
                match = all_matches[0]
                sig_match = re.match(rf"{modifier_required}init\s*\([^)]*\)", match.group())
                if sig_match:
                    return (sig_match.group().strip(), match.start(), match.end())

        # No parameters or fallback
        match = re.search(pattern, skeleton_content, re.MULTILINE | re.DOTALL)
        if match:
            sig_match = re.match(rf"{modifier_required}init\s*\([^)]*\)", match.group())
            if sig_match:
                return (sig_match.group().strip(), match.start(), match.end())
        return (None, None, None)

    if param_types:
        # Use re.finditer to find all matches and select the correct overload
        if is_test:
            pattern = rf"(@Test\s+)?{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}"
        else:
            pattern = rf"{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}"

        # Extract expected Cangjie parameter types from Java signature
        java_param_types = extract_param_types_list(signature)
        type_map = get_type_map()
        expected_cangjie_types = [get_cangjie_type(t, type_map) for t in java_param_types]

        # Find all matches
        all_matches = list(re.finditer(pattern, skeleton_content, re.MULTILINE | re.DOTALL))

        for match in all_matches:
            matched_text = match.group()
            # Extract parameter list from matched signature
            # Note: modifier_for_sig captures: (open)?, (public|private|protected), (open)?
            sig_pattern = rf"(?:@Test\s+)?{modifier_for_sig}\s+func\s+{re.escape(method_name)}\s*\(([^)]*)\)\s*:"
            sig_match = re.search(sig_pattern, matched_text)
            if not sig_match:
                continue

            param_str = sig_match.group(1)  # group 1 is the params (modifier parts are non-capturing)
            # Parse Cangjie params: "a: Int64, b: Float64" -> ["Int64", "Float64"]
            cangjie_param_types = []
            for param in param_str.split(','):
                param = param.strip()
                if ':' in param:
                    cangjie_param_types.append(param.split(':')[-1].strip())

            if cangjie_param_types == expected_cangjie_types:
                sig_full_match = re.match(rf"(?:@Test\s+)?{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*", matched_text)
                if sig_full_match:
                    return (sig_full_match.group().strip(), match.start(), match.end())

        # Fallback: if no exact match found, return first match (original behavior)
        if all_matches:
            match = all_matches[0]
            sig_match = re.match(rf"(?:@Test\s+)?{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*", match.group())
            if sig_match:
                return (sig_match.group().strip(), match.start(), match.end())
    else:
        if is_test:
            pattern = rf"(@Test\s+)?{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}"
        else:
            pattern = rf"{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*\{{[\s\S]*?throw Exception\('TODO'\)[\s\S]*?\}}"

        match = re.search(pattern, skeleton_content, re.MULTILINE | re.DOTALL)
        if match:
            sig_match = re.match(rf"(?:@Test\s+)?{modifier_opt}func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*", match.group())
            if sig_match:
                return (sig_match.group().strip(), match.start(), match.end())

    return (None, None, None)


def find_fragment_in_skeleton(skeleton_content: str, fragment: dict) -> tuple:
    """
    Find the fragment location in skeleton content.
    Dispatch to type-specific handlers.
    """
    fragment_name = fragment.get("fragment_name", "")
    fragment_type = fragment.get("fragment_type", "")
    signature = fragment.get("signature", "")
    is_test = fragment.get("is_test_method", False)


    if ":" in fragment_name:
        name = fragment_name.split(":")[-1]
    else:
        name = fragment_name

    if fragment_type == "field":
        return find_field_in_skeleton(skeleton_content, name)
    elif fragment_type == "static_initializer":
        return find_static_initializer_in_skeleton(skeleton_content)
    elif fragment_type == "method":
        is_constructor = fragment.get("is_constructor", False)
        return find_method_in_skeleton(skeleton_content, name, signature, is_test, is_constructor)

    return (None, None, None)


def replace_field_in_skeleton(skeleton_content: str, field_sig: str, field_value: str) -> str:
    """Replace field throw Exception('TODO') with new value. Returns modified skeleton.

    field_sig: full field declaration like "var name: String = throw Exception('TODO')"
    field_value: full field with new value like "var name: String = \"\""
    """
    # Find the field signature first, then find throw after it
    sig_start = skeleton_content.find(field_sig)
    if sig_start == -1:
        return skeleton_content

    throw_pattern = "throw Exception('TODO')"
    throw_pos = skeleton_content.find(throw_pattern, sig_start)
    if throw_pos == -1:
        return skeleton_content

    # Find the line containing throw
    line_start = skeleton_content.rfind('\n', 0, throw_pos) + 1
    line_end = skeleton_content.find('\n', throw_pos)
    if line_end == -1:
        line_end = len(skeleton_content)

    old_line = skeleton_content[line_start:line_end]

    # Extract just the value part from field_value (e.g., "\"\"")
    parts = field_value.split("=")
    if len(parts) >= 2:
        new_value = parts[-1].strip()
    else:
        new_value = field_value.strip()

    new_line = old_line.replace(throw_pattern, new_value)

    return skeleton_content[:line_start] + new_line + skeleton_content[line_end:]


def replace_method_body_in_skeleton(skeleton_content: str, method_sig: str, method_body: str) -> str:
    """Replace method body throw Exception('TODO') with new body. Returns modified skeleton."""
    sig_start = skeleton_content.find(method_sig)
    if sig_start == -1:
        return skeleton_content

    brace_start = skeleton_content.find('{', sig_start)
    if brace_start == -1:
        return skeleton_content

    throw_start = skeleton_content.find("throw Exception('TODO')", brace_start)
    if throw_start == -1:
        return skeleton_content

    line_start = skeleton_content.rfind('\n', 0, throw_start) + 1
    throw_indent = skeleton_content[line_start:throw_start]

    close_brace_pos = find_matching_brace(skeleton_content, brace_start)
    if close_brace_pos == -1:
        return skeleton_content

    close_brace_line_start = skeleton_content.rfind('\n', 0, close_brace_pos) + 1
    close_brace_indent = skeleton_content[close_brace_line_start:close_brace_pos]

    body_lines = method_body.strip().split('\n')
    new_body_lines = []
    for line in body_lines:
        stripped = line.strip()
        if stripped:
            new_body_lines.append(f"{throw_indent}{stripped}")
        else:
            new_body_lines.append(f"{throw_indent}")

    new_content = '\n'.join(new_body_lines)
    final_replacement = f"{new_content}\n{close_brace_indent}}}"

    return skeleton_content[:throw_start] + final_replacement + skeleton_content[close_brace_pos + 1:]


def replace_static_initializer_in_skeleton(skeleton_content: str, static_init_sig: str, body: str) -> str:
    """Replace static initializer body. Same logic as replace_method_body_in_skeleton."""
    return replace_method_body_in_skeleton(skeleton_content, static_init_sig, body)


def replace_fragment_in_skeleton(skeleton_content: str, fragment_sig: str, fragment_body: str, fragment_type: str) -> str:
    """Replace fragment content based on type."""
    if fragment_type == "field":
        return replace_field_in_skeleton(skeleton_content, fragment_sig, fragment_body)
    elif fragment_type == "static_initializer":
        return replace_static_initializer_in_skeleton(skeleton_content, fragment_sig, fragment_body)
    else:
        return replace_method_body_in_skeleton(skeleton_content, fragment_sig, fragment_body)


def reset_field_to_todo(skeleton_content: str, field_sig: str, args, fragment: dict) -> str:
    """Reset field using original skeleton backup."""
    original_path = get_original_skeleton_path(fragment, args)
    if not original_path or not os.path.exists(original_path):
        raise FileNotFoundError(f"Original skeleton not found: {original_path}")

    with open(original_path, 'r') as f:
        original_content = f.read()

    sig_start = original_content.find(field_sig)
    if sig_start == -1:
        raise ValueError(f"Field signature not found in original skeleton: {field_sig}")

    throw_pattern = "throw Exception('TODO')"
    throw_pos = original_content.find(throw_pattern, sig_start)
    if throw_pos == -1:
        raise ValueError(f"throw pattern not found in original skeleton for: {field_sig}")

    line_start = original_content.rfind('\n', 0, throw_pos) + 1
    line_end = original_content.find('\n', throw_pos)
    if line_end == -1:
        line_end = len(original_content)
    original_line = original_content[line_start:line_end]

    # Replace in current skeleton
    sig_start_in_skeleton = skeleton_content.find(field_sig)
    if sig_start_in_skeleton == -1:
        raise ValueError(f"Field signature not found in current skeleton: {field_sig}")

    throw_pos_in_skeleton = skeleton_content.find(throw_pattern, sig_start_in_skeleton)
    if throw_pos_in_skeleton == -1:
        raise ValueError(f"throw pattern not found in current skeleton for: {field_sig}")

    line_start_in_skeleton = skeleton_content.rfind('\n', 0, throw_pos_in_skeleton) + 1
    line_end_in_skeleton = skeleton_content.find('\n', throw_pos_in_skeleton)
    if line_end_in_skeleton == -1:
        line_end_in_skeleton = len(skeleton_content)

    # Add comment to mark as already translated
    new_line = original_line.rstrip() + "  // Already translated, compilation failed"
    return skeleton_content[:line_start_in_skeleton] + new_line + skeleton_content[line_end_in_skeleton:]


def reset_method_body_to_todo(skeleton_content: str, method_sig: str, args, fragment: dict) -> str:
    """Reset method body by replacing with original TODO from backup skeleton."""
    original_path = get_original_skeleton_path(fragment, args)
    if not original_path or not os.path.exists(original_path):
        raise FileNotFoundError(f"Original skeleton not found: {original_path}")

    with open(original_path, 'r') as f:
        original_content = f.read()

    sig_start = original_content.find(method_sig)
    if sig_start == -1:
        raise ValueError(f"Method signature not found in original skeleton: {method_sig}")

    brace_start = original_content.find('{', sig_start)
    if brace_start == -1:
        raise ValueError(f"Opening brace not found for method: {method_sig}")

    close_brace_pos = find_matching_brace(original_content, brace_start)
    if close_brace_pos == -1:
        raise ValueError(f"Closing brace not found for method: {method_sig}")

    # Extract original todo body and add comment to throw line
    original_todo = original_content[brace_start + 1:close_brace_pos]
    throw_pattern = "throw Exception('TODO')"
    throw_pos = original_todo.find(throw_pattern)
    if throw_pos == -1:
        raise ValueError(f"throw pattern not found in original todo for: {method_sig}")

    throw_line_start = original_todo.rfind('\n', 0, throw_pos) + 1
    throw_line_end = original_todo.find('\n', throw_pos)
    if throw_line_end == -1:
        throw_line_end = len(original_todo)

    old_throw_line = original_todo[throw_line_start:throw_line_end]
    new_throw_line = old_throw_line.rstrip() + "  // Already translated, compilation failed"
    modified_todo = original_todo[:throw_line_start] + new_throw_line + original_todo[throw_line_end:]

    sig_start_in_skeleton = skeleton_content.find(method_sig)
    if sig_start_in_skeleton == -1:
        raise ValueError(f"Method signature not found in current skeleton: {method_sig}")

    brace_start_in_skeleton = skeleton_content.find('{', sig_start_in_skeleton)
    if brace_start_in_skeleton == -1:
        raise ValueError(f"Opening brace not found in current skeleton for: {method_sig}")

    close_brace_pos_in_skeleton = find_matching_brace(skeleton_content, brace_start_in_skeleton)
    if close_brace_pos_in_skeleton == -1:
        raise ValueError(f"Closing brace not found in current skeleton for: {method_sig}")

    result = (
        skeleton_content[:brace_start_in_skeleton + 1] +
        modified_todo +
        skeleton_content[close_brace_pos_in_skeleton:]
    )
    return result


def reset_static_initializer_to_todo(skeleton_content: str, static_init_sig: str, args, fragment: dict) -> str:
    """Reset static initializer body. Same logic as reset_method_body_to_todo."""
    return reset_method_body_to_todo(skeleton_content, static_init_sig, args, fragment)


def reset_fragment_to_todo(skeleton_content: str, fragment_sig: str, fragment_type: str, args, fragment: dict) -> str:
    """Reset fragment to original TODO using backup skeleton."""
    if fragment_type == "field":
        return reset_field_to_todo(skeleton_content, fragment_sig, args, fragment)
    elif fragment_type == "static_initializer":
        return reset_static_initializer_to_todo(skeleton_content, fragment_sig, args, fragment)
    else:
        return reset_method_body_to_todo(skeleton_content, fragment_sig, args, fragment)



def cangjie_compile_with_skeleton(cangjie_code: str, fragment: dict, args) -> tuple:
    """
    Compile Cangjie code by integrating it into the skeleton file.
    """
    skeleton_file = get_skeleton_path(fragment, args)
    fragment_type = fragment.get("fragment_type", "")
    fragment_name = fragment.get("fragment_name", "")


    if not os.path.exists(skeleton_file):
        return cangjie_compile(cangjie_code, fragment, args)

    with open(skeleton_file, 'r') as f:
        skeleton_content = f.read()

    fragment_sig, start_pos, end_pos = find_fragment_in_skeleton(skeleton_content, fragment)

    if fragment_sig is None:
        return cangjie_compile(cangjie_code, fragment, args)

    fragment_body = extract_method_body(cangjie_code, fragment)

    modified_skeleton = replace_fragment_in_skeleton(skeleton_content, fragment_sig, fragment_body, fragment_type)

    with open(skeleton_file, 'w') as f:
        f.write(modified_skeleton)

    project_root = os.path.abspath(os.path.dirname(skeleton_file))
    if '/translations/' in skeleton_file:
        while project_root and not os.path.exists(os.path.join(project_root, 'cjpm.toml')):
            project_root = os.path.dirname(project_root)

    try:
        cmd = ['cjpm', 'build']

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=getattr(args, 'compile_timeout', 60),
            cwd=project_root
        )

        if result.returncode == 0:
            return (SUCCESS, None, "Compilation successful")

        error_info = parse_cjpm_error(result.stderr, result.stdout)

        # Reset from current skeleton (which contains previous successful translations)
        with open(skeleton_file, 'r') as f:
            current_skeleton = f.read()
        reset_skeleton = reset_fragment_to_todo(current_skeleton, fragment_sig, fragment_type, args, fragment)
        with open(skeleton_file, 'w') as f:
            f.write(reset_skeleton)

        return (ERROR, error_info, f"Compilation failed: {error_info}")

    except subprocess.TimeoutExpired:
        with open(skeleton_file, 'r') as f:
            current_skeleton = f.read()
        reset_skeleton = reset_fragment_to_todo(current_skeleton, fragment_sig, fragment_type, args, fragment)
        with open(skeleton_file, 'w') as f:
            f.write(reset_skeleton)
        return (ERROR, "Compilation timeout", "Timeout after 60 seconds")
    except Exception as e:
        with open(skeleton_file, 'r') as f:
            current_skeleton = f.read()
        reset_skeleton = reset_fragment_to_todo(current_skeleton, fragment_sig, fragment_type, args, fragment)
        with open(skeleton_file, 'w') as f:
            f.write(reset_skeleton)
        return (ERROR, str(e), str(e))


def extract_method_body(cangjie_code: str, fragment: dict) -> str:
    """
    Extract the method body from generated Cangjie code.
    """
    fragment_name = fragment.get("fragment_name", "")
    signature = fragment.get("signature", "")
    class_name = fragment.get("class_name", "")
    fragment_type = fragment.get("fragment_type", "")


    if ":" in fragment_name:
        method_name = fragment_name.split(":")[-1]
    else:
        method_name = fragment_name

    # Extract parameter types from signature for precise matching
    param_types = extract_param_types_from_signature(signature)

    # Convert Java types to Cangjie types for precise matching
    java_param_types = extract_param_types_list(signature)
    type_map = get_type_map()
    cangjie_param_types = [get_cangjie_type(t, type_map) for t in java_param_types]

    is_top_level_func = (method_name == "main")
    is_static_initializer = (fragment_type == "static_initializer")
    is_constructor = fragment.get("is_constructor", False)


    # Helper to parse Cangjie params: "a: Int64, b: Float64" -> ["Int64", "Float64"]
    def parse_cangjie_params(param_str):
        result = []
        for param in param_str.split(','):
            param = param.strip()
            if ':' in param:
                result.append(param.split(':')[-1].strip())
        return result

    modifier_for_sig = r"(?:open\s+)?(?:public|private|protected)(?:\s+(?:static|open))*"

    if is_static_initializer:
        # Cangjie static init: static init() { body }
        sig_match = re.search(rf"static init\(\)\s*\{{", cangjie_code)
        if not sig_match:
            return cangjie_code.strip()
    elif is_constructor:
        # Constructor: public init(...) { body } - no 'func' keyword
        if cangjie_param_types:
            # Find all init() matches and select correct one based on params
            pattern = rf"{modifier_for_sig}\s+init\s*\([^)]*\)\s*\{{"
            all_matches = list(re.finditer(pattern, cangjie_code, re.MULTILINE))
            sig_match = None
            for match in all_matches:
                matched_text = match.group()
                sig_pattern = rf"{modifier_for_sig}\s+init\s*\(([^)]*)\)"
                sig_match_inner = re.search(sig_pattern, matched_text)
                if not sig_match_inner:
                    continue
                if parse_cangjie_params(sig_match_inner.group(1)) == cangjie_param_types:
                    sig_match = re.search(rf"{modifier_for_sig}\s+init\s*\([^)]*\)", matched_text)
                    break
            # Fallback to first match
            if not sig_match and all_matches:
                sig_match = re.search(rf"{modifier_for_sig}\s+init\s*\([^)]*\)", all_matches[0].group())
            if not sig_match:
                return cangjie_code.strip()
        else:
            sig_match = re.search(rf"{modifier_for_sig}\s+init\s*\([^)]*\)\s*\{{", cangjie_code)
            if not sig_match:
                return cangjie_code.strip()
    elif is_top_level_func:
        sig_match = re.search(rf"{method_name}\s*\([^)]*\)\s*:\s*[^\{{]*", cangjie_code)
        if not sig_match:
            return cangjie_code.strip()
    elif cangjie_param_types:
        # Find all func matches and select correct one based on params (same logic as find_method_in_skeleton)
        pattern = rf"(?:@Test\s+)?{modifier_for_sig}\s+func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*\{{"
        all_matches = list(re.finditer(pattern, cangjie_code, re.MULTILINE))
        sig_match = None
        for match in all_matches:
            matched_text = match.group()
            sig_pattern = rf"(?:@Test\s+)?{modifier_for_sig}\s+func\s+{re.escape(method_name)}\s*\(([^)]*)\)\s*:"
            sig_match_inner = re.search(sig_pattern, matched_text)
            if not sig_match_inner:
                continue
            if parse_cangjie_params(sig_match_inner.group(1)) == cangjie_param_types:
                sig_match = re.search(rf"(?:@Test\s+)?{modifier_for_sig}\s+func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*", matched_text)
                break
        # Fallback to first match
        if not sig_match and all_matches:
            sig_match = re.search(rf"(?:@Test\s+)?{modifier_for_sig}\s+func\s+{re.escape(method_name)}\s*\([^)]*\)\s*:\s*[^\{{]*", all_matches[0].group())
        if not sig_match:
            return cangjie_code.strip()
    else:
        sig_match = re.search(rf"func\s+{method_name}\s*\([^)]*\)\s*:\s*[^\{{]*", cangjie_code)
        if not sig_match:
            return cangjie_code.strip()

    brace_start = cangjie_code.find('{', sig_match.end() - 1)
    if brace_start == -1:
        return cangjie_code.strip()

    close_brace_pos = find_matching_brace(cangjie_code, brace_start)
    if close_brace_pos == -1:
        return cangjie_code.strip()

    body_content = cangjie_code[brace_start + 1:close_brace_pos]
    lines = body_content.strip().split('\n')
    stripped_lines = [line.strip() for line in lines if line.strip()]
    return '\n'.join(stripped_lines)


def cangjie_compile(cangjie_code: str, fragment: dict, args) -> tuple:
    """
    Use Cangjie compiler (cjc) to validate Cangjie code.
    """
    output_dir = getattr(args, 'output_dir', '/tmp/cj_output')
    os.makedirs(output_dir, exist_ok=True)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.cj', delete=False) as f:
        f.write(cangjie_code)
        temp_file = f.name

    output_file = os.path.join(output_dir, f"{fragment.get('class_name', 'output')}.so")

    try:
        cmd = [
            'cjc',
            '-o', output_file,
            temp_file
        ]

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=getattr(args, 'compile_timeout', 60)
        )

        if result.returncode == 0:
            return (SUCCESS, None, "Compilation successful")

        error_info = parse_cjc_error(result.stderr, result.stdout)
        return (ERROR, error_info, f"Compilation failed: {error_info}")

    except subprocess.TimeoutExpired:
        return (ERROR, "Compilation timeout", "Timeout after 60 seconds")
    except Exception as e:
        return (ERROR, str(e), str(e))
    finally:
        if os.path.exists(temp_file):
            os.unlink(temp_file)


def parse_cjc_error(stderr: str, stdout: str) -> str:
    """
    Parse cjc compiler error output and extract useful error messages.
    """
    combined_output = stderr + "\n" + stdout

    try:
        json_start = stdout.find('{')
        if json_start != -1:
            json_str = stdout[json_start:]

            brace_count = 0
            json_end = json_start
            for i, char in enumerate(json_str):
                if char == '{':
                    brace_count += 1
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        json_end = json_start + i + 1
                        break

            json_str = json_str[:json_end - json_start]
            errors = json.loads(json_str)

            error_messages = []
            diagnostics = errors.get('diagnostics', [])

            if not diagnostics:
                for key, value in errors.items():
                    if isinstance(value, dict):
                        msg = value.get('message', str(value))
                        location = value.get('range', {}).get('start', {})
                        line = location.get('line', '?')
                        error_messages.append(f"Line {line}: {msg}")
                    elif isinstance(value, str):
                        error_messages.append(f"{key}: {value}")

            for diag in diagnostics:
                msg = diag.get('message', '')
                location = diag.get('range', {}).get('start', {})
                line = location.get('line', '?')
                column = location.get('column', '?')
                severity = diag.get('severity', 'error')

                error_msg = f"[{severity.upper()}] Line {line}, Col {column}: {msg}"
                error_messages.append(error_msg)

            if error_messages:
                return '\n'.join(error_messages)

    except json.JSONDecodeError:
        pass
    except Exception:
        pass

    return f"--- cjc stderr ---\n{stderr}\n--- cjc stdout ---\n{stdout}"


def parse_cjpm_error(stderr: str, stdout: str) -> str:
    """
    Parse cjpm build error output and extract useful error messages.
    """
    combined_output = stderr + "\n" + stdout

    try:
        json_start = stdout.find('{')
        if json_start != -1:
            json_str = stdout[json_start:]

            brace_count = 0
            json_end = json_start
            for i, char in enumerate(json_str):
                if char == '{':
                    brace_count += 1
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        json_end = json_start + i + 1
                        break

            json_str = json_str[:json_end - json_start]
            errors = json.loads(json_str)

            error_messages = []
            diagnostics = errors.get('diagnostics', [])

            if not diagnostics:
                for key, value in errors.items():
                    if isinstance(value, dict):
                        msg = value.get('message', str(value))
                        location = value.get('range', {}).get('start', {})
                        line = location.get('line', '?')
                        error_messages.append(f"Line {line}: {msg}")
                    elif isinstance(value, str):
                        error_messages.append(f"{key}: {value}")

            for diag in diagnostics:
                msg = diag.get('message', '')
                location = diag.get('range', {}).get('start', {})
                line = location.get('line', '?')
                column = location.get('column', '?')
                severity = diag.get('severity', 'error')
                file = diag.get('file', '')

                error_msg = f"[{severity.upper()}] {file}: Line {line}, Col {column}: {msg}"
                error_messages.append(error_msg)

            if error_messages:
                return '\n'.join(error_messages)

    except json.JSONDecodeError:
        pass
    except Exception:
        pass

    error_lines = []
    for line in combined_output.split('\n'):
        if 'error' in line.lower() or ': error' in line.lower():
            error_lines.append(line.strip())

    if error_lines:
        return '\n'.join(error_lines[:10])

    return f"--- cjpm stderr ---\n{stderr}\n--- cjpm stdout ---\n{stdout}"


def cangjie_compilation_validation(generation: str, fragment: dict, args) -> tuple:
    """
    Main entry point for Cangjie compilation validation.
    """
    return cangjie_compile_with_skeleton(generation, fragment, args)
