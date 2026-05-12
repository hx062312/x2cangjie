#!/usr/bin/env python3
"""
Handle Java naming conflicts for Cangjie translation.

Renames inner classes to OuterClass_InnerClass format to avoid conflicts
when they are later extracted to top-level in Cangjie (which has no inner classes).

Also detects and resolves naming conflicts (same inner class name from
different outer classes).

Input:  projects/java/keyword_handled/<project>/
Output: projects/java/name_handled/<project>/
"""
import argparse
import os
import re
import shutil

from src.java.preprocessing._shared import (
    load_parser, extract_text_by_bytes, _skip_dir, clean_target_dirs
)


def _find_inner_classes(code, tree):
    """Find inner class declarations. Returns list of dicts with name and outer_class_name."""
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
                inner_classes.append({
                    'name': class_name,
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


def _resolve_names(all_inner_classes, all_top_level_names):
    """Resolve unique names. Returns dict of (file_path, outer, inner) -> new_name."""
    name_map = {}
    used_names = set(all_top_level_names)

    for file_path, ic_list in all_inner_classes.items():
        for ic in ic_list:
            default = f"{ic['outer_class_name']}_{ic['name']}"
            if default not in used_names:
                name_map[(file_path, ic['outer_class_name'], ic['name'])] = default
                used_names.add(default)
            else:
                suffix = 2
                while f"{default}_{suffix}" in used_names:
                    suffix += 1
                resolved = f"{default}_{suffix}"
                name_map[(file_path, ic['outer_class_name'], ic['name'])] = resolved
                used_names.add(resolved)
                print(f"  CONFLICT: {default} → {resolved}")
    return name_map


def main(args):
    input_dir = f"projects/java/keyword_handled/{args.project}"
    output_dir = f"projects/java/name_handled/{args.project}"

    if not os.path.exists(input_dir):
        print(f"Error: Input directory not found: {input_dir}")
        return

    if os.path.exists(output_dir):
        shutil.rmtree(output_dir)
    shutil.copytree(input_dir, output_dir)

    # Step 1: Collect all top-level class names (for conflict detection)
    # and extends relationships (for inner class bare-name replacement in subclasses).
    print("Step 1/3: Collecting class names...")
    parser = load_parser()
    all_names = set()
    # file_path -> set of simple parent class names (from extends/implements)
    file_extends = {}

    def _extract_super_name(node, code):
        """Extract the simple class name from a superclass/interfaces node."""
        text = extract_text_by_bytes(code, node.start_byte, node.end_byte)
        # Strip 'extends ' prefix
        if text.startswith('extends '):
            text = text[8:]
        # Strip generics and trailing args: BaseNCodec<Integer> -> BaseNCodec
        text = text.split('<')[0].split(',')[0].strip()
        # Get last component of fully-qualified name
        return text.rsplit('.', 1)[-1]

    for root, dirs, files in os.walk(output_dir):
        if _skip_dir(root):
            continue
        for fname in files:
            if not fname.endswith('.java'):
                continue
            file_path = os.path.join(root, fname)
            with open(file_path, 'rb') as f:
                code = f.read()
            tree = parser.parse(code)

            def _collect_names(node, depth=0):
                if node.type in ('class_declaration', 'interface_declaration',
                                 'enum_declaration'):
                    name_node = node.child_by_field_name('name')
                    if name_node:
                        cls_name = extract_text_by_bytes(code,
                                        name_node.start_byte, name_node.end_byte)
                        all_names.add(cls_name)
                        # Collect extends for top-level classes (depth==1: program → class)
                        if depth == 1:
                            superclass = node.child_by_field_name('superclass')
                            if superclass:
                                super_name = _extract_super_name(superclass, code)
                                if super_name:
                                    file_extends.setdefault(file_path, set()).add(super_name)
                            # interfaces (implements)
                            interfaces = node.child_by_field_name('interfaces')
                            if interfaces:
                                for child in interfaces.children:
                                    if child.type != ',':
                                        iface_name = _extract_super_name(child, code)
                                        if iface_name:
                                            file_extends.setdefault(file_path, set()).add(iface_name)
                for child in node.children:
                    _collect_names(child, depth + 1)
            _collect_names(tree.root_node, 0)
    print(f"  Found {len(all_names)} class names, "
          f"{len(file_extends)} files with extends/implements")

    # Step 2: Find all inner classes
    print("Step 2/3: Detecting inner classes...")
    all_inner_classes = {}

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
            ics = _find_inner_classes(code, tree)
            if ics:
                all_inner_classes[file_path] = ics

    if not all_inner_classes:
        print("  No inner classes found.")
        print(f"Output: {output_dir}")
        return

    total = sum(len(v) for v in all_inner_classes.values())
    print(f"  Found {total} inner classes in {len(all_inner_classes)} files")

    # Step 3: Resolve names and rename
    print("Step 3/3: Resolving names and renaming...")
    name_map = _resolve_names(all_inner_classes, all_names)

    for file_path, ic_list in all_inner_classes.items():
        rel = os.path.relpath(file_path, output_dir)

        for ic in ic_list:
            old_name = ic['name']
            new_name = name_map[(file_path, ic['outer_class_name'], old_name)]
            if old_name == new_name:
                continue

            outer = ic['outer_class_name']
            qualified_pattern = rf'({re.escape(outer)})\.{re.escape(old_name)}\b'
            qualified_replacement = rf'\1.{new_name}'
            dot_new_pattern = rf'\.new\s+{re.escape(old_name)}\b'
            bare_pattern = rf'\b{re.escape(old_name)}\b'

            for root2, dirs2, files2 in os.walk(output_dir):
                if _skip_dir(root2):
                    continue
                for fname2 in files2:
                    if not fname2.endswith('.java'):
                        continue
                    fp2 = os.path.join(root2, fname2)
                    with open(fp2, 'r') as f:
                        fc = f.read()

                    had_qualified = False
                    if re.search(qualified_pattern, fc):
                        fc = re.sub(qualified_pattern, qualified_replacement, fc)
                        had_qualified = True
                    if re.search(dot_new_pattern, fc):
                        fc = re.sub(dot_new_pattern, f'.new {new_name}', fc)
                        had_qualified = True

                    # Rename bare references in:
                    # - the defining file, or
                    # - files with qualified references (imports / usages), or
                    # - subclasses that inherit the inner class via extends
                    subclasses_outer = outer in file_extends.get(fp2, set())
                    if fp2 == file_path or had_qualified or subclasses_outer:
                        if re.search(bare_pattern, fc):
                            fc = re.sub(bare_pattern, new_name, fc)

                    if fp2 == file_path or had_qualified or subclasses_outer:
                        with open(fp2, 'w') as f:
                            f.write(fc)

            print(f"  {rel}: {outer}.{old_name} → {new_name}")

    removed = clean_target_dirs(output_dir)
    if removed:
        print(f"\nCleaned {len(removed)} target director(ies)")

    print(f"\nDone: {total} inner classes renamed")
    print(f"Output: {output_dir}")


if __name__ == '__main__':
    ap = argparse.ArgumentParser(
        description='Handle Java naming conflicts for Cangjie translation')
    ap.add_argument('--project', type=str, required=True, help='project name')
    args = ap.parse_args()
    main(args)
