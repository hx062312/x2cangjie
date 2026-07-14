# 框架接口

此页面记录UI框架使用的公开接口，应用开发者禁止使用，否则会产生无法预期的结果。

## 导入模块

```cangjie
import kit.ArkUI.*
```

## func bind((CustomView) -> ViewBuilder, CustomView)

```cangjie
public func bind(builder: (CustomView) -> ViewBuilder, thisView: CustomView): () -> Unit
```

**功能：** 用于将@Builder修饰的函数与自定义组件对象进行绑定。详情见bind函数使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|builder|([CustomView](#class-customview))->[ViewBuilder](#class-viewbuilder)|是|-|[@Builder](../../arkui-cj/paradigm/cj-macro-builder.md)修饰的函数类型。|
|thisView|[CustomView](#class-customview)|是|-|当前自定义组件对象（一般为this）。|

**返回值：**

|类型|说明|
|:----|:----|
|() -> Unit|返回builder函数。|

## func bind\<T1>((CustomView,ObservedProperty\<T1>) -> ViewBuilder, CustomView)

```cangjie
public func bind<T1>(builder: (CustomView, ObservedProperty<T1>) -> ViewBuilder, thisView: CustomView): (T1) -> Unit
```

**功能：** 用于将@Builder修饰的函数与自定义组件对象进行绑定。详情见bind函数使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|builder|([CustomView](#class-customview),[ObservedProperty](./cj-state-rendering-componentstatemanagement.md#class-observedpropertyt)\<T1>)->[ViewBuilder](#class-viewbuilder)|是|-|[@Builder](../../arkui-cj/paradigm/cj-macro-builder.md)修饰的函数类型。|
|thisView|[CustomView](#class-customview)|是|-|当前自定义组件对象（一般为this）。|

**返回值：**

|类型|说明|
|:----|:----|
|(T1) -> Unit|返回builder函数。|

## func bind\<T1, T2>((CustomView,ObservedProperty\<T1>,ObservedProperty\<T2>) -> ViewBuilder, CustomView)

```cangjie
public func bind<T1, T2>(
    builder: (CustomView, ObservedProperty<T1>, ObservedProperty<T2>) -> ViewBuilder,
    thisView: CustomView
): (T1, T2) -> Unit
```

**功能：** 用于将@Builder修饰的函数与自定义组件对象进行绑定。详情见bind函数使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|builder|([CustomView](#class-customview),[ObservedProperty](./cj-state-rendering-componentstatemanagement.md#class-observedpropertyt)\<T1>,[ObservedProperty](./cj-state-rendering-componentstatemanagement.md#class-observedpropertyt)\<T2>)->[ViewBuilder](#class-viewbuilder)|是|-|[@Builder](../../arkui-cj/paradigm/cj-macro-builder.md)修饰的函数类型。|
|thisView|[CustomView](#class-customview)|是|-|当前自定义组件对象（一般为this）。|

**返回值：**

|类型|说明|
|:----|:----|
|(T1, T2) -> Unit|返回builder函数。|

## func bind\<T1, T2, T3>((CustomView,ObservedProperty\<T1>,ObservedProperty\<T2>,ObservedProperty\<T3>) -> ViewBuilder, CustomView)

```cangjie
public func bind<T1, T2, T3>(builder: (CustomView, ObservedProperty<T1>, ObservedProperty<T2>,
    ObservedProperty<T3>) -> ViewBuilder, thisView: CustomView)
```

**功能：** 用于将@Builder修饰的函数与自定义组件对象进行绑定。详情见bind函数使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|builder|([CustomView](#class-customview),[ObservedProperty](./cj-state-rendering-componentstatemanagement.md#class-observedpropertyt)\<T1>,[ObservedProperty](./cj-state-rendering-componentstatemanagement.md#class-observedpropertyt)\<T2>,[ObservedProperty](./cj-state-rendering-componentstatemanagement.md#class-observedpropertyt)\<T3>)->[ViewBuilder](#class-viewbuilder)|是|-|[@Builder](../../arkui-cj/paradigm/cj-macro-builder.md)修饰的函数类型。|
|thisView|[CustomView](#class-customview)|是|-|当前自定义组件对象（一般为this）。|

## class RemoteView

```cangjie
public abstract class RemoteView {
    public init()
}
```

**功能：** UI框架使用的组件基础类。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### init()

```cangjie
public init()
```

**功能：** 构造一个RemoteView类型的对象，仅在UI框架场景下有效。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func build()

```cangjie
public func build(): Unit
```

**功能：** 用于定义自定义组件的声明式UI描述，自定义组件必须定义build()函数。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func rerender()

```cangjie
public open func rerender(): Unit
```

**功能：** 框架自动触发 rerender，重新执行组件的 build() 方法来更新 UI。仅供UI框架使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func purgeVariableDependenciesOnElmtId(Int64)

```cangjie
public func purgeVariableDependenciesOnElmtId(_: Int64): Unit
```

**功能：** 负责清除该组件ID绑定的状态变量依赖，避免内存泄漏或无效引用。仅供UI框架使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|_|Int64|是|-|-|

### func forceCompleteRerender(Bool)

```cangjie
public func forceCompleteRerender(deep: Bool): Unit
```

**功能：** 强制重新渲染组件树。仅供UI框架使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|deep|Bool|是|-|-|

## class CustomView

```cangjie
public abstract class CustomView <: RemoteView {
    public init(parent: Option<CustomView>, localStorage: Option<LocalStorage>)
}
```

**功能：** UI框架使用的组件基础类。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**父类型：**

- [RemoteView](#class-remoteview)

### init(Option\<CustomView>, Option\<LocalStorage>)

```cangjie
public init(parent: Option<CustomView>, localStorage: Option<LocalStorage>)
```

**功能：** 构造一个CustomView类型的对象，仅在实现UI框架场景下有效。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|parent|Option\<[CustomView](#class-customview)>|是|-|父组件。|
|localStorage|Option\<[LocalStorage](./cj-state-rendering-appstatemanagement.md#class-localstorage)>|是|-|持久化存储对象。|

### func getLocalStorage()

```cangjie
public func getLocalStorage(): LocalStorage
```

**功能：** 获取LocalStorage实例。仅供UI框架使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**返回值：**

|类型|说明|
|:----|:----|
|[LocalStorage](./cj-state-rendering-appstatemanagement.md#class-localstorage)|持久化存储对象。|

### func build()

```cangjie
public func build(): Unit
```

**功能：** 用于定义自定义组件的声明式UI描述，自定义组件必须定义build()函数。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func aboutToBeDeleted()

```cangjie
public func aboutToBeDeleted(): Unit
```

**功能：** 组件销毁阶段由架自动触发。仅供UI框架使用。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func getUIContext()

```cangjie
public func getUIContext(): UIContext
```

**功能：** 获取UIContext对象。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

**返回值：**

|类型|说明|
|:----|:----|
|[UIContext](./cj-apis-uicontext-uicontext.md#class-uicontext)|UI上下文。|

## class ViewBuilder

```cangjie
public class ViewBuilder {
}
```

**功能：** UI框架使用的基础类。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

## class CJPageEntry

```cangjie
public class CJPageEntry {}
```

**功能：** 用于提供被Native调用的全局函数。

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### static func getInstance()

```cangjie
public static func getInstance(): CJPageEntry
```

**功能：** 创建并返回CJPageEntry对象。

**返回值：**

|类型|说明|
|:----|:----|
|[CJPageEntry](#class-cjpageentry)|对应的CJPageEntry对象。|

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func registerHybridPage(String, CustomView)

```cangjie
public func registerHybridPage(name: String, cjPage: CustomView): Unit
```

**功能：** 注册混合页面，UI框架使用。

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|name|String|是|-|注册名称。|
|cjPage|[CustomView](#class-customview)|是|-|回调函数。|

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22

### func removeHybridPage(String)

```cangjie
public func removeHybridPage(name: String): Unit
```

**功能：** 移除对应名称的混合页面。

**参数：**

|参数名|类型|必填|默认值|说明|
|:---|:---|:---|:---|:---|
|name|String|是|-|混合页面名称|

**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**起始版本：** 22
