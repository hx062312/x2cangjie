# jansi 类型翻译结果分析报告

- 更新时间：`2026-05-21 17:24:49`
- 项目：`jansi`
- 模型：`deepseek-chat`
- 温度：`0.0`
- 最新运行开始时间：`2026-05-21 17:05:16`
- Schema 目录：`data/java/schemas/deepseek-chat/0.0/jansi`
- 类型翻译日志：`logs/type_resolution/jansi_deepseek-chat_0.0_type_resolution.log`
- 失败类型 map：`data/java/analysis/jansi_deepseek-chat_0.0_type_resolution_failure_map.json`

## 统计口径

- 当前 jansi schema 已清理重复文件，只统计 `jansi.*` 这一批 32 个 schema。
- 来源类别统计使用日志中的最新一次 `Type resolution run started` 之后的 `PASS` / `FALLBACK` 事件。
- fallback 会被写回为 `translated=true`，但终端显示为失败，并携带 `feedback`；本报告把这类 fallback 计为失败。

## 总体结果

| 口径 | 总数 | 成功 | 失败 | 成功率 | 失败率 |
| --- | --- | --- | --- | --- | --- |
| 最新运行日志事件 | 1452 | 1375 | 77 | 94.70% | 5.30% |
| Schema 最终状态 | 1452 | 1375 | 77 | 94.70% | 5.30% |

- Schema 中 `translated=true`：`1452/1452`
- Schema 中带 imports 的类型条目：`82`

## 各类别成功/失败比例

| 类别 | 总数 | 成功 | 失败 | 成功率 | 失败率 |
| --- | --- | --- | --- | --- | --- |
| fixed_map | 944 | 944 | 0 | 100.00% | 0.00% |
| custom_type | 299 | 299 | 0 | 100.00% | 0.00% |
| llm | 132 | 132 | 0 | 100.00% | 0.00% |
| fallback | 77 | 0 | 77 | 0.00% | 100.00% |

## 失败类型 Map

```json
{
  "budget_exhausted:undeclared_or_unknown_type": 37,
  "budget_exhausted:other_cjc_validation_error": 28,
  "budget_exhausted:java_declaration_leaked_as_type": 10,
  "budget_exhausted:malformed_or_raw_generic_type": 2
}
```

## 失败 Source Type 汇总

| Source type | 失败次数 |
| --- | --- |
| PrintStream | 10 |
| StringBuilder | 7 |
| ByteArrayOutputStream | 6 |
| String[] | 6 |
| ProcessBuilder | 4 |
| Charset | 3 |
| Enum<?> | 3 |
| IOException | 3 |
| int[] | 3 |
| Appendable | 2 |
| AtomicReference<> | 2 |
| AtomicReference<String> | 2 |
| FileOutputStream | 2 |
| ProcessBuilder.Redirect | 2 |
| Throwable | 2 |
| BufferedReader | 1 |
| Callable<Boolean> | 1 |
| Class<?> | 1 |
| Closeable | 1 |
| Exception | 1 |
| FilenameFilter | 1 |
| IOError | 1 |
| IllegalArgumentException | 1 |
| IllegalArgumentException \| NullPointerException | 1 |
| InputStreamReader | 1 |
| NullPointerException | 1 |
| Package | 1 |
| Redirect | 1 |
| RuntimeException | 1 |
| SecurityException | 1 |
| URL | 1 |
| UnsatisfiedLinkError | 1 |
| UnsupportedCharsetException | 1 |
| UnsupportedEncodingException | 1 |
| long[] | 1 |

## 失败类型样例

### `budget_exhausted:undeclared_or_unknown_type` × 37
- `PrintStream`

```text
Cangjie compilation error: error: undeclared type name 'PrintStream'
==> /tmp/tmpefu08_t7.cj:58:20:
|
58 |     let _test_val: PrintStream
|                    ^
|
warning: unused import 'std.io.*'
```
- `ByteArrayOutputStream`

```text
Cangjie compilation error: error: undeclared type name 'ByteArrayOutputStream'
==> /tmp/tmp3gst19t9.cj:58:20:
|
58 |     let _test_val: ByteArrayOutputStream
|                    ^
|
warning: unused import 'std.io.*'
```
- `PrintStream`

```text
Cangjie compilation error: error: undeclared type name 'PrintStream'
==> /tmp/tmpefu08_t7.cj:58:20:
|
58 |     let _test_val: PrintStream
|                    ^
|
warning: unused import 'std.io.*'
```
- `PrintStream`

```text
Cangjie compilation error: error: undeclared type name 'PrintStream'
==> /tmp/tmpefu08_t7.cj:58:20:
|
58 |     let _test_val: PrintStream
|                    ^
|
warning: unused import 'std.io.*'
```

### `budget_exhausted:other_cjc_validation_error` × 28
- `String[]`

```text
Cangjie compilation error: error: 'Array' is not accessible in package 'std.collection'
==> /tmp/tmpa2ckttii.cj:3:8:
|
3 | import std.collection.Array
|        ^^^^^^^^^^^^^^^^^^^^
|
1 error generated, 1 error printed.
```
- `Callable<Boolean>`

```text
Cangjie compilation error: error: 'Array' is not accessible in package 'std.collection'
==> /tmp/tmp239g8gid.cj:3:8:
|
3 | import std.collection.Array
|        ^^^^^^^^^^^^^^^^^^^^
|
1 error generated, 1 error printed.
```
- `StringBuilder`

```text
Cangjie compilation error: error: can not find package 'std.string'
==> /tmp/tmpxpypx88f.cj:3:8:
|
3 | import std.string.StringBuilder
|        ^^^^^^^^^^
|
# help: check if the .cjo file of the package exists in CANGJIE_PATH or CANGJIE_HOME, or use '--import-path' to specify the .cjo file path
```
- `StringBuilder`

```text
Cangjie compilation error: error: can not find package 'std.string'
==> /tmp/tmpxpypx88f.cj:3:8:
|
3 | import std.string.StringBuilder
|        ^^^^^^^^^^
|
# help: check if the .cjo file of the package exists in CANGJIE_PATH or CANGJIE_HOME, or use '--import-path' to specify the .cjo file path
```

### `budget_exhausted:java_declaration_leaked_as_type` × 10
- `Throwable`

```text
Cangjie compilation error: error: expected type name after ':', found keyword 'class'
==> /tmp/tmpcm71l0hf.cj:58:20:
|
58 |     let _test_val: class Throwable <: Error
|                  ~ ^^^^^ expected type name here
|                  |
|                  after ':'
```
- `UnsupportedCharsetException`

```text
Cangjie compilation error: error: expected type name after ':', found keyword 'class'
==> /tmp/tmpp9fz_132.cj:58:20:
|
58 |     let _test_val: class UnsupportedCharsetException <: Exception {
|                  ~ ^^^^^ expected type name here
|                  |
|                  after ':'
```
- `IOError`

```text
Cangjie compilation error: error: expected type name after ':', found keyword 'class'
==> /tmp/tmpouj2qelk.cj:58:20:
|
58 |     let _test_val: class IOError <: Error {
|                  ~ ^^^^^ expected type name here
|                  |
|                  after ':'
```
- `Throwable`

```text
Cangjie compilation error: error: expected type name after ':', found keyword 'class'
==> /tmp/tmpcm71l0hf.cj:58:20:
|
58 |     let _test_val: class Throwable <: Error
|                  ~ ^^^^^ expected type name here
|                  |
|                  after ':'
```

### `budget_exhausted:malformed_or_raw_generic_type` × 2
- `AtomicReference<>`

```text
Cangjie compilation error: error: generics type arguments do not match the constraint of 'Class-AtomicReference<Generics-T>'
==> /tmp/tmpl6wnu2a4.cj:58:36:
|
58 |     let _test_val: AtomicReference<String>
|                                    ^
|
note: 'Struct-String' is not a subtype of 'Class-Object'
```
- `AtomicReference<>`

```text
Cangjie compilation error: error: generics type arguments do not match the constraint of 'Class-AtomicReference<Generics-T>'
==> /tmp/tmpl6wnu2a4.cj:58:36:
|
58 |     let _test_val: AtomicReference<String>
|                                    ^
|
note: 'Struct-String' is not a subtype of 'Class-Object'
```

## 错误类型分析总结

- 本次运行共处理 `1452` 个类型条目，成功 `1375` 个，fallback 失败 `77` 个；schema 最终状态中失败 `77` 个，和日志 fallback 数一致。
- Prompt 增加 import 格式约束后，`from std... import ...` 类错误没有完全消失，但数量已下降；失败仍主要集中在 LLM 返回了非法 Cangjie import 语法。
- 第二类主要失败是 Cangjie 当前环境或映射表中无法加载的 Java 标准库类型，例如 `PrintStream`、`ByteArrayOutputStream`、`AtomicReference<>`、`File` 等。
- `fixed_map` 和 `custom_type` 路径仍然是确定性成功；后续要减少 fallback，优先把高频失败 source type 加入 `fixed_type_map.json` / `std_type_imports.json`，而不是依赖 LLM 猜测。
- 当前失败条目会退化为 `Any` / `Array<Any>` 后继续进入 2.4/2.5，这能维持流程推进，但会降低后续骨架和片段翻译的类型精度。
