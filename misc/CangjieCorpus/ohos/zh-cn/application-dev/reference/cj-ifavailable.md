# API标签化管控

## 概述

通常，开发者需要对一些 API 进行标签化，使得这些 API 能够根据标签被限定在源码的不同位置使用。全局标签会从 Deveco Studio 创建的仓颉工程中获取，例如：创建的工程为 5.1.0，那么它的全局 API level 为 18。 标签化的 API 需要满足全局的标签配置才能够被合法使用。

为了做到 API 标签化管控，仓颉语言引入了 `@IfAvailable` 宏表达式。它可以基于全局的标签设置，提供更精细的标签化 API 的使用管控。`@IfAvailable` 需要与自定义注解 `APILevel` 配合使用，本章将介绍 `@IfAvailable` 的功能及使用方法。

## `@IfAvailable` 的语法

<!-- compile -->

```cangjie
@IfAvailable(<label>: <value>, <lambda1>, <lambda2>)
```

其中：

- `<label>` 为自定义注解 `APILevel` 的参数名称；
- `<value>` 为该注解类型的参数，仅支持字面量表达式；
- `<label>: <value>` 构成了 `@IfAvailable` 的条件；
- `<lambda1>` 和 `<lambda2>` 需满足 Lambda 表达式的语法，且被限定为无形参的形式，`<lambda1>` 和 `<lambda2>` 的返回类型由编译器推断为 `Unit`。

## `@IfAvailable` 的语义

若 `@IfAvailable` 的条件在运行态是成立的，则 `<lambda1>` 的函数体会被执行，否则 `<lambda2>` 的函数体会被执行。`<lambda1>` 中所有调用的符号将被标记为弱符号，不要求编译链接时一定能够找到。

在一个仓颉工程中，使用 `@IfAvailable` 表达式时会默认隐式导入依赖包 `ohos.device_info` 和 `ohos.base`，不需要手动导入。

### `level` 检查

`@IfAvailable` 宏表达式中，指定 `<label>` 为 `level` 时，该检查生效。

在任何作用域中，不允许调用比当前作用域更高 Level 的 API。即 `<lambda1>` 中不得调用高于 `level: <value>` 中 `<value>` 指定的值，在 `<lambda2>` 中不得调用高于当前工程的 Level 等级。

### `syscap` 检查

`@IfAvailable` 宏表达式中，指定 `<label>` 为 `syscap` 时，该检查生效。

> **说明：**
>
> - 交集：所有设备同时拥有的能力集合；
> - 并集：至少有一个设备拥有的能力集合。

**检查规则：**

- 当调用的 API 满足**交集**时，不报错；
- 当调用 API 不满足**交集**，但满足**并集**时，编译告警；
- 当调用 API 既不满足**交集**，也不满足时**并集**，编译报错。

在任何作用域中，不允许调用任何设备中都不支持的 API，允许调用 syscap 在**交集**与**并集**中的 API。`@IfAvailable` 可以为**交集**与**并集**增加能力，即 `<lambda1>` 中可以调用 `syscap: <value>` 中 `<value>` 指定的 syscap API，在 `<lambda2>` 中则不允许。

## `@IfAvailable` 使用示例

### 使用 `IfAvailable` 控制 `APILevel`

前置依赖，提供不同标签的 API：

<!-- compile -pkg0 -->

```cangjie
package ohos.sample

@!APILevel[17]
public func f17() {
    println("level-17")
}

@!APILevel[18]
public func f18() {
    println("level-18")
}

@!APILevel[19]
public func f19() {
    println("level-19")
}
```

假设 `ohos.sample` 为 sdk 提供的包，用户使用 Deveco Studio 仓颉项目工程时可以选择所需的 level 等级：

![image-Create-Project-With-Level](./figures/image-Create-Project-With-Level.png)

使用 `@IfAvailable` 时，`<label>: <value>` 为 `level: xx`，`xx` 为数值字面量。

<!-- compile -pkg0 -->

```cangjie
import ohos.sample.*

func demo() {
    @IfAvaliable(level: 19, { =>
        // 编译期：此作用域允许调用 level 为 19 或 19 以下的 API。即该分支能够使用 f17, f18, f19，调用更高等级接口会编译报错。
        // 运行期：当执行设备支持 level 19，那么执行该分支。
        f17();
        f18();
        f19();
    }, { =>
        // 编译期：此作用域使用工程提供的能力，允许调用 level 为 18 或 18 以下的 API。即该分支能够使用 f17, f18，调用更高等级接口会编译报错（如 f19）。
        // 运行期：当执行设备支持 level 18，那么执行该分支。
        f17();
        f18();
        f19(); // compile error
    })
}
```

### 使用 `IfAvailable` 控制 `syscap`

前置依赖，提供不同标签 `syscap` 的 API：

<!-- compile -pkg1 -->

```cangjie
package ohos.sample

@!APILevel[18, syscap: "SystemCapability.A"]
public func f1() {
    println("SystemCapability.A")
}

@!APILevel[18, syscap: "SystemCapability.B"]
public func f2() {
    println("SystemCapability.B")
}

@!APILevel[18, syscap: "SystemCapability.C"]
public func f3() {
    println("SystemCapability.C")
}

@!APILevel[18, syscap: "SystemCapability.D"]
public func f4() {
    println("SystemCapability.D")
}
```

Deveco Studio 默认读取所有设备支持的 SystemCapability，用于检查作用域中是否允许使用带有标签的 API。

假设 `ohos.sample` 为 sdk，此时设备1的 syscap 为 `["SystemCapability.A", "SystemCapability.B"]`，设备2的 syscap 为 `["SystemCapability.B", "SystemCapability.C"]`

使用 `@IfAvailable` 时，`<label>: <value>` 为 `syscap: "SystemCapability.xx"`，`"SystemCapability.xx"` 为字符串字面量。

<!-- compile -pkg1 -->

```cangjie
import ohos.sample.*

func demo() {
    @IfAvaliable(syscap: "SystemCapability.D", { =>
        // 此作用域最高允许使用 ["SystemCapability.A", "SystemCapability.B", "SystemCapability.C", "SystemCapability.D"]，其中：
        // ["SystemCapability.B", "SystemCapability.D"] 不告警；
        // ["SystemCapability.A", "SystemCapability.C"] 告警；
        // 非 ["SystemCapability.A", "SystemCapability.B", "SystemCapability.C", "SystemCapability.D"] 报错
        f1();  // warning
        f2();  // ok
        f3();  // warning
        f4();  // ok
    }, { =>
        // 此作用域最高允许使用 ["A", "B", "C"]，其中：
        // ["B"] 不告警；
        // ["A", "C"] 告警；
        // 非 ["A", "B", "C"] 报错
        f1();  // warning
        f2();  // ok
        f3();  // warning
        f4();  // error
    })
}
```
