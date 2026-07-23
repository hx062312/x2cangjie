# Mock 测试独立性统计

本报告使用当前严格的独立测试阻塞规则，对 `jansi` 与 `commons-cli` 生成的 Cangjie mock 测试进行合并分类。

## 来源

- 计数单位：生成的 Cangjie `*_test.cj` 文件，而不是原始 Java `@Test` 方法。
- `jansi` 语料目录：`/tmp/cangjie_mock/jansi`；Cangjie 源码：`data/java/skeletons/translations/deepseek-chat/0.0/jansi/src`；测试数 `1309`，workflow `1309`，覆盖原始 Java 测试方法前缀 `34`。
- `commons-cli` 语料目录：`/tmp/cangjie_mock/commons-cli`；Cangjie 源码：`data/java/skeletons/translations/deepseek-chat/0.0/commons-cli/src`；当前测试数 `5310`，workflow `5310`，覆盖原始 Java 测试方法前缀 `38`。
- `commons-cli` 生成在中途停止过，本报告按当前已落盘语料统计；因此整体结果是 `jansi` 完整语料 + `commons-cli` 当前部分语料。
- 合并测试数：`6619`；合并 workflow 规格数：`6619`；缺失 workflow：`0`。

## 分类规则

| 类别 | 规则 | 含义 |
|---|---|---|
| 无依赖链；不需要 mock | 配对的 `.workflow.json` 为空 | 焦点方法可以直接重放；没有下游调用需要 stub。 |
| 可 mock 且可独立测试 | workflow 有依赖，并且不存在下面的严格 blocker | 焦点方法需要下游行为，但当前独立测试检查器没有发现已知的重放/拦截阻塞。 |
| 需要 mock，但不可独立测试 | workflow 有依赖，并且至少存在一个严格 blocker | 生成的测试依赖当前 Cangjie mock/重放路径无法独立复现的行为。 |

## 严格 Blocker

| Blocker | 检测规则 |
|---|---|
| `instance-method-dependency` | dependency-only workflow 中的某个依赖方法存在真实 receiver mutation，即 `Instance Initial` 与 `Instance Final` 不同。仅有 `Instance Initial` 不再自动阻塞；如果 receiver 是 focal 参数或注入字段，框架会生成 mock receiver 并注入后用 `@On(mockReceiver.method(...))` 拦截。 |
| `expression-side-effect-unreplayable` | 需要通过额外语句重放真实副作用的依赖，出现在无法安全插入副作用重放语句的调用点。安全位置包括独立调用、`let/var x = dep()`，以及简单的 `x = dep()`。如果依赖只需要 mock 返回值且可被拦截，`dep() + 1`、嵌套参数、条件和返回语句等表达式位置仍可能独立测试；只有这些位置还需要副作用重放时，才会被此 blocker 阻塞。 |

## 合并汇总

本节把 `jansi` 与当前已生成的 `commons-cli` 语料合并为一个整体分析。合并后共有 `6619` 个 generated Cangjie mock test，其中 `jansi` 为完整语料，`commons-cli` 为当前已落盘的部分语料。

| 类别 | 数量 | 占比 |
|---|---:|---:|
| 无依赖链；不需要 mock | 4018 | 60.7% |
| 可 mock 且可独立测试 | 1315 | 19.9% |
| 需要 mock，但不可独立测试 | 1286 | 19.4% |
| 总计 | 6619 | 100.0% |

只在“需要 mock”的 generated test-file 中看，`1315 / (1315 + 1286) = 50.6%` 当前可 mock 且可独立测试。

## 合并 Blocker 计数

这些计数只适用于 `需要 mock，但不可独立测试` 类别中的测试。单个测试可能包含多个 blocker。

| Blocker | 受影响测试数 | 依赖出现次数 |
|---|---:|---:|
| `instance-method-dependency` | 860 | 1076 |
| `expression-side-effect-unreplayable` | 576 | 647 |

## 合并 Blocker 组合

| Blocker 组合 | 测试数 |
|---|---:|
| 仅 `instance-method-dependency` | 710 |
| 仅 `expression-side-effect-unreplayable` | 426 |
| `instance-method-dependency` + `expression-side-effect-unreplayable` | 150 |

合并后可以看到两个主要阻塞来源都存在：`instance-method-dependency` 仍是最大项；`expression-side-effect-unreplayable` 在 commons-cli 中更明显，因此合并后不再像 jansi 单项目那样完全伴随实例 receiver mutation。

## 合并后的主要焦点方法

### 无依赖链；不需要 Mock

| 数量 | 焦点方法 |
|---:|---|
| 417 | `org.apache.commons.cli.Option.getKey` |
| 289 | `org.apache.commons.cli.Util.stripLeadingHyphens` |
| 210 | `org.fusesource.jansi.Ansi.flushAttributes` |
| 192 | `org.apache.commons.cli.Option.hasArg` |
| 183 | `org.apache.commons.cli.Option.getOpt` |
| 167 | `org.apache.commons.cli.Option.isRequired` |
| 166 | `org.apache.commons.cli.OptionValidator.isValidChar` |
| 155 | `org.apache.commons.cli.Option.hasLongOpt` |
| 149 | `org.apache.commons.cli.Option.getLongOpt` |
| 123 | `org.apache.commons.cli.Parser.getOptions` |
| 107 | `org.fusesource.jansi.Ansi.<init>` |
| 90 | `org.fusesource.jansi.io.AnsiOutputStream.write` |

### 可 Mock 且可独立测试

| 数量 | 焦点方法 |
|---:|---|
| 125 | `org.apache.commons.cli.HelpFormatter$HelpFormatter_OptionComparator.compare` |
| 113 | `org.apache.commons.cli.Options.hasOption` |
| 104 | `org.apache.commons.cli.Options.addOption0` |
| 101 | `org.apache.commons.cli.OptionValidator.validate` |
| 93 | `org.apache.commons.cli.Option.<init>` |
| 88 | `org.fusesource.jansi.Ansi.toString` |
| 78 | `org.fusesource.jansi.Ansi.appendEscapeSequence` |
| 60 | `org.apache.commons.cli.Options.getOption` |
| 58 | `org.apache.commons.cli.HelpFormatter.renderWrappedText` |
| 39 | `org.apache.commons.cli.CommandLine.resolveOption` |
| 35 | `org.fusesource.jansi.Ansi.a` |
| 28 | `org.fusesource.jansi.Ansi.ansi` |

### 需要 Mock，但不可独立测试

| 数量 | 焦点方法 |
|---:|---|
| 105 | `org.fusesource.jansi.Ansi.Ansi` |
| 90 | `org.apache.commons.cli.Option.acceptsArg` |
| 89 | `org.apache.commons.cli.OptionValidator.isValidOpt` |
| 63 | `org.apache.commons.cli.Options.getOptionGroup` |
| 49 | `org.apache.commons.cli.Options.addOption3` |
| 48 | `org.apache.commons.cli.Option.add` |
| 38 | `org.apache.commons.cli.Option.addValueForProcessing` |
| 38 | `org.apache.commons.cli.Option.processValue` |
| 32 | `org.apache.commons.cli.DefaultParser.handleToken` |
| 27 | `org.apache.commons.cli.Option.Option1` |
| 26 | `org.fusesource.jansi.Ansi.cursorDown` |
| 26 | `org.fusesource.jansi.Ansi.cursorRight` |

## 示例

### 无依赖链；不需要 Mock

- 文件：`/tmp/cangjie_mock/jansi/org_fusesource_jansi_AnsiRendererTest_setUp_decomposed_mocker_0_Ansi_setEnabled_test.cj`
- 焦点方法：`org.fusesource.jansi.Ansi.setEnabled`
- 焦点参数数量：`1`
- 焦点参数类型：`boolean`
- 依赖数量：`0`

### 可 Mock 且可独立测试

- 文件：`/tmp/cangjie_mock/jansi/org_fusesource_jansi_AnsiTest_testApply_decomposed_mocker_0_Ansi_ansi0_test.cj`
- 焦点方法：`org.fusesource.jansi.Ansi.ansi0`
- 焦点参数数量：`0`
- 焦点参数类型：无
- 依赖数量：`2`
- 严格 blocker：无
- 依赖：`org.fusesource.jansi.Ansi.isEnabled`、`org.fusesource.jansi.Ansi.Ansi0`

### 可 Mock 且可独立测试：参数 receiver

- 文件：`/tmp/cangjie_mock/jansi/org_fusesource_jansi_AnsiRendererTest_testRender2_decomposed_mocker_11_Ansi_a_test.cj`
- 焦点方法：`org.fusesource.jansi.Ansi.a`
- 焦点参数数量：`1`
- 焦点参数类型：`Attribute`
- 依赖数量：`1`
- 严格 blocker：无
- 依赖：`org.fusesource.jansi.Ansi$Attribute.value`

### 可 Mock 且可独立测试：表达式中的纯返回值依赖

- 文件：`/tmp/cangjie_mock/jansi/org_fusesource_jansi_AnsiRendererTest_testRender2_decomposed_mocker_16_Ansi_fg_test.cj`
- 焦点方法：`org.fusesource.jansi.Ansi.fg`
- 焦点参数数量：`1`
- 焦点参数类型：`Color`
- 依赖数量：`1`
- 严格 blocker：无
- 依赖：`org.fusesource.jansi.Ansi$Color.fg`
- Cangjie 调用点：`attributeOptions.add(color.fg())`

## 说明

- 本报告有意只使用 `side_effect.analyze_replayability` 中实现的两个严格 blocker。
- 之前更宽泛的报告会把 private 依赖、构造函数和仅规格依赖计为不可独立。在当前要求的标准下，除非它们同时触发上述两个严格 blocker 之一，否则不纳入本分类。
- 框架修正后，`@On` 已验证可拦截静态/类方法、全局函数，以及 mock receiver 上的实例方法；生成器会为可绑定的 focal 参数或注入字段创建 mock receiver 并注入。真实 receiver 对象不能直接 `@On(real.method(...))`。

## 源码示例

下面的例子展示“焦点方法长成什么样时”通常可以独立测试，或者会被当前严格规则判定为不可独立测试。这里关注的是 mock/replay 能否独立复现依赖行为，不是方法业务逻辑是否复杂。

### 可独立测试示例 1：无依赖链

源码位置：`src/java/isolation_validation/jansi/src/main/java/org/fusesource/jansi/Ansi.java`

```java
public static void setEnabled(final boolean flag) {
    holder.set(flag);
}
```

这个焦点方法只写入本类静态状态，没有下游项目方法调用需要 mock。对应 workflow 为空，因此归为“无依赖链；不需要 mock”。

### 可独立测试示例 2：有依赖，但当前可 mock

源码位置：`src/java/isolation_validation/jansi/src/main/java/org/fusesource/jansi/Ansi.java`

```java
public static Ansi ansi0() {
    if (isEnabled()) {
        return Ansi.Ansi0();
    } else {
        return new Ansi_NoAnsi(null);
    }
}
```

这个焦点方法有两个明确的下游依赖：静态/类方法 `Ansi.isEnabled()` 和 `Ansi.Ansi0()`。它们都没有实例 receiver，不需要把 receiver 塞进参数或字段；测试端可以直接生成类名限定的 `@On`：

```cj
@On(Ansi.isEnabled()).returns(true).once()
@On(Ansi.Ansi0()).returns(__mockCreateViaIoc<Ansi>()).once()

let method_ret = Ansi.ansi0()
```

因此它是更典型的“有依赖，但当前可 mock 且可独立测试”：依赖是静态/类函数，拦截点就是 `ClassName.method(...)`，不存在 object receiver 绑定问题，也不需要副作用回放插桩。

### 可独立测试示例 3：参数 receiver 可替换为 mock

源码位置：`src/java/isolation_validation/jansi/src/main/java/org/fusesource/jansi/Ansi.java`

```java
public Ansi a(Attribute attribute) {
    attributeOptions.add(attribute.value());
    return this;
}
```

这里焦点方法依赖参数对象 `attribute` 的实例方法 `attribute.value()`。修正后，`Instance Initial == Instance Final` 不再被视为真实 receiver mutation；生成器可以把参数 receiver 替换为 mock receiver，并生成类似 `@On(__dep_receiver_1.value()).returns(1)` 的桩。因此这类参数 receiver 依赖可归入“可 mock 且可独立测试”。

测试端关键代码形态如下。重点是同一个 mock receiver `__dep_receiver_1` 同时用于 `@On` 拦截和 focal 参数传入；这样 focal method 内部执行到 `attribute.value()` 时，实际 receiver 就是可拦截的 mock 对象。

```cj
@Test
func test_Ansi_a_attribute_receiver_mocked() {
    var instance_initial = __mockCreateViaIoc<Ansi>()
    instance_initial.builder = ""
    instance_initial.attributeOptions = __mockArrayListOf<Any>([])

    let __dep_receiver_1 = mock<Attribute>()
    @On(__dep_receiver_1.value()).returns(1i64).once()

    var arg_0: Attribute = __dep_receiver_1
    let method_ret = instance_initial.a0(arg_0)

    @Assert(method_ret.attributeOptions == __mockArrayListOf<Int64>([1i64]))
}
```

这里不是对真实对象 `Attribute.INTENSITY_BOLD.value()` 做 `@On`，而是先创建 mock receiver，再把这个 receiver 塞进 focal call 的参数位置。依赖调用发生在焦点方法内部，但 receiver 已经被替换成 `__dep_receiver_1`，所以 `@On(__dep_receiver_1.value())` 能命中。

### 可独立测试示例 4：表达式中的纯返回值依赖

源码位置：`src/java/isolation_validation/jansi/src/main/java/org/fusesource/jansi/Ansi.java`

```java
public Ansi fg(Color color) {
    attributeOptions.add(color.fg());
    return this;
}
```

这里依赖调用 `color.fg()` 嵌在另一个调用的参数表达式中：`attributeOptions.add(color.fg())`。如果这里只需要拦截返回值，表达式位置本身不阻塞；修正后 `Color.fg()` 的 receiver 没有真实 mutation，因此不会触发 `expression-side-effect-unreplayable`。只有依赖还需要额外语句重放副作用时，这类嵌套表达式才会被阻塞。

### 不可独立测试示例：`this`/private receiver 无法普通 mock

源码位置：`src/java/isolation_validation/jansi/src/main/java/org/fusesource/jansi/Ansi.java`

```java
public String toString() {
    flushAttributes();
    return builder.toString();
}
```
这个方法调用了本类 private 实例方法 `flushAttributes()`。它不是外部注入 receiver，也不是 focal 参数；要拦截它需要 spy/partial mock 或源码插桩，而不是普通 `@On(mockReceiver.method(...))`。这类仍归入“需要 mock，但不可独立测试”。

### 不可独立测试示例：表达式调用需要副作用重放

源码位置：`src/java/isolation_validation/commons-cli/src/main/java/org/apache/commons/cli/DefaultParser.java`

```java
private void handleToken(final String token) throws ParseException {
    currentToken = token;

    if (skipParsing) {
        cmd.addArg(token);
    } else if ("--".equals(token)) {
        skipParsing = true;
    } else if (currentOption != null && currentOption.acceptsArg() && isArgument(token)) {
        currentOption.addValueForProcessing(stripLeadingAndTrailingQuotesDefaultOn(token));
    }

    if (currentOption != null && !currentOption.acceptsArg()) {
        currentOption = null;
    }
}
```

这里的依赖调用 `currentOption.acceptsArg()` 出现在 `&&` 条件表达式里。单纯返回值依赖可以用 `@On(mockReceiver.acceptsArg()).returns(...)` 拦截；但如果 workflow 还记录了真实 receiver/static/参数副作用，就需要在调用点附近插入副作用重放语句。条件表达式内部不能安全插入这种语句，同时还要保持 Java 短路求值语义，所以会触发 `expression-side-effect-unreplayable`，归入“需要 mock，但不可独立测试”。

### 副作用回放插桩是怎么插的

副作用回放有两条路径：能塞进 `@On` action lambda 的参数/static 副作用，会留在测试端 mock 桩里；`side_effect.instrument` 这条源码插桩路径，则会直接修改 focal method 所在的 Cangjie 源文件。它根据 `_test.cj` 里的 `// focal call: ...` 找到 focal class 和方法，再根据 `.workflow.json` 中的依赖方法名和 `occurrence_idx` 定位 focal 方法体里的第 N 次依赖调用。

插入内容由 workflow 的 final snapshot 生成：

- `Static Fields Changed` 生成静态字段赋值，例如 `SomeClass.flag = true`。
- `Instance Final` 生成 receiver 原地字段更新，例如调用点是 `option.acceptsArg()`，receiver 就是 `option`，插桩会更新 `option` 的变更字段。
- `Args Final` 生成实参原地更新，例如调用点是 `fill(values)`，如果 `values` 被依赖方法改了，就对 `values` 做 reset 或字段赋值。

源码插桩只在简单调用点安全执行。当前安全形态包括独立调用、`let/var x = dep()`，以及简单的 `x = dep()`。这些位置可以在物理调用行后面插入一段普通语句，不改变调用求值顺序。

插桩前的 Cangjie 形态类似：

```cj
func handle(values: ArrayList<String>) {
    parser.fill(values)
    this.size = values.size
}
```

如果 workflow 记录到 `parser.fill(values)` 会把实参 `values` 改成 `["a", "b"]`，源码插桩后会变成：

```cj
func handle(values: ArrayList<String>) {
    parser.fill(values)
    // __SIDEEFFECT_STUB_BEGIN__
    __mockResetArrayList<String>(values, ["a", "b"])
    // __SIDEEFFECT_STUB_END__
    this.size = values.size
}
```

receiver 副作用也是同样思路。比如依赖调用本身修改 receiver：

```cj
func handle(option: Option) {
    let accepted = option.acceptsArg()
    this.accepted = accepted
}
```

如果 final snapshot 显示 `option` 的字段被依赖调用改了，插桩后会在调用行后写回 receiver 的变更字段：

```cj
func handle(option: Option) {
    let accepted = option.acceptsArg()
    // __SIDEEFFECT_STUB_BEGIN__
    option.numberOfArgs = 1i64
    option.values = __mockArrayListOf<String>(["x"])
    // __SIDEEFFECT_STUB_END__
    this.accepted = accepted
}
```

这就是为什么表达式位置会成为 blocker。下面这种调用点不能直接插入一段语句：

```cj
if (currentOption != None && currentOption.acceptsArg() && isArgument(token)) {
    currentOption.addValueForProcessing(token)
}
```

如果在 `currentOption.acceptsArg()` 后面需要回放 receiver/static/arg 副作用，插桩器没有一个既能插入普通语句、又能保持 `&&` 短路求值语义的位置。因此它不会强行改写表达式，而是报告 `expression-side-effect-unreplayable`。测试运行结束后，`deinstrument` 会按 `// __SIDEEFFECT_STUB_BEGIN__` 和 `// __SIDEEFFECT_STUB_END__` 标记删除这些临时插桩块。

## 按焦点方法去重的合并统计

本节把 `jansi` 与当前 `commons-cli` 语料合并后，计数单位从生成测试文件改为焦点方法签名：`(project, focal call, focal argc, focal arg types)`。这样可以区分重载，也能避免长链测试反复生成同一类 focal call 后把比例拉偏。

同一个焦点方法签名如果在任意生成测试中触发严格 blocker，则归入“需要 mock，但不可独立测试”；否则如果任意生成测试存在非空 workflow 且可重放，则归入“可 mock 且可独立测试”；否则归入“无依赖链；不需要 mock”。

| 类别 | 焦点方法签名数 | 占比 |
|---|---:|---:|
| 无依赖链；不需要 mock | 142 | 46.1% |
| 可 mock 且可独立测试 | 70 | 22.7% |
| 需要 mock，但不可独立测试 | 96 | 31.2% |
| Workflow 缺失 | 0 | 0.0% |
| 总计 | 308 | 100.0% |

只在“需要 mock 的焦点方法”里看，`70 / (70 + 96) = 42.2%` 可以 mock 且可独立测试。按 test-file 口径，合并分类为：无依赖链 `4018`，可 mock 且可独立测试 `1315`，需要 mock 但不可独立测试 `1286`，对应比例为 `60.7% / 19.9% / 19.4%`。

### 焦点方法级 Blocker

| Blocker | 受影响焦点方法签名数 | 依赖出现次数 |
|---|---:|---:|
| `instance-method-dependency` | 73 | 94 |
| `expression-side-effect-unreplayable` | 32 | 40 |

### 合并焦点方法级示例

| 类别 | 示例焦点方法签名 |
|---|---|
| 无依赖链；不需要 mock | `org.fusesource.jansi.Ansi.setEnabled(boolean)` |
| 无依赖链；不需要 mock | `org.fusesource.jansi.internal.JansiLoader.readNBytes(byte[], Int64, Int64)` |
| 可 mock 且可独立测试 | `org.fusesource.jansi.AnsiRenderer.render0(String)` |
| 可 mock 且可独立测试 | `org.fusesource.jansi.Ansi.a0(Attribute)` |
| 可 mock 且可独立测试 | `org.fusesource.jansi.Ansi.fg0(Color)` |
| 可 mock 且可独立测试 | `org.apache.commons.cli.Options.hasOption(String)` |
| 需要 mock，但不可独立测试 | `org.fusesource.jansi.Ansi.a1(String)` |
| 需要 mock，但不可独立测试 | `org.fusesource.jansi.Ansi.toString()` |
| 需要 mock，但不可独立测试 | `org.apache.commons.cli.Option.acceptsArg()` |

结论：把 jansi 和当前 commons-cli 语料合并后，按 test-file 口径，需要 mock 的样本中 `50.6%` 当前可 mock 且可独立测试；按 focal-method 口径，需要 mock 的焦点签名中 `42.2%` 当前可 mock 且可独立测试。剩余不可独立部分主要来自 `this`/private/self-call、真实 receiver mutation，以及需要副作用重放但调用点处于复杂表达式的位置；这些不能靠普通 `@On(mockReceiver.method(...))` 解决。表达式副作用 blocker 只在需要副作用重放时才阻塞，单纯的 `dep() + 1` 返回值表达式不应被当成天然不可独立。

## Fragment 到 Mock 测试的流程

最简流程如下：

1. 跑 Java fragment，Aspect 记录 `.log`。
2. `log_parser.py` 解析日志，切出 workflow。
3. `change_mode` 把原始 replay/validation 形态切到 mock 生成模式。
4. `script.py` 生成 Cangjie mock `_test.cj` 和 `.workflow.json`。
5. 生成 `@On(...)` 桩；能绑定 receiver 的实例依赖会创建 mock receiver，并塞回 focal 参数或字段。
6. `side_effect.py` 判断是否需要源码插桩回放副作用；安全则插 `__SIDEEFFECT_STUB`，不安全则记 blocker。
7. 跑 Cangjie 测试，比较返回值和 final state。
8. 跑完 `deinstrument` 清理临时插桩。
