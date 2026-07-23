## 模型消息结构

最终发给模型的是 chat message：

```json
[
  {
    "role": "system",
    "content": "You are a Java to Cangjie code translation expert. You output only valid JSON."
  },
  {
    "role": "user",
    "content": "<PromptGenerator 生成的大 prompt>"
  }
]
```

其中 user prompt 是真正携带 Java fragment、仓颉骨架、依赖上下文、可选文档和错误反馈的主体。

## Instruction 约束

首轮翻译的 instruction 主要包含：

```text
Translate the following Java <fragment_type> to Cangjie.
You only need to translate the "<fragment_name>" <fragment_type>.
All necessary dependencies are available in partial Cangjie translation.

IMPORTANT: Use COLON (:) for return type in function signatures, NOT arrow (->).

You MUST output ONLY valid JSON.
The JSON must have:
- class: optional complete class definition
- method: translated fragment with signature
- reasoning: optional reasoning
- imports: optional comma-separated imports
```

反馈轮的 instruction 主要变为：

```text
Based on the feedback provided, identify the error in the following Cangjie translation
and correct it.
You only need to correct the current fragment.
Output ONLY valid JSON.
```

## Java Source Code 块

类名 + fragment源代码

```java
class AnsiConsole {
<相关字段>
<当前 fragment Java body>
}
```

字段 fragment 也会这样包裹。例如：

```java
class AnsiConsole {
@Deprecated
public static PrintStream system_out = System.out;
}
```

## Partial Cangjie Translation 块

它来自 schema、skeleton 和依赖图，通常包含：

| 内容                   | 来源/规则                                                                  |
| ---------------------- | -------------------------------------------------------------------------- |
| imports                | schema 里的 `cangjie_imports`                                              |
| 当前类声明             | `cangjie_class_declaration`                                                |
| 当前类相关字段         | 当前 fragment body 中提到的字段，或必要的字段 skeleton                     |
| 依赖类                 | `data/java/dependencies.../dependencies.json`                              |
| 父类                   | 当前类 `extends` 指向的 schema                                             |
| 调用图 callee          | `--include_call_graph` 打开时加入被调用方法                                |
| callee 实现            | `--include_implementation` 打开时优先放已有翻译，否则放 partial skeleton   |
| 当前 fragment skeleton | 当前 fragment 的 `partial_translation`，通常包含 `throw Exception('TODO')` |

`translate_fragment.sh` 默认传入：

```text
--include_call_graph
--include_implementation
```

所以 prompt 会尽量携带调用图相关方法和已有实现。模型实际翻译时主要依赖这个 partial block 来判断可用字段、方法签名、父类关系和当前 TODO 的替换位置。

## RAG 文档块

当 `--use_rag=true` 时，`PromptGenerator` 会调用：

```text
src/java/rag::get_rag_engine()
rag.inject_fragment_context(self.source_fragment_body)
```

它会用当前 Java fragment 构造查询，检索：

```text
misc/CangjieCorpus
```

索引位置：

```text
data/java/rag/chromadb
data/java/rag/bm25_index.pkl
```

检索结果会被插入为：

```text
### Reference Cangjie documentation:
### Reference [Source: Language Manual]
[Context: ...]
...
```

RAG 查询会从 Java fragment 中抽取类型名、API 调用和关键词，并用 `configs/java_cangjie_terms.yaml` 扩展查询词。例如 `List` 会扩展到 `ArrayList`、`Array`、`列表`，`Map` 会扩展到 `HashMap`、`映射`。

## Adaptive ICL 块

字段：

Java field translation pattern:
Java: public int x;
Cangjie: var x: Int64 = 0

方法：

Java method translation pattern:
Java: public int add(int a, int b) { return a + b; }
Cangjie: public func add(a: Int64, b: Int64): Int64 { return a + b }

静态初始化块：

Java static initializer pattern:
Java: static { count = 10; }
Cangjie: static init() { count = 10 }

如果当前 Java fragment 中命中 `data/java/type_resolution/assert_map.json` 里的断言模式，则会构造断言迁移相关的 ICL 示例。

## 反馈轮 Prompt

如果上一轮生成不是合法 JSON，下一轮 feedback 会包含 JSON 解析错误，例如：

```text
Execution feedback:
The output must be valid JSON with 'code' and 'reasoning' fields: ...
```

如果 Cangjie 编译失败，下一轮 prompt 会追加上一轮错误翻译：

```text
Incorrect Cangjie translation:
```

```cangjie
class AnsiConsole {
<上一轮生成的 fragment>
}
```

然后追加编译反馈：

```text
Execution feedback:
```

```text
error: mismatched types
...
```

如果 `--use_rag=true`，编译失败后还会基于错误信息再次检索文档，并把结果拼在 feedback 前：

```text
### Corrective Reference:
The translation above failed Cangjie compilation.
Relevant documentation:
...
```

因此文档 RAG 有两个使用时机：

1. 首轮：根据 Java fragment 检索相关 Cangjie 文档。
2. 反馈轮：根据 Cangjie 编译错误检索修复相关文档。

## 输出约束

模型必须只输出 JSON，不应输出 Markdown 或代码围栏。期望形态：

```json
{
  "method": "static func initStreams(): Unit {\n    ...\n}",
  "reasoning": "optional",
  "imports": "optional.imports"
}
```

字段 fragment 也仍然放在 `"method"` 字段里：

```json
{
  "method": "static var system_out: OutputStream = <Cangjie expression>"
}
```

静态初始化块同理，返回可替换 skeleton 中 TODO 的代码片段。

## 示例：method fragment 的 prompt 形状

真实 fragment：

```text
schema: jansi.src.main.org.fusesource.jansi.AnsiConsole
class: 61-568:AnsiConsole
fragment: 561-567:initStreams
type: method
```

Java body：

```java
static synchronized void initStreams() {
    if (!initialized) {
        out = ansiStream(true);
        err = ansiStream(false);
        initialized = true;
    }
}
```

Prompt 完整内容如下。该版本按 `--use_rag=true` 的正常流程书写：保留当前 fragment 需要的字段 skeleton、当前 TODO 方法 skeleton、RAG 文档块和 Adaptive ICL；不包含泛型规则库，也不包含 Progressive KB few-shot。为避免 Markdown preview 和 prompt 内部代码围栏冲突，外层使用四个反引号，内部保留真实 prompt 的三个反引号。

````text
### Instruction:
Translate the following Java method to Cangjie. You only need to translate the "initStreams" method. All necessary dependencies are available in partial Cangjie translation.

IMPORTANT: Use COLON (:) for return type in function signatures, NOT arrow (->). Example: func foo(): Int64 { ... } NOT func foo() -> Int64 { ... }

You MUST output ONLY valid JSON (no markdown, no code fences). The JSON must have these fields:
- 'class': (optional) the complete class definition
- 'method': ONLY the translated method (with signature). This field will be inserted into the skeleton.
- 'reasoning': (optional) your reasoning about the translation
- 'imports': (optional) any additional imports needed as a comma-separated string

Java code:
```
class AnsiConsole {
@Deprecated    public static PrintStream out;
@Deprecated    public static PrintStream err;
private static boolean initialized;


static synchronized void initStreams() {        if (!initialized) {            out = ansiStream(true);            err = ansiStream(false);            initialized = true;        }    }
}
```

Partial Cangjie translation:
```


public open class AnsiConsole {
static var out: PrintStream = throw Exception('TODO')

static var err: PrintStream = throw Exception('TODO')

static var initialized: Bool = false

    static func initStreams(): Unit {        throw Exception('TODO')    }
}

```

### Reference Cangjie documentation:
### Reference [Source: Language Manual]
[Context: runtime 环境变量使用手册 > runtime 初始化可选配置 > 仓颉 GWP-Asan 内存安全检测]
[Context: runtime 环境变量使用手册 > runtime 初始化可选配置 > 仓颉 GWP-Asan 内存安全检测]

- 仓颉 GWP-Asan 是一种基于采样的内存检查工具，内存越界问题可能无法完全检出。
- 仓颉 GWP-Asan 对仓颉堆内存的越界检测范围有限，无法检测内存读越界访问，仅能检测部分写越界访问：向前写越界 8 字节以内；向后写越界到尾部的填充区域（根据数组对象长度的不同，填充区域可能为 0-7 字节）。

### Reference [Source: Language Manual]
[Context: runtime 环境变量使用手册 > runtime 初始化可选配置 > 仓颉 GWP-Asan 内存安全检测]
[Context: runtime 环境变量使用手册 > runtime 初始化可选配置 > 仓颉 GWP-Asan 内存安全检测]

在仓颉与 C 代码互操作的过程中，可能出现一些仓颉堆内存安全问题。仓颉 GWP-Asan 提供了一种内存安全检测功能。它可以在仓颉程序运行过程中检测代码是否存在仓颉堆内存安全问题。GWP-Asan 通过对仓颉语言标准库提供的 acquireArrayRawData 和 releaseArrayRawData 接口（参见《仓颉编程语言库 API 文档》std.core 包一节）进行采样，并记录对比采样对象前后内存的 Canary 数据，从而检测仓颉与 C 语言互操作过程中是否出现了仓颉堆内存安全问题。

仓颉 GWP-Asan 是一种基于采样的检测工具，可以通过设置不同的值来调整采样频率，以平衡性能影响和检测覆盖率。在默认或更低采样频率下，CPU 性能损失和额外的内存占用极低。

> **说明：**
>
> 仓颉 GWP-Asan 内存安全检测仅支持 Linux 和 OpenHarmony 操作系统。

### Reference [Source: Language Manual]
[Context: runtime 环境变量使用手册 > runtime 初始化可选配置 > 仓颉 GWP-Asan 内存安全检测]
[Context: runtime 环境变量使用手册 > runtime 初始化可选配置 > 仓颉 GWP-Asan 内存安全检测]

仓颉 GWP-Asan 内存安全检测功能默认关闭。通过将环境变量 `cjEnableGwpAsan` 设置为 `1`、`true` 或 `TRUE` 可以开启该功能。Linux 下设置参考如下：

```shell
export cjEnableGwpAsan=true
```

Java method translation pattern:
Java: public int add(int a, int b) { return a + b; }
Cangjie: public func add(a: Int64, b: Int64): Int64 { return a + b }


### Response:
Output ONLY the JSON object with your translation in the "method" field.
````

## 示例：field fragment 的 prompt 形状

真实 fragment：

```text
schema: jansi.src.main.org.fusesource.jansi.AnsiConsole
class: 61-568:AnsiConsole
fragment: 174-175:system_out
type: field
```

Java body：

```java
@Deprecated
public static PrintStream system_out = System.out;
```

Prompt 形状：

```text
### Instruction:
Translate the following Java field to Cangjie...

Java code:
class AnsiConsole {
  @Deprecated
  public static PrintStream system_out = System.out;
}

Partial Cangjie translation:
class AnsiConsole {
  static var system_out: OutputStream = throw Exception('TODO')
}

### Response:
Output ONLY the JSON object with your translation in the "method" field.
```

期望输出仍是 JSON：

```json
{
  "method": "static var system_out: OutputStream = <Cangjie equivalent>"
}
```
