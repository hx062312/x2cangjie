import json
import os

from src.java.rag import get_rag_engine


def find_class_key(classes_dict, class_name):
    """Find a class key that matches the given class_name pattern.

    Handles both full keys (e.g., '4-26:BaseClass') and simple names (e.g., 'BaseClass').
    """
    for key in classes_dict:
        if key == class_name or key.endswith(f":{class_name}"):
            return key
    return None


def find_method_key(methods_dict, method_name):
    """Find a method key that matches the given method_name pattern.

    Handles both full keys (e.g., '11-13:methodName') and simple names (e.g., 'methodName').
    """
    for key in methods_dict:
        if key == method_name or key.endswith(f":{method_name}"):
            return key
    return None


def extract_actual_name(fragment_name: str) -> str:
    """Extract actual name from fragment/class name with line prefix like '4-38:BaseClass' -> 'BaseClass'"""
    if ":" in fragment_name:
        return fragment_name.split(":")[-1]
    return fragment_name


class PromptGenerator:

    def __init__(
        self, is_feedback, args, fragment_details, feedback="", use_icl_pool=False
    ):
        self.is_feedback = is_feedback
        self.args = args
        self.prompt = ""
        self.feedback = feedback
        self.prompt_status = "success"
        self.use_icl_pool = use_icl_pool
        self.rag_context: str = ""
        self.fragment_details = fragment_details
        self.signature = None

        self.meta_data = {
            "deepseek-coder-33b-instruct-persona": "You are an AI programming assistant, utilizing the DeepSeek Coder model, developed by DeepSeek Company, and you only answer questions related to computer science. For politically sensitive questions, security and privacy issues, and other non-computer science questions, you will refuse to answer.",
            "deepseek-chat-persona": "",
            "gpt-4o-2024-11-20-persona": "",
            "llama-3-3-70b-instruct-persona": "",
            "Qwen2.5-Coder-32B-Instruct-persona": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant.",
            "cangjie-persona": """You are a Java to Cangjie code translation expert.
Cangjie language features:
- Static type system (let x: Int = 10)
- Object-oriented (class, interface, inheritance)
- Functional programming (lambda, higher-order functions, pattern matching)
- Coroutine support (async/await)
- Type inference (automatic type inference)
- Null safety (?, !)

Java to Cangjie common mappings:
- List<T> -> Array<T>
- Map<K,V> -> HashMap<K,V>
- public/private/protected -> pub/priv/protected
- System.out.println -> println()
- null -> None
- try-catch -> try-catch (similar)
- instanceof -> match (pattern matching)
- Generics <T> -> <T>

IMPORTANT: Cangjie HashMap/HashSet key and element types MUST satisfy Hashable & Equatable.
The top type Any does NOT satisfy these constraints. Therefore:
- HashMap<Object, V> -> HashMap<AnyHashable, V>  (NOT HashMap<Any, V>)
- HashSet<Object> -> HashSet<AnyHashable>         (NOT HashSet<Any>)
- Use AnyHashable (from import <project>.runtime.AnyHashable) whenever Any would
  appear as a HashMap key or HashSet element type.
- To create an AnyHashable from a value: AnyHashable(value) or AnyHashable.of<T>(value)
- To extract the original value: anyHashableValue.unwrap()

Notes:
1. Keep the original Java code logic unchanged
2. Use Cangjie idiomatic syntax
3. Add appropriate type annotations
4. Handle Java and Cangjie differences""",
            "translation_notes": {
                "field": "Java field translation pattern:\nJava: public int x;\nCangjie: var x: Int64 = 0\n",
                "method": "Java method translation pattern:\nJava: public int add(int a, int b) { return a + b; }\nCangjie: public func add(a: Int64, b: Int64): Int64 { return a + b }\n",
                "static_initializer": "Java static initializer pattern:\nJava: static { count = 10; }\nCangjie: static init() { count = 10 }\n",
            },
        }

        self.assert_map = json.load(open("data/java/type_resolution/assert_map.json", "r"))

        self.load_fragment(fragment_details)
        self.construct_adaptive_icl()

        # RAG context injection
        if getattr(self.args, 'use_rag', 'false') == 'true':
            try:
                rag = get_rag_engine()
                context = rag.inject_fragment_context(self.source_fragment_body)
                if context:
                    self.rag_context = context
            except Exception as e:
                print(f"[RAG] Warning: Fragment RAG injection failed: {e}")

        self.build_base_prompt()

    def build_base_prompt(self):
        self.prompt += self.meta_data[f"{self.args.model}-persona"]
        self.double_line_break()

        # instruction first — LLM sees the task immediately
        self.add_instruction()
        self.double_line_break()

        # then Java source code
        self.add_source_code()
        self.double_line_break()

        # then partial Cangjie translation (skeleton with dependencies)
        self.add_partial_translation()
        self.double_line_break()

        # RAG documentation after the task context, not before
        if self.rag_context:
            self.prompt += "### Reference Cangjie documentation:\n"
            self.prompt += self.rag_context
            self.double_line_break()

        # ICL examples after everything else
        if self.adaptive_icl:
            self.prompt += self.adaptive_icl
            self.double_line_break()

        # error feedback at the end (only in feedback loop)
        if self.is_feedback:
            self.add_incorrect_translation()
            self.double_line_break()
            self.add_feedback()
            self.double_line_break()

        self.add_target_translation()

    def construct_adaptive_icl(self):
        used_assertions = []
        for source_assert in self.assert_map:
            if source_assert in self.source_fragment_body:
                used_assertions.append(source_assert)

        source_statements = ""
        target_statements = ""
        for source_assert in self.assert_map:
            if source_assert not in used_assertions:
                continue
            for i in range(2):
                source_statements += (
                    self.assert_map[source_assert][i]["java"] + ";\n        "
                )
                target_statements += (
                    self.assert_map[source_assert][i]["cangjie"] + "\n        "
                )

        if self.is_feedback:
            if used_assertions:
                test_icl = (
                    'Java code:\n```\npublic class TestClass {\n    @Test\n    public void testMethod(self) {\n        List<String> inputList = Arrays.asList("apple", "banana", "cherry");\n        assertEquals("inputList size does not match expected size = 3", 3, inputList.size());\n    '
                    + '}\n}\n```\n\nIncorrect Cangjie translation:\n```\nclass TestClass {\n    public func testMethod(): Void {\n        let inputList: Array<String> = ["apple", "banana", "cherry"]\n        @Test.assertEquals("inputList size does not match expected size = 3", 3, inputList.size())\n    }\n```\n\nExecution feedback:\n```\nerror: argument count mismatch\n```\n\nPartial Cangjie translation:\n```\nclass TestClass {\n    public func testMethod(): Void {\n        // TODO: implement\n    }\n}\n```\n\nCangjie method translation:\n```\n    public func testMethod(): Void {\n        let inputList: Array<String> = ["apple", "banana", "cherry"]\n        @Test.assertEquals(3, inputList.size(), "inputList size does not match expected size = 3")\n    }\n```'
                )
                test_icl = test_icl.replace("self.pytest.", "pytest.")
            else:
                test_icl = self.meta_data["translation_notes"][self.fragment_type]
        else:
            if used_assertions:
                test_icl = (
                    "Java code:\n```\npublic class TestClass {\n    @Test\n    public void testMethod(self) {\n        "
                    + source_statements.rstrip()
                    + "\n    "
                    + "}\n}\n```\n\nPartial Cangjie translation:\n```\nclass TestClass {\n    public func testMethod(): Void {\n        // TODO: implement\n    }\n}\n```\n\nCangjie method translation:\n```\n    public func testMethod(): Void {\n        "
                    + target_statements.rstrip()
                    + "\n```\n"
                )
                test_icl = test_icl.replace("self.pytest.", "pytest.")
            else:
                self.adaptive_icl = self.meta_data["translation_notes"].get(
                    self.fragment_type, ""
                )
                return  # Early return since we set adaptive_icl directly

        if self.is_feedback:
            if used_assertions:
                self.adaptive_icl = test_icl
            else:
                self.adaptive_icl = self.meta_data["translation_notes"].get(
                    self.fragment_type, ""
                )
        else:
            if used_assertions:
                self.adaptive_icl = test_icl
            else:
                self.adaptive_icl = self.meta_data["translation_notes"].get(
                    self.fragment_type, ""
                )

    def load_fragment(self, fragment_details):
        self.schema_name = fragment_details["schema_name"]
        self.class_name = fragment_details["class_name"]
        self.fragment_name = fragment_details["fragment_name"]

        self.class_actual_name = extract_actual_name(self.class_name)
        self.fragment_actual_name = extract_actual_name(self.fragment_name)
        self.fragment_type = fragment_details["fragment_type"]
        self.is_test_method = fragment_details["is_test_method"]

        self.schema_data = {}
        with open(
            f"{self.args.translation_dir}/{self.schema_name}.json", "r"
        ) as f:
            self.schema_data = json.load(f)

        class_key = find_class_key(self.schema_data["classes"], self.class_name)
        if class_key:
            self.fragment_dict = self.schema_data["classes"][class_key].get(
                f"{self.fragment_type}s", {}
            ).get(self.fragment_name, {})
            self.class_dict = self.schema_data["classes"][class_key]
        else:
            self.fragment_dict = {}
            self.class_dict = {"fields": {}, "methods": {}, "nests": [], "nested_inside": [], "extends": [], "cangjie_class_declaration": f"class {self.class_name} {{\n"}

        if "partial_translation" not in self.fragment_dict:
            self.fragment_dict["partial_translation"] = []


        self.source_fragment_body = (
            "\n".join(
                [
                    f"    @{x}"
                    for x in self.class_dict["methods"][
                        self.fragment_name
                    ]["annotations"]
                    if x.startswith("Test")
                ]
            )
            + "\n"
            if self.fragment_type == "method"
            else ""
        )
        if "body" in self.fragment_dict:
            self.source_fragment_body += "".join(self.fragment_dict["body"])

        self.source_class_dependent_fields = ""
        for field in self.class_dict["fields"]:
            if field == self.fragment_name:
                continue
            if field.split(":")[1] in self.source_fragment_body:
                self.source_class_dependent_fields += "".join(
                    self.class_dict["fields"][field][
                        "body"
                    ]
                )
                self.source_class_dependent_fields += "\n"

        self.source_fragment_code = f"class {self.class_actual_name} {{\n{self.source_class_dependent_fields}\n{self.source_fragment_body}\n}}"

    def add_instruction(self):
        main_note = ""
        if self.fragment_actual_name == "main":
            main_note = "\n\nNote: For the 'main' function in Cangjie, do NOT use 'func' keyword. Use the format: main(args: Array<String>): Int32 { ... }"

        syntax_note = "\n\nIMPORTANT: Use COLON (:) for return type in function signatures, NOT arrow (->). Example: func foo(): Int64 { ... } NOT func foo() -> Int64 { ... }"

        json_instruction = "\n\nYou MUST output ONLY valid JSON (no markdown, no code fences). The JSON must have these fields:\n- 'class': (optional) the complete class definition\n- 'method': ONLY the translated method (with signature). This field will be inserted into the skeleton.\n- 'reasoning': (optional) your reasoning about the translation\n- 'imports': (optional) any additional imports needed as a comma-separated string"

        if self.is_feedback:
            self.prompt += f'### Instruction:\nBased on the feedback provided, identify the error in the following Cangjie translation of the {self.fragment_type} and correct it. You only need to correct the "{self.fragment_actual_name}" {self.fragment_type}. All necessary dependencies are available in partial Cangjie translation. Only complete the given "{self.fragment_actual_name}" method.{main_note}{syntax_note}{json_instruction}'
        else:
            self.prompt += f'### Instruction:\nTranslate the following {self.args.from_lang} {self.fragment_type} to Cangjie. You only need to translate the "{self.fragment_actual_name}" {self.fragment_type}. All necessary dependencies are available in partial Cangjie translation.{main_note}{syntax_note}{json_instruction}'

    def add_source_code(self):
        self.prompt += (
            f"{self.args.from_lang} code:\n```\n{self.source_fragment_code}\n```"
        )

    def add_incorrect_translation(self):
        translation = "\n".join(
            self.class_dict[f"{self.fragment_type}s"][
                self.fragment_name
            ]["translation"]
        )
        # Don't wrap main() - it's a top-level function in Cangjie
        if self.fragment_actual_name != "main":
            self.prompt += f"Incorrect {self.args.to_lang} translation:\n```\nclass {self.class_actual_name} {{\n{translation}\n}}\n```"
        else:
            self.prompt += f"Incorrect {self.args.to_lang} translation:\n```\n{translation}\n```"

    def add_feedback(self):
        self.prompt += "Execution feedback:\n```\n"
        self.prompt += self.feedback
        self.prompt += "\n```"

    def add_partial_translation(self):
        self.build_partial_translation()
        self.prompt += (
            f"Partial Cangjie translation:\n```\n{self.partial_translation}\n```"
        )

    def build_partial_translation(self):
        self.partial_translation = "\n".join(
            self.schema_data.get(
                "cangjie_imports", self.schema_data.get("python_imports", [])
            )
        )
        self.partial_translation += "\n\n"

        inner_outer_classes = self.class_dict["nests"] + [
            self.class_dict["nested_inside"]
        ]
        for inner_outer_class in inner_outer_classes:
            if (
                not inner_outer_class
                or "new" in inner_outer_class
                or "{" in inner_outer_class
                or inner_outer_class == []
            ):
                continue

            class_decl = self.schema_data['classes'][inner_outer_class]['cangjie_class_declaration']
            if not class_decl.rstrip().endswith("}"):
                class_decl = class_decl.rstrip() + "\n}"

            inner_outer_classes_py = [class_decl]
            for field in self.schema_data["classes"][inner_outer_class]["fields"]:
                if field.split(":")[1] in "".join(
                    self.class_dict[
                        f"{self.fragment_type}s"
                    ][self.fragment_name]["body"]
                ):
                    field_translation = self.schema_data["classes"][inner_outer_class][
                        "fields"
                    ][field]["translation"]
                    inner_outer_classes_py.append(
                        "\n".join(field_translation)
                        if field_translation
                        else "".join(
                            self.schema_data["classes"][inner_outer_class]["fields"][
                                field
                            ]["partial_translation"]
                        ).replace("<placeholder>", "None")
                    )
                    inner_outer_classes_py.append("\n")

            if len(inner_outer_classes_py) > 0:
                self.partial_translation += "\n".join(inner_outer_classes_py) + "\n\n"

        dependencies = {}
        dependencies_path = (
            f"data/java/dependencies{self.args.suffix}/{self.args.project}/dependencies.json"
        )
        if self.args.translate_evosuite:
            dependencies_path = (
                f"data/java/dependencies_evosuite/{self.args.project}/dependencies.json"
            )

        with open(dependencies_path, "r") as f:
            dependencies = json.load(f)

        imported_classes = []
        if self.class_name in dependencies:
            imported_classes = dependencies[self.class_name]

        for dependenct_class_name, dependent_class_path in imported_classes:

            has_exceptional_import = False
            for exceptional_import in [
                "commons.io",
                "commons.logging",
                "opentest4j",
                "com.google",
                "org.evosuite",
                "scaffolding",
            ]:
                if exceptional_import in dependent_class_path:
                    has_exceptional_import = True
                    break

                if (
                    "joda.convert" in dependent_class_path
                    and self.args.project == "joda-money"
                ):
                    has_exceptional_import = True
                    break

            if has_exceptional_import:
                continue

            imported_class_path = self.get_dependency_path(
                dependent_class_path, self.args.project
            )

            imported_class_data = {}
            with open(
                f"{self.args.translation_dir}/{self.args.project}.{imported_class_path}.json",
                "r",
            ) as f:
                imported_class_data = json.load(f)

            imported_class_key = find_class_key(imported_class_data["classes"], dependenct_class_name)
            class_declaration = imported_class_data["classes"][imported_class_key]["cangjie_class_declaration"]
            if not class_declaration.rstrip().endswith("}"):
                class_declaration = class_declaration.rstrip() + "\n}"

            imported_classes = [class_declaration]

            for field in imported_class_data["classes"][imported_class_key][
                "fields"
            ]:
                if field.split(":")[1] in "".join(
                    self.class_dict[
                        f"{self.fragment_type}s"
                    ][self.fragment_name]["body"]
                ):
                    field_translation = imported_class_data["classes"][
                        imported_class_key
                    ]["fields"][field]["translation"]
                    if field_translation:
                        imported_classes.append("\n".join(field_translation))
                    else:
                        imported_classes.append(
                            "\n".join(
                                imported_class_data["classes"][dependenct_class_name][
                                    "fields"
                                ][field]["partial_translation"]
                            ).replace("<placeholder>", "None")
                        )

            if len(imported_classes) > 0:
                self.partial_translation += "\n".join(imported_classes) + "\n"

        for super_class in self.class_dict["extends"]:
            super_class_schema = ""
            for schema_file in os.listdir(self.args.translation_dir):
                if schema_file.endswith(f".{super_class}.json"):
                    super_class_schema = schema_file
                    break

            if super_class_schema == "":
                continue

            super_class_data = {}
            with open(f"{self.args.translation_dir}/{super_class_schema}", "r") as f:
                super_class_data = json.load(f)


            if (
                f"class {super_class}:" in self.partial_translation
                or f"class {super_class}(" in self.partial_translation
            ):
                continue

            super_class_key = find_class_key(super_class_data["classes"], super_class)
            super_class_decl = super_class_data["classes"][super_class_key]["cangjie_class_declaration"]
            # Don't close the class here - we'll close it after adding fields

            super_class_declaration = [super_class_decl]
            for field in super_class_data["classes"][super_class_key]["fields"]:
                if field.split(":")[1] in "".join(
                    self.class_dict[
                        f"{self.fragment_type}s"
                    ][self.fragment_name]["body"]
                ):
                    field_translation = super_class_data["classes"][super_class_key][
                        "fields"
                    ][field]["translation"]
                    super_class_declaration.append(
                        "\n".join(field_translation)
                        if field_translation
                        else "".join(
                            super_class_data["classes"][super_class_key]["fields"][field][
                                "partial_translation"
                            ]
                        ).replace("<placeholder>", "None")
                    )
                    super_class_declaration.append("\n")

            # Close the class after all fields have been added
            if len(super_class_declaration) > 1:
                super_class_declaration.append("\n}")

            if len(super_class_declaration) > 0:
                self.partial_translation += "\n".join(super_class_declaration) + "\n\n"

        main_class_decl = self.class_dict[
            "cangjie_class_declaration"
        ]
        # Don't close the class here - we'll close it after adding all members
        main_class_partial_translation = main_class_decl

        if "partial_translation" in self.fragment_dict and "throw Exception('TODO')" not in "".join(self.fragment_dict["partial_translation"]):
            self.prompt_status = "translated"

        for field in self.class_dict["fields"]:
            if (
                field.split(":")[1] == self.fragment_actual_name
                and self.fragment_type == "field"
            ):
                continue
            if field.split(":")[1] in "".join(
                "".join(
                    self.class_dict[
                        f"{self.fragment_type}s"
                    ][self.fragment_name]["body"]
                )
            ):
                field_translation = self.class_dict[
                    "fields"
                ][field]["translation"]
                main_class_partial_translation += (
                    "\n".join(field_translation)
                    if field_translation
                    else "".join(
                        self.class_dict["fields"][field][
                            "partial_translation"
                        ]
                    ).replace("<placeholder>", "None")
                )
                main_class_partial_translation += "\n\n"

        if self.fragment_type == "method":

            if (
                len(
                    self.class_dict["methods"][
                        self.fragment_name
                    ]["calls"]
                )
                != 0
                and self.args.include_call_graph
            ):

                out_of_file_dependencies = []
                out_of_class_dependencies = []
                for callee_schema, callee_class, callee_method in self.class_dict["methods"][self.fragment_name]["calls"]:

                    if callee_schema == "library":
                        continue

                    callee_schema_data = {}
                    with open(
                        f"{self.args.translation_dir}/{callee_schema}.json",
                        "r",
                    ) as f:
                        callee_schema_data = json.load(f)

                    if ":" not in callee_method:
                        continue

                    if callee_schema != self.schema_name:
                        out_of_file_dependencies.append(
                            (callee_schema, callee_class, callee_method)
                        )
                        continue

                    if callee_class != self.class_name:
                        out_of_class_dependencies.append(
                            (callee_schema, callee_class, callee_method)
                        )
                        continue

                    if self.args.include_implementation:
                        method_translation = callee_schema_data["classes"][
                            callee_class
                        ]["methods"][callee_method]["translation"]
                        callee_partial_translation = (
                            "\n".join(method_translation).rstrip()
                            if method_translation
                            else "".join(
                                callee_schema_data["classes"][callee_class]["methods"][
                                    callee_method
                                ]["partial_translation"]
                            ).rstrip()
                        )
                    else:
                        callee_partial_translation = "".join(
                            callee_schema_data["classes"][callee_class]["methods"][
                                callee_method
                            ]["partial_translation"]
                        ).rstrip()

                    main_class_partial_translation += (
                        f"{callee_partial_translation}\n\n"
                    )

                main_class_partial_translation += "".join(
                    self.class_dict["methods"][
                        self.fragment_name
                    ]["partial_translation"]
                ).rstrip()

                if len(out_of_file_dependencies) != 0:
                    ordered_out_of_file_dependencies = {}
                    for (
                        callee_schema,
                        callee_class,
                        callee_method,
                    ) in out_of_file_dependencies:
                        ordered_out_of_file_dependencies.setdefault(callee_schema, [])
                        ordered_out_of_file_dependencies[callee_schema].append(
                            (callee_class, callee_method)
                        )

                    for callee_schema in ordered_out_of_file_dependencies:
                        for (
                            callee_class,
                            callee_method,
                        ) in ordered_out_of_file_dependencies[callee_schema]:

                            callee_schema_data = {}
                            with open(
                                f"{self.args.translation_dir}/{callee_schema}.json",
                                "r",
                            ) as f:
                                callee_schema_data = json.load(f)

                            if (
                                callee_schema_data["classes"][callee_class][
                                    "cangjie_class_declaration"
                                ]
                                not in self.partial_translation
                            ):
                                callee_class_decl = callee_schema_data['classes'][callee_class]['cangjie_class_declaration']
                                if not callee_class_decl.rstrip().endswith("}"):
                                    callee_class_decl = callee_class_decl.rstrip() + "\n}"
                                self.partial_translation += callee_class_decl
                                for field in callee_schema_data["classes"][
                                    callee_class
                                ]["fields"]:
                                    field_translation = callee_schema_data["classes"][
                                        callee_class
                                    ]["fields"][field]["translation"]
                                    self.partial_translation += (
                                        "\n".join(field_translation)
                                        if field_translation
                                        else "".join(
                                            callee_schema_data["classes"][callee_class][
                                                "fields"
                                            ][field]["partial_translation"]
                                        ).replace("<placeholder>", "None")
                                    )
                                    self.partial_translation += "\n"

                            self.partial_translation += "\n"

                            if self.args.include_implementation:
                                callee_method_translation = callee_schema_data[
                                    "classes"
                                ][callee_class]["methods"][callee_method]["translation"]
                                self.partial_translation += (
                                    "\n".join(callee_method_translation).rstrip()
                                    if callee_method_translation
                                    else "".join(
                                        callee_schema_data["classes"][callee_class][
                                            "methods"
                                        ][callee_method]["partial_translation"]
                                    ).rstrip()
                                )
                            else:
                                self.partial_translation += "".join(
                                    callee_schema_data["classes"][callee_class][
                                        "methods"
                                    ][callee_method]["partial_translation"]
                                ).rstrip()

                            self.partial_translation += "\n\n"

                if len(out_of_class_dependencies) != 0:
                    ordered_out_of_file_dependencies = {}
                    for (
                        callee_schema,
                        callee_class,
                        callee_method,
                    ) in out_of_class_dependencies:
                        ordered_out_of_file_dependencies.setdefault(callee_schema, [])
                        ordered_out_of_file_dependencies[callee_schema].append(
                            (callee_class, callee_method)
                        )

                    for callee_schema in ordered_out_of_file_dependencies:
                        for (
                            callee_class,
                            callee_method,
                        ) in ordered_out_of_file_dependencies[callee_schema]:
                            callee_schema_data = {}
                            with open(
                                f"{self.args.translation_dir}/{callee_schema}.json",
                                "r",
                            ) as f:
                                callee_schema_data = json.load(f)

                            callee_class_decl = callee_schema_data['classes'][callee_class]['cangjie_class_declaration']
                            # Don't close the class here - we'll close it after adding fields/methods
                            self.partial_translation += callee_class_decl
                            for field in callee_schema_data["classes"][callee_class][
                                "fields"
                            ]:
                                field_translation = callee_schema_data["classes"][
                                    callee_class
                                ]["fields"][field]["translation"]
                                self.partial_translation += (
                                    "\n".join(field_translation) + "\n"
                                    if field_translation
                                    else "".join(
                                        callee_schema_data["classes"][callee_class][
                                            "fields"
                                        ][field]["partial_translation"]
                                    ).replace("<placeholder>", "None")
                                    + "\n"
                                )

                            if self.args.include_implementation:
                                callee_method_translation = callee_schema_data[
                                    "classes"
                                ][callee_class]["methods"][callee_method]["translation"]
                                self.partial_translation += (
                                    "\n".join(callee_method_translation)
                                    if callee_method_translation
                                    else "".join(
                                        callee_schema_data["classes"][callee_class][
                                            "methods"
                                        ][callee_method]["partial_translation"]
                                    )
                                )
                            else:
                                self.partial_translation += "".join(
                                    callee_schema_data["classes"][callee_class][
                                        "methods"
                                    ][callee_method]["partial_translation"]
                                )

                            # Close the callee class after adding fields/methods
                            self.partial_translation += "\n}"

                            self.partial_translation += "\n\n"

                main_class_partial_translation += "\n"

            else:
                main_class_partial_translation += "".join(
                    self.class_dict["methods"][
                        self.fragment_name
                    ]["partial_translation"]
                ).rstrip()
                main_class_partial_translation += "\n"

        else:
            for method in self.class_dict["methods"]:
                if method.split(":")[1] in "".join(
                    "".join(
                        self.class_dict[
                            f"{self.fragment_type}s"
                        ][self.fragment_name]["body"]
                    )
                ):
                    method_translation = self.class_dict[
                        "methods"
                    ][method]["translation"]
                    if self.args.include_implementation:
                        main_class_partial_translation += (
                            "\n".join(method_translation)
                            if method_translation
                            else "".join(
                                self.class_dict["methods"][
                                    method
                                ]["partial_translation"]
                            ).replace("<placeholder>", "None")
                        )
                    else:
                        main_class_partial_translation += "".join(
                            self.class_dict["methods"][
                                method
                            ]["partial_translation"]
                        ).replace("<placeholder>", "None")
                    main_class_partial_translation += "\n\n"

        if self.fragment_type == "field":
            if "partial_translation" in self.fragment_dict:
                main_class_partial_translation += (
                    "".join(self.fragment_dict["partial_translation"]).replace(
                        "<placeholder>", ""
                    )
                    + "\n"
                )
        elif self.fragment_type == "static_initializer":
            if "partial_translation" in self.fragment_dict:
                main_class_partial_translation += (
                    "".join(self.fragment_dict["partial_translation"]).replace(
                        "<placeholder>", ""
                    )
                    + "\n"
                )

        # Close the class after all members have been added
        if not main_class_partial_translation.rstrip().endswith("}"):
            main_class_partial_translation = main_class_partial_translation.rstrip() + "\n}\n"

        self.partial_translation += main_class_partial_translation

    def add_target_translation(self):
        self.prompt += "### Response:\n"
        self.prompt += 'Output ONLY the JSON object with your translation in the "method" field.'

    def single_line_break(self):
        self.prompt += "\n"

    def double_line_break(self):
        self.prompt += "\n\n"

    def get_dependency_path(self, dependent_class, project):
        if os.path.exists(
            f"java_projects/cleaned_final_projects{self.args.suffix}/{project}/src/main/java/"
            + dependent_class.replace(".", "/")
            + ".java"
        ):
            return f"src.main.{dependent_class}"
        elif os.path.exists(
            f"java_projects/cleaned_final_projects{self.args.suffix}/{project}/src/test/java/"
            + dependent_class.replace(".", "/")
            + ".java"
        ):
            return f"src.test.{dependent_class}"
        else:
            return f"src.main.{dependent_class}"

    def generate_prompt(self):
        self.prompt = self.prompt.replace("\u0000", "")
        return self.prompt
