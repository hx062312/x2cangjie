# ohos.business_exception（通用异常信息）

本模块定义了接口调用过程中出现的常见异常信息。

## class BusinessException

```cangjie
public class BusinessException <: Exception {
    public let code: Int32
}
```

**功能：** 业务异常类，继承自Exception类。

**系统能力：** SystemCapability.Base

**起始版本：** 22

**父类型：**

- Exception

### let code

```cangjie
public let code: Int32
```

**功能：** 错误码。

**类型：** Int32

**读写能力：** 只读

**起始版本：** 22

### func getData\<T>()

```cangjie
public func getData<T>(): ?T
```

**功能：** 额外补充异常信息。

**类型：** T

**读写能力：** 只读

**起始版本：** 22

### func toString()

```cangjie
public open func toString(): String
```

**功能：** 获取错误信息字符串。

**系统能力：** SystemCapability.Base

**起始版本：** 22

**返回值：**

| 类型 | 说明    |
|:----|:------|
| String | 错误信息。|

### func getClassName()

```cangjie
protected override func getClassName(): String
```

**功能：** 获取异常类型名称。

**系统能力：** SystemCapability.Base

**起始版本：** 22

**返回值：**

| 类型     | 说明    |
|:-------|:------|
| String | 类型名称。 |

## type AsyncCallback

```cangjie
public type AsyncCallback<T>=(Option<AsyncError>, Option<T>) -> Unit
```

**功能：** 定义了异步回调类型。

**系统能力：** SystemCapability.Base

**起始版本：** 22
