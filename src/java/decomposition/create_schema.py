import os
import json
import tqdm
import argparse
from tree_sitter import Language, Parser

from src.java.utils.get_schema_file import get_schema_file


class Class:

    def get_class_name(self, node, code):
        for child in node.children:
            if child.type == 'identifier':
                return extract_text_by_bytes(code, child.start_byte, child.end_byte)
        return None


    def get_extend_classes(self, node, code):
        extend_classes = []
        for child in node.children:
            if child.type == 'superclass':
                for subchild in child.children:
                    if subchild.type == 'type_identifier':
                        extend_classes.append(extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte))
            if child.type == 'extends_interfaces':
                for subchild in child.children:
                    if subchild.type == 'type_list':
                        for subsubchild in subchild.children:
                            if subsubchild.type == ',':
                                continue
                            extend_classes.append(extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte))
        return extend_classes


    def get_implement_classes(self, node, code):
        implement_classes = []
        for child in node.children:
            if child.type == 'super_interfaces':
                for subchild in child.children:
                    if subchild.type == 'type_list':
                        for subsubchild in subchild.children:
                            if subsubchild.type == ',':
                                continue
                            implement_classes.append(extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte))
        return implement_classes


    def get_class_modifiers(self, node, code):
        modifiers = []
        for child in node.children:
            if child.type == 'modifiers':
                for subchild in child.children:
                    modifiers.append(extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte))
        return modifiers


class Field:

    def get_field_name(self, node, code):
        for child in node.children:
            if child.type == 'variable_declarator':
                for subchild in child.children:
                    if subchild.type == 'identifier':
                        return extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte)
        return None

    def get_field_modifiers(self, node, code):
        modifiers = []
        for child in node.children:
            if child.type == 'modifiers':
                for subchild in child.children:
                    modifiers.append(extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte))
        return modifiers

    def get_field_types(self, node, code):
        types = []
        for child in node.children:
            if 'type' in child.type:
                types.append(extract_text_by_bytes(code, child.start_byte, child.end_byte))
        return types


class Method:

    def get_method_name(self, node, code):
        for child in node.children:
            if child.type == 'identifier':
                return extract_text_by_bytes(code, child.start_byte, child.end_byte)
        return None

    def get_method_modifiers(self, node, code):
        modifiers = []
        for child in node.children:
            if child.type == 'modifiers':
                for subchild in child.children:
                    modifiers.append(extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte))
        return modifiers

    def get_method_return_types(self, node, code):
        return_types = []
        for child in node.children:
            if 'type' in child.type:
                return_types.append(extract_text_by_bytes(code, child.start_byte, child.end_byte))
        return return_types

    def get_method_body_types(self, node, code):
        body_types = []

        def recurse(node):
            if node.type.endswith('_type') or 'type_identifier' in node.type and node.parent.type not in ['generic_type', 'array_type', 'type_arguments']:
                type_content = extract_text_by_bytes(code, node.start_byte, node.end_byte)
                if type_content not in body_types:
                    body_types.append(type_content)
            for child in node.children:
                recurse(child)

        recurse(node)
        return body_types

    def get_method_parameters(self, node, code):
        parameters = []
        for child in node.children:
            if child.type == 'formal_parameters':
                for subchild in child.children:
                    if subchild.type == 'formal_parameter':
                        parameter_details = {
                            'modifier': '',
                            'type': '',
                            'name': '',
                        }

                        for subsubchild in subchild.children:
                            if subsubchild.type == 'modifiers':
                                parameter_details['modifier'] = extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte)
                            if 'type' in subsubchild.type:
                                parameter_details['type'] = extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte)
                            if subsubchild.type == 'identifier':
                                parameter_details['name'] = extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte)

                        parameters.append(parameter_details)
        return parameters


def get_dir_files(dir_path):
    java_files = []
    for root, dirs, files in os.walk(dir_path):
        for file in files:
            if file.endswith('.java'):
                java_files.append(os.path.join(root, file))
    return java_files


def get_language_parser(language):
    if not os.path.exists('misc/parser/language.so'):
        lib_dir = 'misc/sitter-libs'
        libs = [os.path.join(lib_dir, d) for d in os.listdir(lib_dir)]

        Language.build_library(
            'misc/parser/language.so',
            libs,
        )

    LANGUAGE = Language('misc/parser/language.so', language)
    parser = Parser()
    parser.set_language(LANGUAGE)
    return parser


def extract_text_by_bytes(code, start_byte, end_byte, strip=True):
    """
    Extracts text from the code using byte offsets.
    """
    byte_sequence = code.encode('utf8')
    text = byte_sequence[start_byte:end_byte].decode('utf8')
    return text.strip() if strip else text


def process_method_declaration(subchild, code, schema, class_key):
    method_instance = Method()
    method_name = method_instance.get_method_name(subchild, code)
    assert method_name is not None

    method_modifiers = method_instance.get_method_modifiers(subchild, code)

    method_return_types = method_instance.get_method_return_types(subchild, code)

    method_parameters = method_instance.get_method_parameters(subchild, code)

    block = None
    for subsubchild in subchild.children:
        if subsubchild.type in ['block', 'constructor_body']:
            block = subsubchild
            break

    if block is None:
        method_body_types = []
    else:
        method_body_types = method_instance.get_method_body_types(block, code)

    signature = method_name + '(' + ', '.join([f"{x['modifier']} {x['type']} {x['name']}" for x in method_parameters]) + ')'

    method_start_line = subchild.start_point[0] + 1
    method_end_line = subchild.end_point[0] + 1
    method_key = f'{method_start_line}-{method_end_line}:{method_name}'

    schema['classes'][class_key]['methods'].setdefault(method_key, {})
    schema['classes'][class_key]['methods'][method_key] = {
        'start': method_start_line,
        'end': method_end_line,
        'body': extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte).split('\n'),
        'is_constructor': True if subchild.type == 'constructor_declaration' else False,
        'annotations': [x for x in method_modifiers if x.startswith('@')],
        'modifiers': [x for x in method_modifiers if not x.startswith('@') and not x.startswith('//')],
        'return_types': method_return_types,
        'body_types': method_body_types,
        'signature': signature,
        'parameters': method_parameters,
        'calls': [],
        'type_translations': {'return_types': {}, 'body_types': {}, 'parameters': {}, 'types': {}},
        'translation': [],
        'translation_status': 'pending',
        'syntactic_validation': 'pending',
        'cangjie_compilation': 'pending',
        'test_execution': 'pending',
        'elapsed_time': 0,
        'generation_timestamp': 0,
        'model_name': ''
    }

    default_init = {
        'identifier': '',
        'translated': False,
        'attempted': False,
        'type_variation': '',
        'timestamp': '',
        'source_type': '',
        'generation': '',
        'imports': '',
        'translated_target_type': '',
        'reasoning': '',
        'prompt': ''
    }

    for type_ in method_return_types:
        schema['classes'][class_key]['methods'][method_key]['type_translations']['return_types'].setdefault(type_, default_init)
    for type_ in method_body_types:
        schema['classes'][class_key]['methods'][method_key]['type_translations']['body_types'].setdefault(type_, default_init)
    for parameter in method_parameters:
        schema['classes'][class_key]['methods'][method_key]['type_translations']['parameters'].setdefault(f'{parameter["modifier"]}|{parameter["type"]}|{parameter["name"]}', default_init)


def process_enum_constant(subchild, code, schema, class_key):
    enum_constant_name = None
    enum_constant_args = None
    for subsubchild in subchild.children:
        if subsubchild.type == 'identifier':
            enum_constant_name = extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte)
        if subsubchild.type == 'argument_list':
            enum_constant_args = extract_text_by_bytes(code, subsubchild.start_byte, subsubchild.end_byte)
    assert enum_constant_name is not None

    enum_constant_start_line = subchild.start_point[0] + 1
    enum_constant_end_line = subchild.end_point[0] + 1
    enum_constant_key = f'{enum_constant_start_line}-{enum_constant_end_line}:{enum_constant_name}'

    schema['classes'][class_key]['fields'].setdefault(enum_constant_key, {})
    schema['classes'][class_key]['fields'][enum_constant_key] = {
        'start': enum_constant_start_line,
        'end': enum_constant_end_line,
        'enum_constant': True,
        'enum_constant_name': enum_constant_name,
        'enum_constant_args': enum_constant_args,
        'body': extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte).split('\n'),
        'modifiers': [],
        'types': [],
        'type_translations': {'return_types': {}, 'body_types': {}, 'parameters': {}, 'types': {}},
        'translation': [],
        'translation_status': 'pending',
        'syntactic_validation': 'pending',
        'cangjie_compilation': 'pending',
        'test_execution': 'pending',
        'elapsed_time': 0,
        'generation_timestamp': 0,
        'model_name': ''
    }


def process_field_declaration(subchild, code, schema, class_key):
    field_instance = Field()
    field_name = field_instance.get_field_name(subchild, code)
    assert field_name is not None

    field_modifiers = field_instance.get_field_modifiers(subchild, code)
    field_types = field_instance.get_field_types(subchild, code)

    field_start_line = subchild.start_point[0] + 1
    field_end_line = subchild.end_point[0] + 1
    field_key = f'{field_start_line}-{field_end_line}:{field_name}'

    schema['classes'][class_key]['fields'].setdefault(field_key, {})
    schema['classes'][class_key]['fields'][field_key] = {
        'start': field_start_line,
        'end': field_end_line,
        'enum_constant': False,
        'body': extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte).split('\n'),
        'modifiers': field_modifiers,
        'types': field_types,
        'type_translations': {'return_types': {}, 'body_types': {}, 'parameters': {}, 'types': {}},
        'translation': [],
        'translation_status': 'pending',
        'syntactic_validation': 'pending',
        'cangjie_compilation': 'pending',
        'test_execution': 'pending',
        'elapsed_time': 0,
        'generation_timestamp': 0,
        'model_name': ''
    }

    for type_ in field_types:
        schema['classes'][class_key]['fields'][field_key]['type_translations']['types'].setdefault(type_, {
            'identifier': '',
            'translated': False,
            'attempted': False,
            'type_variation': '',
            'timestamp': '',
            'source_type': '',
            'generation': '',
            'imports': '',
            'translated_target_type': '',
            'reasoning': '',
            'prompt': ''
        })


def process_static_initializer(subchild, code, schema, class_key):
    schema['classes'][class_key].setdefault('static_initializers', {})

    static_initializer_start_line = subchild.start_point[0] + 1
    static_initializer_end_line = subchild.end_point[0] + 1
    static_initializer_key = f'{static_initializer_start_line}-{static_initializer_end_line}:run_static_init'

    schema['classes'][class_key]['static_initializers'][static_initializer_key] = {
        'start': static_initializer_start_line,
        'end': static_initializer_end_line,
        'body': extract_text_by_bytes(code, subchild.start_byte, subchild.end_byte).split('\n'),
        'type_translations': {},
        'translation': [],
        'translation_status': 'pending',
        'syntactic_validation': 'pending',
        'cangjie_compilation': 'pending',
        'test_execution': 'pending',
        'elapsed_time': 0,
        'generation_timestamp': 0,
        'model_name': ''
    }


def decompose(node, code, file):
    schema = {
        'path': file,
        'imports': {},
        'classes': {},
        'cangjie_skeleton_path': '',
        'cangjie_translations_skeleton_path': ''
    }

    def decompose_node(node):
        if node.type == 'import_declaration':
            import_body = extract_text_by_bytes(code, node.start_byte, node.end_byte)
            import_start_line = node.start_point[0] + 1
            import_end_line = node.end_point[0] + 1
            import_key = f'{import_start_line}-{import_end_line}:{import_body}'

            schema['imports'].setdefault(import_key, {})
            schema['imports'][import_key] = {
                'start': import_start_line,
                'end': import_end_line,
                'body': import_body
            }
            if 'import_map' not in schema:
                schema['import_map'] = {}
            if import_body.startswith("import "):
                fqcn = import_body[len("import "):].rstrip(";")
                short_name = fqcn.split(".")[-1]
                schema['import_map'][short_name] = fqcn

        elif node.type in ['class_declaration', 'interface_declaration', 'enum_declaration']:

            class_instance = Class()
            class_name = class_instance.get_class_name(node, code)
            assert class_name is not None

            extend_classes = class_instance.get_extend_classes(node, code)

            implement_classes = class_instance.get_implement_classes(node, code)

            resolved_extends = []
            for cls in extend_classes:
                if cls in schema.get('import_map', {}):
                    resolved_extends.append(schema['import_map'][cls])
                else:
                    resolved_extends.append(cls)
            modifiers = class_instance.get_class_modifiers(node, code)

            class_start_line = node.start_point[0] + 1
            class_end_line = node.end_point[0] + 1
            class_key = f'{class_start_line}-{class_end_line}:{class_name}'

            schema['classes'].setdefault(class_key, {})
            schema['classes'][class_key] = {
                'start': class_start_line,
                'end': class_end_line,
                'is_abstract': 'abstract' in modifiers,
                'is_interface': node.type == 'interface_declaration',
                'is_enum': node.type == 'enum_declaration',
                'modifiers': modifiers,
                'nested_inside': '',
                'nests': [],
                'implements': implement_classes,
                'extends': resolved_extends,
                'methods': {},
                'fields': {}
            }

            for child in node.children:
                if child.type in ['class_body', 'interface_body', 'enum_body']:
                    for subchild in child.children:

                        if subchild.type == 'enum_constant':
                            process_enum_constant(subchild, code, schema, class_key)

                        elif subchild.type == 'field_declaration':
                            process_field_declaration(subchild, code, schema, class_key)

                        elif subchild.type in ['method_declaration', 'constructor_declaration']:
                            process_method_declaration(subchild, code, schema, class_key)

                        elif subchild.type == 'static_initializer':
                            process_static_initializer(subchild, code, schema, class_key)

                        elif subchild.type == 'enum_body_declarations':
                            for subsubchild in subchild.children:
                                if subsubchild.type == 'field_declaration':
                                    process_field_declaration(subsubchild, code, schema, class_key)

                                elif subsubchild.type in ['method_declaration', 'constructor_declaration']:
                                    process_method_declaration(subsubchild, code, schema, class_key)

        for child in node.children:
            decompose_node(child)

    decompose_node(node)

    return schema


def create_schema(args):

    args.schemas_dir = f'data/java/schemas{args.suffix}/{args.model_name}/{args.temperature}/{args.project_name}'
    os.makedirs(args.schemas_dir, exist_ok=True)

    java_files = get_dir_files(f'projects/java/cleaned_final_projects{args.suffix}/{args.project_name}')
    parser = get_language_parser('java')

    progress_bar = tqdm.tqdm(total=len(java_files), desc='Creating schemas')
    for file in java_files:
        progress_bar.update(1)

        content = ''
        with open(file, 'r') as f:
            content = f.read()

        tree = parser.parse(bytes(content, "utf8"))

        schema = decompose(tree.root_node, content, file)

        class_ranges = {class_name: (start_line, end_line) for class_name, class_details in schema['classes'].items() for start_line, end_line in [(class_details['start'], class_details['end'])]}
        for class_name, class_details in schema['classes'].items():
            for other_class_name, other in schema['classes'].items():
                if class_name != other_class_name:
                    if class_ranges[class_name][0] > class_ranges[other_class_name][0] and class_ranges[class_name][1] < class_ranges[other_class_name][1]:
                        schema['classes'][class_name]['nested_inside'] = other_class_name
                        schema['classes'][other_class_name]['nests'].append(class_name)

        schema_name = file[file.find(args.project_name):].replace('/', '.').replace('.java', '')
        with open(f'{args.schemas_dir}/{schema_name}.json', 'w') as f:
            json.dump(schema, f, indent=4)

    call_graph = []
    with open(f'data/java/call_graphs/{args.project_name}/callgraph.txt') as f:
        call_graph = [x.strip() for x in f.readlines() if x.strip().startswith('M:')]

    progress_bar = tqdm.tqdm(total=len(call_graph), desc='Updating call graph')
    for call in call_graph:
        progress_bar.update(1)
        caller, callee = call.split(' ')
        caller = caller[2:]
        callee = callee[3:]

        caller_schema_name, caller_signature = caller.split(':')[0], caller.split(':')[1]
        callee_schema_name, callee_signature = callee.split(':')[0], callee.split(':')[1]

        caller_class_name = caller_schema_name.split('.')[-1]
        callee_class_name = callee_schema_name.split('.')[-1]

        caller_method_name = caller_signature.split('(')[0]
        callee_method_name = callee_signature.split('(')[0]

        if '$' in caller_class_name:
            caller_class_name = caller_class_name.split('$')[-1]
            caller_schema_name = caller_schema_name.split('$')[0]

        if '$' in callee_class_name:
            callee_class_name = callee_class_name.split('$')[-1]
            callee_schema_name = callee_schema_name.split('$')[0]

        if caller_method_name == '<init>':
            caller_method_name = caller_class_name
        if callee_method_name == '<init>':
            callee_method_name = callee_class_name

        caller_schema_file = get_schema_file(args.project_name, caller_schema_name, args)
        callee_schema_file = get_schema_file(args.project_name, callee_schema_name, args)

        if caller_schema_file is False:
            continue

        callee_fragment = []
        if callee_schema_file is False:
            callee_fragment = [
                'library',
                callee_schema_name,
                callee_signature
            ]
        else:
            callee_schema = {}
            with open(callee_schema_file, 'r') as f:
                callee_schema = json.load(f)

            for class_ in callee_schema['classes']:
                if callee_class_name == class_.split(':')[1]:
                    for method in callee_schema['classes'][class_]['methods']:
                        if callee_method_name == method.split(':')[1]:
                            callee_fragment = [
                                callee_schema_file.split('/')[-1].replace('.json', ''),
                                class_,
                                method
                            ]
                            break

            if callee_fragment == []:
                super_class_name = []
                for class_ in callee_schema['classes']:
                    if callee_class_name == class_.split(':')[1]:
                        super_class_name += callee_schema['classes'][class_]['extends']
                        super_class_name += callee_schema['classes'][class_]['implements']
                        if callee_schema['classes'][class_]['nested_inside'] != '':
                            super_class_name += [callee_schema['classes'][class_]['nested_inside'].split(':')[1]]
                        break

                if super_class_name != []:

                    for schema_fname in os.listdir(args.schemas_dir):
                        potential_super_class_schema = {}
                        with open(f'{args.schemas_dir}/{schema_fname}', 'r') as f:
                            potential_super_class_schema = json.load(f)

                        for super_class in super_class_name:

                            for class_ in potential_super_class_schema['classes']:
                                if super_class == class_.split(':')[1]:
                                    for method in potential_super_class_schema['classes'][class_]['methods']:
                                        if callee_method_name == method.split(':')[1]:
                                            callee_fragment = [
                                                schema_fname.replace('.json', ''),
                                                class_,
                                                method
                                            ]
                                            break

        if callee_fragment == []:
            continue

        caller_schema = {}
        with open(caller_schema_file, 'r') as f:
            caller_schema = json.load(f)

        for class_ in caller_schema['classes']:
            if caller_class_name == class_.split(':')[1]:
                for method in caller_schema['classes'][class_]['methods']:
                    if caller_method_name == method.split(':')[1] and callee_fragment not in caller_schema['classes'][class_]['methods'][method]['calls']:
                        caller_schema['classes'][class_]['methods'][method]['calls'].append(callee_fragment)
                        break

        with open(caller_schema_file, 'w') as f:
            json.dump(caller_schema, f, indent=4)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create schema for the project')
    parser.add_argument('--project_name', type=str, help='Name of the project')
    parser.add_argument('--model_name', type=str, help='Name of the model')
    parser.add_argument('--temperature', type=float, help='Temperature of the model')
    parser.add_argument('--suffix', type=str, help='suffix')
    args = parser.parse_args()
    create_schema(args)
