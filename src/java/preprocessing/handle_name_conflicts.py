#!/usr/bin/env python3
"""
Handle Java naming conflicts for Cangjie translation.

Detects and resolves structural naming conflicts including:
- Inner class extraction to top-level
- Class/method name conflicts

Input:  projects/java/keyword_handled/<project>/
Output: projects/java/name_handled/<project>/
"""
import argparse
import os
import shutil

from src.java.preprocessing._shared import (
    load_parser, extract_text_by_bytes, _skip_dir, clean_target_dirs
)


def _find_inner_classes(code, tree):
    """Find inner class declarations. Returns list of dicts with name, modifiers, outer_class_name, etc."""
    inner_classes = []

    def _find(node, outer_name=None, depth=0):
        if node.type in ('class_declaration', 'interface_declaration'):
            name_node = node.child_by_field_name('name')
            if name_node is None:
                for child in node.children:
                    _find(child, outer_name, depth)
                return

            class_name = extract_text_by_bytes(code, name_node.start_byte, name_node.end_byte)

            if depth > 0 and outer_name is not None:
                modifiers = []
                is_static = False
                for child in node.children:
                    if child.type == 'modifiers':
                        for mod in child.children:
                            mod_text = extract_text_by_bytes(code, mod.start_byte, mod.end_byte)
                            modifiers.append(mod_text)
                            if mod_text == 'static':
                                is_static = True
                    if child.type in ('class_body', 'interface_body'):
                        break

                inner_classes.append({
                    'name': class_name,
                    'start_byte': node.start_byte,
                    'end_byte': node.end_byte,
                    'modifiers': modifiers,
                    'is_static': is_static,
                    'outer_class_name': outer_name,
                })

            body = node.child_by_field_name('body')
            if body:
                _find(body, class_name, depth + 1)
            else:
                for child in node.children:
                    _find(child, class_name if depth == 0 else outer_name, depth + 1)
        else:
            for child in node.children:
                _find(child, outer_name, depth)

    _find(tree.root_node, None, 0)
    return inner_classes


def main(args):
    input_dir = f"projects/java/keyword_handled/{args.project}"
    output_dir = f"projects/java/name_handled/{args.project}"

    if not os.path.exists(input_dir):
        print(f"Error: Input directory not found: {input_dir}")
        return

    if os.path.exists(output_dir):
        shutil.rmtree(output_dir)
    shutil.copytree(input_dir, output_dir)

    print("Scanning for inner classes...")
    parser = load_parser()
    total_inner = 0

    for root, dirs, files in os.walk(output_dir):
        if _skip_dir(root):
            continue
        for fname in sorted(files):
            if not fname.endswith('.java'):
                continue
            file_path = os.path.join(root, fname)
            with open(file_path, 'rb') as f:
                code = f.read()
            tree = parser.parse(code)
            inner_classes = _find_inner_classes(code, tree)
            if inner_classes:
                rel = os.path.relpath(file_path, output_dir)
                print(f"  {rel}: {len(inner_classes)} inner class(es)")
                for ic in inner_classes:
                    static_str = 'static ' if ic['is_static'] else ''
                    print(f"    {static_str}class {ic['name']} (outer: {ic['outer_class_name']})")
                total_inner += len(inner_classes)

    print(f"\nFound {total_inner} inner classes total (extraction coming in Step 2)")
    print(f"Output: {output_dir}")


if __name__ == '__main__':
    ap = argparse.ArgumentParser(
        description='Handle Java naming conflicts for Cangjie translation')
    ap.add_argument('--project', type=str, required=True, help='project name')
    args = ap.parse_args()
    main(args)
