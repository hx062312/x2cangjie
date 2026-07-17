# commons-csv Baseline 类型错误实例分析

## 1. 分析对象

本文分析 commons-csv 五组消融实验中的 baseline 结果：

```text
project=commons-csv
model=deepseek-chat
temperature=0.0
use_rag=true
use_progressive_kb=false
use_pseudocode=false
use_grammar_prompt=false
use_syntax_rag=false
```

原始结果位于：

```text
data/java/ablation/commons-csv_deepseek-chat_0.0_evosuite_cleaned_base/
  five_run_20260717_013028/baseline/
```

该轮共有 381 个 fragment：

| 指标 | 数量 |
|---|---:|
| 编译成功 | 264 |
| 编译失败 | 115 |
| Pending | 2 |
| 报告编译率 | 264 / 381 = 69.3% |
| 有效 fragment 编译率 | 264 / 379 = 69.7% |

由于本轮 `translate_tests=false` 且跳过 mock，本报告只能评价编译结果，不能评价语义正确性。

失败 fragment 会在快照中回退成 `throw Exception('TODO')`。下文的“实际生成代码”来自各 fragment 保存的 `cangjie_compilation.message`，即编译器真正看到并报错的代码行。

## 2. 类型相关问题占比

按编译器的第一个错误重新分类，115 个失败如下：

| 错误类型 | 数量 | 失败占比 |
|---|---:|---:|
| 未声明标识符或类型 | 36 | 31.3% |
| 成员或 API 映射错误 | 27 | 23.5% |
| 类型、运算符、转换错误 | 20 | 17.4% |
| 语法或代码结构错误 | 19 | 16.5% |
| 泛型实参缺失 | 5 | 4.3% |
| 调用参数数量错误 | 4 | 3.5% |
| 初始化、赋值、构造错误 | 4 | 3.5% |

严格口径下，直接类型错误为：

```text
类型、运算符、转换错误 20
+ 泛型实参缺失          5
= 25 / 115 = 21.7%
```

如果把迁移中的类型语义也计入：

```text
直接类型和泛型错误               25
null/nil 与 Option 语义丢失      16
未解析的库类型                    约 4
继承丢失导致 receiver 退化       约 4
合计                              约 49 / 115 = 42.6%
```

因此，可以将结论概括为：

- 约 22% 是编译器直接报告的类型错误。
- 约 40% 与完整的类型处理链路有关。
- 这不代表约 40% 都能通过扩充 `Java 类型 -> 仓颉类型` 映射表解决。

## 3. 实例一：类型映射正确，但调用点没有转换

### Java 原文

```java
static long copy0(final Reader input, final Appendable output) throws IOException {
    return copy1(input, output, CharBuffer.allocate(DEFAULT_BUFFER_SIZE));
}
```

### type_resolution 结果

```text
long       -> Int64
Reader     -> StringReader<ByteBuffer>
Appendable -> StringWriter<ByteBuffer>
int        -> Int32
```

这些类型映射本身是符合当前规则的。

### 实际生成代码

```cangjie
return copy1(input, output, ByteBuffer(DEFAULT_BUFFER_SIZE))
```

### 编译错误

```text
expected 'Int64', found 'Int32'
```

`DEFAULT_BUFFER_SIZE` 来自 Java `int`，因此被正确解析成 `Int32`。但仓颉 `ByteBuffer(size)` 构造函数要求 `Int64`。

### 应生成的核心写法

```cangjie
return copy1(
    input,
    output,
    ByteBuffer(Int64(DEFAULT_BUFFER_SIZE))
)
```

### 根因与责任模块

这不是 `int -> Int32` 解析错误。真正缺少的是：

```text
目标 API 参数类型 -> 调用点显式转换
```

应由 fragment translation 的目标 API 适配或 expected-type 转换处理，不能把所有 Java `int` 全局改成 `Int64`。

## 4. 实例二：Map 泛型解析正确，但 nullable 丢失

### Java 原文

```java
public boolean isConsistent() {
    final Map<String, Integer> headerMap = getHeaderMapRaw();
    return headerMap == null || headerMap.size() == values.length;
}
```

### type_resolution 结果

```text
Map<String, Integer> -> HashMap<String, Int32>
boolean              -> Bool
```

`Map<String, Integer>` 的泛型结构已经被正确解析。

### 实际生成代码

```cangjie
let headerMap: HashMap<String, Int32> = getHeaderMapRaw()
return headerMap == None || headerMap.size == values.size
```

### 编译错误

```text
generic type should be used with type argument
```

更根本的问题是：`HashMap<String, Int32>` 表示一定存在，不能和 `None` 比较。Java 中允许返回 `null` 的信息没有进入目标类型。

### 应生成的核心写法

`getHeaderMapRaw` 的返回类型应携带 nullable 信息：

```cangjie
private func getHeaderMapRaw(): ?HashMap<String, Int32>
```

调用处应处理 `Option`：

```cangjie
let headerMap: ?HashMap<String, Int32> = getHeaderMapRaw()
return headerMap.isNone()
    || headerMap.getOrThrow().size == values.size
```

### 根因与责任模块

这是当前 type resolution 不完整的地方。它只解析了声明中的名义类型：

```text
Map<String, Integer> -> HashMap<String, Int32>
```

但没有结合以下信息推断 nullable：

- Java 方法可能返回 `null`。
- 变量随后参与了 `== null` 判断。
- 仓颉目标类型应为 `Option<HashMap<...>>`。

需要增加 nullable 流分析，并将结果写入 `translated_target_type` 或单独的 nullable 元数据。

## 5. 实例三：父类映射存在，但骨架没有保留 receiver

### Java 原文

```java
class ExtendedBufferedReader extends BufferedReader {
    int lookAhead0() throws IOException {
        super.mark(1);
        final int c = super.read();
        super.reset();
        return c;
    }
}
```

当前基础映射已经包含：

```text
java.io.BufferedReader -> StringReader
java.io.Reader         -> StringReader
```

### 实际生成骨架

```cangjie
class ExtendedBufferedReader {
    init(reader: StringReader<ByteBuffer>) {
        throw Exception('TODO')
    }
}
```

骨架没有父类，也没有把构造参数保存为 reader 字段。

### 实际生成的方法体

```cangjie
super.mark(1)
let c: Int32 = super.read()
super.reset()
```

### 编译错误

```text
'mark' is not a member of class 'Object'
'read' is not a member of class 'Object'
'reset' is not a member of class 'Object'
```

由于仓颉骨架中不存在有效父类，`super` 最终只能按 `Object` 处理。

### 应生成的核心结构

这里更适合使用组合，而不是机械保留 Java 继承：

```cangjie
class ExtendedBufferedReader {
    let reader: StringReader<ByteBuffer>

    init(reader: StringReader<ByteBuffer>) {
        this.reader = reader
    }

    func lookAhead0(): Int32 {
        let position = reader.position
        let value = reader.read()
        reader.seek(SeekPosition.Begin(position))

        match (value) {
            case Some(ch) => Int32(UInt32(ch))
            case None => -1
        }
    }
}
```

`StringReader.read()` 返回 `Option<Rune>`，因此还需要将：

```text
Some(Rune) -> Int32 Unicode 值
None       -> Java EOF -1
```

### 根因与责任模块

这不是缺少 `BufferedReader` 映射，而是映射结果没有贯穿到骨架和方法体：

```text
extends 信息
-> 仓颉继承或组合策略
-> receiver 字段类型
-> 方法调用目标类型
```

需要修改 skeleton generator 与 fragment translator 之间的类型上下文，而不是只扩充 type map。

## 6. 实例四：Java 隐式类型提升没有转成仓颉显式转换

### Java 原文

```java
int lastChar;

if (lastChar == CR || lastChar == LF) {
    // ...
}
```

### type_resolution 结果

```text
lastChar: int  -> Int32
CR/LF:    char -> Rune
```

这些单独看都正确。

### 实际生成代码

```cangjie
if (lastChar == Constants.CR || lastChar == Constants.LF) {
    // ...
}
```

### 编译错误

```text
invalid binary operator '==' on type 'Int32' and 'Rune'
```

Java 在比较时会把 `char` 隐式提升为 `int`，仓颉不会自动执行该转换。

### 应生成的核心写法

```cangjie
if (
    lastChar == Int32(UInt32(Constants.CR))
    || lastChar == Int32(UInt32(Constants.LF))
) {
    // ...
}
```

仓颉先用 `UInt32(Rune)` 取得字符的 Unicode scalar value，再转成与 `lastChar` 一致的 `Int32`。

### 根因与责任模块

这不是 `int` 或 `char` 的基础映射错误，而是缺少 Java 隐式提升规则：

```text
Java binary numeric promotion
-> 仓颉显式数值转换
```

应由 fragment translator 的表达式类型检查和转换规则处理。

## 7. 实例五：数组声明类型无法表达 Java null

### Java 原文

```java
static String[] toStringArray(final Object[] values) {
    if (values == null) {
        return null;
    }
    final String[] strings = new String[values.length];
    Arrays.setAll(strings, i -> Objects.toString(values[i], null));
    return strings;
}
```

### 当前 type_resolution 结果

```text
Object[] -> Array<Any>
String[] -> Array<String>
```

### 实际生成错误行

```cangjie
if (values[i] == null) {
```

### 编译错误

```text
undeclared identifier 'null'
```

这里不仅是把 `null` 拼成 `None` 就可以解决。Java 代码中至少存在三层 nullable：

1. 参数数组 `values` 本身可能为 `null`。
2. `Object[]` 的数组元素可能为 `null`。
3. 方法返回的 `String[]` 可能为 `null`，其元素也可能为 `null`。

### 更准确的目标签名

```cangjie
static func toStringArray(
    values: ?Array<?Any>
): ?Array<?String>
```

方法体需要使用 `Option` 分支，而不是继续使用 Java `null`：

```cangjie
if (values.isNone()) {
    return None
}

let source = values.getOrThrow()
// 对 source 中的 ?Any 元素逐项处理
```

### 根因与责任模块

Java 类型语法本身没有标出 nullable，单看 `Object[]` 和 `String[]` 无法得到完整目标类型。需要结合方法体中的 `null` 判断和返回路径进行流分析。

## 8. type_resolution 当前完成了什么

当前实现已经能较好完成第一层工作：

```text
Java 类型表达式
-> 解析数组、泛型、基础类型和自定义类型
-> 生成仓颉名义类型
```

例如：

```text
int                  -> Int32
long                 -> Int64
char[]               -> Array<Rune>
Map<String, Integer> -> HashMap<String, Int32>
Reader               -> StringReader<ByteBuffer>
Writer               -> StringWriter<ByteBuffer>
```

因此当前主要问题不是 `Map<String, Option>` 这样的语法完全无法解析，而是后续约束不足。

## 9. 仍缺少的类型信息

完整流程还需要补充四类信息：

### 9.1 Nullable

```text
Java null 判断和返回路径
-> Option<T>
-> None/Some/getOrThrow/isNone
```

### 9.2 继承与 receiver

```text
Java extends/implements
-> 仓颉继承或组合
-> receiver 的实际类型
-> 可用成员和方法
```

### 9.3 目标 API 参数约束

```text
ByteBuffer(size: Int64)
-> 当前表达式是 Int32
-> 自动插入 Int64(...)
```

### 9.4 Java 隐式转换

```text
char 与 int 比较
Java 自动提升
-> 仓颉显式 Rune/UInt32/Int32 转换
```

## 10. 责任划分

| 问题 | 主要责任模块 |
|---|---|
| 泛型、数组、基础类型无法解析 | type_resolution |
| `null` 应变成 `Option<T>` | type_resolution + nullable 流分析 |
| 父类/接口信息没有进入骨架 | skeleton generator |
| receiver 退化为 `Object/Any` | skeleton generator + fragment type context |
| 目标 API 参数类型不同 | API 适配层 + fragment translator |
| Java 隐式数值提升 | fragment translator 的表达式转换规则 |
| 方法体仍生成 `null`、不存在的 API | fragment translator |

## 11. 结论

当前 type resolution 不是“完全不够全”，而是只完成了名义类型翻译：

```text
Java type name -> Cangjie type name
```

下一步不应只继续扩充映射表，而应将流程升级为：

```text
声明类型解析
+ nullable 推断
+ 继承/receiver 类型传播
+ 目标 API 签名约束
+ Java 隐式转换规则
-> fragment translation
```

只有这些类型约束真正进入 skeleton 和 prompt，才能解决本文示例中的大部分问题。
