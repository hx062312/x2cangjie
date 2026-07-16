# Fragment Translation Prompt Anatomy

本文说明当前 fragment translation 实际会向模型发送哪些 prompt 区块、每个区块从哪里生成，以及它们在真实项目中长什么样。

## 1. 本文使用的真实样例

样例来自当前工作区的 `commons-csv`：

```text
project:       commons-csv
class:         CSVParser
fragment:      getHeaderMap
fragment key:  542-549:getHeaderMap
model:         deepseek-chat
schema:        data/java/schemas_evosuite_cleaned_base/deepseek-chat/0.0/commons-csv/
```

对应 Java 方法：

```java
public Map<String, Integer> getHeaderMap() {
    if (this.headers.headerMap == null) {
        return null;
    }
    final Map<String, Integer> map = createEmptyHeaderMap();
    map.putAll(this.headers.headerMap);
    return map;
}
```

本文在 2026-07-16 从当前代码和当前检索索引实际构造 prompt。RAG、KB 和 pseudocode 是运行时数据，不同时间或不同 KB 状态下内容可能变化。

## 2. 一次 fragment 翻译涉及的 LLM 请求

### 2.1 Pseudocode 关闭

只发送一次主翻译请求：

```text
system message
  -> main translation user prompt
  -> JSON-like model response
  -> extract method
  -> cjpm build
```

### 2.2 Pseudocode 开启

先发送一次独立的 pseudocode 请求，再发送主翻译请求：

```text
Java fragment
  -> pseudocode system + user prompt
  -> cache one pseudocode result
  -> main translation prompt
  -> cjpm build
  -> compile feedback retry reuses the same pseudocode
```

实现位置：

- `src/java/translation/compositional_translation_validation.py::_generate_pseudocode`
- `src/java/translation/compositional_translation_validation.py::translate`
- `src/java/translation/prompt_generator.py::PromptGenerator`

## 3. 主翻译请求的 system message

所有主翻译请求都使用这个 system message：

```text
You are a Java to Cangjie code translation expert. You output only valid JSON.
```

实现位置：`compositional_translation_validation.py::prompt_model`。

`deepseek-chat` 当前没有启用 API 的强制 JSON mode，只依赖 system message 和 user prompt 中的文字约束。GPT-4 系列才会附带：

```json
{
  "type": "json_object"
}
```

它只保证输出是 JSON object，并不保证一定包含 `method` 字段。

## 4. 主翻译 user prompt 的完整顺序

```text
Instruction
-> Grammar                         [use_grammar_prompt=true]
-> Java source                     [always]
-> Pseudocode                      [use_pseudocode=true]
-> Partial Cangjie skeleton        [always]
-> Generics rules                  [source contains generic syntax and a rule matches]
-> Progressive KB examples         [use_progressive_kb=true and retrieval hits]
-> Standard RAG documentation      [use_rag=true and retrieval hits]
-> Syntax Graph RAG examples       [use_syntax_rag=true and retrieval hits]
-> Adaptive ICL                    [always]
-> Previous incorrect translation [retry only]
-> Compilation feedback            [retry only]
-> JSON response instruction       [always]
```

实际拼装顺序在 `PromptGenerator.build_base_prompt()`。

## 5. Instruction

### 5.1 作用

告诉模型只翻译当前 fragment，使用 Cangjie 函数签名，并且只输出 JSON。

### 5.2 当前实际文本

`CSVParser.getHeaderMap()` 首次翻译时是：

```text
### Instruction:
Translate the following Java method to Cangjie. You only need to translate the
"getHeaderMap" method. All necessary dependencies are available in partial
Cangjie translation.

IMPORTANT: Use COLON (:) for return type in function signatures, NOT arrow (->).
Example: func foo(): Int64 { ... } NOT func foo() -> Int64 { ... }

You MUST output ONLY valid JSON (no markdown, no code fences). The JSON must
have these fields:
- 'class': (optional) the complete class definition
- 'method': ONLY the translated method (with signature). This field will be
  inserted into the skeleton.
- 'reasoning': (optional) your reasoning about the translation
- 'imports': (optional) any additional imports needed as a comma-separated string
```

重试时第一段会改为：

```text
Based on the feedback provided, identify the error in the following Cangjie
translation of the method and correct it.
```

实现位置：`PromptGenerator.add_instruction()`。

## 6. Grammar

### 6.1 启用条件

```text
use_grammar_prompt=true
```

### 6.2 作用

提供 Cangjie 的声明、泛型和控制流语法。Grammar 只描述语法，不再负责 Java 到 Cangjie 的类型映射。

### 6.3 当前实际形态

```text
### Cangjie Grammar Reference (EBNF excerpt - must obey in output)

var_decl  ::= "let" IDENT ":" TYPE "=" EXPR
            | "var" IDENT ":" TYPE "=" EXPR
TYPE      ::= IDENT [ "<" TYPE { "," TYPE } ">" ]
func_decl ::= "func" IDENT "(" [ PARAMS ] ")" [ ":" TYPE ] "{" STMTS "}"

if_stmt    ::= "if" "(" COND ")" BLOCK [ "else" BLOCK ]
while_stmt ::= "while" "(" COND ")" BLOCK
for_stmt   ::= "for" "(" IDENT [ ":" TYPE ] "in" EXPR ")" BLOCK
return_stmt ::= "return" [ EXPR ]

TYPE AUTHORITY:
  Field types, parameter types, return types, generic arguments, and imports in
  the partial Cangjie skeleton are generated from schema translated_target_type
  values. They are authoritative.
```

真实完整区块为 2,562 字符，来源：

- `configs/prompt_templates.yaml:cangjie_grammar_context`
- `configs/prompt_templates.yaml:cangjie_grammar_runtime_note`
- `src/java/translation/grammar_prompt.py`

## 7. Java source

### 7.1 作用

Java 是行为、控制流、变量和值语义的权威来源。

### 7.2 如何生成

PromptGenerator 不一定只放裸方法。它会把当前方法和方法体引用到的同类字段放进一个 class wrapper。

### 7.3 本例实际文本

```java
class CSVParser {
private final CSVParser_Headers headers;

public Map<String, Integer> getHeaderMap() {
    if (this.headers.headerMap == null) {
        return null;
    }
    final Map<String, Integer> map = createEmptyHeaderMap();
    map.putAll(this.headers.headerMap);
    return map;
}
}
```

实现位置：

- `PromptGenerator.load_fragment()`
- `PromptGenerator.add_source_code()`

## 8. Pseudocode

### 8.1 启用条件

```text
use_pseudocode=true
```

### 8.2 独立的 pseudocode 请求

System prompt 要求模型保持 Java 行为和控制流，但改写成语言无关的伪代码。User prompt 形态：

```text
JAVA FRAGMENT (method "getHeaderMap"):
```

后接 Java class wrapper，并要求：

```text
1. 输出一个 fenced pseudocode block
2. 使用 FOR / WHILE / IF / ELSE / RETURN / BREAK
3. Java API 调用改写成高层语义描述
4. 每个逻辑块前放置 // 注释
5. 不提及任何目标语言
6. 保持控制流顺序和变量名
```

### 8.3 注入主 prompt 的形态

下面的内容是说明形态；其中伪代码正文由 LLM 在运行时生成：

```text
### Semantic Bridge (pseudocode)
The pseudocode below is supplementary guidance for understanding the Java
fragment. The partial Cangjie skeleton is authoritative for declarations and
types, and the Java source is authoritative for behavior.

```

```text
IF the internal header map is absent, RETURN no value.
OTHERWISE create a new empty header map, copy all entries, and RETURN the copy.
```

同一 fragment 的所有编译重试复用同一份 pseudocode，不会重新生成。

## 9. Partial Cangjie skeleton

### 9.1 作用

这是类型和声明的权威来源。它包含由 schema `translated_target_type` 生成的签名，以及翻译当前 fragment 所需的局部依赖。

### 9.2 可能包含的内容

- Cangjie imports
- 当前类声明
- 当前 fragment 的精确 skeleton 签名
- 当前 fragment 引用的同类字段
- 父类、内部类和外部类声明
- dependencies 中相关类和字段
- call graph 中相关被调用方法
- 已成功翻译 fragment 的 translation
- 尚未翻译 fragment 的 TODO skeleton

### 9.3 本例实际文本

```cangjie
open class CSVParser_CSVRecordIterator {
}

class CSVParser_Headers {
}
    var headerMap: HashMap<String, Int32> = throw Exception('TODO')

public class CSVParser {
    var headers: CSVParser_Headers = throw Exception('TODO')

    private func createEmptyHeaderMap(): HashMap<String, Int32> {
        throw Exception('TODO')
    }

    public open func getHeaderMap(): HashMap<String, Int32> {
        throw Exception('TODO')
    }
```

这里可以看到类型解析结果已经进入 skeleton：

```text
Java Map<String, Integer>
-> schema translated_target_type
-> Cangjie HashMap<String, Int32>
```

实现位置：`PromptGenerator.build_partial_translation()`。

## 10. Generics rules

### 10.1 启用条件

当前 fragment 源码包含泛型相关文本，并且 Generics Rule Library 能匹配到规则。

### 10.2 本例实际结果

```text
generics_context = ""
```

虽然 Java 中有 `Map<String, Integer>`，当前规则库没有为这个方法体返回匹配规则，所以该区块实际不会出现在本例 prompt 中。

### 10.3 命中时的真实格式

```text
### Applicable Generics Mapping Rules:
The following rules from the Java->Cangjie generics mapping library apply to this code.

Rule <rule-id> (<rule-name>):
  Java:
    <java example>
  Cangjie:
    <cangjie example>
  Note: <rule note>
  Semantics: <semantic constraint>
  Action: <translation action>
```

最多注入 3 条规则。实现位置：`GenericsRuleLib.format_rule_prompt()`。

## 11. Progressive KB

### 11.1 启用条件

```text
use_progressive_kb=true
```

KB 按 Java 代码和涉及类型检索最多 3 个已验证翻译对。

### 11.2 本例实际结果

当前清理后的全局 KB 没有检索到可用示例：

```text
kb_context = ""
```

所以本例 prompt 中没有 KB 区块。

### 11.3 命中时的真实格式

````text
### Reference: Translation Examples (Java -> Cangjie)
The following are verified translation examples from similar code patterns.

### Example 1 [auto]
// Source: <class>.<fragment>
```java
<verified Java fragment>
```
== translates to ==
```cangjie
<compile-verified Cangjie fragment>
```
// [verified] Compile-verified
````

实现位置：`ProgressiveKnowledgeBase.format_few_shot_prompt()`。

## 12. Standard RAG documentation

### 12.1 启用条件

```text
use_rag=true
```

### 12.2 作用

从 Cangjie 文档语料检索与当前 Java fragment 相关的语言手册和标准库文档。

### 12.3 本例实际命中

本例命中了 3 段 HashMap 文档，总计约 3,641 字符，主题包括：

- 修改 HashMap
- 访问 HashMap 成员
- HashMap 的 get/add/contains

实际区块节选：

````text
### Reference Cangjie documentation:
### Reference [Source: Language Manual]
[Context: HashMap > 修改 HashMap]

HashMap 是一种可变的引用类型，HashMap 类型提供了修改元素、添加元素、
删除元素的功能。

```cangjie
let map = HashMap<String, Int64>()
map.add("a", 0)
map.add("b", 1)
```
````

当前拼装代码会额外再添加一次 `### Reference Cangjie documentation:`，因此实际 full prompt 中这个标题会重复两次。

实现位置：

- `src/java/rag/__init__.py`
- `src/java/rag/injector.py::format_for_fragment_translation`
- `PromptGenerator.build_base_prompt()`

## 13. Syntax Graph RAG

### 13.1 启用条件

```text
use_syntax_rag=true
```

### 13.2 作用

按控制流 shape、调用名和容器类型的 Jaccard 相似度检索最多 3 个 Cangjie 代码片段。

### 13.3 本例实际命中

本例注入了 3 个结构示例，总计约 1,916 字符：

```text
### Structural Examples (retrieved from CangjieCorpus)

-- example 1 (http_server.md) --
```

```cangjie
class NaiveDistributor <: HttpRequestDistributor {
    let map = HashMap<String, HttpRequestHandler>()

    public func distribute(path: String): HttpRequestHandler {
        if (path == "/index") {
            return PageHandler()
        }
        return NotFoundHandler()
    }
}
```

另外两个示例分别来自 `HashSet` size 判断和一个 `onWillDismiss` 回调。它们只在结构上相似，并不保证 API 或类型与 `CSVParser` 兼容。

实现位置：`src/java/rag/syntax_graph.py`。

## 14. Adaptive ICL

### 14.1 作用

如果 fragment 中出现已知 assertion，会生成 assertion translation 示例；否则使用 fragment 类型对应的固定翻译提示。

### 14.2 本例实际文本

```text
Java method translation pattern:
Java: public int add(int a, int b) { return a + b; }
Cangjie: public func add(a: Int64, b: Int64): Int64 { return a + b }
```

实现位置：`PromptGenerator.construct_adaptive_icl()`。

注意：这是当前仍存在的遗留冲突。最新类型解析使用 `int -> Int32`，但这个固定 ICL 示例仍写成 `Int64`。它可能与 partial skeleton 的精确签名冲突。

## 15. Retry-only prompt

编译或 JSON 提取失败后，PromptGenerator 会重新构建主 prompt，并在末尾追加两个区块。

### 15.1 Previous incorrect translation

````text
Incorrect Cangjie translation:
```cangjie
class CSVParser {
    public open func getHeaderMap(): HashMap<String, Int32> {
        <previous failed translation>
    }
}
```
````

### 15.2 Execution feedback

```text
Execution feedback:
```

```text
### Corrective Reference:
<documents retrieved from the compilation error>

error: mismatched types
... expected HashMap<String, Int32> ...
```

反馈会累计，后续重试能看到之前所有反馈。Pseudocode 不会重新生成，但 Grammar、KB、RAG、Syntax RAG 和 ICL 会随 PromptGenerator 重建而再次加载或检索。

## 16. JSON response instruction

Prompt 末尾固定追加：

```text
### Response:
Output ONLY the JSON object with your translation in the "method" field.
```

期望输出形态：

```json
{
  "method": "public open func getHeaderMap(): HashMap<String, Int32> { ... }",
  "reasoning": "...",
  "imports": "..."
}
```

字段 fragment 目前仍使用同一个 `method` JSON key，提取器再把其中代码写回对应 field skeleton。

## 17. 本例全开 prompt 的实际规模

| 区块 | 本例字符数 | 是否出现 |
|---|---:|---|
| Grammar | 2,562 | 是 |
| Java source | 约 360 | 是 |
| Pseudocode bridge | 取决于 LLM | 是 |
| Partial skeleton | 435 | 是 |
| Generics rules | 0 | 否 |
| Progressive KB | 0 | 否 |
| Standard RAG | 3,641 | 是 |
| Syntax Graph RAG | 1,916 | 是 |
| Adaptive ICL | 155 | 是 |
| Full initial user prompt | 约 10,409 | 是 |

## 18. 全关与全开的真实差异

当前 pipeline 中的“全关”不是关闭所有中间件。

### 全关

```text
use_rag=true
use_progressive_kb=true
use_pseudocode=false
use_grammar_prompt=false
use_syntax_rag=false
```

因此全关仍包含：

```text
Instruction
-> Java
-> Partial skeleton
-> Generics rules
-> Progressive KB
-> Standard RAG
-> Adaptive ICL
-> JSON response
```

### 全开

在全关基础上增加：

```text
Grammar
Pseudocode
Syntax Graph RAG
```

## 19. 当前已确认的 prompt 风险

1. Adaptive ICL 的 `int -> Int64` 与当前 `translated_target_type` 路线冲突。
2. Standard RAG 标题被拼装两次。
3. Syntax RAG 只保证结构相似，不保证 API 和类型相容。
4. DeepSeek 没有 API 级 JSON schema，只依赖文字指令，因此可能缺少 `method` 字段。
5. Retry 会累计反馈并重新执行多种检索，prompt 会越来越长。
