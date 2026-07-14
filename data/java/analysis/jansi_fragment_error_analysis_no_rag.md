# jansi fragment 错误分类分析（no RAG）

本报告只分析当前已经实际跑出的 jansi fragment 结果；pending fragment 不进入主表分母。错误分析条目与 `data/java/analysis/older_version.pdf` 对齐。

## 数据来源与统计口径

- jansi schema：`data/java/schemas/deepseek-chat/0.0/jansi`
- jansi fragment 日志：`jansi_deepseek-chat_body.log`
- 明细 CSV：`data/java/analysis/jansi_fragment_error_details.csv`
- 执行设置：`use_rag=false`、`use_progressive_kb=false`、`skip_mock=true`
- 已处理 fragment：349；其中已完成 268，编译失败/未完成 81。
- 原始明细 CSV 包含 pending，本报告只过滤其中已处理的 349 个 fragment。
- no-RAG 旧明细按 `translation_status` 统计；1 个 `attempted` 片段停在 `compilation=pending`，仍算失败/未完成。

## 已处理片段覆盖

| 片段类型 | 已处理数量 | 已处理占比 | 已完成 | 类型内成功率 | 编译失败/未完成 | 类型内失败率 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 方法 | 177 | 50.72% | 109 | 61.58% | 68 | 38.42% |
| 字段 | 168 | 48.14% | 156 | 92.86% | 12 | 7.14% |
| 静态初始化块 | 4 | 1.15% | 3 | 75.00% | 1 | 25.00% |
| 合计 | 349 | 100.00% | 268 | 76.79% | 81 | 23.21% |

## 统一错误模式汇总

下面每类都按“问题是什么 -> 怎么修 -> 例子”写，例子只保留人读得懂的关键信息。

| 错误模式 | 数量 | 占失败/未完成片段 | 处理优先级 |
| --- | ---: | ---: | --- |
| 框架嵌入问题 | 0 | 0.00% | 中 |
| 枚举或静态成员建模错误 | 3 | 3.70% | 中高 |
| Java class literal / 反射类型建模错误 | 2 | 2.47% | 高 |
| Java null 语义残留 | 4 | 4.94% | 高 |
| 构造器和异常体系不匹配 | 5 | 6.17% | 中高 |
| 仓颉集合、字符串、迭代器 API 不匹配 | 9 | 11.11% | 高 |
| Java 标准库或运行时调用未翻译 | 18 | 22.22% | 高 |
| 类型、Option、数值宽度、泛型参数不匹配 | 6 | 7.41% | 高 |
| Java 语法残留或仓颉语法错误 | 11 | 13.58% | 中 |
| 片段上下文或参数绑定丢失 | 4 | 4.94% | 中 |
| 其他编译错误 | 19 | 23.46% | 中 |

### 1. 框架嵌入问题

**问题**：模型把完整函数/修饰符输出进了 fragment 槽位，当前位置只允许方法体、字段初始化或构造器体。

**修正方向**：让模型只返回可嵌入片段；发现 `public/private/static/native` 这类完整声明时直接重试。

**例子**：
- 当前已处理样本里没有明显命中的失败例子。

### 2. 枚举或静态成员建模错误

**问题**：Java enum/static 的访问方式被照搬，但 Cangjie 骨架里这些值不是同样的静态成员。

**修正方向**：按骨架中真实 enum/静态成员声明来访问，不直接套 Java 的 `Type.Member`。

**例子**：
- `AnsiPrintStream.toString`：`error: 'toString' is not a member of class 'AnsiType'`。把 Java enum/static 当成 Cangjie 静态成员访问了。
- `AnsiOutputStream.setMode`：`error: 'Strip' is non-static member, cannot access by type name`。把 Java enum/static 当成 Cangjie 静态成员访问了。
- `AnsiOutputStream.uninstall`：`error: 'Redirected' is non-static member, cannot access by type name`。把 Java enum/static 当成 Cangjie 静态成员访问了。

### 3. Java class literal / 反射类型建模错误

**问题**：Java 的 `Class`、`Class.forName`、`getResource`、反射对象没有被建模成可用的 Cangjie runtime。

**修正方向**：反射和 class literal 走 runtime shim 或保守降级，不能在 fragment 里凭空生成 Java 反射类型。

**例子**：
- `AnsiConsole.systemInstall`：`error: 'install' is not a member of enum 'Option<Class-AnsiPrintStream>'`。Java 反射/class API 没有对应 runtime，不能直接调用。
- `JansiLoader.hasResource`：`error: 'getResource' is not a member of class 'JansiLoader'`。Java 反射/class API 没有对应 runtime，不能直接调用。

### 4. Java null 语义残留

**问题**：Java 的 `null` 判断被原样保留，但当前 Cangjie 代码没有这个字面量，很多字段也不是可空类型。

**修正方向**：先确认类型是否可空；可空用 Option 语义，非可空用空串、默认值或直接删除 null 分支。

**例子**：
- `AnsiOutputStream.processCharsetSelect`：`error: undeclared identifier 'null'`。保留了 Java `null/nil` 或 Java 空值异常语义。
- `AnsiOutputStream.processOperatingSystemCommand`：`error: undeclared identifier 'null'`。保留了 Java `null/nil` 或 Java 空值异常语义。
- `AnsiOutputStream.processEscapeCommand`：`error: undeclared identifier 'null'`。保留了 Java `null/nil` 或 Java 空值异常语义。
- `AnsiOutputStream.install`：`error: undeclared identifier 'null'`。保留了 Java `null/nil` 或 Java 空值异常语义。

### 5. 构造器和异常体系不匹配

**问题**：Java 构造器、`super(...)` 和异常类型被照搬，和 Cangjie 构造签名/异常体系不匹配。

**修正方向**：按 Cangjie skeleton 的真实构造器签名生成；Java checked exception 要映射、降级或移除。

**例子**：
- `AnsiPrintStream.AnsiPrintStream`：`error: extra arguments given for parameter list '()' in call`。构造器参数、`super/init` 或 Java 异常类型不符合 Cangjie 声明。
- `JansiLoader.initialize`：`error: no matching constructor for call 'Thread'`。构造器参数、`super/init` 或 Java 异常类型不符合 Cangjie 声明。
- `JansiLoader.readNBytes`：`error: extra arguments given for parameter list '(Struct-Array<UInt8>)' in call`。构造器参数、`super/init` 或 Java 异常类型不符合 Cangjie 声明。
- `JansiLoader.extractAndLoadLibraryFile`：`error: undeclared type name 'IOException'`。构造器参数、`super/init` 或 Java 异常类型不符合 Cangjie 声明。

### 6. 仓颉集合、字符串、迭代器 API 不匹配

**问题**：Java 集合、数组、字符串、迭代器 API 被逐字翻译，目标 Cangjie 类型没有这些方法或参数形式。

**修正方向**：补 Java API 到 Cangjie API 的确定性规则；迭代器循环改成 Cangjie 可用的遍历方式。

**例子**：
- `JansiLoader.contentsEquals`：`error: unknown named argument prefix 'item:'`。用了 Java 集合/字符串/数组 API，Cangjie 类型没有这个成员或参数。
- `JansiLoader.getMajorVersion`：`error: undeclared identifier 'parse'`。用了 Java 集合/字符串/数组 API，Cangjie 类型没有这个成员或参数。
- `Kernel32.readConsoleInputHelper`：`error: unknown named argument prefix 'item:'`。用了 Java 集合/字符串/数组 API，Cangjie 类型没有这个成员或参数。
- `Kernel32.getErrorMessage`：`error: unknown named argument prefix 'item:'`。用了 Java 集合/字符串/数组 API，Cangjie 类型没有这个成员或参数。

### 7. Java 标准库或运行时调用未翻译

**问题**：代码里还残留 Java 标准库/运行时 API，但项目没有对应 Cangjie 定义。

**修正方向**：优先补 `System`、`Math`、IO、Process、异常类等 runtime shim；不能支持的 API 生成平台 stub。

**例子**：
- `AnsiConsole.system_out`：`error: undeclared identifier 'System'`。Java runtime/API 没有被替换成本项目 shim 或 Cangjie 等价实现。
- `AnsiConsole.system_err`：`error: undeclared identifier 'System'`。Java runtime/API 没有被替换成本项目 shim 或 Cangjie 等价实现。
- `AnsiConsole.IS_WINDOWS`：`error: undeclared identifier 'getProperty'`。Java runtime/API 没有被替换成本项目 shim 或 Cangjie 等价实现。
- `AnsiConsole.getBoolean`：`error: undeclared identifier 'System'`。Java runtime/API 没有被替换成本项目 shim 或 Cangjie 等价实现。

### 8. 类型、Option、数值宽度、泛型参数不匹配

**问题**：Java 的隐式转换、泛型擦除、装箱类型被直接搬到 Cangjie，导致目标类型对不上。

**修正方向**：类型解析给准目标类型；fragment 阶段显式转换，不把 `Option<T>` 当作裸 `T`。

**例子**：
- `AnsiPrintStream.uninstall`：`error: generic type should be used with type argument`。源类型和目标类型没对齐，缺少显式转换或泛型参数。
- `JansiLoader.getMinorVersion`：`error: the expression for numeric type conversion must have a numeric type`。源类型和目标类型没对齐，缺少显式转换或泛型参数。
- `Kernel32.readConsoleKeyInput`：`error: mismatched types`。源类型和目标类型没对齐，缺少显式转换或泛型参数。
- `AnsiOutputStream.SECOND_ESC_CHAR`：`error: the expression for numeric type conversion must have a numeric type`。源类型和目标类型没对齐，缺少显式转换或泛型参数。

### 9. Java 语法残留或仓颉语法错误

**问题**：输出里还混着 Java 三元表达式、lambda、cast、半截 case，或者 JSON/方法体不完整。

**修正方向**：先保证输出是合法 JSON 和合法 Cangjie fragment，再处理 API 语义。

**例子**：
- `Ansi.detector`：`error: expected expression after '=', found '>'`。输出仍是 Java/半截 Cangjie/非法 JSON，语法层面就过不了。
- `Ansi.holder`：`error: expected expression after '=', found '>'`。输出仍是 Java/半截 Cangjie/非法 JSON，语法层面就过不了。
- `AnsiConsole.IS_CYGWIN`：`error: expected ';' or '<NL>', found ')'`。输出仍是 Java/半截 Cangjie/非法 JSON，语法层面就过不了。
- `AnsiConsole.IS_MSYSTEM`：`error: expected ';' or '<NL>', found ')'`。输出仍是 Java/半截 Cangjie/非法 JSON，语法层面就过不了。

### 10. 片段上下文或参数绑定丢失

**问题**：模型没用对当前类、父类、字段、局部变量或接收者类型，所以调用落在了不存在的成员上。

**修正方向**：prompt 提供更准确的成员/父类上下文；反馈时按真实接收者类型重写调用。

**例子**：
- `AnsiConsole.getTerminalWidth`：`error: 'getTerminalWidth' is not a member of interface 'OutputStream'`。接收者、字段或局部变量绑定错了。
- `JansiLoader.cleanup`：`error: 'path' is not a member of class 'File'`。接收者、字段或局部变量绑定错了。
- `AnsiOutputStream.close`：`error: 'close' is not a member of class 'Object'`。接收者、字段或局部变量绑定错了。
- `AnsiProcessor.processCursorDownLine`：`error: 'writeByte' is not a member of interface 'OutputStream'`。接收者、字段或局部变量绑定错了。

### 其他编译错误

**问题**：首行通常只有 `--- cjc stderr ---`、`waiting for compilation` 或其它折叠信息，单看 CSV 首行不能判断真实根因。

**修正方向**：展开 `jansi_deepseek-chat_body.log` 中对应 fragment 的完整 stderr，再归入上面的具体类别。

**例子**：
- `Ansi.setDetector`：`--- cjc stderr ---`。需要回看完整日志。
- `Ansi.setEnabled`：`waiting for compilation`。需要回看完整日志。
- `AnsiConsole.out`：`--- cjc stderr ---`。需要回看完整日志。
- `AnsiConsole.err`：`--- cjc stderr ---`。需要回看完整日志。

## 阅读说明

- “已处理占比”以当前已经跑出的 349 个 jansi fragment 为分母。
- `pending` 不进入主表，因此本报告不是 jansi 全量最终分布。
- `skip_mock=true`，所以成功只表示通过 Cangjie 编译验证，不表示 mock test 通过。
- 高频错误行表已删除；错误行被合并进各错误模式的例子里。

## 直接结论

- 已处理 349 个 fragment，268 个完成/编译通过，81 个失败或未完成；成功率 76.79%。
- 字段成功率 92.86%；方法成功率 61.58%。
- 主要错误：Java 标准库或运行时调用未翻译、Java 语法残留或仓颉语法错误、仓颉集合、字符串、迭代器 API 不匹配、类型、Option、数值宽度、泛型参数不匹配、构造器和异常体系不匹配。