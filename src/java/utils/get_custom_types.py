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
