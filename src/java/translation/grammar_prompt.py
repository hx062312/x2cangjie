"""
Part 2: Cangjie grammar / EBNF prompt injection.

Inspired by *Grammar Prompting for Domain-Specific Language Generation with
Large Language Models* (Wang et al., ACL 2023) and *DocCGen* (Pimparkhede et al.,
EMNLP 2024): providing the target language's grammar as an EBNF excerpt inside
the prompt — without needing constrained decoding — already measurably improves
syntactic correctness for low-resource / domain-specific target languages.
Cangjie is exactly that: a new language whose presence in the LLM's pretraining
corpus is minimal, so explicit grammar rules act as a hard-syntax reminder.

The block is loaded from `configs/prompt_templates.yaml` (`cangjie_grammar_context`
+ `cangjie_grammar_runtime_note`) so the rules remain editable without touching
Python. See those template entries for the authoritative EBNF excerpt; the
versions kept here are only fallbacks used if the config file is unavailable.

Public API:
    build_grammar_prompt()  -> str
        Returns the concatenated grammar + runtime-notes prompt block, ready to
        append to a translation prompt. Empty string on failure (callers should
        treat absence gracefully).
"""

import os
from typing import Optional

import yaml


_THIS_DIR = os.path.dirname(os.path.abspath(__file__))
_TEMPLATE_PATH = os.path.join(
    _THIS_DIR, "..", "..", "..", "configs", "prompt_templates.yaml"
)
_TEMPLATE_PATH = os.path.normpath(_TEMPLATE_PATH)


# ---------------------------------------------------------------------------
# Fallback content (kept short; the authoritative version lives in
# configs/prompt_templates.yaml so non-engineers can edit it)
# ---------------------------------------------------------------------------

_FALLBACK_GRAMMAR = """\
### Cangjie Grammar Reference (EBNF excerpt — must obey in output)
# Distilled from Cangjie language spec Appendix A (official BNF, v0.53.12).

# Type
type         ::= arrowType | tupleType | prefixType | atomicType
arrowType    ::= "(" [ type { "," type } ] ")" "->" type
prefixType   ::= "?" type
atomicType   ::= numericType | "Rune" | "Bool" | "Unit" | "Nothing" | "This" | userType
numericType  ::= "Int8" | "Int16" | "Int32" | "Int64" | "IntNative"
              | "UInt8" | "UInt16" | "UInt32" | "UInt64" | "UIntNative"
              | "Float16" | "Float32" | "Float64"
userType     ::= (identifier ".")* identifier ["<" type { "," type } ">"]

# Variable
var_decl     ::= variableModifier* ("let" | "var" | "const") IDENT [":" type] ["=" expression]

# Function
func_def     ::= funcModifier* "func" identifier [typeParameters] functionParameters [":" type] [genericConstraints] [block]
funcParams   ::= "(" [unnamedParam {"," unnamedParam} ["," namedParam {"," namedParam}]] ")"
unnamedParam ::= (identifier | "_") ":" type
namedParam   ::= identifier "!" ":" type
genericConstraints ::= "where" (identifier | "This") "<:" type { "&" type }

# Class / interface / struct / enum
class_def    ::= classModifier* "class" identifier [typeParameters] ["<:" superClassOrInterfaces] [genericConstraints] classBody
classModifier::= "public" | "protected" | "internal" | "private" | "abstract" | "open"
interface_def::= interfaceModifier* "interface" identifier [typeParameters] ["<:" superInterfaces] [genericConstraints] interfaceBody
interfaceModifier ::= "public" | "protected" | "internal" | "private" | "open"
struct_def   ::= structModifier* "struct" identifier [typeParameters] ["<:" superInterfaces] [genericConstraints] structBody
enum_def     ::= enumModifier* "enum" identifier [typeParameters] ["<:" superInterfaces] [genericConstraints] "{" enumBody "}"

# Constructor
class_init   ::= (classNonStaticMemberModifier | "const")? "init" functionParameters block

# Control flow
if_expr      ::= "if" "(" [ "let" deconstructPattern "<-" ]? expression ")" block ["else" (if_expr | block)]
for_in_expr  ::= "for" "(" patternsMaybeIrrefutable "in" expression [patternGuard] ")" block
while_expr   ::= "while" "(" [ "let" deconstructPattern "<-" ]? expression ")" block
do_while_expr::= "do" block "while" "(" expression ")"
try_expr     ::= "try" block ("catch" "(" catchPattern ")" block)+ ["finally" block]
match_expr   ::= "match" "(" expression ")" "{" matchCase+ "}"
matchCase    ::= "case" pattern [patternGuard] "=>" expressionOrDeclaration
return_expr  ::= "return" [expression]

# Lambda (Cangjie uses => not Java ->)
lambda_expr  ::= "{" [lambdaParameters] "=>" expressionOrDeclarations? "}"
lambdaParameter ::= (identifier | "_") [":" type]

# Patterns
pattern      ::= constantPattern | "_" | identifier | tuplePattern | typePattern | enumPattern
tuplePattern ::= "(" pattern ("," pattern)+ ")"
typePattern  ::= ("_" | identifier) ":" type
enumPattern  ::= [(userType ".") identifier enumPatternParams?]

Constraints:
  G1. Generic bounds: `where T <: Bound` (NOT extends/super). No wildcards.
  G2. Declaration-site variance: `out T` / `in T`.
  G3. `Any` does NOT satisfy `Hashable & Equatable<T>` — use `AnyHashable` for any
      HashMap key / HashSet element type.
  G4. Boolean type is `Bool` (not `boolean`); `Unit` for void functions.
  G5. String interpolation: `"${expr}"`, not Java String.format / `"%" + x`.
  G6. In match expression: `case pattern => body` (DOUBLE_ARROW), NOT `case x: body`.
  G7. Lambda uses `=>` inside `{ }`: `{ params => body }`. Java `->` is for function types only.
"""

_FALLBACK_RUNTIME = """\
RUNTIME NOTES (names you MUST NOT use; equivalent mappings):
  Object (HashMap/HashSet key/elt)  -> AnyHashable
  Runnable -> () -> Unit   Callable<V> -> () -> V   Function<T,R> -> (T) -> R
  Consumer<T> -> (T) -> Unit   Supplier<T> -> () -> T
  Predicate<T> -> (T) -> Bool   Comparator<T> -> (T, T) -> Int64
  ThreadFactory -> () -> Thread
  List<T> -> Array<T>   Map<K,V> -> HashMap<K,V>   Set<T> -> HashSet<T>
"""


# ---------------------------------------------------------------------------
# Cached template content
# ---------------------------------------------------------------------------

_cache: Optional[dict] = None


def _load_templates() -> dict:
    """Load (and cache) the `templates:` section of configs/prompt_templates.yaml.

    On any failure returns an empty dict so the caller falls back to the inline
    content above.
    """
    global _cache
    if _cache is not None:
        return _cache
    try:
        if not os.path.exists(_TEMPLATE_PATH):
            _cache = {}
            return _cache
        with open(_TEMPLATE_PATH, encoding="utf-8") as f:
            raw = yaml.safe_load(f) or {}
        _cache = raw.get("templates", {}) or {}
        return _cache
    except Exception:
        _cache = {}
        return _cache


def reset_cache() -> None:
    """Clear the cached templates — used by tests after editing the YAML."""
    global _cache
    _cache = None


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def build_grammar_prompt() -> str:
    """Compose the Cangjie grammar + runtime-notes prompt block.

    Returns an empty string only when everything fails — callers should still
    short-circuit on the `--use_grammar_prompt` flag themselves.
    """
    tpls = _load_templates()
    grammar = tpls.get("cangjie_grammar_context") or _FALLBACK_GRAMMAR
    runtime = tpls.get("cangjie_grammar_runtime_note") or _FALLBACK_RUNTIME
    return f"{grammar}\n{runtime}"


# ---------------------------------------------------------------------------
# Singleton getter used by PromptGenerator
# ---------------------------------------------------------------------------

_instance: Optional[str] = None


def get_grammar_prompt() -> str:
    """Return the (cached) grammar prompt block. Built once, reused thereafter."""
    global _instance
    if _instance is None:
        _instance = build_grammar_prompt()
    return _instance