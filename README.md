
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

3. 将FitCloud-SDK-iOS中的lib文件夹内源文件导入你的工程。如果你不想导入工程，你可以把lib文件夹放到你的工程文件夹里，然后在Build Settings中设置库文件和头文件的搜索路径，设置如下图：
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
该SDK最低支持`iOS 8.0` 和 `Xcode 7.0`

---

## API 使用指导
### 1. 扫描连接外设
第一次使用需要扫描绑定，调用`scanningPeripherals:`接口,连接后将`CBPeripheral`的UUID存储起来，下次使用调用`scanningPeripheralWithUUID:retHandler:`接口直接扫描连接
#### 注册观察者
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

#### 调用`scanningPeripherals:`扫描所有外设
```objective-c
[[FitCloud shared]scanningPeripherals:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) {
  // 处理扫描结果
}];
```

#### 调用`scanningPeripheralWithUUID:retHandler:`扫描指定外设
```objective-c
// 通过绑定的uuid扫描指定的蓝牙外设
[[FitCloud shared]scanningPeripheralWithUUID:nil retHandler:^(CBPeripheral *aPeripheral) {
  // 扫描到外设后启动连接
}];

```

#### 连接外设
```objective-c
// 连接一个你选择的外设，并在观察者里捕获连接结果
[[FitCloud shared]connectPeripheral:aPeripheral];
```
---

### 2.  绑定设备
第一次使用设备前，选取扫描的外设连接成功后并收到`didDiscoverCharacteristicsForService`后开始绑定设备。绑定成功将绑定的设备UUID使用NSUserDefaults存储起来用于下次自动扫描连接登录。


#### 注册观察者
```objective-c
// 注册观察者
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
```

##### 绑定外设

```objective-c
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
         // 存储手表的系统设置信息
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
|  iPhone4s   | 2 | iPad 2      | 31 |
|  iPhone5     | 3      | iPad 3      | 32      |
| iPhone5c | 4      | iPad 4 | 33  |   
| iPhone5s | 5      | iPad mini | 34 |
| iPhone6 | 6      | iPad air | 35 |
| iPhone6s | 7      | iPad mini2 | 36      |
| iPhone6 Plus | 8      | iPad air2 | 37      |
| iPhone6s Plus | 9      | iPad mini3 | 38      |
| iPhone7 | 10      | iPad pro | 39      |
| iPhone7 Plus | 11      | iPad mini4 | 40      |

operating system

| 系统        | 序号           |  系统        | 序号           |
| ------------- |:-------------:| ------------- |:-------------:
| iOS 8.0     | 3      | iOS 8.1     | 4      |
| iOS 8.2 | 5      | iOS 8.3 | 6  |   
| iOS 8.4 | 7      | iOS 9.0 | 8 |
| iOS 9.1 | 9      | iOS 9.2 | 10 |
| iOS 9.3 | 11      | iOS 10.0 | 12      |
| iOS 10.1 | 13      | |       |

---

### 3.  登录设备
如果app已经绑定，使用存储的UUID字符串直接扫描指定外设，连接后登录设备就可以正常使用了

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
[[FitCloud shared]loginDevice:^(FCAuthDataHandler authDataHandler, FCUserDataHandler userDataHandler)
    {
        if (authDataHandler)
        {
          // 详细数据见 1.绑定设备->设备信息说明
            authDataHandler(100,10,10);
        }

        // 设置用户信息
        if (userDataHandler)
        {
          // 性别：0 女 1 男; 年龄 = 当前年 - 出身 + 1; 体重 65kg; 身高 183cm
            userDataHandler(1,29,65,183);
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

---

### 4. 解除绑定


---

### 5.  闹钟同步
最多可以设置8个闹钟，每个闹钟的响铃时间必须唯一,每次同步前需要对闹钟的ID进行编号，每个id唯一（0-7）
#### 获取闹钟列表
```objective-c
[[FitCloud shared]fcGetAlarmList:^(FCSyncType syncType, NSData *data) {
        NSArray *modelsArray = [NSArray arrayWithAlarmClockConfigurationData:data];
        // 将同步的闹钟展示到列表

    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            // 闹钟同步完成
        }
        else
        {
            // 闹钟同步失败
        }
    }];
```
#### 同步闹钟设置
```objective-c

// 这里的闹钟使用模拟数据，实际同步时使用你存储的真实数据
NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
FCAlarmCycleModel *cycleModel = [[FCAlarmCycleModel alloc]init];
cycleModel.sunday = YES;
FCAlarmModel *alarmModel = [[FCAlarmModel alloc]init];
aModel.cycle = cycleModel.cycleValue;
aModel.isOn = YES;
aModel.year = @(16);
aModel.month = @(10);
aModel.day = @(31);
aModel.hour = @(20);
aModel.minute = @(30);
aModel.alarmId = @(0);
[tmpArray addObject:alarmModel];
NSData *alarmData = [tmpArray alarmClockConfigurationData];
// 开始同步闹钟
[[FitCloud shared]fcSetAlarmData:alarmData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
    if (state == FCSyncResponseStateSuccess) {
        // 闹钟同步成功
    }
    else
    {
        // 闹钟同步失败
    }
}];
```

---

### 6.  消息通知设置
APP绑定手环后手环会将设置信息上传到APP，APP存储这些数据，在数据有更新时重新同步到手环
#### 获取消息通知设置
```objective-c
[FitCloudUtils resolveSystemSettingsData:data withCallbackBlock:^(NSData *notificationData, NSData *screenDisplayData, NSData *functionalSwitchData, NSData *hsVersionData, NSData *healthHistorymonitorData, NSData *longSitData, NSData *bloodPressureData, NSData *drinkWaterReminderData) {
      // 序列化通知设置模型  
      FCNotificationModel *notificationModel = [FCNotificationModel modelWithData:notificationData];
      // 存储或者更新消息通知设置
}];
```
#### 更新消息通知设置
```objective-c

// 这里的model是模拟数据，实际使用你自己存储的数据
FCNotificationModel *aModel = [[FCNotificationModel alloc]init];
aModel.shortMessage = YES;
aModel.phoneCall = YES;
aModel.weChat = YES;
aModel.QQ = YES;
aModel.facebook = YES;
aModel.instagram = YES;
NSData *nfSettingsData = [aModel nfSettingData];
WS(ws);
[self showLoadingHUDWithMessage:@"正在同步"];
[[FitCloud shared]fcSetNotificationSettingData:nfSettingsData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
    if (state == FCSyncResponseStateSuccess) {
        [ws hideLoadingHUDWithSuccess:@"同步成功"];
    }
    else
    {
        [ws hideLoadingHUDWithFailure:@"同步失败"];
    }
}];

```

---

### 7. 相机拍照控制
进入相机拍照页面监听手环发出的拍照指令，收到指令后开始拍照。如果app进入后台或者回到前台，app需要把相机状态同步到手表

#### 拍照监听
```objective-c
[[FitCloud shared]setTakePicturesBlock:^{
    // 启动拍照  
}];
```
#### 注册观察者
```objective-c
// app进入前台
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
// app进入背后
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];

- (void)applicationDidBecomeActiveNotification
{
    // 相机进入前台
}

- (void)applicationDidEnterBackgroundNotification
{
    // 相机进入后台
}

```

#### app发送状态指令到手环
```objective-c

BOOL  inForeground = YES; // 判断前台还是后台
[[FitCloud shared]fcSetCameraState:inForeground retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            if (inForeground) {
                // 相机进入前台同步成功
            }
            else
            {
                // 相机进入后台同步成功-
            }
        }
        else
        {
            // 相机状态同步失败
        }
    }];
```

---

### 8. 手环充电状态和剩余电量获取

---

### 9. 手环显示设置

---

### 10. 手环功能开关设置

---

### 11. 手表固件升级与固件版本信息获取

---

### 12. 手表健康实时测试

---

### 13. 手表天气预报同步

---

### 14. 手表历史数据同步

---

注意
----
至此，你已经能使用FitCloud终端SDK的API内容了。如果想更详细了解每个API函数的用法，请查阅 API文档 或自行下载阅读SDK Sample Demo源码。
