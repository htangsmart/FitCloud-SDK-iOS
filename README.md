
# FitCloud

[![Platfrom][image-1]][1]&nbsp;
[![Support][image-2]][2]&nbsp;
[![building][image-3]][3]&nbsp;


注：本文为FitCloud iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉XCode开发工具的基本使用方法，以及具有一定的编程知识基础等。


---
## 资源介绍
FitCloud SDK 结构十分简单，仅包含以下几部分：
* [FitCloud][4] — SDK的核心文件，提供蓝牙通讯的API接口
* [FCObject][5] — 数据模型的定义
* [FCConstants][6] — 通知定义文件
* [FCDefine][7] — 类型定义
* [FitCloudBlock][8] — block定义
* [FitCloudUtils][9] — 实用工具类
* [FCRTSyncUtils][9] — 实时数据同步解析工具类
* [FCSyncUtils][9] — 数据同步解析工具类
* [FCSysConfigUtils][9] — 手表配置解析工具类
* [FitCloudAPI][9] — 网络API接口
* [libFitCloud.a][10] — 静态库文件

---

## 系统要求
该SDK最低支持`iOS 8.0` 和 `Xcode 7.0`

---

## 文档
你可以查阅FitCloud-SDK-iOS中的`html`文档,也可以将`docset`文档安装到`Xcode`阅读。具体开发指导请参阅Demo源代码。

---

## 修改日志

```
2017-08-15 SDK 2.1.2
 (1) 实时同步打开添加传感器标志，没有此标志不允许启动实时同步

2017-08-14 SDK 2.1.2
（1）登录、绑定、数据同步添加功能开关设置
（2）优化精简蓝牙通讯流程
（3）补充蓝牙数据解析接口
（4）扩展功能接口，开发者可以根据需要自定义配置同步功能

2016-11-17 SDK 1.0.0
(1) 修改登录接口，添加用户信息设置参数
(2) 优化卡路里和距离的计算公式
```

---

## 安装

### CocoaPods
  暂无

### Carthage
暂无

### 手动安装
1. 在XCode中建立你的工程

2. 下载FitCloud-SDK-iOS

3. 将FitCloud-SDK-iOS中的lib文件夹内源文件导入你的工程。如果你不想导入工程，你可以把lib文件夹放到你的工程文件夹里，然后在Build Settings中设置库文件和头文件的搜索路径，设置如下图：
![Alt text][image-4]

4. 在Build Settings中设置Other linker Flags为 -ObjC

5. 链接以下 frameworks:
	* CoreBluetooth
6. 在你的工程中导入`FitCloudKit.h`

如果你的APP需要蓝牙保持长连接并且能够后台同步，请设置背后模式
![Alt text][image-5]

---


注意
----
如果想更详细了解每个API函数的用法，请查阅 API文档 或自行下载阅读SDK Sample Demo源码。

[1]:	https://github.com/htangsmart/FitCloud-SDK-iOS.git
[2]:	https://github.com/htangsmart/FitCloud-SDK-iOS.git
[3]:	https://github.com/htangsmart/FitCloud-SDK-iOS.git
[4]:	https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FitCloud.h
[5]:	https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FCObject.h
[6]:	https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FCConstants.h
[7]:	https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FCDefine.h
[8]:	https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FitCloudBlock.h
[9]:	https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FitCloudUtils.h
[10]:	https://github.com/htangsmart/FitCloud-SDK-iOS/tree/master/lib

[image-1]:	https://img.shields.io/badge/platfrom-iOS-brightgreen.svg?style=flat
[image-2]:	https://img.shields.io/badge/support-iOS%208%2B-brightgreen.svg?style=flat
[image-3]:	https://img.shields.io/wercker/ci/wercker/docs.svg?style=flat
[image-4]:	http://p1.bqimg.com/1949/6dde697bfc40636b.png
[image-5]:	http://p1.bqimg.com/1949/cd775744c0cf1ba8.png
