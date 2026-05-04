#!/usr/bin/env python3
"""
Create Cangjie skeleton files from Java schema.
Adapted from TRAM but targeting Cangjie instead of Python.
"""
import argparse
import json
import keyword
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
from src.java.utils.get_dependencies import get_dependencies
from src.java.utils.get_class_order import get_class_order
from src.java.utils.get_custom_types import get_custom_types


def remove_duplicate_methods(schema, class_to_methods=None, all_schema_classes=None):
    """Mark duplicate methods (overloaded) as not overload, and detect overriding.

    Also marks parent class methods as needing 'open' when they are overridden.
    """
    if class_to_methods is None:
        class_to_methods = {}
    if all_schema_classes is None:
        all_schema_classes = {}

    duplicate_methods = {}
    for class_ in schema['classes']:
        duplicate_methods.setdefault(class_, {})
        for method in schema['classes'][class_]['methods']:
            schema['classes'][class_]['methods'][method]['is_overload'] = False
            schema['classes'][class_]['methods'][method]['is_override'] = False
            schema['classes'][class_]['methods'][method]['needs_open'] = False
            method_name = method.split(':')[1].strip()
            duplicate_methods[class_].setdefault(method_name, [])
            duplicate_methods[class_][method_name].append(method)

    for class_ in duplicate_methods:
        for method_name in duplicate_methods[class_]:
            if len(duplicate_methods[class_][method_name]) > 1:
                for k in duplicate_methods[class_][method_name]:
                    schema['classes'][class_]['methods'][k]['is_overload'] = True

    # Detect overriding: check if method exists in parent class (using cross-schema class_to_methods)
    for class_key in schema['classes']:
        class_name = class_key.split(':')[-1]
        class_info = schema['classes'][class_key]
        extends = class_info.get('extends', [])
        parent_class_short = extends[0].split('.')[-1] if extends else None

        if parent_class_short and parent_class_short in class_to_methods:
            parent_methods = class_to_methods[parent_class_short].get('methods', [])
            # Check each method in current class
            for method_key in schema['classes'][class_key]['methods']:
                method_name = method_key.split(':')[1].strip()
                if method_name in parent_methods:
                    # This is an override
                    schema['classes'][class_key]['methods'][method_key]['is_override'] = True

                    # Also mark parent method as needing 'open'
                    # Find parent method key in all_schema_classes
                    if parent_class_short in all_schema_classes:
                        for parent_method_key in all_schema_classes[parent_class_short].get('methods', {}):
                            parent_method_name = parent_method_key.split(':')[1].strip()
                            if parent_method_name == method_name:
                                # Mark parent method as needing open
                                all_schema_classes[parent_class_short]['methods'][parent_method_key]['needs_open'] = True

    return schema


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
        # Handle nested generics by splitting on comma at depth 0
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

        # Get base type translation
        if base_type in type_map:
            base_cangjie = type_map[base_type]
            # If base_cangjie already has generic params, replace them
            if '<' in base_cangjie:
                base_cangjie = base_cangjie.split('<')[0]
            return f"{base_cangjie}<{generic_cangjie}>"
        else:
            # Unknown base type, use as-is with Cangjie-style generics
            return f"{base_type}<{generic_cangjie}>"

    # Simple type lookup
    if java_type in type_map:
        result = type_map[java_type]
        # If result already has generics, return as-is
        if '<' in result:
            return result
        return result

    # Handle primitive arrays like int[] -> Array<Int64>
    if java_type.endswith('[]'):
        element_type = java_type[:-2]
        return f"Array<{get_cangjie_type(element_type, type_map)}>"

    # Default to Any for unknown types
    return "Any"


def normalize_class_name(class_name, type_map):
    """Normalize a class name using type map."""
    if not class_name:
        return class_name

    class_name = class_name.strip()

    # Handle qualified names
    if '.' in class_name:
        short_name = class_name.split('.')[-1]
        if short_name in type_map:
            return type_map[short_name]
        return short_name

    if class_name in type_map:
        return type_map[class_name]

    return class_name


def get_access_modifier(modifiers):
    """Convert Java modifiers to Cangjie."""
    if 'public' in modifiers:
        return 'public '
    elif 'protected' in modifiers:
        return 'protected '
    elif 'private' in modifiers:
        return 'private '
    return ''


def is_static(modifiers):
    return 'static' in modifiers


def generate_field_skeleton(field_info, field_key, type_map):
    """
    Generate skeleton for a single field.

    Returns:
        tuple: (skeleton_string, partial_translation_list)
    """
    field_name = field_key.split(':')[1].strip()
    modifiers = field_info.get('modifiers', [])
    is_static_field = is_static(modifiers)
    is_final = 'final' in modifiers

    types = field_info.get('types', [])
    if types:
        source_type = types[0]
        field_type = get_cangjie_type(source_type, type_map)
    else:
        field_type = 'Any'

    field_prefix = ""
    if is_static_field:
        field_prefix += "static "
    if is_final:
        field_prefix += "let "
    else:
        field_prefix += "var "

    skeleton = f"    {field_prefix}{field_name}: {field_type} = throw Exception('TODO')\n"

    # partial_translation for fields should match skeleton content
    partial_translation = [f"    {field_prefix}{field_name}: {field_type} = throw Exception('TODO')\n"]

    return skeleton, partial_translation


def generate_method_skeleton(method_info, method_key, class_info, type_map, is_interface=False):
    """
    Generate skeleton for a single method.

    Returns:
        tuple: (skeleton_string, partial_translation_list)
    """
    method_name = method_key.split(':')[1].strip()
    if '(' in method_name:
        method_name = method_name.split('(')[0].strip()

    if not method_name:
        return "", []

    modifiers = method_info.get('modifiers', [])
    access_mod = get_access_modifier(modifiers)
    is_static_method = is_static(modifiers)
    is_constructor = method_info.get('is_constructor', False)

    parameters = method_info.get('parameters', [])
    param_strings = []
    for param in parameters:
        param_name = param.get('name', 'arg')
        param_type = param.get('type', 'Any')
        cangjie_type = get_cangjie_type(param_type, type_map)
        param_strings.append(f"{param_name}: {cangjie_type}")

    return_types = method_info.get('return_types', [])
    if return_types:
        return_type = get_cangjie_type(return_types[0], type_map)
    elif is_constructor:
        return_type = ''
    else:
        return_type = 'Unit'

    # Build method signature
    if is_constructor:
        method_sig = f"    {access_mod}init({', '.join(param_strings)})"
        if is_static_method:
            method_sig = "static " + method_sig
    elif is_static_method:
        method_sig = f"    {access_mod}static func {method_name}({', '.join(param_strings)})"
    else:
        is_override = method_info.get('is_override', False)
        if is_override:
            override_prefix = "override "
            open_prefix = ""
        else:
            override_prefix = ""
            open_prefix = "open " if is_open_method(method_info, class_info) else ""
        method_sig = f"    {access_mod}{override_prefix}{open_prefix}func {method_name}({', '.join(param_strings)})"

    if not is_constructor:
        method_sig += f": {return_type}"

    skeleton = f"{method_sig} {{\n        throw Exception('TODO')\n    }}\n\n"

    partial_translation = [f"{method_sig} {{", "        throw Exception('TODO')", "    }\n"]

    return skeleton, partial_translation


def generate_static_initializer_skeleton(static_init_info, static_init_key):
    """
    Generate skeleton for a static initializer.

    Returns:
        tuple: (skeleton_string, partial_translation_list)
    """
    skeleton = "    static init() {\n        throw Exception('TODO')\n    }\n\n"

    partial_translation = [
        "    static init() {",
        "        throw Exception('TODO')",
        "    }\n"
    ]

    return skeleton, partial_translation


def generate_class_declaration(class_info, class_name, type_map, schema_fname, is_interface, is_abstract_class):
    """
    Generate class/interface declaration skeleton.

    Returns:
        tuple: (skeleton_string, cangjie_class_declaration)
    """
    extends = class_info.get('extends', [])
    implements = class_info.get('implements', [])

    # Determine open_prefix and abstract_prefix
    if is_interface:
        open_prefix = ""
    elif is_abstract_class:
        open_prefix = ""
    else:
        open_prefix = "open " if is_open_class(class_info) else ""
    abstract_prefix = "abstract " if is_abstract_class else ""

    # Build class declaration
    if is_interface:
        # Interface
        if extends:
            extends_str = ' & '.join([normalize_class_name(e, type_map) for e in extends if e])
            class_declaration = f"{open_prefix}interface {class_name} <: {extends_str} {{\n"
        else:
            class_declaration = f"{open_prefix}interface {class_name} {{\n"
    elif extends:
        # Class with parent
        parent = extends[0] if extends else None
        if parent:
            parent_name = normalize_class_name(parent, type_map)
            class_declaration = f"{abstract_prefix}{open_prefix}class {class_name} <: {parent_name} {{\n"
        else:
            class_declaration = f"{abstract_prefix}{open_prefix}class {class_name} {{\n"
    elif implements:
        # Class implementing interfaces (Cangjie uses & for multiple interfaces)
        impl_str = ' & '.join([normalize_class_name(i, type_map) for i in implements if i])
        class_declaration = f"{abstract_prefix}{open_prefix}class {class_name} <: {impl_str} {{\n"
    else:
        # Simple class
        class_declaration = f"{abstract_prefix}{open_prefix}class {class_name} {{\n"

    skeleton = class_declaration

    # Add test annotation if needed
    is_test_class = False
    for method_ in class_info.get('methods', {}):
        annotations = class_info['methods'][method_].get('annotations', [])
        if '@Test' in [x.split('(')[0] for x in annotations]:
            is_test_class = True
            break

    if 'src.test' in schema_fname and is_test_class:
        skeleton = "@Test\n" + skeleton

    return skeleton, class_declaration


def is_abstract(modifiers):
    """Check if method has abstract modifier."""
    return 'abstract' in modifiers


def is_interface(schema_classes, class_key):
    """Check if a class is an interface."""
    if class_key not in schema_classes:
        return False
    return schema_classes[class_key].get('is_interface', False)


def is_open_method(method_info, class_info):
    """
    Check if a method should be marked as open (overridable).

    Returns True for non-static, non-final, non-private methods.
    """
    modifiers = method_info.get('modifiers', [])

    if is_static(modifiers):
        return False
    if 'final' in modifiers:
        return False
    if 'private' in modifiers:
        return False

    return True


def is_abstract(modifiers):
    return 'abstract' in modifiers


def is_final(modifiers):
    return 'final' in modifiers


def is_open_class(class_info):
    """Java class is open (inheritable) if not final."""
    # Interface is always open
    if class_info.get('is_interface', False):
        return True
    # Abstract class is open (can be inherited)
    if class_info.get('is_abstract', False):
        return True
    # Check if class has 'final' modifier
    modifiers = class_info.get('modifiers', [])
    return 'final' not in modifiers


def is_open_method(method_info, class_info):
    """Java instance method is open (overridable) if not final, not static, not private."""
    modifiers = method_info.get('modifiers', [])
    # Static methods cannot be overridden
    if 'static' in modifiers:
        return False
    # Final methods cannot be overridden
    if 'final' in modifiers:
        return False
    # Private methods cannot be open
    if 'private' in modifiers:
        return False
    # In Java, all other instance methods are overridable by default
    return True


def get_class_order(schema):
    """Get topological order of classes based on inheritance."""
    dependency_graph = []

    for class_ in schema.get('classes', {}):
        extends = schema['classes'][class_].get('extends', [])
        if extends:
            for parent in extends:
                parent_short = parent.split('.')[-1]
                if parent_short in schema.get('classes', {}):
                    dependency_graph.append((class_, parent))

    # Topological sort
    in_degree = {}
    adjacency = {}
    for class_ in schema.get('classes', {}):
        in_degree[class_] = 0
        adjacency[class_] = []

    for child, parent in dependency_graph:
        if parent in in_degree and child in in_degree:
            in_degree[child] += 1
            adjacency[parent].append(child)

    queue = [c for c in in_degree if in_degree[c] == 0]
    result = []

    while queue:
        node = queue.pop(0)
        result.append(node)
        for neighbor in adjacency.get(node, []):
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    # Add remaining classes
    for class_ in in_degree:
        if class_ not in result:
            result.append(class_)

    return result


def main(args):
    # Load type mappings
    type_map = {}

    # Load fixed_type_map.json
    fixed_map_path = "data/java/type_resolution/fixed_type_map.json"
    if os.path.exists(fixed_map_path):
        with open(fixed_map_path, 'r') as f:
            fixed_map = json.load(f)
            type_map.update(fixed_map)

    # Load universal_type_map_final.json (user-defined translations)
    universal_map_path = "data/java/type_resolution/universal_type_map_final.json"
    if os.path.exists(universal_map_path):
        with open(universal_map_path, 'r') as f:
            universal_map = json.load(f)
            # Universal map overrides fixed map
            for k, v in universal_map.items():
                if v:  # Only update if value is not empty
                    type_map[k] = v

    # Schema directory path
    schema_dir = f"data/java/schemas{args.suffix}/{args.model}/{args.temperature}/{args.project}"

    if not os.path.exists(schema_dir):
        print(f"Error: Schema directory not found: {schema_dir}")
        return

    # Get dependencies
    args.schemas_dir = schema_dir
    dependencies = get_dependencies(args)

    # Get custom types from schema
    custom_types = get_custom_types(schema_dir)
    additional_custom_types = ['Exception', 'Error', 'RuntimeException']
    custom_types = list(set(custom_types + additional_custom_types))

    # Output directory for skeletons
    skeletons_dir = f"data/java/skeletons/{args.project}"
    os.makedirs(skeletons_dir, exist_ok=True)

    # Convert project name to valid cjpm name (replace hyphens with underscores)
    cjpm_name = args.project.replace('-', '_')

    # Track main methods found across all schemas
    main_methods = []  # List of {'params': [...], 'return_type': '...'}
    has_main = False  # Track if any main method exists

    # Build a class_name -> {parent_class_name: [method_names]} map across all schemas
    # This is needed to detect overriding across schema files
    class_to_methods = {}  # class_name -> {parent: [method_names]}
    all_schema_classes = {}  # class_name -> {methods: {method_key: method_info}}
    for schema_fname in os.listdir(schema_dir):
        if not schema_fname.endswith('.json'):
            continue
        if f'{args.project}.src.main' not in schema_fname and f'{args.project}.src.test' not in schema_fname:
            continue
        with open(f"{schema_dir}/{schema_fname}", 'r') as f:
            schema = json.load(f)
        for class_key, class_info in schema.get('classes', {}).items():
            class_name = class_key.split(':')[-1]
            extends = class_info.get('extends', [])
            parent = extends[0].split('.')[-1] if extends else None
            methods = list(class_info.get('methods', {}).keys())
            method_names = [m.split(':')[1].strip() if ':' in m else m for m in methods]
            class_to_methods[class_name] = {'parent': parent, 'methods': method_names}
            all_schema_classes[class_name] = {'extends': extends, 'methods': class_info.get('methods', {})}

    # Process each schema file
    for schema_fname in os.listdir(schema_dir):
        if not schema_fname.endswith('.json'):
            continue

        if 'package-info' in schema_fname or 'module-info' in schema_fname:
            continue

        if f'{args.project}.src.main' not in schema_fname and f'{args.project}.src.test' not in schema_fname:
            continue

        schema_path = f"{schema_dir}/{schema_fname}"

        with open(schema_path, 'r') as f:
            schema = json.load(f)

        schema = remove_duplicate_methods(schema, class_to_methods, all_schema_classes)

        # Use cjpm-compatible package name
        cjpm_package_name = args.project.replace('-', '_').replace('.', '_')

        # Start building skeleton (package header will be added later based on sub_path)
        skeleton = ""

        # Imports section (placeholder, filled after type_translation and dependency processing)
        skeleton += "// Imports Begin\n"
        skeleton += "__IMPORTS_PLACEHOLDER__\n"
        skeleton += "// Imports End\n\n"

        # Get class order for processing
        class_order = get_class_order(schema)
        processed_classes = set()

        # Collect all cangjie imports
        cangjie_imports = set()

        # Process each class
        for class_key in class_order:
            if class_key not in schema.get('classes', {}):
                continue

            class_info = schema['classes'][class_key]
            class_name = class_key.split(':')[1].strip()

            # Handle nested class names
            if '<' in class_name:
                class_name = class_name.split('<')[0].replace("new ", "").strip()
            if '(' in class_name:
                class_name = class_name.split('(')[0].replace("new ", "").strip()

            # Skip if already processed
            if class_name in processed_classes:
                continue
            processed_classes.add(class_name)

            is_interface = class_info.get('is_interface', False)
            is_abstract_class = class_info.get('is_abstract', False)
            is_enum = class_info.get('is_enum', False)

            # Generate class/interface declaration
            skeleton_prefix, class_declaration = generate_class_declaration(
                class_info, class_name, type_map, schema_fname, is_interface, is_abstract_class
            )
            skeleton += skeleton_prefix

            # Store cangjie_class_declaration in schema for PromptGenerator
            schema['classes'][class_key]['cangjie_class_declaration'] = class_declaration

            # Process fields
            skeleton += "    // Fields Begin\n"
            for field_key in sorted(class_info.get('fields', {})):
                field_info = class_info['fields'][field_key]
                field_skeleton, field_partial = generate_field_skeleton(field_info, field_key, type_map)
                skeleton += field_skeleton
                field_info['partial_translation'] = field_partial

            skeleton += "    // Fields End\n\n"

            # Process static initializers
            if class_info.get('static_initializers'):
                skeleton += "    // Static Initializer Begin\n"
                for static_init_key, static_init_info in class_info.get('static_initializers', {}).items():
                    static_init_skeleton, static_init_partial = generate_static_initializer_skeleton(
                        static_init_info, static_init_key
                    )
                    skeleton += static_init_skeleton
                    static_init_info['partial_translation'] = static_init_partial
                skeleton += "    // Static Initializer End\n\n"

            # Process methods
            skeleton += "    // Methods Begin\n"
            for method_key in class_info.get('methods', {}):
                method_info = class_info['methods'][method_key]

                method_name = method_key.split(':')[1].strip()
                if '(' in method_name:
                    method_name = method_name.split('(')[0].strip()

                # Skip empty names
                if not method_name:
                    continue

                # Detect Java main method - should be at package level in Cangjie
                if method_name == 'main':
                    # Get return type for main method collection
                    return_types = method_info.get('return_types', [])
                    return_type = get_cangjie_type(return_types[0], type_map) if return_types else 'Unit'
                    parameters = method_info.get('parameters', [])
                    param_strings = []
                    for param in parameters:
                        param_name = param.get('name', 'arg')
                        param_type = param.get('type', 'Any')
                        cangjie_type = get_cangjie_type(param_type, type_map)
                        param_strings.append(f"{param_name}: {cangjie_type}")
                    main_methods.append({
                        'params': param_strings,
                        'return_type': return_type
                    })
                    has_main = True
                    continue  # Don't add to class body

                # Generate method skeleton using helper function
                method_skeleton, method_partial = generate_method_skeleton(
                    method_info, method_key, class_info, type_map, is_interface
                )
                skeleton += method_skeleton
                method_info['partial_translation'] = method_partial

            skeleton += "    // Methods End\n"
            skeleton += "}\n\n"

        # Process dependencies for imports
        dependency_key = None
        for key in dependencies:
            if f'{key}.json' in schema_fname:
                dependency_key = key
                break

        if dependency_key and dependency_key in dependencies:
            for dependent_class in dependencies[dependency_key]:
                dep_class_name = dependent_class[0]
                # Add import if needed
                if dep_class_name not in processed_classes:
                    cangjie_imports.add(f"import {dep_class_name}")

        # Collect standard library imports from type_translations in schema
        for class_key in class_order:
            if class_key not in schema.get('classes', {}):
                continue
            class_info = schema['classes'][class_key]
            for fragment_type in ['fields', 'methods']:
                for frag_key, frag_data in class_info.get(fragment_type, {}).items():
                    for tv in ['types', 'return_types', 'parameters', 'body_types']:
                        for tid, tdata in frag_data.get('type_translations', {}).get(tv, {}).items():
                            imports_val = tdata.get('imports', '')
                            if imports_val and imports_val not in ('None', ''):
                                for imp in imports_val.split('\n'):
                                    imp = imp.strip()
                                    if imp:
                                        cangjie_imports.add(imp)

        # Fill imports placeholder (filter out same-package class imports)
        filtered_imports = set()
        for imp in cangjie_imports:
            # Skip bare class name imports (e.g. "import Student") that are custom types in same package
            if imp.startswith('import ') and not imp.startswith(('import std.', 'import ohos.')):
                imported_name = imp[len('import '):].strip()
                # Skip if it's a known custom type (defined in this project)
                if '.' not in imported_name and imported_name in custom_types:
                    continue
            filtered_imports.add(imp)

        if filtered_imports:
            imports_str = '\n'.join(sorted(filtered_imports)) + '\n'
        else:
            imports_str = '\n'
        skeleton = skeleton.replace('__IMPORTS_PLACEHOLDER__\n', imports_str)

        # Write skeleton file
        # Use schema["path"] to get actual Java source path
        java_path = schema["path"]
        is_test = 'src/test' in java_path

        # Get the class name
        class_name = java_path.split('/')[-1].replace('.java', '')
        if is_test and not class_name.endswith('_test'):
            class_name = class_name + '_test'

        # Find directories for path calculation
        path_parts = java_path.split('/')[:-1]  # Remove filename
        java_parent_dir = '/'.join(path_parts)

        # Find first_java_dir: first directory with .java files from file's parent going upward
        first_java_dir_full_path = None
        for i in range(len(path_parts) - 1, -1, -1):
            current_dir = path_parts[i]
            if current_dir == 'src':
                break
            check_dir = '/'.join(path_parts[:i+1])
            if os.path.isdir(check_dir):
                java_files = [f for f in os.listdir(check_dir) if f.endswith('.java')]
                if java_files:
                    first_java_dir_full_path = check_dir
                    break

        # Find base_java_dir: parent of first_java_dir that also has .java files
        base_java_dir_full_path = None
        if first_java_dir_full_path:
            first_index = path_parts.index(first_java_dir_full_path.split('/')[-1])
            for i in range(first_index - 1, -1, -1):
                current_dir = path_parts[i]
                if current_dir == 'src':
                    break
                check_dir = '/'.join(path_parts[:i+1])
                if os.path.isdir(check_dir):
                    java_files = [f for f in os.listdir(check_dir) if f.endswith('.java')]
                    if java_files:
                        base_java_dir_full_path = check_dir
                        break

        # Build final path under src/
        src_dir = f"{skeletons_dir}/src"

        if base_java_dir_full_path:
            # File is in a subdirectory of base_java_dir
            # sub_path is the part between base and the file
            sub_path = first_java_dir_full_path[len(base_java_dir_full_path)+1:]
        elif first_java_dir_full_path and java_parent_dir != first_java_dir_full_path:
            # File's parent is first_java_dir itself
            sub_path = first_java_dir_full_path.split('/')[-1]
        else:
            # File is directly in first_java_dir
            sub_path = None

        if sub_path:
            os.makedirs(f"{src_dir}/{sub_path}", exist_ok=True)
            file_path = f"{src_dir}/{sub_path}/{class_name}.cj"
        else:
            os.makedirs(src_dir, exist_ok=True)
            file_path = f"{src_dir}/{class_name}.cj"

        # Build package header based on sub_path
        if sub_path:
            package_name = f"{cjpm_package_name}.{sub_path.replace('/', '.')}"
        else:
            package_name = cjpm_package_name
        package_header = f"// Package: {package_name}\npackage {package_name}\n\n"

        # Append main method at package level (Cangjie requires main outside classes)
        skeleton_with_main = skeleton
        if main_methods:
            skeleton_with_main += "main(): Unit {\n"
            skeleton_with_main += "    throw Exception('TODO')\n"
            skeleton_with_main += "}\n"
        # Clear main_methods for next schema file (each schema gets its own main methods in its own file)
        main_methods.clear()

        with open(file_path, 'w') as f:
            f.write(package_header + skeleton_with_main)

        print(f"Generated: {file_path}")

        # translations 骨架写入
        # 保持与原始骨架相同的目录结构，用于模型翻译
        translations_skeleton_dir = f"data/java/skeletons/translations/{args.model}/{args.temperature}/{args.project}"
        os.makedirs(translations_skeleton_dir, exist_ok=True)

        # 构建 translations 下的相对路径
        # file_path 格式: data/java/skeletons/{project}/src/{path}/{ClassName}.cj
        # relative_path 应为: src/{path}/{ClassName}.cj
        relative_path = os.path.relpath(file_path, skeletons_dir)
        translations_file_path = os.path.join(translations_skeleton_dir, relative_path)
        os.makedirs(os.path.dirname(translations_file_path), exist_ok=True)

        with open(translations_file_path, 'w') as f:
            f.write(package_header + skeleton_with_main)

        print(f"Generated translations: {translations_file_path}")

        # Update schema with partial translation
        target_schema = schema.copy()
        target_schema['cangjie_skeleton_path'] = file_path
        target_schema['cangjie_translations_skeleton_path'] = translations_file_path
        with open(schema_path, 'w') as f:
            json.dump(target_schema, f, indent=4)

    # Generate cjpm.toml once at the end with correct output-type
    output_type = "executable" if has_main else "static"

    # cjpm.toml for skeletons dir
    cjpm_content = f"""[package]
  cjc-version = "1.0.5"
  name = "{cjpm_name}"
  description = "nothing here"
  version = "1.0.0"
  src-dir = "src"
  target-dir = ""
  output-type = "{output_type}"
  compile-option = ""
  override-compile-option = ""
  link-option = ""
  package-configuration = {{}}

[dependencies]
"""
    with open(f"{skeletons_dir}/cjpm.toml", 'w') as f:
        f.write(cjpm_content)

    # cjpm.toml for translations dir
    translations_cjpm_path = f"{translations_skeleton_dir}/cjpm.toml"
    with open(translations_cjpm_path, 'w') as f:
        f.write(cjpm_content)

    print(f"\nSkeleton generation complete: {skeletons_dir}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create Cangjie skeleton from Java schema')
    parser.add_argument('--project', type=str, dest='project', help='name of the project')
    parser.add_argument('--model', type=str, dest='model', help='name of the model')
    parser.add_argument('--suffix', type=str, dest='suffix', help='suffix (e.g., _decomposed_tests)')
    parser.add_argument('--temperature', type=float, dest='temperature', help='temperature')
    args = parser.parse_args()

    main(args)
