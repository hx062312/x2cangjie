"""
Java Renamer — JDT-inspired semantic rename engine.

Imitates Eclipse JDT Core's approach to safe Java renaming:
  1. Build a project-wide Symbol Table (all declarations across all files)
  2. Resolve every identifier reference to its declaration via scope-chain walking
  3. Collect all references to a target declaration
  4. Apply renames atomically with conflict validation

Architecture mirrors JDT LS's RenameHandler → RenameSupport → *Processor chain:
  - ProjectIndexer   ≈ ASTParser + CompilationUnit resolution
  - ScopeResolver    ≈ IBinding / ITypeBinding resolution
  - RenameEngine     ≈ RenameSupport + *Processor
  - RenamePlan       ≈ Change objects (TextFileChange)

Unlike tree-sitter alone (syntax-only), this module adds a semantic layer:
  - Scope-based name resolution (not heuristic regex matching)
  - Import resolution (single-type, on-demand, static imports)
  - Inheritance tracking (fields, methods up the class hierarchy)
  - Per-file ImportTable for type→FQCN resolution
  - Explicit reference tracking (declaration→all references)

Usage:
  from src.java.preprocessing.java_renamer import JavaProject, RenameEngine

  project = JavaProject("projects/java/commons-cli")
  project.index()

  engine = RenameEngine(project)
  plan = engine.plan_keyword_renames(
      keywords={'type', 'init', 'in', 'is', 'func', 'match'},
      field_suffix='__',
      method_suffix='_',
      variable_suffix='__',
  )
  engine.apply(plan)
"""

from src.java.preprocessing.java_renamer.indexer import (
    ImportTable,
    JavaProject,
)
from src.java.preprocessing.java_renamer.renamer import (
    Edit,
    RenameEngine,
    RenamePlan,
    rename_keyword_conflicts,
)
from src.java.preprocessing.java_renamer.resolver import (
    ResolveResult,
    ScopeResolver,
)
from src.java.preprocessing.java_renamer.symbols import (
    AccessModifier,
    BlockScope,
    ClassDecl,
    ClassScope,
    Declaration,
    EnumConstantDecl,
    FieldDecl,
    FileScope,
    Location,
    MethodDecl,
    MethodScope,
    ParameterDecl,
    Scope,
    Symbol,
    SymbolKind,
    SymbolTable,
    VariableDecl,
)

__all__ = [
    # Symbols
    "Symbol",
    "SymbolKind",
    "AccessModifier",
    "Declaration",
    "ClassDecl",
    "FieldDecl",
    "MethodDecl",
    "VariableDecl",
    "ParameterDecl",
    "EnumConstantDecl",
    "Scope",
    "FileScope",
    "ClassScope",
    "MethodScope",
    "BlockScope",
    "SymbolTable",
    "Location",
    # Indexer
    "JavaProject",
    "ImportTable",
    # Resolver
    "ScopeResolver",
    "ResolveResult",
    # Renamer
    "RenamePlan",
    "RenameEngine",
    "Edit",
    "rename_keyword_conflicts",
]
