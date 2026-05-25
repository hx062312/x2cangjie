import os
import json


def dedupe_preserve_order(items, key=None):
    seen = set()
    result = []
    for item in items:
        marker = key(item) if key else item
        if marker in seen:
            continue
        seen.add(marker)
        result.append(item)
    return result


def get_custom_types(schema_dir, schema_filter=None):
    custom_types = []
    for schema_file in os.listdir(schema_dir):
        if schema_filter is not None and not schema_filter(schema_file):
            continue
        data = {}
        with open(f'{schema_dir}/{schema_file}', 'r') as f:
            data = json.load(f)
        
        for class_ in data['classes']:
            class_name = class_.split(':')[1]
            custom_types.append(class_name)
            if data['classes'][class_]['nested_inside'] != '':
                outer_class = data['classes'][class_]['nested_inside'].split(':')[1]
                custom_types.append(f'{outer_class}.{class_name}')
    
    return dedupe_preserve_order(custom_types)


def get_custom_type_translation_map(schema_dir, schema_filter=None):
    """Map Java custom type spellings to Cangjie flattened class names."""
    custom_types = get_custom_types(schema_dir, schema_filter=schema_filter)
    simple_types = set(t for t in custom_types if '.' not in t)
    type_map = {}
    for type_name in custom_types:
        if '.' not in type_name:
            type_map[type_name] = type_name
            continue
        flattened_name = type_name.split('.')[-1]
        if flattened_name in simple_types:
            type_map[type_name] = flattened_name
    return type_map


def save_custom_types(project_name, custom_types, base_dir='data/java/type_resolution'):
    """Persist custom types to a project-specific JSON file."""
    custom_types = dedupe_preserve_order(custom_types)
    output_dir = os.path.join(base_dir, project_name)
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, 'custom_types.json')
    with open(output_file, 'w') as f:
        json.dump(custom_types, f, indent=4)
