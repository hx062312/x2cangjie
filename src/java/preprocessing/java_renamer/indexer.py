"""
Project indexer — parses all Java files and builds the Symbol Table.

Mirrors Eclipse JDT Core's ASTParser + CompilationUnit resolution step:
  1. Parse every .java file with tree-sitter
  2. Extract all declarations (classes, fields, methods, variables, etc.)
  3. Build per-file ImportTable for type resolution
  4. Register all declarations in the project-level SymbolTable
  5. Build inheritance graph (superclass chain, interface implementations)
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from typing import Optional

from src.java.preprocessing._shared import _skip_dir, extract_text_by_bytes, load_parser
from src.java.preprocessing.java_renamer.symbols import (
    AccessModifier,
    BlockScope,
    ClassScope,
    FileScope,
    Location,
    MethodScope,
    Scope,
    Symbol,
    SymbolKind,
    SymbolTable,
)

# ---------------------------------------------------------------------------
# Import resolution — per-file import table
# ---------------------------------------------------------------------------

# Well-known JDK packages that are always implicitly imported
JAVA_LANG_AUTO_IMPORTS = frozenset(
    {
        "String",
        "Object",
        "Integer",
        "Long",
        "Double",
        "Float",
        "Boolean",
        "Byte",
        "Short",
        "Character",
        "Number",
        "Math",
        "System",
        "Thread",
        "Runnable",
        "Exception",
        "Error",
        "Throwable",
        "RuntimeException",
        "StringBuilder",
        "StringBuffer",
        "Class",
        "Enum",
        "Override",
        "Deprecated",
        "SuppressWarnings",
        "FunctionalInterface",
        "SafeVarargs",
        "Iterable",
        "AutoCloseable",
        "Cloneable",
        "Comparable",
        "ProcessBuilder",
        "StackTraceElement",
        "ThreadLocal",
        "Void",
        "Record",
    }
)


@dataclass
class ImportTable:
    """
    Per-file import resolution table.

    Tracks three categories of imports:
      - single_type:  import java.util.List;        →  List → java.util.List
      - on_demand:    import java.util.*;           →  java.util (available for lookup)
      - static_import: import static org.Foo.bar;   →  bar → org.Foo.bar
    """

    package_name: str = ""
    single_type: dict[str, str] = field(default_factory=dict)  # short → FQCN
    on_demand: set[str] = field(default_factory=set)  # packages (e.g., "java.util")
    static_imports: dict[str, str] = field(default_factory=dict)  # short → FQCN

    def resolve_type(self, short_name: str) -> Optional[str]:
        """
        Resolve a short type name to its FQCN.

        Resolution order (mirrors JLS §6.5):
          1. Single-type import
          2. Same package
          3. On-demand imports
          4. java.lang auto-imports
        """
        # 1. Explicit single-type import
        if short_name in self.single_type:
            return self.single_type[short_name]

        # 2. Same package
        if self.package_name:
            fqcn = f"{self.package_name}.{short_name}"
            # We can't know if it actually exists here, but we return the candidate
            # The caller (ScopeResolver) will verify against the SymbolTable
            return fqcn

        # 3. On-demand package imports (return first match)
        for pkg in self.on_demand:
            potential = f"{pkg}.{short_name}"
            # Caller will check if this exists in the symbol table
            return potential
            # Note: we don't break here because on-demand imports are
            # checked by the caller who has access to the SymbolTable

        # 4. java.lang auto-imports
        if short_name in JAVA_LANG_AUTO_IMPORTS:
            return f"java.lang.{short_name}"

        return None

    def resolve_all_candidates(self, short_name: str) -> list[str]:
        """
        Return ALL possible FQCNs for a short name, in resolution order.
        Used when the caller needs to check the SymbolTable for existence.
        """
        candidates: list[str] = []

        # 1. Single-type import
        if short_name in self.single_type:
            candidates.append(self.single_type[short_name])

        # 2. Same package
        if self.package_name:
            candidates.append(f"{self.package_name}.{short_name}")

        # 3. On-demand imports
        for pkg in self.on_demand:
            candidates.append(f"{pkg}.{short_name}")

        # 4. java.lang
        if short_name in JAVA_LANG_AUTO_IMPORTS:
            candidates.append(f"java.lang.{short_name}")

        return candidates

    def is_static_import(self, name: str) -> bool:
        """Check if a name comes from a static import."""
        return name in self.static_imports

    def get_static_import_origin(self, name: str) -> Optional[str]:
        """Get the FQCN that a static import comes from."""
        return self.static_imports.get(name)


def build_import_table(code: bytes, tree_root, package_name: str) -> ImportTable:
    """Extract all imports from a parsed Java file."""
    table = ImportTable(package_name=package_name)

    def _walk(node):
        if node.type == "import_declaration":
            text = extract_text_by_bytes(code, node.start_byte, node.end_byte)
            text = text.strip()

            is_static = text.startswith("import static ")
            if is_static:
                # import static com.example.Foo.bar;
                # → static_imports["bar"] = "com.example.Foo"
                inner = text[len("import static ") :].rstrip(";")
                parts = inner.rsplit(".", 1)
                if len(parts) == 2:
                    class_fqcn, member = parts
                    table.static_imports[member] = class_fqcn
                # on-demand static: import static com.example.Foo.*;
                elif inner.endswith(".*"):
                    class_fqcn = inner[:-2]
                    # Mark the class for on-demand static lookup
                    table.static_imports[f"*{class_fqcn}"] = class_fqcn
            else:
                # import java.util.List;
                # import java.util.*;
                inner = text[len("import ") :].rstrip(";")
                if inner.endswith(".*"):
                    table.on_demand.add(inner[:-2])
                else:
                    short = inner.rsplit(".", 1)[-1]
                    table.single_type[short] = inner
            return

        for child in node.children:
            _walk(child)

    _walk(tree_root)
    return table


# ---------------------------------------------------------------------------
# JavaProject — the main indexer
# ---------------------------------------------------------------------------


class JavaProject:
    """
    Indexes a Java project directory, building the complete Symbol Table.

    Usage:
      project = JavaProject("projects/java/keyword_handled/commons-cli")
      project.index()
      print(f"Indexed {len(project.symbols)} symbols across {len(project.files)} files")
    """

    def __init__(self, project_dir: str):
        self.project_dir: str = project_dir
        self.symbols: SymbolTable = SymbolTable()
        self.files: dict[str, FileScope] = {}  # file_path → FileScope
        self.imports: dict[str, ImportTable] = {}  # file_path → ImportTable
        self.class_hierarchy: dict[
            str, list[str]
        ] = {}  # FQCN → [parent_FQCN, iface_FQCN, ...]
        self.class_inherited_members: dict[str, dict[str, list[Symbol]]] = {}  # cache

        # Maps for quick lookup
        self._class_by_file: dict[str, list[str]] = {}  # file_path → [class_qname, ...]
        self._class_symbol_by_qname: dict[str, Symbol] = {}
        self._class_scopes: dict[
            str, ClassScope
        ] = {}  # fqcn → ClassScope (for rename walk)
        self._method_scopes: dict[
            str, MethodScope
        ] = {}  # qname → MethodScope (for rename walk)

        # tree-sitter parser (lazy-loaded)
        self._parser = None

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def index(self) -> None:
        """
        Full-project indexing: parse all .java files and build the symbol table.

        This is the main entry point. Call once before any rename operations.
        """
        java_files = list(self._iter_java_files())
        if not java_files:
            print(f"[JavaProject] No .java files found in {self.project_dir}")
            return

        # Phase 1: Parse all files, collect declarations (without full resolution)
        for file_path in java_files:
            self._index_file(file_path)

        # Phase 2: Build inheritance relationships
        self._build_inheritance()

        # Phase 3: Cache inherited members for quick lookup
        self._cache_inherited_members()

        print(
            f"[JavaProject] Indexed {len(self.symbols)} symbols "
            f"in {len(self.files)} files"
        )

    def get_file_scope(self, file_path: str) -> Optional[FileScope]:
        """Get the FileScope for a given file path."""
        return self.files.get(file_path)

    def get_import_table(self, file_path: str) -> Optional[ImportTable]:
        """Get the ImportTable for a given file path."""
        return self.imports.get(file_path)

    def get_class_symbol(self, fqcn: str) -> Optional[Symbol]:
        """Look up a class by its FQCN."""
        return self._class_symbol_by_qname.get(fqcn)

    def get_inherited_members(self, fqcn: str) -> dict[str, list[Symbol]]:
        """Get all members (fields + methods) visible through inheritance."""
        return self.class_inherited_members.get(fqcn, {})

    def is_project_class(self, fqcn: str) -> bool:
        """Does this FQCN refer to a class defined in the project?"""
        return fqcn in self._class_symbol_by_qname

    def get_class_scope(self, fqcn: str):
        """Get the ClassScope for a class by its FQCN."""
        return self._class_scopes.get(fqcn)

    def get_method_scope(self, qname: str):
        """Get the MethodScope for a method by its qualified name."""
        return self._method_scopes.get(qname)

    def is_jdk_class(self, name: str, file_path: str) -> bool:
        """
        Determine if a name refers to a JDK/external class.

        Uses import resolution to check if the resolved FQCN starts with java.*
        or is otherwise not in the project.
        """
        imports = self.imports.get(file_path)
        if not imports:
            return False

        candidates = imports.resolve_all_candidates(name)

        # If none of the candidates are project classes, it's external
        for candidate in candidates:
            if self.is_project_class(candidate):
                return False

        # Check if any candidate starts with java.* / javax.* / jdk.*
        for candidate in candidates:
            if (
                candidate.startswith("java.")
                or candidate.startswith("javax.")
                or candidate.startswith("jdk.")
                or candidate.startswith("sun.")
            ):
                return True

        # If there are candidates but none are project classes → external
        if candidates:
            return True

        # No candidates: check if the bare name looks like a JDK class
        if name[0].isupper() and name in JAVA_LANG_AUTO_IMPORTS:
            return True

        return False

    # ------------------------------------------------------------------
    # Internal: file iteration
    # ------------------------------------------------------------------

    def _iter_java_files(self):
        """Yield paths to all .java files in the project directory."""
        for root, dirs, files in os.walk(self.project_dir):
            if _skip_dir(root):
                continue
            for fname in sorted(files):
                if fname.endswith(".java"):
                    yield os.path.join(root, fname)

    @staticmethod
    def _get_file_path(scope) -> str:
        """Walk up the scope chain to find the FileScope and get its path."""
        s = scope
        while s is not None:
            if hasattr(s, "file_path") and s.file_path:
                return s.file_path
            s = s.parent if hasattr(s, "parent") else None
        return ""

    def _get_parser(self):
        """Lazy-load the tree-sitter parser."""
        if self._parser is None:
            self._parser = load_parser()
        return self._parser

    # ------------------------------------------------------------------
    # Internal: file indexing
    # ------------------------------------------------------------------

    def _index_file(self, file_path: str) -> None:
        """Parse a single Java file and extract all declarations."""
        try:
            with open(file_path, "rb") as f:
                code = f.read()
        except Exception as e:
            print(f"[JavaProject] Warning: cannot read {file_path}: {e}")
            return

        parser = self._get_parser()
        tree = parser.parse(code)
        root = tree.root_node

        # Extract package
        package_name = self._extract_package(code, root)

        # Build import table
        import_table = build_import_table(code, root, package_name)
        self.imports[file_path] = import_table

        # Build FileScope
        file_scope = FileScope(file_path=file_path, package_name=package_name)
        self.files[file_path] = file_scope
        self._class_by_file[file_path] = []

        # Index top-level declarations
        self._index_node(
            root,
            code,
            file_scope,
            import_table,
            parent_fqcn=None,
            is_static_context=False,
        )

    def _extract_package(self, code: bytes, root) -> str:
        """Extract the package name from the AST root."""
        for child in root.children:
            if child.type == "package_declaration":
                # Get the scoped_identifier child
                for sub in child.children:
                    if sub.type == "scoped_identifier":
                        return extract_text_by_bytes(code, sub.start_byte, sub.end_byte)
        return ""

    # ------------------------------------------------------------------
    # Internal: recursive declaration extraction
    # ------------------------------------------------------------------

    def _index_node(
        self,
        node,
        code: bytes,
        scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
        is_static_context: bool,
    ) -> None:
        """
        Recursively walk the AST and extract all declarations into the Symbol Table.

        This is the core indexing logic. For each declaration found, it:
          1. Creates the appropriate Symbol
          2. Registers it in the SymbolTable
          3. Adds it to the current Scope
          4. Recurse into child declarations with a new sub-scope
        """
        nt = node.type

        # --- Class / Interface / Enum / Record ---
        if nt in (
            "class_declaration",
            "interface_declaration",
            "enum_declaration",
            "record_declaration",
        ):
            self._index_class(
                node, code, scope, imports, parent_fqcn, is_static_context
            )
            return

        # --- Method / Constructor ---
        if nt in ("method_declaration", "constructor_declaration"):
            self._index_method(
                node, code, scope, imports, parent_fqcn, is_static_context
            )
            return

        # --- Field ---
        if nt == "field_declaration":
            self._index_field(
                node, code, scope, imports, parent_fqcn, is_static_context
            )
            return

        # --- Enum constant ---
        if nt == "enum_constant":
            self._index_enum_constant(node, code, scope, parent_fqcn)
            return

        # --- Static initializer ---
        if nt == "static_initializer":
            # Static initializers don't have a name, but they create a scope
            # for local variables declared inside the block
            body = node.child_by_field_name("body")
            if body:
                # Create a method-like scope
                init_sym = Symbol(
                    kind=SymbolKind.METHOD,
                    name="<clinit>",
                    qualified_name=f"{parent_fqcn}.<clinit>"
                    if parent_fqcn
                    else "<clinit>",
                    location=Location(
                        file_path=self._get_file_path(scope),
                        start_byte=node.start_byte,
                        end_byte=node.end_byte,
                    ),
                    is_static=True,
                )
                method_scope = MethodScope(parent=scope, method_symbol=init_sym)
                self._index_block_variables(
                    body, code, method_scope, imports, parent_fqcn
                )
            return

        # --- Instance initializer ---
        if nt == "instance_initializer":
            body = node.child_by_field_name("body")
            if body and parent_fqcn:
                init_sym = Symbol(
                    kind=SymbolKind.METHOD,
                    name="<init>",
                    qualified_name=f"{parent_fqcn}.<init>",
                    location=Location(
                        file_path=self._get_file_path(scope),
                        start_byte=node.start_byte,
                        end_byte=node.end_byte,
                    ),
                )
                method_scope = MethodScope(parent=scope, method_symbol=init_sym)
                self._index_block_variables(
                    body, code, method_scope, imports, parent_fqcn
                )
            return

        # --- Local variable declarations ---
        if nt == "local_variable_declaration":
            self._index_local_variable(node, code, scope, imports, parent_fqcn)
            # Don't return — still recurse into children (for blocks inside methods)
            for child in node.children:
                self._index_node(
                    child, code, scope, imports, parent_fqcn, is_static_context
                )
            return

        # --- Recursion for other nodes ---
        for child in node.children:
            self._index_node(
                child, code, scope, imports, parent_fqcn, is_static_context
            )

    # ------------------------------------------------------------------
    # Internal: specific declaration handlers
    # ------------------------------------------------------------------

    def _index_class(
        self,
        node,
        code: bytes,
        parent_scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
        is_static_context: bool,
    ) -> None:
        """Index a class/interface/enum/record declaration."""
        name_node = node.child_by_field_name("name")
        if name_node is None:
            # Anonymous class — skip (no name to rename)
            return

        class_name = extract_text_by_bytes(
            code, name_node.start_byte, name_node.end_byte
        )

        # Determine kind
        kind_map = {
            "class_declaration": SymbolKind.CLASS,
            "interface_declaration": SymbolKind.INTERFACE,
            "enum_declaration": SymbolKind.ENUM,
            "record_declaration": SymbolKind.RECORD,
        }
        kind = kind_map.get(nt := node.type, SymbolKind.CLASS)

        # Determine FQCN
        package = getattr(imports, "package_name", "")
        if parent_fqcn:
            fqcn = f"{parent_fqcn}.{class_name}"
        elif package:
            fqcn = f"{package}.{class_name}"
        else:
            fqcn = class_name

        # Extract modifiers
        modifiers = self._extract_modifiers(node, code)

        # Create class symbol
        class_sym = Symbol(
            kind=kind,
            name=class_name,
            qualified_name=fqcn,
            location=Location(
                file_path=self._get_file_path(parent_scope),
                start_byte=name_node.start_byte,
                end_byte=name_node.end_byte,
                start_line=name_node.start_point[0] + 1,
                end_line=name_node.end_point[0] + 1,
            ),
            modifiers=modifiers,
            is_static=is_static_context,
            is_abstract="abstract" in modifiers,
            super_class=self._extract_super_class(node, code),
            interfaces=self._extract_interfaces(node, code),
        )

        # Register
        self.symbols.add(class_sym)
        parent_scope.define(class_sym)
        self._class_symbol_by_qname[fqcn] = class_sym

        if isinstance(parent_scope, FileScope):
            self._class_by_file.setdefault(parent_scope.file_path, []).append(fqcn)

        # Create class scope for members
        class_scope = ClassScope(parent=parent_scope, class_symbol=class_sym)
        self._class_scopes[fqcn] = class_scope

        if isinstance(parent_scope, ClassScope):
            parent_scope.inner_scopes.append(class_scope)

        # Index class body (methods, fields, inner classes)
        body = node.child_by_field_name("body")
        if body:
            self._index_class_body(body, code, class_scope, imports, fqcn)

    def _index_class_body(
        self,
        body_node,
        code: bytes,
        class_scope: ClassScope,
        imports: ImportTable,
        class_fqcn: str,
    ) -> None:
        """Index all members inside a class body, creating method scopes for methods."""
        for child in body_node.children:
            ct = child.type

            if ct in (
                "class_declaration",
                "interface_declaration",
                "enum_declaration",
                "record_declaration",
            ):
                # Inner class — using the same is_static_context as outer
                self._index_node(
                    child,
                    code,
                    class_scope,
                    imports,
                    class_fqcn,
                    is_static_context=False,
                )
            elif ct in ("method_declaration", "constructor_declaration"):
                self._index_method(
                    child,
                    code,
                    class_scope,
                    imports,
                    class_fqcn,
                    is_static_context=False,
                )
            elif ct == "field_declaration":
                self._index_field(
                    child,
                    code,
                    class_scope,
                    imports,
                    class_fqcn,
                    is_static_context=False,
                )
            elif ct == "static_initializer":
                # static initializer in class body
                body = child.child_by_field_name("body")
                if body:
                    init_sym = Symbol(
                        kind=SymbolKind.METHOD,
                        name="<clinit>",
                        qualified_name=f"{class_fqcn}.<clinit>",
                        location=Location(
                            file_path=self._get_file_path(class_scope),
                            start_byte=child.start_byte,
                            end_byte=child.end_byte,
                        ),
                        is_static=True,
                    )
                    method_scope = MethodScope(
                        parent=class_scope, method_symbol=init_sym
                    )
                    self._index_block_variables(
                        body, code, method_scope, imports, class_fqcn
                    )
            elif ct == "instance_initializer":
                body = child.child_by_field_name("body")
                if body:
                    init_sym = Symbol(
                        kind=SymbolKind.METHOD,
                        name="<init>",
                        qualified_name=f"{class_fqcn}.<init>",
                        location=Location(
                            file_path=self._get_file_path(class_scope),
                            start_byte=child.start_byte,
                            end_byte=child.end_byte,
                        ),
                    )
                    method_scope = MethodScope(
                        parent=class_scope, method_symbol=init_sym
                    )
                    self._index_block_variables(
                        body, code, method_scope, imports, class_fqcn
                    )
            elif ct == "enum_constant":
                self._index_enum_constant(child, code, class_scope, class_fqcn)
            elif ct == "enum_body_declarations":
                for sub in child.children:
                    if sub.type == "field_declaration":
                        self._index_field(
                            sub,
                            code,
                            class_scope,
                            imports,
                            class_fqcn,
                            is_static_context=False,
                        )
                    elif sub.type in ("method_declaration", "constructor_declaration"):
                        self._index_method(
                            sub,
                            code,
                            class_scope,
                            imports,
                            class_fqcn,
                            is_static_context=False,
                        )
            # Other statements (semicolons, etc.) — skip for indexing

    def _index_method(
        self,
        node,
        code: bytes,
        parent_scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
        is_static_context: bool,
    ) -> None:
        """Index a method or constructor declaration."""
        name_node = node.child_by_field_name("name")
        if name_node is None:
            return

        method_name = extract_text_by_bytes(
            code, name_node.start_byte, name_node.end_byte
        )
        is_constructor = node.type == "constructor_declaration"
        kind = SymbolKind.CONSTRUCTOR if is_constructor else SymbolKind.METHOD

        modifiers = self._extract_modifiers(node, code)
        return_type = ""
        if not is_constructor:
            return_type_node = node.child_by_field_name("type")
            if return_type_node:
                return_type = extract_text_by_bytes(
                    code, return_type_node.start_byte, return_type_node.end_byte
                )

        # Extract parameters
        parameters = []
        formal_params = node.child_by_field_name("parameters")
        if formal_params:
            for child in formal_params.children:
                if child.type == "formal_parameter":
                    param_name_node = child.child_by_field_name("name")
                    param_type_node = child.child_by_field_name("type")
                    if param_name_node:
                        param_name = extract_text_by_bytes(
                            code, param_name_node.start_byte, param_name_node.end_byte
                        )
                        param_type = ""
                        if param_type_node:
                            param_type = extract_text_by_bytes(
                                code,
                                param_type_node.start_byte,
                                param_type_node.end_byte,
                            )
                        param_sym = Symbol(
                            kind=SymbolKind.PARAMETER,
                            name=param_name,
                            qualified_name=f"{parent_fqcn}.{method_name}.{param_name}",
                            location=Location(
                                file_path=self._get_file_path(parent_scope),
                                start_byte=param_name_node.start_byte,
                                end_byte=param_name_node.end_byte,
                            ),
                            type_annotation=param_type,
                        )
                        parameters.append(param_sym)

        # Build qualified name with signature for uniqueness
        param_types = ",".join(p.type_annotation for p in parameters)
        qname = (
            f"{parent_fqcn}.{method_name}({param_types})"
            if parent_fqcn
            else f"{method_name}({param_types})"
        )

        method_sym = Symbol(
            kind=kind,
            name=method_name,
            qualified_name=qname,
            location=Location(
                file_path=self._get_file_path(parent_scope),
                start_byte=name_node.start_byte,
                end_byte=name_node.end_byte,
                start_line=name_node.start_point[0] + 1,
                end_line=name_node.end_point[0] + 1,
            ),
            modifiers=modifiers,
            is_static="static" in modifiers or is_static_context,
            return_type=return_type,
            parameters=parameters,
        )

        # Register method symbol
        self.symbols.add(method_sym)
        parent_scope.define(method_sym)

        # Also register parameter symbols
        for p in parameters:
            self.symbols.add(p)

        # Create method scope for local variables in the body
        method_scope = MethodScope(parent=parent_scope, method_symbol=method_sym)
        self._method_scopes[qname] = method_scope

        # Register parameters in the method scope
        for p in parameters:
            method_scope.define(p)

        # Index the method body for local variables
        body = node.child_by_field_name("body")
        if body:
            self._index_block_variables(body, code, method_scope, imports, parent_fqcn)

    def _index_field(
        self,
        node,
        code: bytes,
        parent_scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
        is_static_context: bool,
    ) -> None:
        """Index a field declaration (may have multiple declarators)."""
        modifiers = self._extract_modifiers(node, code)

        type_node = node.child_by_field_name("type")
        type_annotation = ""
        if type_node:
            type_annotation = extract_text_by_bytes(
                code, type_node.start_byte, type_node.end_byte
            )

        for child in node.children:
            if child.type == "variable_declarator":
                name_node = child.child_by_field_name("name")
                if name_node is None:
                    continue
                field_name = extract_text_by_bytes(
                    code, name_node.start_byte, name_node.end_byte
                )

                field_sym = Symbol(
                    kind=SymbolKind.FIELD,
                    name=field_name,
                    qualified_name=f"{parent_fqcn}.{field_name}"
                    if parent_fqcn
                    else field_name,
                    location=Location(
                        file_path=self._get_file_path(parent_scope),
                        start_byte=name_node.start_byte,
                        end_byte=name_node.end_byte,
                    ),
                    type_annotation=type_annotation,
                    modifiers=modifiers,
                    is_static="static" in modifiers or is_static_context,
                    is_final="final" in modifiers,
                )

                self.symbols.add(field_sym)
                parent_scope.define(field_sym)

    def _index_enum_constant(
        self, node, code: bytes, parent_scope: Scope, parent_fqcn: Optional[str]
    ) -> None:
        """Index an enum constant."""
        name_node = node.child_by_field_name("name")
        if name_node is None:
            return

        const_name = extract_text_by_bytes(
            code, name_node.start_byte, name_node.end_byte
        )
        const_sym = Symbol(
            kind=SymbolKind.ENUM_CONSTANT,
            name=const_name,
            qualified_name=f"{parent_fqcn}.{const_name}" if parent_fqcn else const_name,
            location=Location(
                file_path=self._get_file_path(parent_scope),
                start_byte=name_node.start_byte,
                end_byte=name_node.end_byte,
            ),
        )
        self.symbols.add(const_sym)
        parent_scope.define(const_sym)

    def _index_local_variable(
        self,
        node,
        code: bytes,
        parent_scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
    ) -> None:
        """Index a local variable declaration."""
        type_node = node.child_by_field_name("type")
        type_annotation = ""
        if type_node:
            type_annotation = extract_text_by_bytes(
                code, type_node.start_byte, type_node.end_byte
            )

        for child in node.children:
            if child.type == "variable_declarator":
                name_node = child.child_by_field_name("name")
                if name_node is None:
                    continue
                var_name = extract_text_by_bytes(
                    code, name_node.start_byte, name_node.end_byte
                )

                var_sym = Symbol(
                    kind=SymbolKind.VARIABLE,
                    name=var_name,
                    qualified_name=f"{parent_fqcn}.{var_name}"
                    if parent_fqcn
                    else var_name,
                    location=Location(
                        file_path=self._get_file_path(parent_scope),
                        start_byte=name_node.start_byte,
                        end_byte=name_node.end_byte,
                    ),
                    type_annotation=type_annotation,
                )

                self.symbols.add(var_sym)
                parent_scope.define(var_sym)

    def _index_block_variables(
        self,
        block_node,
        code: bytes,
        parent_scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
    ) -> None:
        """
        Walk a block (method body, static initializer, etc.) and index all
        local variable declarations, with proper block scoping.
        """
        self._index_block_variables_recursive(
            block_node, code, parent_scope, imports, parent_fqcn
        )

    def _index_block_variables_recursive(
        self,
        node,
        code: bytes,
        scope: Scope,
        imports: ImportTable,
        parent_fqcn: Optional[str],
    ) -> None:
        """Recursively walk block statements with scope tracking."""
        nt = node.type

        # Local variable declaration — index in current scope
        if nt == "local_variable_declaration":
            self._index_local_variable(node, code, scope, imports, parent_fqcn)

        # Block-creating statements → new block scope
        elif nt in (
            "block",
            "for_statement",
            "enhanced_for_statement",
            "while_statement",
            "do_statement",
            "if_statement",
            "try_statement",
            "catch_clause",
            "finally_clause",
            "synchronized_statement",
            "switch_expression",
            "switch_block",
            "lambda_expression",
        ):
            new_scope = BlockScope(parent=scope)

            # Enhanced for — the loop variable is in the new scope
            if nt == "enhanced_for_statement":
                for child in node.children:
                    if (
                        child.type == "enhanced_for_parameter"
                        or child.type == "identifier"
                    ):
                        # The enhanced for variable
                        var_name = extract_text_by_bytes(
                            code, child.start_byte, child.end_byte
                        )
                        var_sym = Symbol(
                            kind=SymbolKind.VARIABLE,
                            name=var_name,
                            qualified_name=f"{parent_fqcn}.{var_name}"
                            if parent_fqcn
                            else var_name,
                            location=Location(
                                file_path=self._get_file_path(scope),
                                start_byte=child.start_byte,
                                end_byte=child.end_byte,
                            ),
                        )
                        self.symbols.add(var_sym)
                        new_scope.define(var_sym)

            # Catch clause — the exception parameter is in the new scope
            if nt == "catch_clause":
                for child in node.children:
                    if child.type == "catch_formal_parameter":
                        name_node = child.child_by_field_name("name")
                        if name_node:
                            exc_name = extract_text_by_bytes(
                                code, name_node.start_byte, name_node.end_byte
                            )
                            exc_sym = Symbol(
                                kind=SymbolKind.PARAMETER,
                                name=exc_name,
                                qualified_name=f"{parent_fqcn}.catch.{exc_name}"
                                if parent_fqcn
                                else exc_name,
                                location=Location(
                                    file_path=self._get_file_path(scope),
                                    start_byte=name_node.start_byte,
                                    end_byte=name_node.end_byte,
                                ),
                            )
                            self.symbols.add(exc_sym)
                            new_scope.define(exc_sym)

            # Recurse with new scope
            for child in node.children:
                self._index_block_variables_recursive(
                    child, code, new_scope, imports, parent_fqcn
                )
            return

        # Recurse into children with same scope
        for child in node.children:
            self._index_block_variables_recursive(
                child, code, scope, imports, parent_fqcn
            )

    # ------------------------------------------------------------------
    # Internal: modifier extraction
    # ------------------------------------------------------------------

    def _extract_modifiers(self, node, code: bytes) -> set[AccessModifier]:
        """Extract access modifiers from a class/method/field node."""
        modifiers: set[AccessModifier] = set()
        for child in node.children:
            if child.type == "modifiers":
                for mod_child in child.children:
                    text = extract_text_by_bytes(
                        code, mod_child.start_byte, mod_child.end_byte
                    )
                    if text == "public":
                        modifiers.add(AccessModifier.PUBLIC)
                    elif text == "protected":
                        modifiers.add(AccessModifier.PROTECTED)
                    elif text == "private":
                        modifiers.add(AccessModifier.PRIVATE)
            elif child.type in ("public", "protected", "private"):
                text = extract_text_by_bytes(code, child.start_byte, child.end_byte)
                if text == "public":
                    modifiers.add(AccessModifier.PUBLIC)
                elif text == "protected":
                    modifiers.add(AccessModifier.PROTECTED)
                elif text == "private":
                    modifiers.add(AccessModifier.PRIVATE)
        # Default: package-private if no explicit modifier
        if (
            not {
                AccessModifier.PUBLIC,
                AccessModifier.PROTECTED,
                AccessModifier.PRIVATE,
            }
            & modifiers
        ):
            modifiers.add(AccessModifier.PACKAGE_PRIVATE)
        return modifiers

    # ------------------------------------------------------------------
    # Internal: superclass/interface extraction
    # ------------------------------------------------------------------

    def _extract_super_class(self, node, code: bytes) -> str:
        """Extract the superclass name from a class declaration."""
        sup = node.child_by_field_name("superclass")
        if sup is None:
            return ""
        text = extract_text_by_bytes(code, sup.start_byte, sup.end_byte)
        # tree-sitter may include "extends " prefix
        if text.startswith("extends "):
            text = text[8:]
        # Strip generics: BaseNCodec<Integer> -> BaseNCodec
        text = text.split("<")[0].strip()
        return text

    def _extract_interfaces(self, node, code: bytes) -> list[str]:
        """Extract implemented interface names."""
        interfaces_node = node.child_by_field_name("interfaces")
        if interfaces_node is None:
            return []
        interfaces: list[str] = []
        for child in interfaces_node.children:
            if child.type in (
                "type_identifier",
                "scoped_type_identifier",
                "scoped_identifier",
            ):
                interfaces.append(
                    extract_text_by_bytes(code, child.start_byte, child.end_byte)
                )
        return interfaces

    # ------------------------------------------------------------------
    # Internal: inheritance
    # ------------------------------------------------------------------

    def _build_inheritance(self) -> None:
        """
        Build the inheritance graph for all project classes.

        For each class, determine:
          - Its parent class (walk up the extends chain for project classes)
          - All ancestors' fields and methods (for inherited member resolution)
        """
        for fqcn, class_sym in self._class_symbol_by_qname.items():
            ancestors: list[str] = []

            # Add direct superclass
            if class_sym.super_class:
                resolved = self._resolve_type_name(class_sym.super_class, class_sym)
                if resolved and self.is_project_class(resolved):
                    ancestors.append(resolved)

            # Add direct interfaces
            for iface in class_sym.interfaces:
                resolved = self._resolve_type_name(iface, class_sym)
                if resolved and self.is_project_class(resolved):
                    ancestors.append(resolved)

            self.class_hierarchy[fqcn] = ancestors

    def _resolve_type_name(self, short_name: str, class_sym: Symbol) -> Optional[str]:
        """
        Resolve a short type name to its FQCN using the declaring file's imports.

        For extends/implements clauses, the short name needs to be resolved
        against the file's imports.
        """
        file_path = class_sym.location.file_path
        imports = self.imports.get(file_path)

        if imports:
            candidates = imports.resolve_all_candidates(short_name)
            for candidate in candidates:
                if self.is_project_class(candidate):
                    return candidate

        # Simple same-package guess
        if imports and imports.package_name:
            return f"{imports.package_name}.{short_name}"

        return short_name

    def _cache_inherited_members(self) -> None:
        """
        Pre-compute inherited members for each class.

        Stores list of symbols keyed by name to handle Java's allowance of
        same-named fields and methods (JLS allows this).
        """
        for fqcn in list(self._class_symbol_by_qname.keys()):
            members_dict = self._collect_ancestor_members(fqcn)
            # Convert to {name: [symbols]} to preserve field+method with same name
            self.class_inherited_members[fqcn] = members_dict

    def _collect_ancestor_members(
        self, fqcn: str, visited: Optional[set[str]] = None
    ) -> dict[str, list[Symbol]]:
        """Collect all members (fields + methods) from the ancestor chain."""
        if visited is None:
            visited = set()
        if fqcn in visited:
            return {}
        visited.add(fqcn)

        # Use list per name to preserve field+method with same name.
        # Collect directly from global SymbolTable (not Scope.symbols dict)
        # because Scope.symbols is keyed by name and overwrites same-named
        # field+method pairs (JDT avoids this by using AST context to
        # distinguish field_access from method_invocation during binding).
        members: dict[str, list[Symbol]] = {}

        # Get this class's own members from global symbol table
        prefix = fqcn + "."
        for sym in self.symbols:
            if sym.qualified_name.startswith(prefix):
                # Only take direct members (not sub-members like params)
                rest = sym.qualified_name[len(prefix) :]
                if "." not in rest and "(" not in rest:
                    if sym.kind in (
                        SymbolKind.FIELD,
                        SymbolKind.METHOD,
                        SymbolKind.CONSTRUCTOR,
                        SymbolKind.ENUM_CONSTANT,
                    ):
                        members.setdefault(sym.name, []).append(sym)
                elif "(" in rest and "." not in rest.split("(")[0]:
                    # Method without nested dots in name part
                    if sym.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
                        members.setdefault(sym.name, []).append(sym)

        # Recurse into ancestors
        for ancestor_fqcn in self.class_hierarchy.get(fqcn, []):
            ancestor_members = self._collect_ancestor_members(ancestor_fqcn, visited)
            for name, syms in ancestor_members.items():
                existing = {s.qualified_name for s in members.get(name, [])}
                for sym in syms:
                    if sym.qualified_name not in existing:
                        members.setdefault(name, []).append(sym)

        return members
