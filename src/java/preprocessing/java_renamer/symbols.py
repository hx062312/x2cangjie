"""
Symbol table data structures — foundation of the JDT-inspired renamer.

Mirrors Eclipse JDT Core's internal model:
  - Symbol          ≈ IBinding (the resolved semantic entity)
  - Scope hierarchy ≈ BlockScope → MethodScope → ClassScope → FileScope
  - SymbolTable     ≈ JavaProject's global index (like JDT's JavaModel)
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum, auto
from typing import Optional

# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------


class SymbolKind(Enum):
    """Java element kind — mirrors org.eclipse.jdt.core.IJavaElement types."""

    CLASS = auto()
    INTERFACE = auto()
    ENUM = auto()
    RECORD = auto()
    FIELD = auto()
    METHOD = auto()
    CONSTRUCTOR = auto()
    VARIABLE = auto()  # local variable
    PARAMETER = auto()  # method/constructor/lambda parameter
    ENUM_CONSTANT = auto()
    PACKAGE = auto()
    UNKNOWN = auto()


class AccessModifier(Enum):
    PUBLIC = auto()
    PROTECTED = auto()
    PACKAGE_PRIVATE = auto()
    PRIVATE = auto()


# ---------------------------------------------------------------------------
# Location
# ---------------------------------------------------------------------------


@dataclass
class Location:
    """A position in a source file, identified by file path + byte range."""

    file_path: str
    start_byte: int
    end_byte: int
    start_line: int = 0
    end_line: int = 0

    def __hash__(self) -> int:
        return hash((self.file_path, self.start_byte, self.end_byte))

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Location):
            return False
        return (
            self.file_path == other.file_path
            and self.start_byte == other.start_byte
            and self.end_byte == other.end_byte
        )


# ---------------------------------------------------------------------------
# Symbol — the core resolved entity
# ---------------------------------------------------------------------------


@dataclass
class Symbol:
    """
    A resolved declaration in the Java project.

    Every Symbol has:
      - kind: what kind of Java element this is
      - name: the simple name (e.g., "type", "init")
      - qualified_name: a project-unique identifier
      - location: where it's declared in source
      - parent: the enclosing scope / declaration (None for top-level classes)
    """

    kind: SymbolKind
    name: str
    qualified_name: str
    location: Location
    parent: Optional[Symbol] = None

    # --- fields & methods only ---
    type_annotation: str = ""  # declared type as written in source
    modifiers: set[AccessModifier] = field(default_factory=set)
    is_static: bool = False
    is_final: bool = False
    is_abstract: bool = False

    # --- methods only ---
    parameters: list[Symbol] = field(default_factory=list)
    return_type: str = ""

    # --- classes only ---
    super_class: str = ""  # FQCN of superclass
    interfaces: list[str] = field(default_factory=list)

    def is_external(self) -> bool:
        """Is this symbol declared outside the project (JDK / third-party)?"""
        return self.kind == SymbolKind.UNKNOWN

    @property
    def signature(self) -> str:
        """A human-readable identifier for this symbol."""
        if self.kind in (SymbolKind.METHOD, SymbolKind.CONSTRUCTOR):
            params = ",".join(p.type_annotation or "?" for p in self.parameters)
            return f"{self.name}({params})"
        return self.name

    def __hash__(self) -> int:
        return hash(self.qualified_name)

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Symbol):
            return False
        return self.qualified_name == other.qualified_name


# ---------------------------------------------------------------------------
# Declarations — AST-level declaration nodes
# ---------------------------------------------------------------------------


@dataclass
class Declaration:
    """A declaration found during indexing (before binding resolution)."""

    name: str
    location: Location
    kind: SymbolKind = SymbolKind.UNKNOWN
    node_id: int = 0  # tree-sitter node id for later lookup


@dataclass
class ClassDecl(Declaration):
    super_class: str = ""
    interfaces: list[str] = field(default_factory=list)
    modifiers: set[AccessModifier] = field(default_factory=set)
    is_static: bool = False
    is_abstract: bool = False

    def __post_init__(self):
        self.kind = SymbolKind.CLASS


@dataclass
class FieldDecl(Declaration):
    type_annotation: str = ""
    modifiers: set[AccessModifier] = field(default_factory=set)
    is_static: bool = False
    is_final: bool = False

    def __post_init__(self):
        self.kind = SymbolKind.FIELD


@dataclass
class MethodDecl(Declaration):
    parameters: list[ParameterDecl] = field(default_factory=list)
    return_type: str = ""
    modifiers: set[AccessModifier] = field(default_factory=set)
    is_static: bool = False
    is_abstract: bool = False

    def __post_init__(self):
        self.kind = SymbolKind.METHOD


@dataclass
class VariableDecl(Declaration):
    type_annotation: str = ""

    def __post_init__(self):
        self.kind = SymbolKind.VARIABLE


@dataclass
class ParameterDecl(Declaration):
    type_annotation: str = ""

    def __post_init__(self):
        self.kind = SymbolKind.PARAMETER


@dataclass
class EnumConstantDecl(Declaration):
    def __post_init__(self):
        self.kind = SymbolKind.ENUM_CONSTANT


# ---------------------------------------------------------------------------
# Scope hierarchy — mirrors JDT's Scope chain
# ---------------------------------------------------------------------------


class Scope:
    """
    A lexical scope in Java source code.

    JDT's scope chain: BlockScope → MethodScope → ClassScope → CompilationUnitScope
    We use: BlockScope → MethodScope → ClassScope → FileScope

    Each scope stores symbols declared within it and has a parent pointer
    for walking up the chain during name resolution.
    """

    def __init__(self, parent: Optional[Scope] = None, name: str = ""):
        self.parent: Optional[Scope] = parent
        self.name: str = name
        # JDT-style: allow same-named field+method (list per name).
        # Callers use resolve(name, kind=...) to disambiguate.
        self.symbols: dict[str, list[Symbol]] = {}

    def define(self, symbol: Symbol) -> None:
        """Register a symbol (appends, never overwrites)."""
        self.symbols.setdefault(symbol.name, []).append(symbol)

    def resolve(self, name: str, kind: Optional[SymbolKind] = None) -> Optional[Symbol]:
        """
        Look up a name in this scope (does NOT walk up).
        If kind is given, returns first match of that kind.
        """
        syms = self.symbols.get(name, [])
        if kind is not None:
            for s in syms:
                if s.kind == kind:
                    return s
            return None
        return syms[0] if syms else None

    def resolve_chain(
        self, name: str, kind: Optional[SymbolKind] = None
    ) -> Optional[Symbol]:
        """Full scope-chain resolution with optional kind filter."""
        current: Optional[Scope] = self
        while current is not None:
            sym = current.resolve(name, kind)
            if sym is not None:
                return sym
            current = current.parent
        return None

    def __repr__(self) -> str:
        return f"{type(self).__name__}(name={self.name!r}, symbols={list(self.symbols.keys())})"


class FileScope(Scope):
    """
    Top-level scope for a single .java file.

    Contains:
      - Package declaration
      - Import table (separate, not in symbols dict)
      - Top-level type declarations
    """

    def __init__(self, file_path: str, package_name: str = ""):
        super().__init__(parent=None, name=file_path)
        self.file_path: str = file_path
        self.package_name: str = package_name


class ClassScope(Scope):
    """
    Scope for a class/interface/enum/record declaration.

    Contains fields, methods, inner classes. Inherits from parent class scope
    and implemented interfaces.
    """

    def __init__(self, parent: Scope, class_symbol: Symbol):
        super().__init__(parent=parent, name=class_symbol.qualified_name)
        self.class_symbol: Symbol = class_symbol
        self.inner_scopes: list[ClassScope] = []


class MethodScope(Scope):
    """
    Scope for a method/constructor/static-initializer body.

    Contains parameters and local variables declared in the method body.
    """

    def __init__(self, parent: Scope, method_symbol: Symbol):
        super().__init__(parent=parent, name=method_symbol.qualified_name)
        self.method_symbol: Symbol = method_symbol


class BlockScope(Scope):
    """
    Scope for any block statement: if-body, for-body, while-body, try-catch, etc.
    Also used for lambda bodies.
    """

    pass


# ---------------------------------------------------------------------------
# SymbolTable — project-wide index (≈ JDT's JavaModel)
# ---------------------------------------------------------------------------


class SymbolTable:
    """
    Global symbol table for a Java project.

    Indexes all declarations across all files for cross-file reference resolution.
    Organized as a two-level lookup:
      - By qualified name (exact match)
      - By simple name → list of candidates (for disambiguation)
    """

    def __init__(self):
        # qualified_name → Symbol (exact lookup)
        self._by_qname: dict[str, Symbol] = {}
        # simple_name → list[Symbol] (candidate lookup)
        self._by_simple: dict[str, list[Symbol]] = {}
        # All symbols indexed (for iteration)
        self._all: list[Symbol] = []

    def add(self, symbol: Symbol) -> None:
        """Register a symbol in the table."""
        self._by_qname[symbol.qualified_name] = symbol
        self._by_simple.setdefault(symbol.name, []).append(symbol)
        self._all.append(symbol)

    def get_by_qname(self, qualified_name: str) -> Optional[Symbol]:
        """Exact qualified-name lookup."""
        return self._by_qname.get(qualified_name)

    def get_by_simple_name(self, name: str) -> list[Symbol]:
        """Get all symbols with the given simple name."""
        return self._by_simple.get(name, [])

    def remove(self, symbol: Symbol) -> None:
        """Remove a symbol from the table."""
        self._by_qname.pop(symbol.qualified_name, None)
        candidates = self._by_simple.get(symbol.name, [])
        if symbol in candidates:
            candidates.remove(symbol)
        if symbol in self._all:
            self._all.remove(symbol)

    def __len__(self) -> int:
        return len(self._all)

    def __iter__(self):
        return iter(self._all)

    def __contains__(self, symbol: Symbol) -> bool:
        return symbol.qualified_name in self._by_qname
