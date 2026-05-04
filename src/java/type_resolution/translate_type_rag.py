import argparse
import json
import os
import re
import yaml
import subprocess
import tempfile
from datetime import datetime
from src.java.model.model import Model
from jinja2 import Template

from src.java.rag import get_rag_engine


class TypePromptGenerator:
    def __init__(self, context_code_snippet, fragment_type, source_type, source_type_description, type_variation, prompt_type, source_language, target_language, feedback):
        self.context_code_snippet = context_code_snippet
        self.fragment_type = fragment_type
        self.source_type = source_type if type_variation in ['FIELD TYPE', 'RETURN TYPE', 'METHOD BODY TYPE'] else source_type['type']
        self.source_type_description = source_type_description
        self.type_variation = type_variation
        self.prompt_type = prompt_type
        self.source_language = source_language
        self.target_language = target_language
        self.feedback = feedback
        self.prompt = ''

        self.prompt_template_config = yaml.safe_load(open('configs/prompt_templates.yaml', 'r'))

    def generate_prompt(self):
        self.prompt += self.add_instance_prompt()
        self.prompt += '\n\n'
        if self.feedback != '':
            self.prompt += self.add_feedback_prompt()
            self.prompt += '\n\n'
        self.prompt += self.add_response_format_prompt()
        return self.prompt

    def add_instance_prompt(self):
        template = Template(self.prompt_template_config['templates'][f'type_resolution_{self.prompt_type}_instance'])
        return template.render(**self.__dict__)

    def add_feedback_prompt(self):
        template = Template(self.prompt_template_config['templates'][f'type_resolution_{self.prompt_type}_feedback'])
        return template.render(**self.__dict__)

    def add_response_format_prompt(self):
        template = Template(self.prompt_template_config['templates'][f'type_resolution_{self.prompt_type}_response_format'])
        return template.render(**self.__dict__)


class Interaction:
    def __init__(self, role, content):
        self.role = role
        self.content = content


class Result:
    def __init__(self):
        self.identifier = ''
        self.translated = False
        self.attempted = False
        self.type_variation = ''
        self.timestamp = ''
        self.source_type = ''
        self.generation = ''
        self.imports = ''
        self.translated_target_type = ''
        self.reasoning = ''
        self.prompt = ''


class Parser:
    def extract_imports(self, text):
        pattern = re.search(r'CANGJIE IMPORTS:\s*```(?:cangjie)?\s*(.*?)\s*```', text, re.DOTALL)
        return pattern.group(1).strip() if pattern else None

    def extract_translation(self, text):
        pattern = re.search(r'CANGJIE TRANSLATION:\s*```(?:cangjie)?\s*(.*?)\s*```', text, re.DOTALL)
        return pattern.group(1).strip() if pattern else None

    def extract_reasoning(self, text):
        pattern = re.search(r'REASONING:\s*(.*?)(?=\n\n|$)', text, re.DOTALL)
        return pattern.group(1).strip() if pattern else None

    def parse_response(self, generation):
        imports = self.extract_imports(generation)
        translation = self.extract_translation(generation)
        reasoning = self.extract_reasoning(generation)
        return imports, translation, reasoning


def get_source_type_description(source_type):
    source_type = source_type.strip()
    if '[' in source_type:
        source_type = source_type.split('[')[0]
    if '<' in source_type:
        source_type = source_type.split('<')[0]
    type_documentation = {}
    with open('data/java/crawl/java.base_module_doc.json') as f:
        type_documentation = json.load(f)

    for module_name in type_documentation:
        for package_name in type_documentation[module_name]:
            for class_name in type_documentation[module_name][package_name]:
                if source_type in type_documentation[module_name][package_name][class_name]:
                    if 'description' in type_documentation[module_name][package_name][class_name][source_type]:
                        return type_documentation[module_name][package_name][class_name][source_type]['description']
                    return ''

    return ''


def append_result(data, class_, fragment_type, fragment, type_variation, type_, result):
    type_identifier = type_ if type_variation in ['types', 'return_types', 'body_types'] else f'{type_["modifier"]}|{type_["type"]}|{type_["name"]}'
    data['classes'][class_][f'{fragment_type}s'][fragment]['type_translations'][type_variation][type_identifier] = result.__dict__
    return data

def save_results(data, schema_dir, schema_file):
    with open(f'{schema_dir}/{schema_file}', 'w') as f:
        json.dump(data, f, indent=4)


def update_universal_type_map(source_type, translated_type, map_file='data/java/type_resolution/universal_type_map_final.json'):
    """
    Update the universal type map with successful translations.
    If a source type is already recorded, do not overwrite it.

    Args:
        source_type (str): Original Java type
        translated_type (str): Translated Cangjie type
        map_file (str): Path to the universal type map JSON file
    """
    # Load existing map
    type_map = {}
    if os.path.exists(map_file):
        try:
            with open(map_file, 'r') as f:
                type_map = json.load(f)
        except (json.JSONDecodeError, IOError):
            type_map = {}

    # Only add if not already recorded
    if source_type not in type_map:
        type_map[source_type] = translated_type
        # Ensure directory exists
        os.makedirs(os.path.dirname(map_file), exist_ok=True)
        # Save updated map
        with open(map_file, 'w') as f:
            json.dump(type_map, f, indent=4)


def get_custom_types(schema_dir):
    """
    Extract custom types from schema files.
    Custom types are classes defined in the project itself (not external libraries).

    Args:
        schema_dir (str): Directory containing schema JSON files

    Returns:
        list: List of custom type names
    """
    custom_types = []
    for schema_file in os.listdir(schema_dir):
        data = {}
        with open(f'{schema_dir}/{schema_file}', 'r') as f:
            data = json.load(f)

        for class_ in data['classes']:
            # Format is "{start}-{end}:{classname}"
            class_name = class_.split(':')[1]
            custom_types.append(class_name)

            # Handle nested classes
            if data['classes'][class_].get('nested_inside', ''):
                nested_info = data['classes'][class_]['nested_inside']
                outer_class = nested_info.split(':')[1]
                custom_types.append(f'{outer_class}.{class_name}')

    return custom_types


def is_type_loadable(import_stmt, type_name, custom_classes=None):
    """
    Validates if a type can be loaded or used in the Cangjie type system
    by attempting to compile a test program using cjc.

    Args:
        import_stmt (str): The import statement needed to access the type, or empty if built-in
        type_name (str): The name of the type to validate
        custom_classes (list, optional): List of custom class names to treat as valid types

    Returns:
        tuple: (bool, str) indicating if the type can be loaded and an error message if applicable
    """
    if isinstance(type_name, str):
        if "#" in type_name:
            return False, 'invalid type name'

    type_name = type_name.strip() if type_name else ''
    import_stmt = import_stmt.strip() if import_stmt else ''
    custom_classes = custom_classes or []

    if import_stmt == '' and type_name == '':
        return False, 'no type translation has been provided'

    # Generate Cangjie test program - simplified validation
    cangjie_program = f"""package test

{import_stmt}

main(): Int64 {{
    let _test_val: {type_name}
    0
}}
"""

    with tempfile.NamedTemporaryFile(mode='w', suffix='.cj', delete=False, dir='/tmp') as f:
        f.write(cangjie_program)
        temp_file = f.name

    try:
        # Compile check using cjc
        result = subprocess.run(
            ["cjc", temp_file],
            capture_output=True,
            timeout=60,
        )

        if result.returncode != 0:
            error_output = result.stdout.decode('utf-8') if result.stdout else result.stderr.decode('utf-8') if result.stderr else "Unknown error"
            return False, f'Cangjie compilation error: {error_output}'

        return True, ''

    except subprocess.CalledProcessError as e:
        error_output = e.stdout.decode('utf-8') if e.stdout else e.stderr.decode('utf-8') if e.stderr else "Unknown error"
        return False, f'Cangjie compilation error: {error_output}'

    except FileNotFoundError:
        return False, 'cjc compiler not found - please ensure Cangjie SDK is installed'

    except subprocess.TimeoutExpired:
        return False, 'Cangjie compilation timed out'

    finally:
        if os.path.exists(temp_file):
            os.remove(temp_file)


def main(args):

    # Java to Cangjie primitive type mappings
    JAVA_TO_CANGJIE_PRIMITIVES = {
        # Integers
        'int': 'Int64',
        'Integer': 'Int64',
        'java.lang.Integer': 'Int64',
        'long': 'Int64',
        'java.lang.Long': 'Int64',
        'Long': 'Int64',
        'short': 'Int64',
        'java.lang.Short': 'Int64',
        'Short': 'Int64',
        'byte': 'Int64',
        'Byte': 'Int64',
        'java.lang.Byte': 'Int64',

        # Floating point
        'float': 'Float64',
        'java.lang.Float': 'Float64',
        'Float': 'Float64',
        'double': 'Float64',
        'Double': 'Float64',
        'java.lang.Double': 'Float64',

        # Boolean
        'boolean': 'Bool',
        'Boolean': 'Bool',
        'java.lang.Boolean': 'Bool',

        # Character / String
        'char': 'Rune',
        'java.lang.Character': 'Rune',
        'java.lang.String': 'String',
        'Character': 'Rune',
        'String': 'String',

        # Void
        'void': 'Void',
        'Void': 'Void',
        'java.lang.Void': 'Void',

        # Collections
        'List<T>': 'Array<T>',
        'ArrayList<T>': 'Array<T>',
        'Map<K, V>': 'HashMap<K, V>',
        'HashMap<K, V>': 'HashMap<K, V>',
        'Set<T>': 'HashSet<T>',
        'HashSet<T>': 'HashSet<T>',
        'Collection<T>': 'Array<T>',
        'Iterable<T>': 'Iterator<T>',
        'Iterator<T>': 'Iterator<T>',

        # Optional
        'Optional<T>': '?T',
        'OptionalInt': '?Int64',
        'OptionalLong': '?Int64',
        'OptionalDouble': '?Float64',

        # Common types
        'Object': 'Any',
        'java.lang.Object': 'Any',
        'Class<T>': 'Type',
        'java.lang.Class': 'Type',
        'Comparable<T>': 'Comparable<T>',
        'Runnable': '() -> Void',
        'Callable<T>': '() -> T',
        'Exception': 'Exception',
        'RuntimeException': 'RuntimeException',
        'IllegalArgumentException': 'IllegalArgumentException',
        'NullPointerException': 'NullPointerException',
    }

    model_info = yaml.safe_load(open('configs/model_configs.yaml', 'r'))['models']
    args.schema_dir = f'data/java/schemas{args.suffix}/{args.model_name}/{args.temperature}/{args.project_name}'
    model = Model(model_info=model_info[args.model_name])

    # Get custom types from schema files (project-defined classes)
    custom_types = get_custom_types(args.schema_dir)

    for schema_file in os.listdir(args.schema_dir):

        data = {}
        with open(f'{args.schema_dir}/{schema_file}', 'r') as f:
            data = json.load(f)

        for class_ in data['classes']:
            for fragment_type in ['field', 'method']:
                for fragment in data['classes'][class_][f'{fragment_type}s']:
                    fragment_body = '\n'.join(data['classes'][class_][f'{fragment_type}s'][fragment]['body'])
                    fragment_body = '    ' + fragment_body
                    type_variations = {'types': 'FIELD TYPE', 'return_types': 'RETURN TYPE', 'parameters': 'PARAMETER TYPE', 'body_types': 'METHOD BODY TYPE'}

                    for type_variation in type_variations:

                        if fragment_type == 'field' and type_variation != 'types':
                            continue
                        elif fragment_type == 'method' and type_variation == 'types':
                            continue

                        interaction_history = []
                        feedback = ''
                        budget = args.budget
                        i = 0
                        while i < len(data['classes'][class_][f'{fragment_type}s'][fragment][type_variation]):

                            type_ = data['classes'][class_][f'{fragment_type}s'][fragment][type_variation][i]
                            type_identifier = type_ if type_variation in ['types', 'return_types', 'body_types'] else f'{type_["modifier"]}|{type_["type"]}|{type_["name"]}'

                            if data['classes'][class_][f'{fragment_type}s'][fragment]['type_translations'][type_variation][type_identifier]['translated']:
                                i += 1
                                interaction_history = []
                                feedback = ''
                                budget = args.budget
                                continue

                            if budget == 0:
                                i += 1
                                interaction_history = []
                                feedback = ''
                                budget = args.budget
                                continue

                            if interaction_history == []:
                                initial_interaction = Interaction(role='system', content='You are a helpful assistant.')
                                interaction_history.append(initial_interaction)

                            source_type = type_ if type_variation in ['types', 'return_types', 'body_types'] else type_["type"]

                            result = Result()
                            result.attempted = True
                            result.identifier = type_identifier
                            result.translated = False
                            result.type_variation = type_variation
                            result.timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                            result.source_type = source_type

                            # Check if it's a known primitive or custom type
                            if source_type in custom_types or source_type in JAVA_TO_CANGJIE_PRIMITIVES:
                                result.translated = True
                                if source_type in JAVA_TO_CANGJIE_PRIMITIVES:
                                    result.translated_target_type = JAVA_TO_CANGJIE_PRIMITIVES.get(source_type)
                                else:
                                    result.translated_target_type = source_type
                                # Record successful translation
                                update_universal_type_map(source_type, result.translated_target_type)
                                append_result(data, class_, fragment_type, fragment, type_variation, type_, result)
                                i += 1
                                interaction_history = []
                                feedback = ''
                                budget = args.budget

                                save_results(data, args.schema_dir, schema_file)

                                if args.debug:
                                    if source_type in JAVA_TO_CANGJIE_PRIMITIVES:
                                        message = 'PRIMITIVE TYPE DETECTED'
                                    else:
                                        message = 'CUSTOM TYPE DETECTED'
                                    print('=' * 50 + message + '=' * 50, flush=True)
                                    print(source_type, flush=True)

                                continue

                            source_type_description = get_source_type_description(source_type)

                            # RAG context injection for type resolution
                            rag_context = ""
                            if hasattr(args, 'use_rag') and args.use_rag:
                                try:
                                    rag_engine = get_rag_engine()
                                    rag_ctx = rag_engine.inject_type_context(source_type)
                                    if rag_ctx:
                                        rag_context = rag_ctx
                                except Exception as e:
                                    print(f"[RAG] Warning: Type RAG injection failed: {e}")

                            prompt_generator = TypePromptGenerator(
                                fragment_body,
                                fragment_type,
                                type_,
                                source_type_description,
                                type_variations[type_variation],
                                args.prompt_type,
                                args.source_language,
                                args.target_language,
                                feedback
                            )
                            prompt = prompt_generator.generate_prompt()
                            if rag_context:
                                prompt = rag_context + "\n\n" + prompt

                            interaction = Interaction(role='user', content=prompt)
                            interaction_history.append(interaction)

                            if args.debug:
                                print('=' * 50 + 'PROMPT' + '=' * 50, flush=True)
                                print(prompt, flush=True)

                            messages = model.get_messages(interaction_history)
                            status, generation = model.prompt_model(messages)

                            result.generation = generation
                            result.prompt = prompt
                            append_result(data, class_, fragment_type, fragment, type_variation, type_, result)
                            save_results(data, args.schema_dir, schema_file)

                            if not status:
                                i += 1
                                interaction_history = []
                                feedback = ''
                                budget = args.budget
                                continue

                            interaction = Interaction(role='system', content=generation)
                            interaction_history.append(interaction)

                            if args.debug:
                                print('=' * 50 + 'GENERATION' + '=' * 50, flush=True)
                                print(generation, flush=True)

                            try:
                                imports, translation, reasoning = Parser().parse_response(generation)
                            except BaseException:
                                feedback = 'Your response did not follow the RESPONSE FORMAT guidelines. Make sure you follow the RESPONSE FORMAT in your new response.'
                                budget -= 1
                                continue

                            if imports is None and translation is None and reasoning is None:
                                feedback = 'Your response did not follow the RESPONSE FORMAT guidelines. Make sure you follow the RESPONSE FORMAT in your new response.'
                                budget -= 1
                                continue

                            if isinstance(translation, str):
                                if "#" in translation:
                                    translation = translation.split('#', 1)[0].strip()

                            # Validate type using Cangjie compilation
                            validation_result, feedback = is_type_loadable(imports or '', translation, custom_classes=custom_types)
                            if not validation_result:
                                budget -= 1
                                continue

                            # Type validation passes
                            result.translated = True
                            result.imports = imports
                            result.translated_target_type = translation
                            result.reasoning = reasoning

                            # Record successful translation
                            update_universal_type_map(source_type, translation)

                            if args.debug:
                                print('=' * 50 + 'IMPORTS' + '=' * 50, flush=True)
                                print(imports, flush=True)
                                print('=' * 50 + 'TRANSLATION' + '=' * 50, flush=True)
                                print(translation, flush=True)
                                print('=' * 50 + 'REASONING' + '=' * 50, flush=True)
                                print(reasoning, flush=True)

                            append_result(data, class_, fragment_type, fragment, type_variation, type_, result)
                            i += 1
                            interaction_history = []
                            feedback = ''
                            budget = args.budget

                            save_results(data, args.schema_dir, schema_file)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Translate java types to cangjie types')
    parser.add_argument('--project_name', type=str, dest='project_name', help='project name')
    parser.add_argument('--model_name', type=str, dest='model_name', help='model name to use for translation')
    parser.add_argument('--temperature', type=float, dest='temperature', help='temperature for generation')
    parser.add_argument('--suffix', type=str, dest='suffix', help='suffix for schema files')
    parser.add_argument('--debug', action='store_true', dest='debug', help='debug mode')
    parser.add_argument('--prompt_type', type=str, dest='prompt_type', help='prompt type')
    parser.add_argument('--source_language', type=str, dest='source_language', help='source language')
    parser.add_argument('--target_language', type=str, dest='target_language', help='target language')
    parser.add_argument('--budget', type=int, dest='budget', help='budget for each type translation')
    parser.add_argument('--use_rag', action='store_true', default=False, help='Enable RAG context injection for type resolution')
    args = parser.parse_args()
    main(args)
