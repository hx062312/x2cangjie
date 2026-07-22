"""
Scope-based reference resolver — JDT's IBinding resolution in Python.

Mirrors Eclipse JDT Core's approach:
  - For each identifier reference, walk the scope chain to find the declaration
  - Handle special cases: this.field, super.field, ClassName.staticField
  - Cross-file resolution for imported types and their members

Unlike the current heuristic approach (guess based on naming conventions),
this module uses the full SymbolTable + Scope chain for accurate resolution.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from src.java.preprocessing._shared import extract_text_by_bytes
from src.java.preprocessing.java_renamer.indexer import (
    JAVA_LANG_AUTO_IMPORTS,
    ImportTable,
    JavaProject,
)
from src.java.preprocessing.java_renamer.symbols import (
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
# ResolveResult
# ---------------------------------------------------------------------------


@dataclass
class ResolveResult:
    """
    Result of resolving an identifier reference to its declaration.

    Attributes:
      symbol: The resolved Symbol (None if unresolved)
      is_external: True if the symbol is from JDK/external library
      is_ambiguous: True if multiple candidates match (e.g., overloaded methods)
      candidates: List of candidate symbols (when ambiguous)
    """

    symbol: Optional[Symbol] = None
    is_external: bool = False
    is_ambiguous: bool = False
    candidates: list[Symbol] = field(default_factory=list)

    @property
    def resolved(self) -> bool:
        return self.symbol is not None and not self.is_external

    @property
    def should_rename(self) -> bool:
        """Should this reference be renamed? (project-internal, resolved)"""
        return self.symbol is not None and not self.is_external


# ---------------------------------------------------------------------------
# ScopeResolver
# ---------------------------------------------------------------------------


class ScopeResolver:
    """
    Resolves identifier references to their declarations.

    Implements Java's name resolution rules (JLS §6.5):
      1. Check local scope (parameters, local variables)
      2. Check enclosing method/class scopes
      3. Check inherited members
      4. Check imports (single-type, on-demand, static)
      5. Check same-package classes
      6. Check java.lang auto-imports

    Also handles qualified references:
      - this.field       → field in current class or inherited
      - obj.field        → field in obj's declared type
      - ClassName.field  → static field in ClassName
      - obj.method()     → method in obj's declared type
      - super.method()   → method in parent class
    """

    def __init__(self, project: JavaProject):
        self.project: JavaProject = project

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    @staticmethod
    def _find_inherited(
        inherited: dict, name: str, kind: SymbolKind
    ) -> Optional[Symbol]:
        """Find a symbol in inherited members by name and kind."""
        syms = inherited.get(name, [])
        for s in syms:
            if s.kind == kind:
                return s
        return None

    @staticmethod
    def _find_inherited_method(inherited: dict, name: str) -> Optional[Symbol]:
        """Find a METHOD or CONSTRUCTOR in inherited members."""
        syms = inherited.get(name, [])
        for s in syms:
            if s.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
                return s
        return None

    def resolve_identifier(
        self, node, code: bytes, file_path: str, scope: Scope
    ) -> ResolveResult:
        """
        Resolve an identifier node to its declaration.

        This is the main entry point. Given a tree-sitter identifier node,
        determine what it refers to.

        Args:
          node: The tree-sitter identifier node
          code: The raw bytes of the file
          file_path: Path to the file containing the node
          scope: The current scope at the node's position

        Returns a ResolveResult with the resolved symbol.
        """
        name = extract_text_by_bytes(code, node.start_byte, node.end_byte)
        parent = node.parent

        if parent is None:
            return ResolveResult()

        pt = parent.type

        # Determine the reference context based on the parent node type
        # (mirrors JDT's ASTNode.resolveBinding() logic)

        # --- Method/constructor declaration name → it IS the declaration ---
        if pt in ("method_declaration", "constructor_declaration"):
            if parent.child_by_field_name("name") == node:
                kind = (
                    SymbolKind.CONSTRUCTOR
                    if pt == "constructor_declaration"
                    else SymbolKind.METHOD
                )
                return self._resolve_declaration(name, scope, kind=kind)

        # --- Field/variable declaration name → it IS the declaration ---
        if pt == "variable_declarator":
            if parent.child_by_field_name("name") == node:
                return self._resolve_declaration(
                    name, scope
                )  # kind depends on enclosing scope

        # --- Formal parameter → declaration ---
        if pt == "formal_parameter":
            if parent.child_by_field_name("name") == node:
                return self._resolve_declaration(name, scope, kind=SymbolKind.PARAMETER)

        # --- Method invocation name → method reference ---
        if pt == "method_invocation":
            if parent.child_by_field_name("name") == node:
                return self._resolve_method_call(
                    name, node, parent, code, file_path, scope
                )

        # --- Field access → field reference ---
        if pt == "field_access":
            if parent.child_by_field_name("field") == node:
                return self._resolve_field_access(
                    name, node, parent, code, file_path, scope
                )

        # --- scoped_identifier → qualified reference ---
        if pt in ("scoped_identifier", "scoped_type_identifier"):
            return self._resolve_scoped_identifier(
                name, node, parent, code, file_path, scope
            )

        # --- type_identifier → type reference ---
        if node.type == "type_identifier":
            # Check parent context
            if pt in (
                "class_declaration",
                "interface_declaration",
                "enum_declaration",
                "record_declaration",
            ):
                if parent.child_by_field_name("name") == node:
                    return self._resolve_declaration(name, scope)  # class decl
            return self._resolve_type_reference(name, file_path, scope)

        # --- Standalone identifier → variable/parameter/field ---
        # Check if it's a declaration first
        if pt == "local_variable_declaration":
            # The variable_declarator's name is a declaration
            pass  # handled by variable_declarator case above

        # General reference: walk the scope chain
        return self._resolve_simple_name(name, file_path, scope)

    def resolve_method_call(
        self,
        method_name: str,
        receiver_name: Optional[str],
        file_path: str,
        scope: Scope,
    ) -> ResolveResult:
        """
        Resolve a method call like `obj.method()` or bare `method()`.

        Args:
          method_name: The name of the method being called
          receiver_name: The name of the receiver variable (None for bare calls)
          file_path: The current file
          scope: The current scope at the call site

        Returns the resolved method symbol.
        """
        # Bare call: check local methods, then inherited, then static imports
        if receiver_name is None:
            # First, check the scope chain for the method name
            result = self._resolve_simple_name(method_name, file_path, scope)
            if result.resolved:
                return result

            # Check static imports
            imports = self.project.get_import_table(file_path)
            if imports and imports.is_static_import(method_name):
                return ResolveResult(is_external=True)

            return ResolveResult()

        # Qualified call: receiver.method()
        # Resolve the receiver first
        receiver_result = self._resolve_simple_name(receiver_name, file_path, scope)
        receiver_sym = receiver_result.symbol

        if receiver_sym and receiver_sym.type_annotation:
            # Try to resolve the method on the receiver's declared type
            receiver_type = receiver_sym.type_annotation
            return self._resolve_method_on_type(method_name, receiver_type, file_path)

        # Check special receivers
        if receiver_name == "this":
            return self._resolve_method_on_this(method_name, file_path, scope)

        if receiver_name == "super":
            return self._resolve_method_on_super(method_name, file_path, scope)

        # If receiver type can't be resolved, check if method is project-internal
        # by looking for any method with this name in project classes
        candidates = self.project.symbols.get_by_simple_name(method_name)
        project_methods = [
            s
            for s in candidates
            if s.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR)
        ]

        if project_methods:
            return ResolveResult(symbol=project_methods[0])
        return ResolveResult(is_external=True)

    # ------------------------------------------------------------------
    # Internal resolution methods
    # ------------------------------------------------------------------

    def _resolve_declaration(
        self, name: str, scope: Scope, kind: Optional[SymbolKind] = None
    ) -> ResolveResult:
        """Resolve a declaration name with optional kind filter."""
        sym = scope.resolve_chain(name, kind)
        if sym:
            return ResolveResult(symbol=sym)

        # Fallback: search global symbol table for any symbol with this name
        # that was declared in the project (handles MethodScope symbols
        # that are not persisted across indexing and rename walks).
        candidates = self.project.symbols.get_by_simple_name(name)
        project_syms = [
            s
            for s in candidates
            if s.kind
            not in (
                SymbolKind.CLASS,
                SymbolKind.INTERFACE,
                SymbolKind.ENUM,
                SymbolKind.RECORD,
                SymbolKind.UNKNOWN,
            )
        ]
        if project_syms:
            # Prefer the one whose location is in the same file as the scope
            file_scope = self._find_file_scope(scope)
            if file_scope:
                same_file = [
                    s
                    for s in project_syms
                    if s.location.file_path == file_scope.file_path
                ]
                if same_file:
                    if len(same_file) == 1:
                        return ResolveResult(symbol=same_file[0])
                    # Multiple: prefer the one declared closest (by byte position)
                    same_file.sort(key=lambda s: s.location.start_byte)
                    return ResolveResult(symbol=same_file[0])
            return ResolveResult(symbol=project_syms[0])
        return ResolveResult()

    def _resolve_inner_class(self, name: str, scope: Scope) -> Optional[Symbol]:
        """Resolve a short name to an inner class via enclosing class hierarchy."""
        # Try scope chain first
        class_scope = self._find_enclosing_class_scope(scope)
        if class_scope:
            fqcn = class_scope.class_symbol.qualified_name
            to_check = [fqcn] + self.project.class_hierarchy.get(fqcn, [])
            for cls_fqcn in to_check:
                inner_fqcn = cls_fqcn + "." + name
                sym = self.project.get_class_symbol(inner_fqcn)
                if sym:
                    return sym

        # Fallback: search class scopes by file path
        file_scope = self._find_file_scope(scope)
        if file_scope and file_scope.file_path:
            for fqcn, cs in self.project._class_scopes.items():
                if cs.class_symbol.location.file_path == file_scope.file_path:
                    to_check = [fqcn] + self.project.class_hierarchy.get(fqcn, [])
                    for cls_fqcn in to_check:
                        inner_fqcn = cls_fqcn + "." + name
                        sym = self.project.get_class_symbol(inner_fqcn)
                        if sym:
                            return sym
                    break
        return None

    def _resolve_simple_name(
        self, name: str, file_path: str, scope: Scope
    ) -> ResolveResult:
        """
        Resolve a simple (unqualified) name.

        Priority order (JLS §6.5.1):
          1. Local variable / parameter in current scope chain
          2. Field in current class or inherited
          3. Method in current class or inherited
          4. Single-type import
          5. Same-package class
          6. On-demand import
          7. java.lang
        """
        # 1. Scope chain (locals, params, fields, methods in enclosing class)
        sym = scope.resolve_chain(name)
        if sym:
            return ResolveResult(symbol=sym)

        # 1b. Fallback: search global symbol table for local variables / params
        #     (MethodScope symbols are not persisted across indexing and rename walks)
        candidates = self.project.symbols.get_by_simple_name(name)
        local_syms = [
            s
            for s in candidates
            if s.kind
            in (
                SymbolKind.VARIABLE,
                SymbolKind.PARAMETER,
                SymbolKind.FIELD,
                SymbolKind.METHOD,
                SymbolKind.CONSTRUCTOR,
            )
            and s.location.file_path == file_path
        ]
        if local_syms:
            # If only one, use it
            if len(local_syms) == 1:
                return ResolveResult(symbol=local_syms[0])
            # Multiple candidates with same name: prefer the one with
            # the closest start_byte (most local scope wins — local vars
            # and params are declared closer to their references)
            local_syms.sort(key=lambda s: s.location.start_byte)
            return ResolveResult(symbol=local_syms[0])

        # 1c. Check static imports for cross-file symbol resolution
        #     e.g., import static com.example.util.TypeHelper.type;
        imports = self.project.get_import_table(file_path)
        if imports:
            origin_fqcn = imports.get_static_import_origin(name)
            if origin_fqcn:
                class_sym = self.project.get_class_symbol(origin_fqcn)
                if class_sym:
                    inherited = self.project.get_inherited_members(origin_fqcn) or {}
                    # Try field first, then method
                    sym = self._find_inherited(inherited, name, SymbolKind.FIELD)
                    if not sym:
                        sym = self._find_inherited_method(inherited, name)
                    if sym:
                        return ResolveResult(symbol=sym)

        # 2-7. Type resolution via imports
        return self._resolve_type_reference(name, file_path, scope)

    def _resolve_type_reference(
        self, name: str, file_path: str, scope: Optional[Scope] = None
    ) -> ResolveResult:
        """
        Resolve a type identifier to a class declaration.

        Checks imports, same-package, and java.lang.
        """
        imports = self.project.get_import_table(file_path)
        if imports is None:
            return ResolveResult()

        candidates = imports.resolve_all_candidates(name)

        # Check each candidate against the symbol table
        for candidate in candidates:
            class_sym = self.project.get_class_symbol(candidate)
            if class_sym:
                return ResolveResult(symbol=class_sym)

        # Inner class: check enclosing scope (e.g., Builder → Option.Builder)
        if scope is not None:
            inner = self._resolve_inner_class(name, scope)
            if inner:
                return ResolveResult(symbol=inner)

        # Global inner class fallback: search all project classes for any
        # inner class with this name (handles .new Inner() patterns).
        # Only returns if exactly one match exists (avoids ambiguity).
        matches = []
        for fqcn in self.project._class_symbol_by_qname:
            if fqcn.endswith("." + name):
                sym = self.project.get_class_symbol(fqcn)
                if sym:
                    matches.append(sym)
        if len(matches) == 1:
            return ResolveResult(symbol=matches[0])

        # Check if it's a JDK class (via java.lang)
        if name in JAVA_LANG_AUTO_IMPORTS:
            return ResolveResult(is_external=True)

        # Check if any candidate starts with java/javax
        for candidate in candidates:
            if (
                candidate.startswith("java.")
                or candidate.startswith("javax.")
                or candidate.startswith("jdk.")
            ):
                return ResolveResult(is_external=True)

        return ResolveResult()

    def _resolve_method_call(
        self, method_name: str, node, parent, code: bytes, file_path: str, scope: Scope
    ) -> ResolveResult:
        """
        Resolve a method_invocation's name node.

        The parent is the method_invocation node.
        """
        # Check if it has a receiver (object)
        obj = parent.child_by_field_name("object")

        if obj is None:
            # Bare call: this.method() or static import
            return self._resolve_bare_method_call(method_name, file_path, scope)

        # Qualified call: obj.method() or ClassName.staticMethod()
        obj_text = extract_text_by_bytes(code, obj.start_byte, obj.end_byte)

        if obj_text == "this":
            return self._resolve_method_on_this(method_name, file_path, scope)

        if obj_text == "super":
            return self._resolve_method_on_super(method_name, file_path, scope)

        # Resolve obj's type
        obj_result = self._resolve_simple_name(obj_text, file_path, scope)
        obj_sym = obj_result.symbol

        if obj_sym is not None:
            # The receiver is a variable with a known type
            if obj_sym.type_annotation:
                return self._resolve_method_on_type(
                    method_name, obj_sym.type_annotation, file_path
                )
            # obj_sym might be a class (static call)
            if obj_sym.kind in (
                SymbolKind.CLASS,
                SymbolKind.INTERFACE,
                SymbolKind.ENUM,
            ):
                return self._resolve_method_on_class(
                    method_name, obj_sym.qualified_name
                )

        # If obj_text starts with uppercase, it might be a static class reference
        if obj_text and obj_text[0].isupper():
            type_result = self._resolve_type_reference(obj_text, file_path, scope)
            if type_result.symbol:
                return self._resolve_method_on_class(
                    method_name, type_result.symbol.qualified_name
                )

        # Can't resolve receiver type — check if method is project-internal
        return self._resolve_method_by_name(method_name)

    def _resolve_bare_method_call(
        self, method_name: str, file_path: str, scope: Scope
    ) -> ResolveResult:
        """
        Resolve a method call without explicit receiver: method().

        Could be:
          1. this.method() — method in current class or inherited
          2. Static import — method from another class
          3. Local method reference (unlikely but possible)
        """
        # Check scope chain for the method
        sym = scope.resolve_chain(method_name)
        if sym and sym.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
            return ResolveResult(symbol=sym)

        # Check static imports - resolve to project symbol if source is project class
        imports = self.project.get_import_table(file_path)
        if imports and imports.is_static_import(method_name):
            origin_fqcn = imports.get_static_import_origin(method_name)
            if origin_fqcn and self.project.is_project_class(origin_fqcn):
                inherited = self.project.get_inherited_members(origin_fqcn) or {}
                sym = self._find_inherited_method(inherited, method_name)
                if sym:
                    return ResolveResult(symbol=sym)
            return ResolveResult(is_external=True)

        # Check if it's a method in any project class (could be inherited)
        candidates = self.project.symbols.get_by_simple_name(method_name)
        project_methods = [
            s
            for s in candidates
            if s.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR)
        ]

        if project_methods:
            # Prefer methods from the current class's hierarchy
            return ResolveResult(symbol=project_methods[0])

        return ResolveResult(is_external=True)

    def _resolve_method_on_this(
        self, method_name: str, file_path: str, scope: Scope
    ) -> ResolveResult:
        """Resolve this.method() — look in current class and ancestors."""
        # Find the enclosing class scope
        class_scope = self._find_enclosing_class_scope(scope)
        if class_scope is None:
            return ResolveResult()

        class_fqcn = class_scope.class_symbol.qualified_name

        # Check own class scope
        sym = class_scope.resolve(method_name)
        if sym and sym.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
            return ResolveResult(symbol=sym)

        # Check inherited members
        inherited = self.project.get_inherited_members(class_fqcn) or {}
        sym = self._find_inherited_method(inherited, method_name)
        if sym:
            return ResolveResult(symbol=sym)

        return ResolveResult()

    def _resolve_method_on_super(
        self, method_name: str, file_path: str, scope: Scope
    ) -> ResolveResult:
        """Resolve super.method() — look in parent class only."""
        class_scope = self._find_enclosing_class_scope(scope)
        if class_scope is None:
            return ResolveResult()

        class_sym = class_scope.class_symbol
        hierarchy = self.project.class_hierarchy.get(class_sym.qualified_name, [])

        for ancestor_fqcn in hierarchy:
            inherited = self.project.class_inherited_members.get(ancestor_fqcn) or {}
            sym = self._find_inherited_method(inherited, method_name)
            if sym:
                return ResolveResult(symbol=sym)

        return ResolveResult()

    def _resolve_method_on_type(
        self, method_name: str, type_name: str, file_path: str
    ) -> ResolveResult:
        """
        Resolve a method call on a variable of a given declared type.

        type_name is the declared type from the variable declaration.
        This is a simple type name — needs to be resolved via imports.
        """
        imports = self.project.get_import_table(file_path)
        if imports is None:
            return ResolveResult()

        # Resolve the type name
        type_result = self._resolve_type_reference(type_name, file_path)
        if type_result.symbol:
            return self._resolve_method_on_class(
                method_name, type_result.symbol.qualified_name
            )
        if type_result.is_external:
            return ResolveResult(is_external=True)

        return ResolveResult()

    def _resolve_method_on_class(
        self, method_name: str, class_fqcn: str
    ) -> ResolveResult:
        """
        Resolve a method call on a known class type.

        Checks the class itself, then inherited members.
        """
        class_sym = self.project.get_class_symbol(class_fqcn)
        if class_sym is None:
            return ResolveResult()

        # Check the class's own scope
        file_scope = self.project.files.get(class_sym.location.file_path)

        # Check inherited members (filter by method kind)
        inherited = self.project.get_inherited_members(class_fqcn) or {}
        sym = self._find_inherited_method(inherited, method_name)
        if sym:
            return ResolveResult(symbol=sym)

        # Check all methods in the symbol table that belong to this class
        prefix = f"{class_fqcn}."
        for sym in self.project.symbols:
            if sym.qualified_name.startswith(prefix) and sym.name == method_name:
                if sym.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
                    return ResolveResult(symbol=sym)

        return ResolveResult()

    def _resolve_method_by_name(self, method_name: str) -> ResolveResult:
        """
        Find any project method with the given name.
        Used as fallback when receiver type can't be resolved.
        """
        candidates = self.project.symbols.get_by_simple_name(method_name)
        project_methods = [
            s
            for s in candidates
            if s.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR)
        ]

        if project_methods:
            if len(project_methods) == 1:
                return ResolveResult(symbol=project_methods[0])
            return ResolveResult(
                symbol=project_methods[0], is_ambiguous=True, candidates=project_methods
            )
        return ResolveResult(is_external=True)

    def _resolve_field_access(
        self, field_name: str, node, parent, code: bytes, file_path: str, scope: Scope
    ) -> ResolveResult:
        """
        Resolve a field_access node: obj.field or ClassName.staticField.
        """
        obj = parent.child_by_field_name("object")
        if obj is None:
            return ResolveResult()

        obj_text = extract_text_by_bytes(code, obj.start_byte, obj.end_byte)

        # this.field
        if obj_text == "this":
            return self._resolve_field_on_this(field_name, scope)

        # super.field
        if obj_text == "super":
            return self._resolve_field_on_super(field_name, scope)

        # Nested field_access: this.x.y → resolve this.x first, then find y
        if obj.type == "field_access":
            inner_result = self._resolve_field_access(
                extract_text_by_bytes(
                    code,
                    obj.child_by_field_name("field").start_byte,
                    obj.child_by_field_name("field").end_byte,
                ),
                obj.child_by_field_name("field"),
                obj,
                code,
                file_path,
                scope,
            )
            if inner_result.symbol and inner_result.symbol.type_annotation:
                type_result = self._resolve_type_reference(
                    inner_result.symbol.type_annotation, file_path, scope
                )
                if type_result.symbol:
                    return self._resolve_field_on_class(
                        field_name, type_result.symbol.qualified_name
                    )
                if type_result.is_external:
                    return ResolveResult(is_external=True)

        # ClassName.staticField or obj.field
        # Try to resolve obj as a type first
        type_result = self._resolve_type_reference(obj_text, file_path, scope)
        if type_result.symbol:
            return self._resolve_field_on_class(
                field_name, type_result.symbol.qualified_name
            )
        if type_result.is_external:
            return ResolveResult(is_external=True)

        # obj is a variable — resolve its type, then find field on type
        var_result = self._resolve_simple_name(obj_text, file_path, scope)
        if var_result.symbol and var_result.symbol.type_annotation:
            type_name = var_result.symbol.type_annotation
            type_result2 = self._resolve_type_reference(type_name, file_path, scope)
            if type_result2.symbol:
                return self._resolve_field_on_class(
                    field_name, type_result2.symbol.qualified_name
                )
            if type_result2.is_external:
                return ResolveResult(is_external=True)

        # Final fallback: search global symbol table for any project field
        # with this name. Only returns if exactly one match (avoids ambiguity).
        field_matches = [
            s
            for s in self.project.symbols.get_by_simple_name(field_name)
            if s.kind == SymbolKind.FIELD
        ]
        if len(field_matches) == 1:
            return ResolveResult(symbol=field_matches[0])

        return ResolveResult(is_external=True)

    def _resolve_field_on_this(self, field_name: str, scope: Scope) -> ResolveResult:
        """Resolve this.field."""
        class_scope = self._find_enclosing_class_scope(scope)
        if class_scope is None:
            return ResolveResult()

        # Check own scope
        sym = class_scope.resolve(field_name)
        if sym and sym.kind == SymbolKind.FIELD:
            return ResolveResult(symbol=sym)

        # Check inherited
        class_fqcn = class_scope.class_symbol.qualified_name
        inherited = self.project.get_inherited_members(class_fqcn) or {}
        sym = self._find_inherited(inherited, field_name, SymbolKind.FIELD)
        if sym:
            return ResolveResult(symbol=sym)

        return ResolveResult()

    def _resolve_field_on_super(self, field_name: str, scope: Scope) -> ResolveResult:
        """Resolve super.field."""
        class_scope = self._find_enclosing_class_scope(scope)
        if class_scope is None:
            return ResolveResult()

        hierarchy = self.project.class_hierarchy.get(
            class_scope.class_symbol.qualified_name, []
        )
        for ancestor_fqcn in hierarchy:
            inherited = self.project.class_inherited_members.get(ancestor_fqcn) or {}
            sym = self._find_inherited(inherited, field_name, SymbolKind.FIELD)
            if sym:
                return ResolveResult(symbol=sym)

        return ResolveResult()

    def _resolve_field_on_class(
        self, field_name: str, class_fqcn: str
    ) -> ResolveResult:
        """Resolve a static field on a type: ClassName.field."""
        class_sym = self.project.get_class_symbol(class_fqcn)
        if class_sym is None:
            return ResolveResult()

        # Check inherited members (filter by field kind)
        inherited = self.project.get_inherited_members(class_fqcn) or {}
        sym = self._find_inherited(inherited, field_name, SymbolKind.FIELD)
        if sym:
            return ResolveResult(symbol=sym)

        # Search symbol table
        prefix = f"{class_fqcn}."
        for sym in self.project.symbols:
            if sym.qualified_name.startswith(prefix) and sym.name == field_name:
                if sym.kind == SymbolKind.FIELD:
                    return ResolveResult(symbol=sym)

        # Not a field — try inner class (e.g., Rule.Phoneme.COMPARATOR)
        inner_fqcn = f"{class_fqcn}.{field_name}"
        inner_sym = self.project.get_class_symbol(inner_fqcn)
        if inner_sym:
            return ResolveResult(symbol=inner_sym)

        return ResolveResult()

    def _resolve_scoped_identifier(
        self, name: str, node, parent, code: bytes, file_path: str, scope: Scope
    ) -> ResolveResult:
        """
        Resolve the rightmost part of a scoped identifier like Outer<?>.Inner.
        Strips generics from scope before resolution.
        """
        # Get full text and strip generics: "BaseGenericObjectPool<?>.Evictor" → "BaseGenericObjectPool.Evictor"
        full_text = extract_text_by_bytes(code, parent.start_byte, parent.end_byte)
        clean_text = full_text.split("<")[0] if "<" in full_text else full_text
        # If full text had generics, reconstruct: scope.N name
        if "<" in full_text:
            scope_end = full_text.rfind(".")
            if scope_end > 0:
                clean_text = full_text[:scope_end].split("<")[0] + "." + name

        imports = self.project.get_import_table(file_path)
        if imports and imports.package_name:
            fqcn = imports.package_name + "." + clean_text
            sym = self.project.get_class_symbol(fqcn)
            if sym:
                return ResolveResult(symbol=sym)

        # Try two-step: resolve scope part (strip generics), then lookup
        scope_node = parent.child_by_field_name("scope")
        if scope_node:
            if scope_node.type == "generic_type":
                # Extract base type without generics
                base_node = (
                    scope_node.child_by_field_name("name") or scope_node.children[0]
                )
                scope_text = extract_text_by_bytes(
                    code, base_node.start_byte, base_node.end_byte
                )
            else:
                scope_text = extract_text_by_bytes(
                    code, scope_node.start_byte, scope_node.end_byte
                )
            scope_result = self._resolve_type_reference(scope_text, file_path, scope)
            if scope_result.symbol:
                inner_fqcn = scope_result.symbol.qualified_name + "." + name
                sym = self.project.get_class_symbol(inner_fqcn)
                if sym:
                    return ResolveResult(symbol=sym)

        return self._resolve_simple_name(name, file_path, scope)

    # ------------------------------------------------------------------
    # Utility
    # ------------------------------------------------------------------

    def _find_enclosing_class_scope(self, scope: Scope) -> Optional[ClassScope]:
        """Walk up the scope chain to find the nearest ClassScope."""
        current: Optional[Scope] = scope
        while current is not None:
            if isinstance(current, ClassScope):
                return current
            current = current.parent
        return None

    def _find_enclosing_method_scope(self, scope: Scope) -> Optional[MethodScope]:
        """Walk up the scope chain to find the nearest MethodScope."""
        current: Optional[Scope] = scope
        while current is not None:
            if isinstance(current, MethodScope):
                return current
            current = current.parent
        return None

    def _find_file_scope(self, scope: Scope) -> Optional[FileScope]:
        """Walk up the scope chain to find the FileScope."""
        current: Optional[Scope] = scope
        while current is not None:
            if isinstance(current, FileScope):
                return current
            current = current.parent
        return None
