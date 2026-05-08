#!/usr/bin/env python3
"""
Create Cangjie skeleton files from Java schema.
Adapted from TRAM but targeting Cangjie instead of Python.
"""
import argparse
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
from src.java.utils.get_dependencies import get_dependencies
from src.java.utils.get_class_order import get_class_order
from src.java.utils.get_custom_types import get_custom_types


# ============================================================
# Schema Preprocessing
# ============================================================


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
                if method_name not in parent_methods:
                    continue

                # Get child method parameter types
                child_method = schema['classes'][class_key]['methods'][method_key]
                child_param_types = [p['type'] for p in child_method.get('parameters', [])]

                # Find matching parent method with same name AND parameter types
                is_override = False
                if parent_class_short in all_schema_classes:
                    for pm_key, pm_info in all_schema_classes[parent_class_short].get('methods', {}).items():
                        pm_name = pm_key.split(':')[1].strip()
                        if pm_name == method_name:
                            parent_param_types = [p['type'] for p in pm_info.get('parameters', [])]
                            if child_param_types == parent_param_types:
                                is_override = True
                                break

                if is_override:
                    # This is an override
                    schema['classes'][class_key]['methods'][method_key]['is_override'] = True

                    # Also mark parent method as needing 'open'
                    if parent_class_short in all_schema_classes:
                        for parent_method_key in all_schema_classes[parent_class_short].get('methods', {}):
                            parent_method_name = parent_method_key.split(':')[1].strip()
                            if parent_method_name == method_name:
                                all_schema_classes[parent_class_short]['methods'][parent_method_key]['needs_open'] = True

    return schema


# ============================================================
# Type Resolution
# ============================================================


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


def _filter_jdk_types(type_list, class_to_package):
    """Filter out JDK types not present in the project from extends/implements."""
    if not type_list:
        return []
    result = []
    for t in type_list:
        short_name = t.split('.')[-1] if '.' in t else t
        if short_name in class_to_package:
            result.append(t)
    return result


def _get_class_parent(class_name, extends, implements, class_to_package, type_map):
    """Resolve class declaration parent from extends/implements.

    Returns (parent_name, implements_str) — both can be empty.
    Filters out types in sub-packages (root pkg can't depend on sub-pkgs in Cangjie).
    """
    current_pkg = class_to_package.get(class_name, '')

    # Try single extends first
    parent_name = ''
    for t in (extends or []):
        short_name = t.split('.')[-1]
        if short_name in class_to_package:
            ref_pkg = class_to_package[short_name]
            if not (current_pkg and ref_pkg.startswith(current_pkg + '.')):
                parent_name = normalize_class_name(t, type_map)
                break

    if parent_name:
        return parent_name, ''

    # Fallback to implements
    impls = []
    for t in (implements or []):
        short_name = t.split('.')[-1]
        if short_name in class_to_package:
            ref_pkg = class_to_package[short_name]
            if not (current_pkg and ref_pkg.startswith(current_pkg + '.')):
                impls.append(normalize_class_name(t, type_map))

    return parent_name, ' & '.join(impls)


def _get_interface_parents(class_name, extends, class_to_package, type_map):
    """Resolve interface extends, filtering out inaccessible sub-package types.

    Returns list of extended interface names.
    """
    current_pkg = class_to_package.get(class_name, '')

    result = []
    for t in (extends or []):
        short_name = t.split('.')[-1]
        if short_name in class_to_package:
            ref_pkg = class_to_package[short_name]
            if not (current_pkg and ref_pkg.startswith(current_pkg + '.')):
                result.append(normalize_class_name(t, type_map))

    return result


# ============================================================
# Modifier Decisions
# ============================================================


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


def get_method_modifiers(modifiers, is_override=False, is_interface=False,
                         is_constructor=False, needs_open=False):
    """Build Cangjie method modifier prefix string.

    Returns e.g. 'public override open ', 'public override ', 'public open ',
    'public static ', ''.
    Interface methods return '' (modifiers are implicitly public open).
    Constructors return only access modifier (no open/override/static).
    The caller handles the func/init keyword.
    """
    if is_interface:
        return ""

    if is_constructor:
        return get_access_modifier(modifiers)

    access_mod = get_access_modifier(modifiers)

    if is_static(modifiers):
        return f"{access_mod}static "

    if is_override:
        if not access_mod:
            access_mod = "public "
        if needs_open:
            return f"{access_mod}override open "
        return f"{access_mod}override "

    if method_needs_open(modifiers):
        if not access_mod:
            access_mod = "public "
        return f"{access_mod}open "

    return access_mod


def get_class_modifiers(java_modifiers, is_abstract):
    """Build Cangjie class modifier prefix string.

    Returns e.g. 'public abstract ', 'public open ', 'public ', ''.
    """
    access_mod = get_access_modifier(java_modifiers)
    if is_abstract:
        return f"{access_mod}abstract "
    if class_needs_open(java_modifiers, is_abstract):
        return f"{access_mod}open "
    return access_mod


def get_interface_modifiers(java_modifiers):
    """Build Cangjie interface modifier prefix string.

    Returns e.g. 'public ', ''.
    Interfaces are implicitly open in Cangjie — no 'open' needed.
    """
    return get_access_modifier(java_modifiers)


def get_field_modifiers(modifiers):
    """Build Cangjie field modifier prefix string.

    Returns e.g. 'static let ', 'static var ', 'let ', 'var '.
    In Cangjie, final fields use 'let', mutable fields use 'var'.
    """
    parts = []
    if is_static(modifiers):
        parts.append('static')
    if 'final' in modifiers:
        parts.append('let')
    else:
        parts.append('var')
    return ' '.join(parts) + ' '


def get_method_params(method_info, type_map):
    """Extract Cangjie parameter list from method info.

    Returns list of strings like ['name: String', 'count: Int32'].
    """
    params = method_info.get('parameters', [])
    result = []
    for param in params:
        param_name = param.get('name', 'arg')
        param_type = param.get('type', 'Any')
        cangjie_type = get_cangjie_type(param_type, type_map)
        result.append(f"{param_name}: {cangjie_type}")
    return result


def get_method_return_type(method_info, type_map, is_constructor=False):
    """Extract Cangjie return type string from method info.

    Returns the type string (e.g. 'String', 'Unit'), or '' for constructors.
    """
    if is_constructor:
        return ''
    return_types = method_info.get('return_types', [])
    if not return_types:
        return 'Unit'
    rt = return_types[0]
    if rt.startswith('<') and rt.endswith('>') and len(return_types) > 1:
        rt = return_types[1]
    return get_cangjie_type(rt, type_map)


def generate_field_skeleton(field_info, field_key, type_map):
    """
    Generate skeleton for a single field.

    Returns:
        tuple: (skeleton_string, partial_translation_list)
    """
    field_name = field_key.split(':')[1].strip()
    modifiers = field_info.get('modifiers', [])

    types = field_info.get('types', [])
    if types:
        source_type = types[0]
        field_type = get_cangjie_type(source_type, type_map)
    else:
        field_type = 'Any'

    field_prefix = get_field_modifiers(modifiers)

    skeleton = f"    {field_prefix}{field_name}: {field_type} = throw Exception('TODO')\n"

    # partial_translation for fields should match skeleton content
    partial_translation = [f"    {field_prefix}{field_name}: {field_type} = throw Exception('TODO')\n"]

    return skeleton, partial_translation


def generate_method_skeleton(method_info, method_key, type_map,
                              is_override=False, needs_super_call=False,
                              custom_method_name=None, is_interface=False,
                              needs_open=False):
    """
    Generate skeleton for a single method.

    Parameters:
        custom_method_name: If provided, use instead of parsing from method_key
                            (handles field-method name conflict rename).

    Returns:
        tuple: (skeleton_string, partial_translation_list)
    """
    if custom_method_name:
        method_name = custom_method_name
    else:
        method_name = method_key.split(':')[1].strip()
        if '(' in method_name:
            method_name = method_name.split('(')[0].strip()

    if not method_name:
        return "", []

    modifiers = method_info.get('modifiers', [])
    is_constructor = method_info.get('is_constructor', False)

    param_strings = get_method_params(method_info, type_map)
    return_type = get_method_return_type(method_info, type_map, is_constructor)

    mod_prefix = get_method_modifiers(
        modifiers,
        is_override=is_override,
        is_interface=is_interface,
        is_constructor=is_constructor,
        needs_open=needs_open,
    )
    params_str = ', '.join(param_strings)
    if is_constructor:
        method_sig = f"    {mod_prefix}init({params_str})"
    else:
        method_sig = f"    {mod_prefix}func {method_name}({params_str})"
        if return_type:
            method_sig += f": {return_type}"

    body_lines = []
    if is_constructor and needs_super_call:
        body_lines.append("        super()")
    body_lines.append("        throw Exception('TODO')")
    body_str = "\n".join(body_lines)

    skeleton = f"{method_sig} {{\n{body_str}\n    }}\n\n"

    partial_translation = [f"{method_sig} {{", body_str, "    }\n"]

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


def generate_class_skeleton(class_info, class_name, type_map, schema_fname,
                             class_to_package, all_schema_classes):
    """
    Generate class declaration + fields + static initializers + methods.
    Modifies class_info in-place with partial_translations.
    Returns (skeleton_string, has_main_from_class).
    """
    is_abstract_class = class_info.get('is_abstract', False)
    java_modifiers = class_info.get('modifiers', [])
    class_mod = get_class_modifiers(java_modifiers, is_abstract_class)

    extends = class_info.get('extends', [])
    implements = class_info.get('implements', [])

    # Build class declaration
    parent_name, impl_str = _get_class_parent(
        class_name, extends, implements, class_to_package, type_map
    )
    if parent_name:
        declaration = f"{class_mod}class {class_name} <: {parent_name} {{\n"
    elif impl_str:
        declaration = f"{class_mod}class {class_name} <: {impl_str} {{\n"
    else:
        declaration = f"{class_mod}class {class_name} {{\n"

    skeleton = declaration
    class_info['cangjie_class_declaration'] = declaration

    # Add test annotation if needed
    if 'src.test' in schema_fname and _is_test_class(class_info):
        skeleton = "@Test\n" + skeleton

    # Fields
    skeleton += "    // Fields Begin\n"
    for field_key in sorted(class_info.get('fields', {})):
        field_info = class_info['fields'][field_key]
        field_skeleton, field_partial = generate_field_skeleton(field_info, field_key, type_map)
        skeleton += field_skeleton
        field_info['partial_translation'] = field_partial
    skeleton += "    // Fields End\n\n"

    # Static initializers
    if class_info.get('static_initializers'):
        skeleton += "    // Static Initializer Begin\n"
        for static_init_key, static_init_info in class_info.get('static_initializers', {}).items():
            static_init_skeleton, static_init_partial = generate_static_initializer_skeleton(
                static_init_info, static_init_key
            )
            skeleton += static_init_skeleton
            static_init_info['partial_translation'] = static_init_partial
        skeleton += "    // Static Initializer End\n\n"

    # Methods
    skeleton += "    // Methods Begin\n"

    # Check if child constructors need explicit super() call
    needs_super_call = _check_needs_super_call(extends, all_schema_classes)

    # Field names for conflict detection
    field_names = set()
    for field_key in class_info.get('fields', {}):
        fn = field_key.split(':')[1].strip()
        if fn:
            field_names.add(fn)

    used_sigs = set()
    has_main_from_class = False

    for method_key in class_info.get('methods', {}):
        method_info = class_info['methods'][method_key]
        method_name = method_key.split(':')[1].strip()
        if '(' in method_name:
            method_name = method_name.split('(')[0].strip()
        if not method_name:
            continue

        # Main method detection (handled at file level in Cangjie)
        if method_name == 'main':
            has_main_from_class = True
            continue

        # Rename method if it conflicts with a field name
        custom_method_name = method_name
        if method_name in field_names:
            custom_method_name = method_name + '_method'
            method_info['renamed_from'] = method_name

        # Signature conflict detection
        is_constructor = method_info.get('is_constructor', False)
        cangjie_method_name = 'init' if is_constructor else custom_method_name
        cangjie_param_types = tuple(
            get_cangjie_type(p.get('type', 'Any'), type_map)
            for p in method_info.get('parameters', [])
        )
        sig_key = (cangjie_method_name, cangjie_param_types)

        if sig_key in used_sigs:
            if is_constructor:
                method_skeleton = f"    // TODO: constructor with same signature 'init({', '.join(cangjie_param_types)})' needs manual resolution\n"
                skeleton += method_skeleton
                method_info['partial_translation'] = [method_skeleton]
                method_info['skipped'] = True
                continue
            else:
                suffix = 1
                while (f"{custom_method_name}_{suffix}", cangjie_param_types) in used_sigs:
                    suffix += 1
                custom_method_name = f"{custom_method_name}_{suffix}"
        used_sigs.add(sig_key)

        method_skeleton, method_partial = generate_method_skeleton(
            method_info, method_key, type_map,
            is_override=method_info.get('is_override', False),
            needs_super_call=needs_super_call,
            custom_method_name=custom_method_name,
            needs_open=method_info.get('needs_open', False),
        )
        skeleton += method_skeleton
        method_info['partial_translation'] = method_partial

    skeleton += "    // Methods End\n"

    # Add synthetic no-arg constructor if class has param constructors but no no-arg.
    # This gives subclasses a super() target to call in their constructors.
    if _needs_synthetic_no_arg_constructor(class_info):
        skeleton += "\n    protected init() {\n        throw Exception('TODO')\n    }\n"

    skeleton += "}\n\n"

    return skeleton, has_main_from_class


def generate_interface_skeleton(class_info, class_name, type_map, schema_fname, class_to_package):
    """
    Generate interface declaration + methods.
    Modifies class_info in-place with partial_translations.
    Returns skeleton_string.
    """
    java_modifiers = class_info.get('modifiers', [])
    interface_mod = get_interface_modifiers(java_modifiers)

    extends = class_info.get('extends', [])
    parent_names = _get_interface_parents(class_name, extends, class_to_package, type_map)
    if parent_names:
        declaration = f"{interface_mod}interface {class_name} <: {' & '.join(parent_names)} {{\n"
    else:
        declaration = f"{interface_mod}interface {class_name} {{\n"

    skeleton = declaration
    class_info['cangjie_class_declaration'] = declaration

    # Add test annotation if needed
    if 'src.test' in schema_fname and _is_test_class(class_info):
        skeleton = "@Test\n" + skeleton

    # Methods (interfaces don't have fields/static initializers)
    skeleton += "    // Methods Begin\n"

    used_sigs = set()
    for method_key in class_info.get('methods', {}):
        method_info = class_info['methods'][method_key]
        method_name = method_key.split(':')[1].strip()
        if '(' in method_name:
            method_name = method_name.split('(')[0].strip()
        if not method_name:
            continue

        # Signature conflict detection
        is_constructor = method_info.get('is_constructor', False)
        cangjie_method_name = 'init' if is_constructor else method_name
        cangjie_param_types = tuple(
            get_cangjie_type(p.get('type', 'Any'), type_map)
            for p in method_info.get('parameters', [])
        )
        sig_key = (cangjie_method_name, cangjie_param_types)

        if sig_key in used_sigs:
            if is_constructor:
                method_skeleton = f"    // TODO: constructor with same signature 'init({', '.join(cangjie_param_types)})' needs manual resolution\n"
                skeleton += method_skeleton
                method_info['partial_translation'] = [method_skeleton]
                method_info['skipped'] = True
                continue
            else:
                suffix = 1
                while (f"{method_name}_{suffix}", cangjie_param_types) in used_sigs:
                    suffix += 1
                method_name = f"{method_name}_{suffix}"
        used_sigs.add(sig_key)

        method_skeleton, method_partial = generate_method_skeleton(
            method_info, method_key, type_map,
            is_override=method_info.get('is_override', False),
            needs_super_call=False,
            is_interface=True
        )
        skeleton += method_skeleton
        method_info['partial_translation'] = method_partial

    skeleton += "    // Methods End\n"
    skeleton += "}\n\n"

    return skeleton


def generate_package_header(cjpm_name, sub_path):
    """Generate Cangjie package header string."""
    if sub_path:
        package_name = f"{cjpm_name}.{sub_path.replace('/', '.')}"
    else:
        package_name = cjpm_name
    return f"// Package: {package_name}\npackage {package_name}\n\n"


def is_interface(schema_classes, class_key):
    """Check if a class is an interface."""
    if class_key not in schema_classes:
        return False
    return schema_classes[class_key].get('is_interface', False)


def class_needs_open(java_modifiers, is_abstract):
    """A Cangjie class needs 'open' if inheritable (non-final, non-abstract)."""
    if is_abstract:
        return False
    return 'final' not in java_modifiers


def method_needs_open(java_modifiers):
    """A Cangjie method needs 'open' if overridable (non-static, non-final, non-private)."""
    if 'static' in java_modifiers:
        return False
    if 'final' in java_modifiers:
        return False
    if 'private' in java_modifiers:
        return False
    return True


def _is_test_class(class_info):
    """Check if any method in the class has @Test annotation."""
    return any(
        '@Test' in [x.split('(')[0] for x in class_info['methods'][m].get('annotations', [])]
        for m in class_info.get('methods', {})
    )


def _check_needs_super_call(extends, all_schema_classes):
    """Check if child constructors need explicit super() call.

    Returns True when the parent class has constructors but no no-arg constructor,
    meaning child constructors must call super() explicitly.
    """
    if not extends:
        return False
    parent_short = extends[0].split('.')[-1]
    if parent_short not in all_schema_classes:
        return False
    parent_constructors = [
        pm for pm_key, pm in all_schema_classes[parent_short].get('methods', {}).items()
        if pm.get('is_constructor', False)
    ]
    if not parent_constructors:
        return False
    return not any(len(pm.get('parameters', [])) == 0 for pm in parent_constructors)


def _needs_synthetic_no_arg_constructor(class_info):
    """Check if class needs a synthetic protected no-arg constructor.

    Cangjie requires subclasses to call super() explicitly if the parent
    has parameter constructors but no no-arg constructor. This function
    detects whether the current class needs such a synthetic constructor.
    """
    has_constructor = False
    has_no_arg = False
    for mk, mv in class_info.get('methods', {}).items():
        if mv.get('is_constructor', False):
            has_constructor = True
            if len(mv.get('parameters', [])) == 0:
                has_no_arg = True
                break
    return has_constructor and not has_no_arg


# ============================================================
# Path & Package
# ============================================================


def _parse_java_path(java_path):
    """
    Extract the Java package sub-path from a full source path.

    For a path like ``.../src/main/java/org/apache/Foo.java``,
    returns ``org/apache``.  Returns ``None`` when no standard
    Java source root (``src/main/java/`` or ``src/test/java/``)
    is found.
    """
    for marker in ('src/main/java/', 'src/test/java/'):
        if marker in java_path:
            after = java_path.split(marker, 1)[1]
            parts = after.split('/')
            return '/'.join(parts[:-1]) if len(parts) > 1 else None
    return None


def _get_cangjie_package(java_path, cjpm_package_name):
    """Compute Cangjie package name from a Java source file path."""
    sub_path = _compute_skeleton_sub_path(java_path)
    if sub_path:
        return f"{cjpm_package_name}.{sub_path.replace('/', '.')}"
    return cjpm_package_name


def _compute_skeleton_sub_path(java_path):
    """
    Compute the skeleton sub_path by walking up the Java directory tree.

    Finds the first directory (going upward from the file) that contains .java
    files, then finds the parent of that directory that also has .java files.
    The difference between them is the meaningful sub_path.

    e.g. .../codec/net/URLCodec.java -> 'net'
         .../codec/language/bm/Rule.java -> 'bm'
         .../codec/BinaryDecoder.java -> None (root package)
    """
    path_parts = java_path.split('/')[:-1]
    java_parent_dir = '/'.join(path_parts)

    # Find first directory (going upward) that has .java files
    first_java_dir_full_path = None
    for i in range(len(path_parts) - 1, -1, -1):
        current_dir = path_parts[i]
        if current_dir == 'src':
            break
        check_dir = '/'.join(path_parts[:i + 1])
        if os.path.isdir(check_dir):
            java_files = [f for f in os.listdir(check_dir) if f.endswith('.java')]
            if java_files:
                first_java_dir_full_path = check_dir
                break

    if not first_java_dir_full_path:
        return None

    # Find parent of first_java_dir that also has .java files
    base_java_dir_full_path = None
    first_name = first_java_dir_full_path.split('/')[-1]
    if first_name in path_parts:
        first_index = path_parts.index(first_name)
        for i in range(first_index - 1, -1, -1):
            current_dir = path_parts[i]
            if current_dir == 'src':
                break
            check_dir = '/'.join(path_parts[:i + 1])
            if os.path.isdir(check_dir):
                java_files = [f for f in os.listdir(check_dir) if f.endswith('.java')]
                if java_files:
                    base_java_dir_full_path = check_dir
                    break

    if base_java_dir_full_path:
        return first_java_dir_full_path[len(base_java_dir_full_path) + 1:]
    elif java_parent_dir != first_java_dir_full_path:
        return first_java_dir_full_path.split('/')[-1]
    else:
        return None


# ============================================================
# Import Helpers
# ============================================================


# Known Cangjie std lib type to import mappings
STD_TYPE_IMPORTS = {
    'ArrayList': 'import std.collection.ArrayList',
    'HashMap': 'import std.collection.HashMap',
    'HashSet': 'import std.collection.HashSet',
    'InputStream': 'import std.io.InputStream',
    'OutputStream': 'import std.io.OutputStream',
    'ByteBuffer': 'import std.io.ByteBuffer',
    'Regex': 'import std.regex.Regex',
    'BigInt': 'import std.math.numeric.BigInt',
}


def _extract_type_names(cangjie_type_str):
    """Extract all base type names from a Cangjie type string, including nested generics."""
    names = set()
    depth = 0
    current = ""
    for c in cangjie_type_str:
        if c == '<':
            depth += 1
            if current.strip():
                names.add(current.strip())
            current = ""
        elif c == '>':
            depth -= 1
            if current.strip():
                names.add(current.strip())
            current = ""
        elif c == ',' and depth > 0:
            if current.strip():
                names.add(current.strip())
            current = ""
        elif c == ' ':
            continue
        else:
            current += c
    if current.strip():
        names.add(current.strip())
    return names


def generate_imports_skeleton(schema, class_order, schema_fname, java_path,
                               cjpm_name, type_map, class_to_package,
                               dependencies, custom_types, processed_classes):
    """Build the complete import section for a skeleton file.

    Returns the import string to replace __IMPORTS_PLACEHOLDER__.
    """
    cangjie_imports = set()

    _add_project_imports(cangjie_imports, dependencies, schema_fname,
                         processed_classes, schema, class_order,
                         java_path, cjpm_name, class_to_package)

    _add_lib_imports(cangjie_imports, schema, class_order, type_map)

    # Filter out custom types (they're in the same project, no import needed)
    filtered_imports = set()
    for imp in cangjie_imports:
        if imp.startswith('import ') and not imp.startswith(('import std.', 'import ohos.')):
            imported_name = imp[len('import '):].strip()
            if '.' not in imported_name and imported_name in custom_types:
                continue
        filtered_imports.add(imp)

    if filtered_imports:
        return '\n'.join(sorted(filtered_imports)) + '\n'
    return '\n'


def _add_project_imports(cangjie_imports, dependencies, schema_fname,
                         processed_classes, schema, class_order,
                         java_path, cjpm_name, class_to_package):
    """Add imports for project types (dependencies + cross-package extends/implements)."""
    # Process dependencies for imports
    dependency_key = None
    for key in dependencies:
        if f'{key}.json' in schema_fname:
            dependency_key = key
            break

    if dependency_key and dependency_key in dependencies:
        for dependent_class in dependencies[dependency_key]:
            dep_class_name = dependent_class[0]
            if dep_class_name not in processed_classes:
                cangjie_imports.add(f"import {dep_class_name}")

    # Cross-package imports for extends/implements
    cur_pkg = _get_cangjie_package(java_path, cjpm_name)
    is_root_pkg = (cur_pkg == cjpm_name)
    for class_key in class_order:
        if class_key not in schema.get('classes', {}):
            continue
        class_info = schema['classes'][class_key]
        for ref_type in class_info.get('extends', []) + class_info.get('implements', []):
            ref_name = ref_type.split('.')[-1]
            if ref_name not in class_to_package:
                continue
            ref_pkg = class_to_package[ref_name]
            if ref_pkg == cur_pkg:
                continue
            # Root package cannot import from its own sub-packages in Cangjie
            if is_root_pkg and ref_pkg.startswith(cjpm_name + '.'):
                continue
            cangjie_imports.add(f"import {ref_pkg}.{ref_name}")


def _add_lib_imports(cangjie_imports, schema, class_order, type_map):
    """Add imports for library types (std + type_translations)."""
    # Scan all types for std imports
    for class_key in class_order:
        if class_key not in schema.get('classes', {}):
            continue
        class_info = schema['classes'][class_key]
        for field_key, field_info in class_info.get('fields', {}).items():
            for t in field_info.get('types', []):
                _add_std_import_for_type(get_cangjie_type(t, type_map), cangjie_imports)
        for method_key, method_info in class_info.get('methods', {}).items():
            for rt in method_info.get('return_types', []):
                _add_std_import_for_type(get_cangjie_type(rt, type_map), cangjie_imports)
            for p in method_info.get('parameters', []):
                _add_std_import_for_type(get_cangjie_type(p.get('type', 'Any'), type_map), cangjie_imports)

    # Collect std imports from type_translations
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


def _add_std_import_for_type(cangjie_type_name, cangjie_imports):
    """Add std lib import if any type name matches a known std type."""
    for name in _extract_type_names(cangjie_type_name):
        if name in STD_TYPE_IMPORTS:
            cangjie_imports.add(STD_TYPE_IMPORTS[name])


# ============================================================
# Per-File Orchestrator
# ============================================================


def generate_one_file_skeleton(schema, schema_fname, schema_path, cjpm_name, type_map,
                                class_to_package, all_schema_classes, class_to_methods,
                                dependencies, custom_types, skeletons_dir,
                                translations_skeleton_dir):
    """
    Generate Cangjie skeleton for one schema file.

    Handles package header, imports, class/interface skeletons,
    main method extraction, import resolution, and file output.

    Returns True if any main method was found in this file.
    """
    # Package header
    java_path = schema.get('path', '')
    sub_path = _compute_skeleton_sub_path(java_path)
    skeleton = generate_package_header(cjpm_name, sub_path)

    # Imports placeholder
    skeleton += "// Imports Begin\n__IMPORTS_PLACEHOLDER__\n// Imports End\n\n"

    # Class order
    class_order = get_class_order(schema)
    processed_classes = set()

    has_main_from_file = False

    # Process each class in dependency order
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

        if class_name in processed_classes:
            continue
        processed_classes.add(class_name)

        is_interface_class = class_info.get('is_interface', False)

        if is_interface_class:
            class_skeleton = generate_interface_skeleton(
                class_info, class_name, type_map, schema_fname, class_to_package
            )
            skeleton += class_skeleton
        else:
            class_skeleton, has_main_from_class = generate_class_skeleton(
                class_info, class_name, type_map, schema_fname,
                class_to_package, all_schema_classes
            )
            skeleton += class_skeleton
            if has_main_from_class:
                has_main_from_file = True

        # Store cangjie_class_declaration in schema for PromptGenerator
        schema['classes'][class_key]['cangjie_class_declaration'] = class_info.get('cangjie_class_declaration', '')

    imports_str = generate_imports_skeleton(
        schema, class_order, schema_fname, java_path,
        cjpm_name, type_map, class_to_package,
        dependencies, custom_types, processed_classes
    )
    skeleton = skeleton.replace('__IMPORTS_PLACEHOLDER__\n', imports_str)

    # Write skeleton file
    is_test = 'src/test' in java_path
    class_name = java_path.split('/')[-1].replace('.java', '')
    if is_test and not class_name.endswith('_test'):
        class_name = class_name + '_test'

    src_dir = f"{skeletons_dir}/src"
    if sub_path:
        os.makedirs(f"{src_dir}/{sub_path}", exist_ok=True)
        file_path = f"{src_dir}/{sub_path}/{class_name}.cj"
    else:
        os.makedirs(src_dir, exist_ok=True)
        file_path = f"{src_dir}/{class_name}.cj"

    # Append main at package level if any class had one
    if has_main_from_file:
        skeleton += "main(): Unit {\n"
        skeleton += "    throw Exception('TODO')\n"
        skeleton += "}\n"

    with open(file_path, 'w') as f:
        f.write(skeleton)

    print(f"Generated: {file_path}")

    # Translations skeleton
    relative_path = os.path.relpath(file_path, skeletons_dir)
    translations_file_path = os.path.join(translations_skeleton_dir, relative_path)
    os.makedirs(os.path.dirname(translations_file_path), exist_ok=True)

    with open(translations_file_path, 'w') as f:
        f.write(skeleton)

    print(f"Generated translations: {translations_file_path}")

    # Update schema with partial translation
    target_schema = schema.copy()
    target_schema['cangjie_skeleton_path'] = file_path
    target_schema['cangjie_translations_skeleton_path'] = translations_file_path
    with open(schema_path, 'w') as f:
        json.dump(target_schema, f, indent=4)

    return has_main_from_file


# ============================================================
# Main Pipeline
# ============================================================


def main(args):
    # Load type mappings
    type_map = {}

    # Phase 1: Build Global Context

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
            for k, v in universal_map.items():
                if v:
                    type_map[k] = v

    # Schema directory
    schema_dir = f"data/java/schemas{args.suffix}/{args.model}/{args.temperature}/{args.project}"

    if not os.path.exists(schema_dir):
        print(f"Error: Schema directory not found: {schema_dir}")
        return

    # Dependencies and custom types
    args.schemas_dir = schema_dir
    dependencies = get_dependencies(args)
    custom_types = get_custom_types(schema_dir)
    additional_custom_types = ['Exception', 'Error', 'RuntimeException']
    custom_types = list(set(custom_types + additional_custom_types))

    # Output directories
    skeletons_dir = f"data/java/skeletons/{args.project}"
    os.makedirs(skeletons_dir, exist_ok=True)
    translations_skeleton_dir = f"data/java/skeletons/translations/{args.model}/{args.temperature}/{args.project}"
    os.makedirs(translations_skeleton_dir, exist_ok=True)

    # Cangjie package name
    cjpm_name = args.project.replace('-', '_')

    # Build cross-schema mappings and load all schemas
    class_to_methods = {}
    all_schema_classes = {}
    class_to_package = {}
    all_schemas = []

    for schema_fname in os.listdir(schema_dir):
        if not schema_fname.endswith('.json'):
            continue
        if f'{args.project}.src.main' not in schema_fname and f'{args.project}.src.test' not in schema_fname:
            continue
        schema_path = f"{schema_dir}/{schema_fname}"
        with open(schema_path, 'r') as f:
            schema = json.load(f)
        cangjie_pkg = _get_cangjie_package(schema.get('path', ''), cjpm_name)
        for class_key, class_info in schema.get('classes', {}).items():
            class_name = class_key.split(':')[-1]
            extends = class_info.get('extends', [])
            parent = extends[0].split('.')[-1] if extends else None
            methods = list(class_info.get('methods', {}).keys())
            method_names = [m.split(':')[1].strip() if ':' in m else m for m in methods]
            class_to_methods[class_name] = {'parent': parent, 'methods': method_names}
            all_schema_classes[class_name] = {'extends': extends, 'methods': class_info.get('methods', {})}
            class_to_package[class_name] = cangjie_pkg
        all_schemas.append((schema_fname, schema_path, schema))

    # Phase 1b: Run remove_duplicate_methods on all schemas to populate needs_open flags
    for schema_fname, schema_path, schema in all_schemas:
        if 'package-info' in schema_fname or 'module-info' in schema_fname:
            continue
        remove_duplicate_methods(schema, class_to_methods, all_schema_classes)

    # Phase 2: Generate Skeletons (using Phase 1 schema data — no reload from disk)
    has_main = False

    for schema_fname, schema_path, schema in all_schemas:
        if 'package-info' in schema_fname or 'module-info' in schema_fname:
            continue

        has_main_from_file = generate_one_file_skeleton(
            schema, schema_fname, schema_path, cjpm_name, type_map,
            class_to_package, all_schema_classes, class_to_methods,
            dependencies, custom_types, skeletons_dir, translations_skeleton_dir
        )
        has_main = has_main or has_main_from_file

    # Phase 3: Generate cjpm.toml
    output_type = "executable" if has_main else "static"

    cjpm_content = f"""[package]
  cjc-version = "1.0.5"
  name = "{cjpm_name}"
  description = "nothing here"
  version = "1.0.0"
  src-dir = "src"
  target-dir = ""
  output-type = "{output_type}"
  compile-option = "-Woff unused"
  override-compile-option = ""
  link-option = ""
  package-configuration = {{}}

[dependencies]
"""
    with open(f"{skeletons_dir}/cjpm.toml", 'w') as f:
        f.write(cjpm_content)

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
