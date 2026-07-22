"""
Rename Engine — JDT-inspired safe rename planner and executor.

Mirrors JDT's RenameSupport + *Processor chain:
  1. Plan: collect all references to target declarations
  2. Validate: check for naming conflicts
  3. Apply: execute edits in descending byte-order (to preserve positions)

Supports:
  - Keyword conflict renaming (Cangjie keyword → suffixed name)
  - General declaration renaming with full reference tracking
  - Cross-file renaming (references in other files are updated)

Design note (JDT parallel):
  - RenamePlan    ≈ Change objects (TextFileChange)
  - collect_refs  ≈ *Processor.checkInitialConditions + findReferences
  - apply         ≈ CreateChangeOperation + perform
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from typing import Optional

from src.java.preprocessing._shared import _skip_dir, extract_text_by_bytes, load_parser
from src.java.preprocessing.java_renamer.indexer import ImportTable, JavaProject
from src.java.preprocessing.java_renamer.resolver import ResolveResult, ScopeResolver
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
)

# ---------------------------------------------------------------------------
# Edit — a single text replacement
# ---------------------------------------------------------------------------


@dataclass
class Edit:
    """A single text replacement in a source file."""

    file_path: str
    start_byte: int
    end_byte: int
    new_text: str
    old_text: str = ""
    reason: str = ""  # e.g. "declaration", "reference from Foo.bar()"

    def __post_init__(self):
        # Sort by (file_path, -start_byte) for reverse-order application
        self._sort_key = (self.file_path, -self.start_byte)

    def __lt__(self, other: Edit) -> bool:
        return self._sort_key < other._sort_key


# ---------------------------------------------------------------------------
# RenamePlan — collection of edits
# ---------------------------------------------------------------------------


@dataclass
class RenamePlan:
    """A planned set of renames, ready for validation and application."""

    edits: list[Edit] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
    renamed_symbols: dict[str, str] = field(
        default_factory=dict
    )  # old_qname → new_name

    def add_edit(self, edit: Edit) -> None:
        self.edits.append(edit)

    def add_warning(self, msg: str) -> None:
        self.warnings.append(msg)

    def add_error(self, msg: str) -> None:
        self.errors.append(msg)

    @property
    def is_valid(self) -> bool:
        return len(self.errors) == 0

    @property
    def file_count(self) -> int:
        return len(set(e.file_path for e in self.edits))

    @property
    def edit_count(self) -> int:
        return len(self.edits)


# ---------------------------------------------------------------------------
# RenameEngine
# ---------------------------------------------------------------------------


class RenameEngine:
    """
    Plans and executes safe Java renames across a project.

    Usage:
      project = JavaProject("projects/java/foo")
      project.index()

      engine = RenameEngine(project)
      plan = engine.plan_rename(
          file_path="Foo.java",
          line=10, col=5,
          new_name="type_"
      )
      engine.apply(plan)
    """

    def __init__(self, project: JavaProject):
        self.project: JavaProject = project
        self.resolver: ScopeResolver = ScopeResolver(project)
        self._parser = None

    # ------------------------------------------------------------------
    # JDT-inspired: Rename availability check
    #   ≈ RefactoringAvailabilityTesterCore.isRenameElementAvailable()
    # ------------------------------------------------------------------

    def check_rename_available(self, symbol: Symbol) -> tuple:
        """Check if a symbol can be safely renamed. Returns (available, reason)."""
        if symbol.kind == SymbolKind.UNKNOWN or symbol.is_external():
            return (False, "unresolved or external symbol")
        if symbol.kind in (
            SymbolKind.CLASS,
            SymbolKind.INTERFACE,
            SymbolKind.ENUM,
            SymbolKind.RECORD,
        ):
            if "$" in symbol.name or symbol.name.isdigit():
                return (False, "generated or anonymous class")
        return (True, "ok")

    # ------------------------------------------------------------------
    # JDT-inspired: Virtual method detection
    #   ≈ MethodChecks.isVirtual() → RenameVirtualMethodProcessor
    # ------------------------------------------------------------------

    def _is_virtual_method(self, method_sym: Symbol) -> bool:
        """Check if a method is virtual (overridable)."""
        if method_sym.kind != SymbolKind.METHOD:
            return False
        if AccessModifier.PRIVATE in method_sym.modifiers:
            return False
        if method_sym.is_static or method_sym.is_final:
            return False
        return True

    def _find_overriding_methods(self, method_sym: Symbol) -> list:
        """Find methods that override or are overridden by this method."""
        if not self._is_virtual_method(method_sym):
            return []
        overrides = []
        method_name = method_sym.name
        method_params = len(method_sym.parameters)
        qname = method_sym.qualified_name
        last_dot = qname.rfind(".")
        if last_dot < 0:
            return []
        class_fqcn = qname[:last_dot]
        # Walk UP hierarchy
        for ancestor_fqcn in self.project.class_hierarchy.get(class_fqcn, []):
            inherited = self.project.class_inherited_members.get(ancestor_fqcn) or {}
            syms = inherited.get(method_name, [])
            for am in syms:
                if am.kind == SymbolKind.METHOD and len(am.parameters) == method_params:
                    overrides.append(am)
        # Walk DOWN hierarchy
        for child_fqcn, ancestors in self.project.class_hierarchy.items():
            if class_fqcn in ancestors:
                inherited = self.project.class_inherited_members.get(child_fqcn) or {}
                syms = inherited.get(method_name, [])
                for cm in syms:
                    if (
                        cm.kind == SymbolKind.METHOD
                        and AccessModifier.PRIVATE not in cm.modifiers
                        and len(cm.parameters) == method_params
                        and cm.qualified_name != method_sym.qualified_name
                    ):
                        overrides.append(cm)
        return overrides

    # ------------------------------------------------------------------
    # JDT-inspired: Getter/setter pair detection
    #   ≈ UPDATE_GETTER_METHOD / UPDATE_SETTER_METHOD flags
    # ------------------------------------------------------------------

    @staticmethod
    def _getter_name(field_name: str) -> str:
        c = field_name[0].upper() + field_name[1:] if field_name else ""
        return f"get{c}"

    @staticmethod
    def _setter_name(field_name: str) -> str:
        c = field_name[0].upper() + field_name[1:] if field_name else ""
        return f"set{c}"

    def _find_getter_setter_pairs(self, field_sym: Symbol) -> tuple:
        """Find getter and setter methods for a field."""
        qname = field_sym.qualified_name
        last_dot = qname.rfind(".")
        if last_dot < 0:
            return (None, None)
        class_fqcn = qname[:last_dot]
        inherited = self.project.class_inherited_members.get(class_fqcn) or {}
        getter_name = self._getter_name(field_sym.name)
        setter_name = self._setter_name(field_sym.name)
        getter = None
        setter = None
        for s in inherited.get(getter_name, []):
            if s.kind == SymbolKind.METHOD:
                getter = s
                break
        for s in inherited.get(setter_name, []):
            if s.kind == SymbolKind.METHOD:
                setter = s
                break
        return (getter, setter)

    # ------------------------------------------------------------------
    # Public API: keyword conflict renaming
    # ------------------------------------------------------------------

    def plan_keyword_renames(
        self,
        keywords: set[str],
        field_suffix: str = "__",
        method_suffix: str = "_",
        variable_suffix: str = "__",
        parameter_suffix: str = "__",
    ) -> RenamePlan:
        """
        Plan renames for all identifiers that conflict with Cangjie keywords.

        This is the main entry point for keyword conflict handling.
        It replaces the heuristic logic in handle_keyword_conflicts.py with
        scope-based resolution.

        For each keyword-conflicting identifier:
          1. Resolve it to its declaration (via ScopeResolver)
          2. If external → skip
          3. If project-internal → plan rename with appropriate suffix
          4. Automatically collect all references across the project

        Args:
          keywords: Set of Cangjie keywords to detect (e.g., {'type', 'init', 'in'})
          field_suffix: Suffix for field renames (default: '__')
          method_suffix: Suffix for method renames (default: '_')
          variable_suffix: Suffix for variable renames (default: '__')
          parameter_suffix: Suffix for parameter renames (default: '__')

        Returns a RenamePlan that can be inspected and applied.
        """
        plan = RenamePlan()
        seen_renames: dict[str, str] = {}  # qualified_name → new_name

        for file_path in list(self.project.files.keys()):
            try:
                with open(file_path, "rb") as f:
                    code = f.read()
            except Exception as e:
                plan.add_warning(f"Cannot read {file_path}: {e}")
                continue

            parser = self._get_parser()
            tree = parser.parse(code)

            # Find the FileScope for this file
            file_scope = self.project.files.get(file_path)
            if file_scope is None:
                continue

            # Walk the AST and find all conflicting identifiers
            self._collect_keyword_conflicts(
                tree.root_node,
                code,
                file_path,
                file_scope,
                keywords,
                seen_renames,
                plan,
                field_suffix,
                method_suffix,
                variable_suffix,
                parameter_suffix,
            )

        return plan

    def _collect_keyword_conflicts(
        self,
        node,
        code: bytes,
        file_path: str,
        scope: Scope,
        keywords: set[str],
        seen_renames: dict[str, str],
        plan: RenamePlan,
        field_suffix: str,
        method_suffix: str,
        variable_suffix: str,
        parameter_suffix: str,
    ) -> None:
        """
        Recursively find identifier nodes matching keywords, resolve them,
        and add rename edits to the plan.

        Maintains scope tracking as we descend into the AST (entering classes,
        methods, blocks creates new scopes).
        """
        nt = node.type

        # Track scope changes
        current_scope = scope

        # --- Class declaration → enter ClassScope ---
        if nt in (
            "class_declaration",
            "interface_declaration",
            "enum_declaration",
            "record_declaration",
        ):
            name_node = node.child_by_field_name("name")
            if name_node:
                class_name = extract_text_by_bytes(
                    code, name_node.start_byte, name_node.end_byte
                )
                # Find the ClassScope for this class
                if isinstance(current_scope, (FileScope, ClassScope)):
                    for name, syms in current_scope.symbols.items():
                        for sym in syms:
                            if name == class_name and sym.kind in (
                                SymbolKind.CLASS,
                                SymbolKind.INTERFACE,
                                SymbolKind.ENUM,
                                SymbolKind.RECORD,
                            ):
                                # Find or create the ClassScope
                                new_scope = self._find_class_scope_for_symbol(
                                    sym, current_scope
                                )
                                if new_scope:
                                    current_scope = new_scope
                                break

        # --- Method declaration → enter MethodScope ---
        if nt in ("method_declaration", "constructor_declaration"):
            name_node = node.child_by_field_name("name")
            if name_node:
                method_name = extract_text_by_bytes(
                    code, name_node.start_byte, name_node.end_byte
                )
                if isinstance(current_scope, ClassScope):
                    sym = current_scope.resolve(method_name)
                    if sym and sym.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
                        ms = self.project.get_method_scope(sym.qualified_name)
                        if ms is not None:
                            current_scope = ms
                        else:
                            current_scope = MethodScope(
                                parent=current_scope, method_symbol=sym
                            )

        # --- Process identifiers ---
        if nt in ("identifier", "type_identifier"):
            name = extract_text_by_bytes(code, node.start_byte, node.end_byte)

            if name not in keywords:
                # Not a keyword conflict — skip
                pass
            else:
                # Resolve this identifier
                result = self.resolver.resolve_identifier(
                    node, code, file_path, current_scope
                )

                if result.is_external or result.symbol is None:
                    # External reference or unresolved — skip
                    pass
                elif result.resolved:
                    sym = result.symbol
                    qname = sym.qualified_name

                    # Determine the suffix based on the declaration's kind
                    suffix = self._get_suffix_for_kind(
                        sym.kind,
                        field_suffix,
                        method_suffix,
                        variable_suffix,
                        parameter_suffix,
                    )

                    new_name = name + suffix

                    # Check if already planned
                    if qname in seen_renames:
                        if seen_renames[qname] != new_name:
                            plan.add_warning(
                                f"Conflicting rename for {qname}: "
                                f"{seen_renames[qname]} vs {new_name}"
                            )
                        # Still add the reference edit
                        if node.start_byte != sym.location.start_byte:
                            plan.add_edit(
                                Edit(
                                    file_path=file_path,
                                    start_byte=node.start_byte,
                                    end_byte=node.end_byte,
                                    new_text=new_name,
                                    old_text=name,
                                    reason=f"reference to {qname}",
                                )
                            )
                    else:
                        # First encounter: plan rename for declaration + this reference
                        seen_renames[qname] = new_name
                        plan.renamed_symbols[qname] = new_name

                        # Add declaration edit
                        plan.add_edit(
                            Edit(
                                file_path=sym.location.file_path,
                                start_byte=sym.location.start_byte,
                                end_byte=sym.location.end_byte,
                                new_text=new_name,
                                old_text=sym.name,
                                reason=f"declaration of {qname} ({sym.kind.name})",
                            )
                        )

                        # If this node is NOT the declaration, add reference edit
                        if (
                            node.start_byte != sym.location.start_byte
                            or file_path != sym.location.file_path
                        ):
                            plan.add_edit(
                                Edit(
                                    file_path=file_path,
                                    start_byte=node.start_byte,
                                    end_byte=node.end_byte,
                                    new_text=new_name,
                                    old_text=name,
                                    reason=f"reference to {qname}",
                                )
                            )

            # Don't return — continue recursing into children
            # (identifiers can appear inside method bodies)

        # --- Block-creating nodes → enter BlockScope ---
        if nt in (
            "block",
            "for_statement",
            "enhanced_for_statement",
            "while_statement",
            "do_statement",
            "if_statement",
            "try_statement",
            "synchronized_statement",
            "lambda_expression",
        ):
            new_scope = BlockScope(parent=current_scope)
            for child in node.children:
                self._collect_keyword_conflicts(
                    child,
                    code,
                    file_path,
                    new_scope,
                    keywords,
                    seen_renames,
                    plan,
                    field_suffix,
                    method_suffix,
                    variable_suffix,
                    parameter_suffix,
                )
            return

        # --- Continue recursion ---
        for child in node.children:
            self._collect_keyword_conflicts(
                child,
                code,
                file_path,
                current_scope,
                keywords,
                seen_renames,
                plan,
                field_suffix,
                method_suffix,
                variable_suffix,
                parameter_suffix,
            )

    # ------------------------------------------------------------------
    # Public API: general rename
    # ------------------------------------------------------------------

    def plan_rename(
        self,
        file_path: str,
        line: int,
        col: int,
        new_name: str,
    ) -> RenamePlan:
        """
        Plan a rename of the Java element at the given position.

        Args:
          file_path: Path to the Java file
          line: 1-based line number
          col: 1-based column number
          new_name: The new name for the element

        Returns a RenamePlan.
        """
        plan = RenamePlan()

        try:
            with open(file_path, "rb") as f:
                code = f.read()
        except Exception as e:
            plan.add_error(f"Cannot read {file_path}: {e}")
            return plan

        parser = self._get_parser()
        tree = parser.parse(code)

        # Convert line/col to byte offset
        byte_offset = self._line_col_to_byte(code, line, col)

        # Find the identifier node at this position
        node = self._find_node_at(tree.root_node, byte_offset)
        if node is None or node.type not in ("identifier", "type_identifier"):
            plan.add_error(f"No identifier found at {file_path}:{line}:{col}")
            return plan

        name = extract_text_by_bytes(code, node.start_byte, node.end_byte)

        # Resolve to declaration
        file_scope = self.project.files.get(file_path)
        if file_scope is None:
            plan.add_error(f"File not indexed: {file_path}")
            return plan

        result = self.resolver.resolve_identifier(node, code, file_path, file_scope)

        if result.is_external:
            plan.add_error(f"'{name}' is an external/JDK reference — cannot rename")
            return plan

        if result.symbol is None:
            plan.add_error(f"Cannot resolve '{name}' to a declaration")
            return plan

        sym = result.symbol

        # Plan: rename declaration + all references
        self._plan_rename_for_symbol(sym, new_name, plan)

        return plan

    def _plan_rename_for_symbol(
        self,
        sym: Symbol,
        new_name: str,
        plan: RenamePlan,
    ) -> None:
        """
        Rename a symbol and all its references across the project.

        This does a full project scan to find all references to the symbol.
        """
        old_name = sym.name
        plan.renamed_symbols[sym.qualified_name] = new_name

        # 1. Rename the declaration itself
        plan.add_edit(
            Edit(
                file_path=sym.location.file_path,
                start_byte=sym.location.start_byte,
                end_byte=sym.location.end_byte,
                new_text=new_name,
                old_text=old_name,
                reason=f"declaration of {sym.qualified_name} ({sym.kind.name})",
            )
        )

        # 1b. If renaming a class, also rename its constructors
        if sym.kind in (
            SymbolKind.CLASS,
            SymbolKind.INTERFACE,
            SymbolKind.ENUM,
            SymbolKind.RECORD,
        ):
            prefix = sym.qualified_name + "."
            for other in self.project.symbols:
                if other.qualified_name.startswith(prefix):
                    rest = other.qualified_name[len(prefix) :]
                    if "(" in rest and "." not in rest.split("(")[0]:
                        if other.kind == SymbolKind.CONSTRUCTOR:
                            plan.add_edit(
                                Edit(
                                    file_path=other.location.file_path,
                                    start_byte=other.location.start_byte,
                                    end_byte=other.location.end_byte,
                                    new_text=new_name,
                                    old_text=sym.name,
                                    reason=f"constructor of {sym.qualified_name}",
                                )
                            )
                            plan.renamed_symbols[other.qualified_name] = new_name

        # 2. Scan all files for references (identifiers with the same name
        #    that resolve to the same symbol)
        for file_path in self.project.files:
            try:
                with open(file_path, "rb") as f:
                    code = f.read()
            except Exception:
                continue

            parser = self._get_parser()
            tree = parser.parse(code)

            file_scope = self.project.files.get(file_path)
            if file_scope is None:
                continue

            self._find_and_add_references(
                tree.root_node,
                code,
                file_path,
                file_scope,
                sym,
                old_name,
                new_name,
                plan,
            )

    def _find_and_add_references(
        self,
        node,
        code: bytes,
        file_path: str,
        scope: Scope,
        target_sym: Symbol,
        old_name: str,
        new_name: str,
        plan: RenamePlan,
    ) -> None:
        """
        Recursively find all references to target_sym and add rename edits.

        Skips the declaration location (already added).
        Skips identifiers that are in different scopes (same name, different binding).
        """
        nt = node.type

        # Track scope changes
        current_scope = scope

        # Enter class scope
        if nt in (
            "class_declaration",
            "interface_declaration",
            "enum_declaration",
            "record_declaration",
        ):
            name_node = node.child_by_field_name("name")
            if name_node:
                class_name = extract_text_by_bytes(
                    code, name_node.start_byte, name_node.end_byte
                )
                for name, syms in current_scope.symbols.items():
                    for sym in syms:
                        if name == class_name and sym.kind in (
                            SymbolKind.CLASS,
                            SymbolKind.INTERFACE,
                            SymbolKind.ENUM,
                            SymbolKind.RECORD,
                        ):
                            new_scope = self._find_class_scope_for_symbol(
                                sym, current_scope
                            )
                            if new_scope:
                                current_scope = new_scope
                            break

        # Enter method scope
        if nt in ("method_declaration", "constructor_declaration"):
            name_node = node.child_by_field_name("name")
            if name_node and isinstance(current_scope, ClassScope):
                method_name = extract_text_by_bytes(
                    code, name_node.start_byte, name_node.end_byte
                )
                sym = current_scope.resolve(method_name)
                if sym and sym.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
                    ms = self.project.get_method_scope(sym.qualified_name)
                    if ms is not None:
                        current_scope = ms
                    else:
                        current_scope = MethodScope(
                            parent=current_scope, method_symbol=sym
                        )

        # Process identifier
        if nt in ("identifier", "type_identifier"):
            name = extract_text_by_bytes(code, node.start_byte, node.end_byte)

            if name == old_name:
                # Skip the declaration itself
                if (
                    file_path == target_sym.location.file_path
                    and node.start_byte == target_sym.location.start_byte
                ):
                    pass
                else:
                    # Resolve to check if this is the SAME symbol
                    result = self.resolver.resolve_identifier(
                        node, code, file_path, current_scope
                    )
                    if (
                        result.symbol
                        and result.symbol.qualified_name == target_sym.qualified_name
                    ):
                        plan.add_edit(
                            Edit(
                                file_path=file_path,
                                start_byte=node.start_byte,
                                end_byte=node.end_byte,
                                new_text=new_name,
                                old_text=old_name,
                                reason=f"reference to {target_sym.qualified_name}",
                            )
                        )

        # Enter block scope
        if nt in (
            "block",
            "for_statement",
            "enhanced_for_statement",
            "while_statement",
            "do_statement",
            "if_statement",
            "try_statement",
            "synchronized_statement",
            "lambda_expression",
        ):
            new_scope = BlockScope(parent=current_scope)
            for child in node.children:
                self._find_and_add_references(
                    child,
                    code,
                    file_path,
                    new_scope,
                    target_sym,
                    old_name,
                    new_name,
                    plan,
                )
            return

        for child in node.children:
            self._find_and_add_references(
                child,
                code,
                file_path,
                current_scope,
                target_sym,
                old_name,
                new_name,
                plan,
            )

    # ------------------------------------------------------------------
    # Apply
    # ------------------------------------------------------------------

    def apply(self, plan: RenamePlan, dry_run: bool = False) -> int:
        """
        Apply all edits in a RenamePlan.

        Edits are applied in reverse byte-order per file to preserve positions.

        Args:
          plan: The RenamePlan to apply
          dry_run: If True, only print what would be done

        Returns the number of files modified.
        """
        if not plan.is_valid:
            print(f"[RenameEngine] Plan has {len(plan.errors)} errors, aborting:")
            for err in plan.errors:
                print(f"  ⛔ {err}")
            return 0

        if plan.warnings:
            for w in plan.warnings:
                print(f"  ⚠️  {w}")

        # Group edits by file
        edits_by_file: dict[str, list[Edit]] = {}
        for edit in plan.edits:
            edits_by_file.setdefault(edit.file_path, []).append(edit)

        if dry_run:
            print(f"[RenameEngine] DRY RUN: would modify {len(edits_by_file)} files:")
            for fp, edits in sorted(edits_by_file.items()):
                print(f"  {fp}: {len(edits)} edit(s)")
                for e in edits[:5]:  # Show first 5
                    print(f"    {e.old_text!r} → {e.new_text!r}  ({e.reason})")
                if len(edits) > 5:
                    print(f"    ... and {len(edits) - 5} more")
            return 0

        modified_count = 0
        for file_path, edits in edits_by_file.items():
            try:
                with open(file_path, "rb") as f:
                    code = bytearray(f.read())
            except Exception as e:
                plan.add_error(f"Cannot read {file_path}: {e}")
                continue

            # Sort by start_byte descending (reverse order)
            # so earlier edits don't shift later positions
            edits.sort(key=lambda e: e.start_byte, reverse=True)

            applied_count = 0
            for edit in edits:
                if edit.start_byte < 0 or edit.end_byte > len(code):
                    plan.add_warning(
                        f"Edit out of bounds in {file_path}: "
                        f"bytes {edit.start_byte}-{edit.end_byte}, file len={len(code)}"
                    )
                    continue

                # Verify old text matches
                actual = code[edit.start_byte : edit.end_byte].decode(
                    "utf-8", errors="replace"
                )
                if actual != edit.old_text and edit.old_text:
                    plan.add_warning(
                        f"Old text mismatch in {file_path}: "
                        f"expected {edit.old_text!r}, found {actual!r}"
                    )
                else:
                    code[edit.start_byte : edit.end_byte] = edit.new_text.encode(
                        "utf-8"
                    )
                    applied_count += 1

            if applied_count > 0:
                try:
                    with open(file_path, "wb") as f:
                        f.write(code)
                    modified_count += 1
                    print(f"  ✅ {file_path}: {applied_count} edit(s)")
                except Exception as e:
                    plan.add_error(f"Cannot write {file_path}: {e}")

        print(
            f"[RenameEngine] Applied {plan.edit_count} edits in "
            f"{modified_count} file(s)"
        )
        return modified_count

    # ------------------------------------------------------------------
    # Internal utilities
    # ------------------------------------------------------------------

    def _get_parser(self):
        if self._parser is None:
            self._parser = load_parser()
        return self._parser

    def _get_suffix_for_kind(
        self,
        kind: SymbolKind,
        field_suffix: str,
        method_suffix: str,
        variable_suffix: str,
        parameter_suffix: str,
    ) -> str:
        """Determine the appropriate suffix for a symbol's kind."""
        suffix_map = {
            SymbolKind.FIELD: field_suffix,
            SymbolKind.METHOD: method_suffix,
            SymbolKind.CONSTRUCTOR: method_suffix,
            SymbolKind.VARIABLE: variable_suffix,
            SymbolKind.PARAMETER: parameter_suffix,
            SymbolKind.ENUM_CONSTANT: field_suffix,
        }
        # Default for classes, interfaces, etc. — use field_suffix
        return suffix_map.get(kind, field_suffix)

    def _find_class_scope_for_symbol(
        self, sym: Symbol, current_scope: Scope
    ) -> Optional[ClassScope]:
        """Find the ClassScope corresponding to a class symbol."""
        # Direct lookup via project class scope map (indexed during build)
        cs = self.project.get_class_scope(sym.qualified_name)
        if cs is not None:
            return cs

        # Fallback: search current scope children (for inner classes)
        if isinstance(current_scope, ClassScope):
            for inner in current_scope.inner_scopes:
                if inner.class_symbol.qualified_name == sym.qualified_name:
                    return inner
        return None

    def _find_node_at(self, node, byte_offset: int):
        """
        Find the most specific node at the given byte offset.

        Returns the deepest node that contains the offset.
        """
        if byte_offset < node.start_byte or byte_offset > node.end_byte:
            return None

        # Prefer leaf nodes (identifiers)
        best = node if node.type in ("identifier", "type_identifier") else None

        for child in node.children:
            result = self._find_node_at(child, byte_offset)
            if result is not None:
                return result

        return best

    def _line_col_to_byte(self, code: bytes, line: int, col: int) -> int:
        """Convert 1-based line,col to byte offset in code bytes."""
        lines = code.split(b"\n")
        offset = 0
        for i in range(min(line - 1, len(lines))):
            offset += len(lines[i]) + 1  # +1 for newline
        return offset + col - 1


# ---------------------------------------------------------------------------
# Convenience function — drop-in replacement for handle_keyword_conflicts
# ---------------------------------------------------------------------------


def rename_keyword_conflicts(
    project_dir: str,
    keywords: set[str] | None = None,
    field_suffix: str = "__",
    method_suffix: str = "_",
    variable_suffix: str = "__",
    parameter_suffix: str = "__",
    dry_run: bool = False,
) -> int:
    """
    Convenience function for keyword conflict renaming.

    This is the recommended entry point — it handles the full pipeline:
      index → plan → apply.

    Args:
      project_dir: Path to the Java project directory
      keywords: Set of Cangjie keywords to rename (default: common conflicts)
      field_suffix: Suffix for fields
      method_suffix: Suffix for methods
      variable_suffix: Suffix for local variables
      parameter_suffix: Suffix for parameters
      dry_run: If True, only print the plan without applying

    Returns the number of files modified.
    """
    if keywords is None:
        keywords = {"type", "init", "in", "is", "func", "match"}

    print(f"Indexing project: {project_dir}")
    project = JavaProject(project_dir)
    project.index()

    print(f"Planning keyword renames for: {sorted(keywords)}")
    engine = RenameEngine(project)
    plan = engine.plan_keyword_renames(
        keywords=keywords,
        field_suffix=field_suffix,
        method_suffix=method_suffix,
        variable_suffix=variable_suffix,
        parameter_suffix=parameter_suffix,
    )

    print(f"Plan: {plan.edit_count} edits in {plan.file_count} file(s)")

    if plan.warnings:
        for w in plan.warnings:
            print(f"  ⚠️  {w}")

    if plan.errors:
        for e in plan.errors:
            print(f"  ⛔ {e}")
        return 0

    if dry_run:
        return engine.apply(plan, dry_run=True)

    return engine.apply(plan)
