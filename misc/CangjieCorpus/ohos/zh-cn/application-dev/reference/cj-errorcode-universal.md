# 通用错误码

## 201 权限校验失败

**错误信息**

Permission verification failed. The application does not have the permission required to call the API.

**错误描述**

权限校验失败，应用无权限使用该API，需要申请权限。

**可能原因**

该错误码表示权限校验失败，通常为没有权限，却调用了需要权限的API。

**处理步骤**

请检查是否有调用API的权限。

## 202 系统API权限校验失败

**错误信息**

Permission verification failed. A non-system application calls a system API.

**错误描述**

权限校验失败，非系统应用使用了系统API。

**可能原因**

非系统应用，使用了系统API，请校验是否使用了系统API。

**处理步骤**

请检查是否调用了系统API，并且去掉。

## 401 参数检查失败

**错误信息**

Parameter error. Possible causes: 1. Mandatory parameters are left unspecified; 2. Incorrect parameter types; 3. Parameter verification failed.

**错误描述**

1. 必填参数为空。

2. 参数类型不正确。

3. 参数校验失败。

**可能原因**

1. 必选参数没有传入。

2. 参数类型错误 (Type Error)。

3. 参数数量错误 (Argument Count Error)。

4. 空参数错误 (Null Argument Error)。

5. 参数格式错误 (Format Error)。

6. 参数值范围错误 (Value Range Error)。

**处理步骤**

请检查必选参数是否传入，或者传入的参数类型是否错误。对于参数校验失败，阅读参数规格约束，按照可能原因进行排查。

## 801 该设备不支持此API

**错误信息**

Capability not supported. Failed to call the API due to limited device capabilities.

**错误描述**

该设备不支持此API，通常用于在设备已支持该SysCap时，针对其少量的API的支持处理。

**可能原因**

该设备不支持此API。

**处理步骤**

请检查设备是否支持使用的API。
