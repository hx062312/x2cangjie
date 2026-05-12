import os
import json


def get_custom_types(schema_dir):
    custom_types = []
    for schema_file in os.listdir(schema_dir):
        data = {}
        with open(f'{schema_dir}/{schema_file}', 'r') as f:
            data = json.load(f)
        
        for class_ in data['classes']:
            class_name = class_.split(':')[1]
            custom_types.append(class_name)
            if data['classes'][class_]['nested_inside'] != '':
                outer_class = data['classes'][class_]['nested_inside'].split(':')[1]
                custom_types.append(f'{outer_class}.{class_name}')
    
    return custom_types


def save_custom_types(project_name, custom_types, base_dir='data/java/type_resolution'):
    """Persist custom types to a project-specific JSON file."""
    output_dir = os.path.join(base_dir, project_name)
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, 'custom_types.json')
    with open(output_file, 'w') as f:
        json.dump(custom_types, f, indent=4)
