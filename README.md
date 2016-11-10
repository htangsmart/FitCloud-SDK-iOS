
# FitCloud

[![Platfrom](https://img.shields.io/badge/platfrom-iOS-brightgreen.svg?style=flat)](https://github.com/htangsmart/FitCloud-SDK-iOS.git)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208%2B-brightgreen.svg?style=flat)](https://github.com/htangsmart/FitCloud-SDK-iOS.git)&nbsp;
[![building](https://img.shields.io/wercker/ci/wercker/docs.svg?style=flat)](https://github.com/htangsmart/FitCloud-SDK-iOS.git)&nbsp;


注：本文为FitCloud iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉XCode开发工具的基本使用方法，以及具有一定的编程知识基础等。

---
## 简介

FitCloud 是基于和唐智能手表开发的一款SDK，它可以帮助你记录全天事件：标准运动功能（步数、热量、距离）、睡眠时间、心率、血氧、信息提醒（来电、留言、微信、QQ、Facebook等）、智能闹钟、防丢失提醒、解除手腕查看信息、闲置报警、水钟、相机拍照控制等,功能十分强大，在你的APP中快速集成吧！

---
## 资源介绍
FitCloud SDK 结构十分简单，仅包含以下几部分：
* [FitCloud](https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FitCloud.h) — SDK的核心文件，提供蓝牙通讯的API接口
* [FCObject](https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FCObject.h) — SDK数据模型的定义
* [FCConstants](https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FCConstants.h) — SDK通知定义文件
* [FCDefine](https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FCDefine.h) — SDK类型定义
* [FitCloudBlock](https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FitCloudBlock.h) — SDK block定义
* [FitCloudUtils](https://github.com/htangsmart/FitCloud-SDK-iOS/blob/master/lib/include/FitCloudUtils.h) — SDK 数据解析与转换实用工具
* [libFitCloud.a](https://github.com/htangsmart/FitCloud-SDK-iOS/tree/master/lib) — SDK 静态库文件

---
## 安装

### CocoaPods
  暂无

### Carthage
暂无

### 手动安装
1. 在XCode中建立你的工程

2. 下载FitCloud-SDK-iOS

3. 将FitCloud-SDK-iOS中的lib文件夹内源文件导入你的工程。如果你不想导入工程，你可以把lib文件夹放到你的工程里，然后在Build Settings中设置库文件和头文件的搜索路径，设置如下图：
![Alt text](http://p1.bqimg.com/1949/6dde697bfc40636b.png)

4. 在Build Settings中设置Other linker Flags为 -ObjC

5. 链接以下 frameworks:
    * CoreBluetooth
6. 在你的工程中导入`FitCloudKit.h`

7. 如果你的APP需要蓝牙保持长连接并且能够后台同步，请设置背后模式
![Alt text](http://p1.bqimg.com/1949/cd775744c0cf1ba8.png)

---

## 文档
你可以查阅FitCloud-SDK-iOS中的`html`文档,也可以将`docset`文档安装到`Xcode`阅读

---

## 系统要求
该SDk最低支持`iOS 8.0` 和 `Xcode 7.0`

---

## API 使用指导
### 1.  绑定设备
绑定设备前我们需要先扫描要连接的外设，在扫描到的外设列表中选取一个外设并连接，连接成功并`didDiscoverCharacteristicsForService`后启动绑定服务。绑定成功将绑定的设备UUID使用NSUserDefaults存储起来用于下次自动扫描连接登录。

##### 扫描外设列表

```objective-c
[[FitCloud shared]scanningPeripherals:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) { }];
```

##### 注册观察者

```objective-c
// centralManager 状态改变通知
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(centerManagerDidUpdateState:) name:EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY object:nil];
// 外设成功连接通知
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peripheralDidConnected:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
// 外设连接失败通知
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peripheralDidFailConnected:) name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];

// 此处观察设备蓝牙的状态，如果蓝牙打开或者关闭，更改相应的扫描状态
- (void)centerManagerDidUpdateState:(NSNotification*)notification
{
    if (notification && notification.userInfo)
    {
        NSDictionary *params = notification.userInfo;
        NSNumber *stateNumber = params[@"state"];
        CBCentralManagerState state = stateNumber.integerValue;
        if (state == CBCentralManagerStatePoweredOn)
        {
            // 蓝牙打开，启动扫描外设
        }
        else if (state == CBCentralManagerStatePoweredOff)
        {
            // 蓝牙关闭，停止扫描外设
        }
    }
}
- (void)peripheralDidFailConnected:(NSNotification*)notification
{
    // 连接失败，停止扫描或者重新扫描外设
}
```



##### 连接外设

```objective-c
CBPeripheral *aPeripheral = nil; // 这里是你选择的外设
[[FitCloud shared]connectPeripheral:aPeripheral];
```
##### 绑定外设

```objective-c
// 注册观察者
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];

// 蓝牙连接成功，发现特征值服务
- (void)didDisconnectPeripheral:(NSNotification*)notfication
{
   // 你的逻辑代码

   // 绑定设备
   [self startBindingDevice:^(FCSyncResponseState state) {
            // 结果处理
    }];
}

// 绑定设备
- (void)startBindingDevice:(void(^)(FCSyncResponseState state))retHandler
{
    [[FitCloud shared]bondDevice:^(FCAuthDataHandler authDataHandler, FCUserDataHandler userDataHandler, FCWearStyleHandler wearStyleHandler)
    {
        // 设置绑定设备信息
        if (authDataHandler)
        {
          // *用户id* 100; *手机型号* 见设备信息说明； *手机系统版本* 见设备信息说明
            authDataHandler(100,2,1);
        }
        // 设置用户信息
        if (userDataHandler)
        {
          // 性别：0 女 1 男; 年龄 = 当前年 - 出身 + 1; 体重 65kg; 身高 183cm
            userDataHandler(1,29,65,183);
        }
        if (wearStyleHandler)
        {
          // 佩戴方式，YES为左手佩戴
            wearStyleHandler(YES);
        }
    } dataHandler:^(FCSyncType syncType, NSData *data) {
        [self updateSystemSettingsWithData:data];
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state)
     {
         if (state == FCSyncResponseStateSuccess)
         {
             // 绑定成功
         }
         else if (state == FCSyncResponseStateTimeOut)
         {
             // 绑定超时
         }
         else
         {
             // 绑定失败
         }
         if (retHandler) {
             retHandler(state);
         }
     }];
}

// 解析存储系统设置数据
- (void)updateSystemSettingsWithData:(NSData*)data
{
  [FitCloudUtils resolveSystemSettingsData:data withCallbackBlock:^(NSData *notificationData, NSData *screenDisplayData, NSData *functionalSwitchData, NSData *hsVersionData, NSData *healthHistorymonitorData, NSData *longSitData, NSData *bloodPressureData, NSData *drinkWaterReminderData) {
    // 你自己的处理
    [FitCloudUtils resolveHardwareAndSoftwareVersionData:hsVersionData withCallbackBlock:^(NSData *projData, NSData *hardwareData, NSData *sdkData, NSData *patchData, NSData *flashData, NSData *fwAppData, NSData *seqData) {
            // 你自己的处理
        }];
    [FitCloudUtils resolveHardwareAndSoftwareVersionDataToString:hsVersionData withCallbackBlock:^(NSString *projNum, NSString *hardware, NSString *sdkVersion, NSString *patchVerson, NSString *falshVersion, NSString *appVersion, NSString *serialNum) {
       // 你自己的处理
    }];
  }];
}

```
##### 设备信息说明
phone model 信息说明

| 设备        | 序号           |  设备        | 序号           |
| ------------- |:-------------:| ------------- |:-------------:
| iPhone3G      | 2 | iPad 1      | 31 |
| iPhone3Gs      | 3      | iPad 2      | 32      |
| iPhone4 | 4      | iPad 3 | 33  |   
| iPhone4s | 5      | iPad 4 | 34 |
| iPhone5 | 6      | iPad mini | 35 |
| iPhone5c | 7      | iPad air | 36      |
| iPhone5s | 8      | iPad mini2 | 37      |
| iPhone6 | 9      | iPad air2 | 38      |
| iPhone6s | 10      | iPad mini3 | 39      |
| iPhone6 Plus | 11      | iPad pro | 40      |
| iPhone6s Plus | 12      | iPad mini4 | 41      |
| iPhone7 | 13      |  |      |
| iPhone7 Plus | 14      |  |      |

operating system

| 系统        | 序号           |  系统        | 序号           |
| ------------- |:-------------:| ------------- |:-------------:
| iOS 7.0      | 1 | iOS 7.1      | 2 |
| iOS 8.0     | 3      | iOS 8.1     | 4      |
| iOS 8.2 | 5      | iOS 8.3 | 6  |   
| iOS 8.4 | 7      | iOS 9.0 | 8 |
| iOS 9.1 | 9      | iOS 9.2 | 10 |
| iOS 9.3 | 11      | iOS 10.0 | 12      |
| iOS 10.1 | 13      | |       |

---

### 2.  登录设备
如果app已经绑定，下次使用只需要使用存储的UUID字符串直接扫描指定外设，连接后启动登录就可以正常使用了

##### 扫描指定的外设
```objective-c
// 通过绑定的uuid扫描指定的蓝牙外设
[[FitCloud shared]scanningPeripheralWithUUID:@"xxx" retHandler:^(CBPeripheral *aPeripheral) {
  // 扫描到外设后启动连接
  [[FitCloud shared]connectPeripheral:aPeripheral];
}];
```
#### 注册观察者
```objective-c
// 注册观察者通知，如果发现服务特征值则启动登录路程
[[NSNotificationCenter defaultCenter]addObserverForName:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
   // 你的代码判断分支
   // 登录设备

}];
```
#### 登录设备
```objective-c
[[FitCloud shared]loginDevice:^(FCAuthDataHandler authDataHandler)
    {
        if (authDataHandler)
        {
          // 详细数据见 1.绑定设备->设备信息说明
            authDataHandler(100,10,10);
        }

    } retHandler:^(FCSyncType syncType, FCSyncResponseState state)
    {
      if (syncType == FCSyncTypeLoginToSyncTime) {
            NSLog(@"--同步完成--");
            // 登录成功，处理其他同步
        }
        else if (syncType == FCSyncResponseStateError)
        {
          // 登录失败，移除绑定信息重新绑定
        }
        else
        {
           //超时，后者蓝牙未连接等做其他处理
        }
    }];
```


5. 至此，你已经能使用FitCloud终端SDK的API内容了。如果想更详细了解每个API函数的用法，请查阅 API文档 或自行下载阅读SDK Sample Demo源码。
