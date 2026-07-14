# 获取密钥属性（仓颉）

HUKS提供了接口供业务获取指定密钥的相关属性。在获取指定密钥属性前，需要确保已在HUKS中生成或导入持久化存储的密钥。

> **说明：**
>
> 轻量级设备不支持获取密钥属性功能。

## 开发步骤

1. 指定待查询的密钥别名keyAlias，密钥别名最大长度为128字节。

2. 调用接口[getKeyItemProperties](../../reference/UniversalKeystoreKit/cj-apis-security_huks.md#func-getkeyitempropertiesstring-huksoptions)，传入参数keyAlias和options。options为预留参数，当前可传入空值。

3. 返回值为Array\<[HuksParam](../../reference/UniversalKeystoreKit/cj-apis-security_huks.md#class-huksparam)>类型的对象，获取的属性集合在properties字段中。

## 示例

<!-- compile -->

```cangjie
import kit.PerformanceAnalysisKit.Hilog
import kit.BasicServicesKit.*
import kit.CoreFileKit.*
import kit.AbilityKit.*
import kit.UniversalKeystoreKit.*

func loggerInfo(str: String) {
    Hilog.info(0, "CangjieTest", str)
}

func test() {
    /* 1. 设置密钥别名 */
    let keyAlias = "keyAlias"
    /* options对象传空 */
    let emptyOptions: HuksOptions = HuksOptions(properties: [], inData: Bytes())
    try {
        /* 2. 获取密钥属性 */
        getKeyItemProperties(keyAlias, emptyOptions)
        loggerInfo("getKeyItemProperties success")
    } catch (e: Exception) {
        loggerInfo("getKeyItemProperties input arg invalid, ${e.toString()}")
    }
}
```
