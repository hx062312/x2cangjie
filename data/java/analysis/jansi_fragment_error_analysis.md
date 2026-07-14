# 统一片段翻译错误分类分析

本报告基于本轮已经实际跑出的 jansi RAG fragment 结果分析；pending fragment 不进入主表分母，也不参与错误比例计算。错误分析条目与 `data/java/analysis/older_version.pdf` 中的分类口径对齐。

## 数据来源与统计口径

- jansi schema：`data/java/schemas/deepseek-chat/0.0/jansi`
- jansi fragment 日志：`jansi_deepseek-chat_body.log`
- jansi RAG 明细 CSV：`data/java/analysis/jansi_fragment_error_details_rag_349.csv`
- 本轮执行设置：`use_rag=true`、`use_progressive_kb=false`、`skip_mock=true`
- 已处理 fragment：349；其中编译成功 270，编译失败 79。
- pending fragment：485，本报告不分析。
- 成败按 `cangjie_compilation.outcome` 统计；不直接把 `translation_status=attempted` 等同于失败，因为 fixed 字段会以 `attempted + success` 形式落盘。

## 已处理片段覆盖

| 片段类型 | 已处理数量 | 已处理占比 | 编译成功 | 类型内成功率 | 编译失败 | 类型内失败率 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 方法 | 177 | 50.72% | 100 | 56.50% | 77 | 43.50% |
| 字段 | 168 | 48.14% | 168 | 100.00% | 0 | 0.00% |
| 静态初始化块 | 4 | 1.15% | 2 | 50.00% | 2 | 50.00% |
| 合计 | 349 | 100.00% | 270 | 77.36% | 79 | 22.64% |

## 当前最终状态

| 状态口径 | 数量 | 已处理占比 | 字段 | 方法 | 静态初始化块 |
| --- | ---: | ---: | ---: | ---: | ---: |
| 编译成功 | 270 | 77.36% | 168 | 100 | 2 |
| 编译失败 | 79 | 22.64% | 0 | 77 | 2 |

## 统一错误模式汇总

| 错误模式 | 典型错误行或症状 | 影响范围 | 处理优先级 |
| --- | --- | --- | --- |
| 类型、Option、数值宽度、泛型参数不匹配 | `mismatched types`、`Option<T>` 与裸值混用、数值/字符/字符串转换失败、泛型参数不满足 | 字段和方法均可能出现，当前主要集中在方法 | 高 |
| Java class literal / 反射类型建模错误 | `Class.forName`、`getClass`、`getResource`、`ProcessBuilder.Redirect`、Java 反射对象残留 | 反射、资源加载、平台适配方法 | 高 |
| Java null 语义残留 | `undeclared identifier 'null'`、`undeclared identifier 'nil'`、Java nullable 判断直接复制 | 安装/卸载、流处理、条件判断 | 高 |
| 仓颉集合、字符串、迭代器 API 不匹配 | `put`、`contains`、`append`、`hasNext`、`substring`、`replaceAll`、`toString`、`Array(..., item:)` 不存在 | 方法 fragment 为主，少量静态初始化块 | 高 |
| Java 标准库或运行时调用未翻译 | `System`、`Runtime`、`Files`、`Random`、`ByteArrayOutputStream`、`ProcessBuilder`、Java 异常类残留 | OS/env/system property、进程、IO、异常处理 | 高 |
| 枚举或静态成员建模错误 | Java enum 构造器、枚举值、静态成员访问被当成普通类成员；如 enum 值非静态访问 | 枚举、静态成员相关片段 | 中高 |
| 构造器和异常体系不匹配 | `super(...)` 参数不匹配、父类构造调用顺序错误、`init` 调用形态错误、`throw` 非 `Exception` | 构造器、wrapper 方法、异常处理 | 中高 |
| Java 语法残留或仓颉语法错误 | 三元表达式、`case`、`?`、Java cast、非法 JSON 输出、空 method body | 方法 fragment 为主 | 中 |
| 片段上下文或参数绑定丢失 | 局部变量、字段、接收者或参数未绑定，如 `out`、`getTerminalWidth` 接收者不对 | 方法 fragment 为主 | 中 |
| 框架嵌入问题 | 完整函数声明、`public/private/static/native` 修饰符被嵌入函数体 | 少量，但会造成确定性失败 | 中 |

## 高频首轮/最终错误行

| 错误行 | 数量 | 占失败片段 | 观察 |
| --- | ---: | ---: | --- |
| `Compilation failed: --- cjc stderr ---` | 12 | 15.19% | 包级 stderr 被折叠，需要回看 body log 的完整 cjc 输出。 |
| `Compilation failed: error: mismatched types` | 5 | 6.33% | 类型、Option、数值宽度或接收者类型不匹配的共同表征。 |
| `extracted method body is empty` | 4 | 5.06% | 模型没有给出可嵌入的 fragment body。 |
| `Compilation failed: error: unknown named argument prefix 'item:'` | 3 | 3.80% | 数组/集合构造沿用错误参数形态。 |
| `Compilation failed: error: undeclared type name 'IOException'` | 2 | 2.53% | Java 异常类残留。 |
| `Compilation failed: error: undeclared identifier 'out'` | 2 | 2.53% | 片段上下文或父类字段绑定丢失。 |
| `Compilation failed: error: undeclared identifier 'null'` | 2 | 2.53% | Java nullability 未转成 Cangjie 可空语义。 |
| `Compilation failed: error: undeclared identifier 'System'` | 2 | 2.53% | Java runtime API 未抽象或替换。 |
| `Compilation failed: error: expected ';' or '<NL>', found '?'` | 2 | 2.53% | Java 三元/可空语法残留。 |
| `Compilation failed: error: undeclared identifier 'ArrayList'` | 2 | 2.53% | Java 集合类残留。 |
| `Compilation failed: error: undeclared identifier 'parse'` | 2 | 2.53% | Java helper/静态解析 API 未映射。 |
| `Compilation failed: error: undeclared identifier 'getProperty'` | 2 | 2.53% | System property 访问未替换为本地 runtime shim。 |
| `Compilation failed: error: undeclared identifier 'nil'` | 2 | 2.53% | null 修复时漂移到 Cangjie 中不存在的 `nil`。 |

## 阅读说明

- “已处理占比”以当前已经跑出的 349 个 jansi fragment 为分母。
- `pending` 不进入主表，因此本报告反映的是当前已运行样本的错误分布，不代表 jansi 全量最终分布。
- `skip_mock=true`，所以成功只表示通过 Cangjie 编译验证，不表示 mock test 通过。
- 错误模式按 `older_version.pdf` 的条目命名；当前样本中没有明显命中的条目仍保留，用于后续跨轮次、跨项目对齐。

## 代表性首轮错误样例

以下样例只作为错误模式例证，完整源码和生成内容可回看 `jansi_deepseek-chat_body.log` 与 `data/java/analysis/jansi_fragment_error_details_rag_349.csv`。

### 类型、Option、数值宽度、泛型参数不匹配

- fragment：`jansi.src.main.org.fusesource.jansi.AnsiConsole|61-568:AnsiConsole|561-567:initStreams`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: mismatched types`

### Java class literal / 反射类型建模错误

- fragment：`jansi.src.main.org.fusesource.jansi.internal.JansiLoader|61-395:JansiLoader|355-357:hasResource`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: 'getResource' is not a member of class 'JansiLoader'`

### Java null 语义残留

- fragment：`jansi.src.main.org.fusesource.jansi.AnsiPrintStream|28-96:AnsiPrintStream|79-85:uninstall`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: undeclared identifier 'null'`

### 仓颉集合、字符串、迭代器 API 不匹配

- fragment：`jansi.src.main.org.fusesource.jansi.internal.JansiLoader|61-395:JansiLoader|145-174:contentsEquals`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: unknown named argument prefix 'item:'`

### Java 标准库或运行时调用未翻译

- fragment：`jansi.src.main.org.fusesource.jansi.internal.JansiLoader|61-395:JansiLoader|101-103:getTempDir`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: undeclared identifier 'System'`

### 枚举或静态成员建模错误

- fragment：`jansi.src.main.org.fusesource.jansi.io.AnsiOutputStream|41-359:AnsiOutputStream|138-143:setMode`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: 'Strip' is non-static member, cannot access by type name`

### 构造器和异常体系不匹配

- fragment：`jansi.src.main.org.fusesource.jansi.AnsiPrintStream|28-96:AnsiPrintStream|30-32:AnsiPrintStream`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: expected a member name after '.' in qualified name, found keyword 'init'`

### Java 语法残留或仓颉语法错误

- fragment：`jansi.src.main.org.fusesource.jansi.internal.JansiLoader|61-395:JansiLoader|185-206:cleanup`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: expected ';' or '<NL>', found '?'`

### 片段上下文或参数绑定丢失

- fragment：`jansi.src.main.org.fusesource.jansi.AnsiPrintStream|28-96:AnsiPrintStream|39-41:getOut`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: undeclared identifier 'out'`

### 框架嵌入问题

- fragment：`jansi.src.main.org.fusesource.jansi.internal.CLibrary|25-161:CLibrary|91-92:openpty`
- 片段类型：method
- 最终编译结果：error
- 错误行：`Compilation failed: error: unexpected modifier 'public' on function declaration in function body`

## 直接结论

- 在已处理的 349 个 jansi RAG fragment 中，270 个编译通过，79 个失败；已处理成功率 77.36%。
- 字段 fragment 当前全部编译成功；失败主要集中在方法 fragment 和少量静态初始化块。
- 与旧版条目对齐后，主要系统性问题仍是：Java runtime/API 未替换、仓颉集合/字符串/数组 API 不匹配、null/Option 语义、构造器/异常体系、片段上下文绑定。
