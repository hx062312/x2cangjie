#!/usr/bin/env python3
"""
Handle Cangjie keyword conflicts in Java code using tree-sitter.
When Java identifiers conflict with Cangjie keywords (type, init, in, main, etc.),
append '_' suffix to make them valid Cangjie identifiers.
"""
import argparse
import os
import shutil

from tree_sitter import Language, Parser


# Cangjie keywords that can conflict with Java identifiers
CANGJIE_KEYWORDS = {
    'type', 'init', 'in', 'main', 'func', 'class', 'interface', 'struct',
    'enum', 'public', 'private', 'protected', 'internal', 'static', 'var',
    'let', 'import', 'package', 'return', 'if', 'else', 'for', 'while', 'match',
    'where', 'throws', 'try', 'catch', 'finally', 'override', 'abstract',
    'final', 'native', 'synchronized', 'transient', 'volatile',
}

# Keywords to skip (Java and Cangjie both use these as reserved words)
SKIP_KEYWORDS = {
    'class', 'enum', 'interface', 'struct', 'import', 'package',
    'return', 'if', 'else', 'for', 'while', 'try', 'catch', 'finally',
    'throws', 'override', 'abstract', 'final', 'native', 'synchronized',
    'transient', 'volatile', 'public', 'private', 'protected', 'internal',
    'static', 'var', 'let', 'where', 'match', 'main'
}


def load_parser():
    """Load tree-sitter parser for Java."""
    if not os.path.exists('misc/parser/language.so'):
        lib_dir = 'misc/sitter-libs'
        libs = [os.path.join(lib_dir, d) for d in os.listdir(lib_dir)]
        Language.build_library('misc/parser/language.so', libs)
    LANGUAGE = Language('misc/parser/language.so', 'java')
    parser = Parser()
    parser.set_language(LANGUAGE)
    return parser


def extract_text_by_bytes(code, start_byte, end_byte):
    """Extract text from code bytes."""
    return code[start_byte:end_byte].decode('utf-8')


def find_identifier_conflicts(node, code, conflicts):
    """
    Recursively find all identifier nodes that conflict with Cangjie keywords.
    Returns list of (start_byte, end_byte, original_name, new_name).
    """
    node_type = node.type

    # Check if this is an identifier node
    if node_type == 'identifier' or node_type == 'type_identifier':
        name = extract_text_by_bytes(code, node.start_byte, node.end_byte)
        if name in CANGJIE_KEYWORDS and name not in SKIP_KEYWORDS:
            conflicts.append((node.start_byte, node.end_byte, name, name + '_'))

    # Check method_declaration nodes - check method name specifically
    elif node_type == 'method_declaration':
        # Find the method name (identifier child that is not in modifiers or parameters)
        for child in node.children:
            if child.type == 'identifier':
                name = extract_text_by_bytes(code, child.start_byte, child.end_byte)
                if name in CANGJIE_KEYWORDS and name not in SKIP_KEYWORDS:
                    conflicts.append((child.start_byte, child.end_byte, name, name + '_'))

    # Recurse into children
    for child in node.children:
        find_identifier_conflicts(child, code, conflicts)


def process_java_file_with_tree_sitter(file_path):
    """
    Process a Java file using tree-sitter to find and rename conflicting identifiers.
    """
    with open(file_path, 'rb') as f:
        code = f.read()

    parser = load_parser()
    tree = parser.parse(code)

    # Find all conflicting identifiers
    conflicts = []
    find_identifier_conflicts(tree.root_node, code, conflicts)

    if not conflicts:
        return False

    # Deduplicate by start_byte - same position shouldn't be renamed twice
    # (method_declaration branch and recursive children both add the same identifier)
    seen_positions = set()
    unique_conflicts = []
    for c in conflicts:
        if c[0] not in seen_positions:
            seen_positions.add(c[0])
            unique_conflicts.append(c)
    conflicts = unique_conflicts

    # Sort by start_byte descending (so we edit from end to beginning, preserving positions)
    conflicts.sort(key=lambda x: x[0], reverse=True)

    # Apply edits
    code_list = bytearray(code)
    for start, end, old_name, new_name in conflicts:
        # Verify the text matches
        if code_list[start:end].decode('utf-8') == old_name:
            new_name_bytes = new_name.encode('utf-8')
            code_list[start:end] = new_name_bytes

    # Write back
    with open(file_path, 'wb') as f:
        f.write(code_list)

    return True


def main(args):
    input_dir = f"projects/java/automated_reduced_projects/{args.project}"
    output_dir = f"projects/java/keyword_handled/{args.project}"

    if not os.path.exists(input_dir):
        print(f"Error: Input directory not found: {input_dir}")
        return

    # Copy entire directory structure
    if os.path.exists(output_dir):
        shutil.rmtree(output_dir)
    shutil.copytree(input_dir, output_dir)

    # Process all Java files
    java_files = []
    for root, dirs, files in os.walk(output_dir):
        for fname in files:
            if fname.endswith('.java'):
                java_files.append(os.path.join(root, fname))

    print(f"Processing {len(java_files)} Java files...")

    total_modified = 0
    for java_file in java_files:
        rel_path = os.path.relpath(java_file, output_dir)
        if process_java_file_with_tree_sitter(java_file):
            total_modified += 1
            print(f"  Modified: {rel_path}")

    print(f"\nProcessed {len(java_files)} files, modified {total_modified} files")
    print(f"Output: {output_dir}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Handle Cangjie keyword conflicts in Java code')
    parser.add_argument('--project', type=str, help='project name')
    args = parser.parse_args()
    main(args)
