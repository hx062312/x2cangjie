# OpenHarmony中仓颉能力概述

## 一、仓颉特征及支持场景

仓颉定位为面向OpenHarmony应用开发的现代编程语言，是一款静态类型、静态编译的编程语言，通过现代语言特性的集成、全方位的编译优化和运行时实现、以及开箱即用的工具链支持，为OpenHarmony应用开发者打造友好开发体验和卓越程序性能。

仓颉语言的基本特征：

* 静态类型系统：仓颉是静态类型语言，程序中变量和表达式的类型均在编译期确定，并不会在运行期发生改变。静态类型系统能够在编译期发现程序中的错误，减少后期问题调试定位时间。
* 简明语法：仓颉吸收了静态类型应用开发语言的优秀设计理念和语法特征，因此这些语言的开发者学习仓颉成本较低；同时，仓颉支持类型推断和丰富的语法糖，使编程简洁高效。此外，仓颉还提供元编程能力，允许开发者针对特定业务快速设计领域特定语言（DSL），进一步提升了仓颉的易用性。
* 多范式支持：仓颉是一个典型的多范式编程语言，对过程式、面向对象和函数式编程都提供了良好的支持。开发者可以灵活选择或混合使用不同的编程范式，来满足不同开发场景的需求。
* 丰富的标准库：仓颉提供了丰富、通用、性能卓越的标准库，包括集合类库、IO库、数据库、网络库、安全库、OS库、数学库、数据结构、排序算法、控制台读取写、正则表达式、time库、命令行处理库、fs 库、sync库等，助力开发者快速构建OpenHarmony应用。
* 快速成长的生态：仓颉已基于开源社区构建400多个三方库，基本覆盖Top5000应用所需的高频三方库范围。同时仓颉针对OpenHarmony应用开发的痛点场景，针对性优化了多个三方库，如MarkDown、protobuf、pako、bigint、lottie、formula-ffi、editor4cj等，这些库在功能和性能上都有较好的表现。

仓颉可适用于的业务场景包括但不限于：

* 关注开发效率、性能和安全平衡的的复杂应用开发场景
* 基于eDSL的编程，如UI DSL、数据库访问DSL、大数据处理DSL等
* 特定三方库需求场景，如MarkDown渲染、数据序列化等

当前仓颉能力已在以下类似场景中得到验证：

| 应用场景| 业务功能 | 仓颉能力 |
| :------:| ------ | ------ |
|  配送管理类场景<br>比如美团骑手| 应用主页提供新任务、待取货、配送中三大UI列表，基于用户位置信息，提供<br>订单任务的全流程跟踪； | 仓颉与ArkTS互操作、Ability Kit（程序框架服务）、ArkUI（方舟UI框架）、Image Kit<br>（图片处理服务）、Location Kit（位置服务）、Telephony Kit（蜂窝通信服务） 、<br>Basic Services Kit（基础服务）等 |
|   配送管理类场景<br>比如美团骑手 | 智能推理模块，结合传感器等实时采集信息，调用相关算法进行用户状态分析； | 仓颉与ArkTS/Python/JS互操作、Network Kit（网络服务）、Camera Kit（相机服务）、<br>Media Library Kit（媒体文件管理服务）、Sensor Service Kit（传感器服务）、Crypto <br>Architecture Kit（加解密算法框架服务）等|
|   配送管理类场景<br>比如美团骑手 |  语音和录音模块，调用媒体相关能力记录用户语言信息，并发送云端服务器；| Media Kit（媒体服务）、Core File Kit（文件基础服务）等  |
| 知识社交类场景<br>比如力扣 | 题目和题解模块，提供题目描述，并允许用户发帖分享解题思路和源码；  | ArkUI（方舟UI框架）、ArkWeb（方舟Web）等  |
| 知识社交类场景<br>比如力扣 | 在线编程，提供用户代码编辑、实时高亮，并且发送服务端判题；  | ArkData（方舟数据管理）、Network Kit（网络服务）等 |
| 知识社交类场景<br>比如力扣 | 个人信息模块，个人信息显示与编辑，包括姓名、头像等； |  Core File Kit（文件基础服务）、Image Kit（图片处理服务）等|
| 新兴AI类场景<br>比如纳米AI，Kimi | 对话界面，类似于即时通讯，支持用户文字输入、文件上传等功能，以及显示<br>AI回复内容，以及AI与用户的实时交互； | ArkUI（方舟UI框架）、 Core File Kit（文件基础服务）、Network Kit（网络服务）等|

## 二、支持的能力

以下是仓颉面向OpenHarmony提供的相关能力，详细描述可参考[仓颉开发文档](https://gitcode.com/openharmony-sig/docs_cangjie/blob/master/README_zh.md)。

### 1. ArkUI

仓颉版ArkUI框架提供了基于仓颉语言的声明式开发范式（简称“声明式开发范式”），适用于不同的应用场景及技术背景。它是一套开发极简、高性能、支持跨设备的UI开发框架，提供了构建应用UI所必需的能力，主要包括：

- 布局：布局是UI的必要元素，它定义了组件在界面中的位置。ArkUI框架提供了多种布局方式，除了基础的线性布局、层叠布局、弹性布局、相对布局、栅格布局外，也提供了相对复杂的列表、宫格、轮播。
- 组件：组件是UI的必要元素，形成了在界面中的样子，由框架直接提供的称为系统组件，由开发者定义的称为自定义组件。系统内置组件包括按钮、单选框、进度条、文本等。开发者可以通过链式调用的方式设置系统内置组件的渲染效果。开发者可以将系统内置组件组合为自定义组件，通过这种方式将页面组件化为一个个独立的UI单元，实现页面不同单元的独立创建、开发和复用，具有更强的工程性。
- 页面路由：应用可能包含多个页面，可通过页面路由实现页面间的跳转。
- 图形：方舟开发框架提供了多种类型图片的显示能力和多种自定义绘制的能力，以满足开发者的自定义绘图需求，支持绘制形状、填充颜色、绘制文本、变形与裁剪、嵌入图片等。
- 动画：动画是UI的重要元素之一。优秀的动画设计能够极大地提升用户体验，框架提供了丰富的动画能力，除了组件内置动画效果外，还包括属性动画、显式动画、自定义转场动画以及动画API等，开发者可以通过封装的物理模型或者调用动画能力API来实现自定义动画轨迹。
- 交互事件：交互事件是UI和用户交互的必要元素。方舟开发框架提供了多种交互事件，除了触摸事件、鼠标事件、键盘按键事件、焦点事件等通用事件外，还包括基于通用事件进行进一步识别的手势事件。
- 自定义能力：自定义能力是UI开发框架提供给开发者对UI界面进行开发和定制化的能力。包括：自定义组合、自定义扩展。

### 2. API

仓颉API是为了支撑OpenHarmony应用使用仓颉语言开发而提供的一系列的API，并提供了详实的资料文档和样例代码。目前仓颉API近覆盖了部分OpenHarmony SDK开放能力。随着时间的推移，会逐步覆盖更多的开放能力。
仓颉API本次随OpenHarmony 6.x版本首次向应用开放，并将在后续版本中持续丰富API能力，目标是为仓颉应用提供全量的OpenHarmony系统能力。本次仓颉版API将优先提供安全、高性能、可并发和基础运行所需的能力，涉及5大类别，22个Kit：

* **应用框架**

    * ArkUI（方舟UI框架）：提供高性能的声明式开发范式。
    * ArkData（方舟数据管理）：提供高性能的分布式键值数据库、Key-Value键值型的数据处理能力。
    * ArkWeb（方舟Web）：提供高性能的web控制能力。
    * Core File Kit（文件基础服务）：提供支持并发的文件操作能力。
    * Ability Kit（程序框架服务）：提供应用运行所需的基础元能力、包管理和访问控制能力。
    * IPC Kit（进程间通信服务）：提供应用运行所需的进程间通信基础能力。
    * Localization Kit（本地化开发服务）：提供应用运行所需的国际化基础能力。
* **系统**

    * Crypto Architecture Kit（加解密算法框架服务）：提供安全类的密码算法库。加解密接口
    * Universal Keystore Kit（密钥管理服务）：提供安全类的密钥库能力，包括密钥管理及密钥的密码学操作等功能。
    * Network Kit（网络服务）：提供支持并发的HTTP数据请求能力
    * Connectivity Kit（短距通信服务）：提供高性能的蓝牙、wifi设备操作接口。
    * Sensor Service Kit（传感器服务）：提供高性能的传感器数据处理能力。
    * Basic Services Kit（基础服务）：提供应用运行所需的电源服务、事件通知、启动恢复、上传下载、设置数据等基础能力。
    * Performance Analysis Kit（性能分析服务）：提供应用运行所需的应用打点和事件订阅等基础能力。
    * Telephony Kit（蜂窝通信服务）：提供应用运行所需的呼叫管理基础功能。
    * Test Kit（应用测试服务）：提供应用运行所需的测试调测框架。
* **媒体**

    * Camera Kit（相机服务）：提供高性能的相机服务接口。
    * Image Kit（图片处理服务）：提供可并发的解码、编码、编辑、元数据处理和图片接收等能力。
    * Media Kit（媒体服务）：提供可并发的音视频相关媒体业务访问能力。
    * Media Library Kit（媒体文件管理服务）：提供可并发的相册管理能力，包括创建相册、访问和修改相册中的媒体数据。

* **图形**

    * ArkGraphics 2D（方舟2D图形服务）：提供应用运行所的抽象化色域对象管理的基础能力。

* **应用服务**

    * Location Kit（位置服务）：提供应用运行所需定位基本功能。

当前仓颉暂不支持的API，用户可通过仓颉->ArkTS和仓颉->C跨语言互操作的方式调用ArkTS API或者NDK API。

### 3. 与ArkTS互操作

在OpenHarmony应用开发中，存在使用仓颉与ArkTS混合开发的诉求，例如以下场景：

- 场景一：在使用ArkTS开发时，通过跨语言互操作调用仓颉开发的代码模块，发挥仓颉高性能高并发优势，提升应用性能体验；
- 场景二：在使用仓颉开发时，通过跨语言互操作调用ArkTS库，复用ArkTS丰富的库生态；

针对互操作场景诉求，仓颉提供 **ark_interop** 互操作库来实现与ArkTS的互操作。该库主要提供以下关键数据结构：

- JSValue: 用于表示来自ArkTS中的对象（如数字、字符串、对象、函数），是仓颉与ArkTS类型转换的桥梁。
- JSRuntime: 用于管理ArkTS运行时，代表一个ArkTS运行时实例。
- JSContext: 用于表示与ArkTS互操作的上下文，提供模块加载、JSValue创建等能力。
- JSCallInfo: 用于表示当发生来自于ArkTS互操作调用时 调用的参数集合。
- JSModule: 用于模块注册，将仓颉侧的符号进行导出，并注册到ArkTS引擎。
- JSArray、JSObject、JSClass、JSFunction、JSHeapObject、JSExternal、JSPromise、JSBigInt：仓颉语言接口，用于创建和访问 ArkTS 语言中引用类型对象。
- JSSymbol、JSBoolean、JSNull、JSNumber、JSType、JSUndefined：仓颉语言接口，用于创建和访问 ArkTS 语言中值类型对象。

同时针对互操作带来的开发复杂度，仓颉提供声明式互操作宏 **ark_interop_macro**，使开发者可以使用宏“@Interop[ArkTS]”标注仓颉代码中需要导出给ArkTS使用的函数或类型，在编译阶段自动生成互操作“胶水层”代码及 ArkTS 接口声明，减少开发者手写互操作代码的复杂度。

#### 典型场景一：ArkTS调用仓颉

针对场景一的诉求，可使用互操作库，在仓颉侧实现可被互操作调用的接口，示例如下：

```cangjie
// 导入互操作库
import ohos.ark_interop.*

func addNumber(context: JSContext, callInfo: JSCallInfo): JSValue {
    // 从JSCallInfo获取参数列表
    let arg0: JSValue = callInfo[0]
    let arg1: JSValue = callInfo[1]
    // 把JSValue转换为仓颉类型
    let a: Float64 = arg0.toNumber()
    let b: Float64 = arg1.toNumber()
    // 实际仓颉函数行为
    let value = a + b
    // 把结果转换为JSValue
    let result: JSValue = context.number(value).toJSValue()
    // 返回 JSValue
    return result
}

// 必须注册该函数到JSModule中
let EXPORT_MODULE = JSModule.registerModule {
    runtime, exports =>
        exports["addNumber"] = runtime.function(addNumber).toJSValue()
}
```

然后在ArkTS侧就可以加载仓颉模块，并调用该接口

```ts
// 导入仓颉动态库，该动态库名称为仓颉包名的名称，该名称需要和互操作接口所在的包名一致
import { addNumber } from "libohos_app_cangjie_entry.so";

// 调用仓颉接口
let result = addNumber(1, 2);
```

该场景可以借助互操作宏简化开发，比如以上案例中仓颉侧代码可以简化成：

```cangjie
@Interop[ArkTS]
public func addNumber(a: Float64, b: Float64): Float64 {
    a + b
}
```

#### 典型场景二：仓颉调用ArkTS

针对场景二的诉求，可使用互操作库，加载ArkTS模块，并调用接口，示例如下：

```cangjie
func callInterop(x: Float64, y: Float64): Float64 {
    // 获取互操作上下文
    let context: JSContext = JSRuntime().mainContext
    // 加载目标ArkTS模块
    let module: JSObject = context.loadArkTSModule(JSModules.Entry).asObject(context)

    // 获取ArkTS模块导出函数
    let addNumber = module["addNumber"].asFunction(context)
    // 调用ArkTS函数
    let result = addNumber.call([context.number(x).toJSValue(), context.number(y).toJSValue()])

    return result.toFloat64()
}
```

### 4. IDE 功能

提供DevEco Studio仓颉开发插件，支持使用仓颉进行OpenHarmony应用的开发(纯仓颉应用、仓颉+ArkTS混合应用)，支持开发仓颉的静态库，提供基础的工程管理、编译构建、语言服务、调试服务等应用开发能力，暂不支持动态库、UI预览、静态检查、性能调优、测试服务功能。
开发者在下载安装DevEco Studio后，获取并安装仓颉开发插件至对应版本的DevEco Studio，下载对应OpenHarmony SDK，进行仓颉OpenHarmony应用开发。 仓颉开发的特性全貌将主要有以下方面：

- 工程管理和创建：

  **工程目录结构：仓颉工程目录结构**

  DevEco Studio支持创建仓颉工程，其工程目录结构如下：

  ```text
  Project_name
  ├── .hvigor
  ├── .idea
  ├── AppScope
  ├── entry
  │    ├── libs
  │    ├── src
  │    │    ├── main
  │    │    │    ├── cangjie
  │    │    │    │    ├── ability_stage.cj
  │    │    │    │    ├── index.cj
  │    │    │    │    └── main_ability.cj
  │    │    │    ├── resources
  │    │    │    └── module.json5
  │    │    └── ohosTest
  │    ├── build-profile.json5
  │    ├── cjpm.toml
  │    ├── hvigorfile.ts
  │    └── oh-package.json5
  ├── hvigor
  │    └── hvigor-config.json5
  ├── oh_modules
  ├── build-profile.json5
  ├── code-linter.json5
  ├── hvigorfile.ts
  ├── local.properties
  ├── oh-package.json5
  └── oh-package-lock.json5
  ```

  其中关键文件信息如下：

    - **AppScope > app.json5**：应用的全局配置信息。
    - **entry**：应用模块，编译构建生成一个HAP。
        - **src > main > cangjie**：用于存放仓颉源码。
        - **src > main > resources**：用于存放应用所用到的资源文件，如图形、多媒体、字符串、布局文件等。
        - **src > main > module.json5**：Stage 模块配置文件，主要包含HAP的配置信息、应用在具体设备上的配置信息以及应用的全局配置信息。
        - **build-profile.json5**：当前的模块信息、编译信息配置项，包括buildOption、targets配置等。
        - **hvigorfile.ts**：模块级编译构建任务脚本。
        - **cjpm.toml**：仓颉的包管理配置文件。
        - **oh-package.json5**：描述三方包的包名、版本、入口文件（类型声明文件）和依赖项等信息。
        - **src > ohosTest**：存放仓颉测试源码，用于仓颉仪器测试。
    - **hvigor**：用于存放当前工程使用的 hvigor。
        - **hvigor-config.json5**：指定工程全局使用的 hvigor 以及 hvigor 参数配置。
    - **oh_modules**：用于存放三方库依赖信息，包含应用/服务所依赖的第三方库文件。
    - **build-profile.json5**：应用级配置信息，包括签名、产品配置等。
    - **hvigorfile.ts**：应用级编译构建任务脚本。
    - **oh-package.json5**：描述全局配置，如：依赖覆盖（overrides）、依赖关系重写（overrideDependencyMap）和参数化配置（parameterFile）等。

  **工程目录结构：仓颉与ArkTS互操作工程目录结构**

  DevEco Studio支持创建仓颉与ArkTS互操作工程，其工程目录结构如下：

  ```text
  Project_name
  ├── .hvigor
  ├── .idea
  ├── AppScope
  │    └── app.json5
  ├── entry
  │    ├── libs
  │    ├── oh_modules
  │    ├── src
  │    │    ├── main
  │    │    │    ├── cangjie
  │    │    │    │    ├── types
  │    │    │    │    └── index.cj
  │    │    │    ├── ets
  │    │    │    │    ├── entryability
  │    │    │    │    ├── entrybackupability
  │    │    │    │    └── pages
  │    │    │    ├── resources
  │    │    │    └── module.json5
  │    │    ├── mock
  │    │    ├── ohosTest
  │    │    └── test
  │    ├── build-profile.json5
  │    ├── cjpm.toml
  │    ├── hvigorfile.ts
  │    ├── obfuscation-rules.txt
  │    ├── oh-package.json5
  │    └── oh-package-lock.json5
  ├── hvigor
  │    └── hvigor-config.json5
  ├── oh_modules
  ├── build-profile.json5
  ├── code-linter.json5
  ├── hvigorfile.ts
  ├── local.properties
  ├── oh-package.json5
  └── oh-package-lock.json5
  ```

    - **AppScope > app.json5**：应用的全局配置信息。
    - **entry**：应用模块，编译构建生成一个HAP。
        - **src > main > cangjie > loader**：提供加载仓颉so的方法声明，帮助ArkTS调用仓颉中注册的方法。
        - **src > main > cangjie**：用于存放仓颉源码。
        - **src > main > ets**：用于存放ArkTS源码。
        - **src > main > resources**：用于存放应用所用到的资源文件，如图形、多媒体、字符串、布局文件等。
        - **src > main > module.json5**：Stage 模块配置文件，主要包含HAP的配置信息、应用在具体设备上的配置信息以及应用的全局配置信息。
        - **build-profile.json5**：当前的模块信息、编译信息配置项，包括 buildOption、targets 配置等。
        - **hvigorfile.ts**：模块级编译构建任务脚本。
        - **cjpm.toml**：仓颉的包管理配置文件。
        - **oh-package.json5**：描述三方包的包名、版本、入口文件（类型声明文件）和依赖项等信息。
    - **hvigor**：用于存放当前工程使用的 hvigor。
        - **hvigor-config.json5**：指定工程全局使用的 hvigor 以及 hvigor 参数配置。
    - **oh_modules**：用于存放三方库依赖信息，包含应用/服务所依赖的第三方库文件。
    - **build-profile.json5**：应用级配置信息，包括签名、产品配置等。
    - **hvigorfile.ts**：应用级编译构建任务脚本。
    - **oh-package.json5**：描述全局配置，如：依赖覆盖（overrides）、依赖关系重写（overrideDependencyMap）和参数化配置（parameterFile）等。

  **创建仓颉工程**

  1. 通过如下两种方式，打开工程创建向导界面。
     - 如果当前未打开任何工程，可以在DevEco Studio的欢迎页，选择**Create Project**开始创建一个新工程。
     - 如果已经打开了工程，可以在菜单栏选择**File > New > Create Project**来创建一个新工程。
  2. 根据工程创建向导，选择 **[Cangjie] Empty Ability** 模板。

     ![image](./figures/capability/cangjieTemplate.png)

  3. 在工程配置页面，需要根据向导配置工程的基本信息。

     ![image](./figures/capability/cangjieConfig.png)

     - **Project name**：工程的名称，可以自定义，由大小写字母、数字和下划线组成。
     - **Bundle name**：标识应用的包名，用于标识应用的唯一性。

       应用包名要求：
       - 必须为以点号（.）分隔的字符串，且至少包含三段，每段中仅允许使用英文字母、数字、下划线（_），如“com.example.myapplication ”。
       - 首段以英文字母开头，非首段以数字或英文字母开头，每一段以数字或者英文字母结尾，如“com.01example.myapplication”。
       - 不允许多个点号（.）连续出现，如“com.example..myapplication ”。
       - 长度为7~128个字符。
     - **Save location**：工程文件本地存储路径，由大小写字母、数字和下划线等组成，不能包含中文字符。
     - **Compatible SDK**：兼容的最低 API Version。
     - **Module name**： 模块的名称。
     - **Device type**：该工程模板支持的设备类型。

       对于开发应用过程中使用的某个API所支持的设备类型，可以通过下述方式进行查询：

       1. 在编辑器使用该API的位置，通过语言服务的悬浮提示查看该API syscap信息。
       2. 通过API声明位置的注释头中syscap字段获取该API的syscap标签，比如：SystemCapability.Communication.NFC.CardEmulation。
       3. 在DevEco的SDK中查看所有设备支持的syscap能力，具体位置为:
          - ohos: deveco-studio\sdk\default\openharmony\ets\api\device-define
       4. 查找openharmony目录，按照设备类型{A}，查找{A}.json文件，该文件包含{A}设备全量syscap能力集合。
  4. 单击 **Finish**，工具会自动生成示例代码和相关资源，等待工程初始化，完成新工程创建。

     ![image](./figures/capability/finishCreateCangjie.png)

  **在已有ArkTS工程中引入仓颉**

  在工程界面，右键选择 **entry > New > Cangjie(Interop)** 使能仓颉与ArkTS混合模块。工程同步完成后，原有的ArkTS模块变为仓颉与ArkTS混合模块。

  ![image](./figures/capability/startEnableCangjie.png)

- 代码编辑：代码高亮、代码补全、语法诊断、悬浮提示、定义跳转、引用查找、格式化等编码辅助能力，包括元编程相关的编码辅助能力。

  例如，代码补全：

  ![image](./figures/capability/funcCom.png)

- 编译构建：支持编译仓颉的HAP/APP、支持编译仓颉的HAR/HSP、支持推送仓颉HAP包至OpenHarmony设备运行能力。
- 代码调试：支持仓颉HAP在手机的调试能力，包括断点能力、单步调试、调试信息（线程、堆栈、变量等）可视化查看能力。

  例如，设置调试代码类型：单击**Run > Edit Configurations > Debugger**，选择相应模块，设置Debug type。

  ![image](./figures/capability/debugType.png)

  例如，检查变量：调试时，停在断点或由于其他原因导致程序中断，在堆栈列表展示当前线程状态，在Variable变量列表支持查看全局/静态变量、寄存器变量和局部变量。

  ![image](./figures/capability/debugInfo.png)

## 三、下一步演进

仓颉始未来将持续深耕高效开发、高性能、强安全等领域，持续提升高效开发体验，提供默认高性能和强安全能力；在跨平台领域持续完善和探索，为OpenHarmony应用开发者提供一码三端编程能力，并将仓颉打造为OpenHarmony生态应用开发的首选静态编程语言。仓颉未来演进方向如下：

* 高性能：通过Actor、并发优先级算法、结构化并发提性能；通过内存所有权机制降内存；通过硬件深度协同的优化技术降功耗。
* 强安全：通过安全宏、FFI安全检查增强编译阶段安全能力；通过前向控制流完整性技术增强运行阶段安全能力；通过数据流分析技术增强应用级别的安全能力构建。
* 跨平台：构建基于静态编译至机器码的跨OS平台执行能力，允许开发者实现“同构开发、异构运行”的跨OS平台代码共享，完善跨OS平台的线下和线上调优工具链，优化跨OS平台的调试体验，优化跨平台框架持续提升OpenHarmony应用跨OS平台代码占比，持续探索仓颉与Java/OC/Swift/Kotlin互通。
* 完善商用能力：以提升开发者体验为目标，将围绕OpenHarmony仓颉 API、IDE开发工具、资料文档等方面，持续建设语言能力。
