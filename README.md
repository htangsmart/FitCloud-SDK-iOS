
# FitCloud

[![Platfrom][image-1]][1]&nbsp;
[![Support][image-2]][2]&nbsp;
[![building][image-3]][3]&nbsp;


注：本文为FitCloud iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉XCode开发工具的基本使用方法，以及具有一定的编程知识基础等。

---
## 简介

FitCloud 是基于和唐智能手表开发的一款SDK，它可以帮助你记录全天事件，功能十分强大，包括标准运动功能（步数、热量、距离）、睡眠时间、心率、血氧、信息提醒（来电、留言、微信、QQ、Facebook等）、智能闹钟、防丢失提醒、解除手腕查看信息、闲置报警、水钟、相机拍照控制等，在你的APP中快速集成吧！

---
## 资源介绍
FitCloud SDK 结构十分简单，仅包含以下几部分：
* [FitCloud][4] — SDK的核心文件，提供蓝牙通讯的API接口
* [FCObject][5] — SDK数据模型的定义
* [FCConstants][6] — SDK通知定义文件
* [FCDefine][7] — SDK类型定义
* [FitCloudBlock][8] — SDK block定义
* [FitCloudUtils][9] — SDK 数据解析与转换实用工具
* [libFitCloud.a][10] — SDK 静态库文件

---

## 系统要求
该SDK最低支持`iOS 8.0` 和 `Xcode 7.0`

---

## 文档
你可以查阅FitCloud-SDK-iOS中的`html`文档,也可以将`docset`文档安装到`Xcode`阅读。具体开发指导请参阅Demo源代码。

---

## 修改日志


	2016-11-17 SDK 1.0.0
	(1) 修改登录接口，添加用户信息设置参数
	(2) 优化卡路里和距离的计算公式



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

## API 使用指导
### 1. 扫描连接外设
第一次使用需要扫描绑定，调用`scanningPeripherals:`接口扫描符合条件的外设,连接绑定后将`CBPeripheral`的UUID存储起来，下次使用调用`scanningPeripheralWithUUID:retHandler:`接口直接扫描连接指定`UUID`的外设进行登录就可以正常通讯了。

#### 注册观察者
```objective-c
// centralManager 状态改变通知，如果蓝牙关闭或者打开，你需要执行某些响应操作
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(centerManagerDidUpdateState:) name:EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY object:nil];
// 外设成功连接通知，当蓝牙连接上了以后，你可以更新相应的UI状态等
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peripheralDidConnected:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
// 外设连接失败通知，如果收到此通知，则蓝牙连接失败，你需要重新执行连接操作或者其他事情
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peripheralDidFailConnected:) name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];

// 此处观察设备蓝牙的状态，如果蓝牙打开或者关闭，更改相应的扫描状态
- (void)centerManagerDidUpdateState:(NSNotification\*)notification
{
	if (notification && notification.userInfo)
	{
	    NSDictionary *params = notification.userInfo;
	    NSNumber *stateNumber = params[@"state"];
	    CBCentralManagerState state = stateNumber.integerValue;
	    if (state == CBCentralManagerStatePoweredOn)
	    {
	        // 蓝牙打开，启动外设扫描
	    }
	    else if (state == CBCentralManagerStatePoweredOff)
	    {
	        // 蓝牙关闭，停止外设扫描
	    }
	}
}
- (void)peripheralDidConnected:(NSNotification\*)notification
{
	// 蓝牙连接成功，这里尚未扫描特征值服务，不能进行通讯，你可以进行UI刷新
}

- (void)peripheralDidFailConnected:(NSNotification\*)notification
{
	// 连接失败，停止扫描或者重新扫描外设
}

```

#### 调用`scanningPeripherals:`扫描所有外设
```objective-c
// 此处会返回当前扫描到的所有外设列表和当前扫描到的外设。
[[FitCloud shared]scanningPeripherals:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) {
  // 处理扫描结果，你可以把结果显示在列表上，然后点击选择一个外设进行连接
}];
```

#### 调用`scanningPeripheralWithUUID:retHandler:`扫描指定`UUID`的外设
```objective-c
// 通过绑定的uuid扫描指定的蓝牙外设，如果你已经存储了UUID，直接调用扫描此UUID的外设即可
[[FitCloud shared]scanningPeripheralWithUUID:nil retHandler:^(CBPeripheral *aPeripheral) {
  // 扫描到外设后启动连接
}];

```

#### 连接外设
```objective-c
// 连接一个你选择的外设，并在上述通知里获取连接结果
[[FitCloud shared]connectPeripheral:aPeripheral];
```
---

### 2.  绑定设备
第一次使用设备前，你需要绑定指定的设备，调用`scanningPeripherals:`扫描外设列表，选取外设连接成功并收到`didDiscoverCharacteristicsForService`通知后开始绑定设备。绑定成功后将此设备`UUID`存储起来下次调用`scanningPeripheralWithUUID:retHandler:`API自动扫描连接然后执行登录即可正常通讯。


#### 注册观察者
```objective-c
// 当扫描到服务特征值后，蓝牙可以进行正常通讯工作，这个你可以执行绑定或者登录了
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverCharacteristics:) name:EVENT\_DISCOVER\_CHARACTERISTICS\_NOTIFY object:nil];
```

##### 绑定外设

```objective-c
// 发现服务特征值通知，这里你需要判断是需要登录还是绑定操作
- (void)didDisconnectPeripheral:(NSNotification\*)notfication
{
   // 你的逻辑代码
	BOOL ret = (已经绑定？YES:NO);
	if (ret)
	{
	    // 设备已经绑定，执行登录操作
	    // your code
	    return;
	}

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
	        // *用户id* 100;
					NSNumber *phoneModel = [NSNumber phoneModel];
					NSNumber *osType = [NSNumber osType];
	        authDataHandler(100,phoneModel,osType);
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

// 绑定成功后，会返回手表的各项设置信息，你需要解析并存储此数据
- (void)updateSystemSettingsWithData:(NSData\*)data
{
	// 将手表数据解析成详细的各项设置数据
  [FitCloudUtils resolveSystemSettingsData:data withCallbackBlock:^(NSData *notificationData, NSData *screenDisplayData, NSData *functionalSwitchData, NSData *hsVersionData, NSData *healthHistorymonitorData, NSData *longSitData, NSData *bloodPressureData, NSData *drinkWaterReminderData) {
	// 你自己的处理，你需要存储这些设置数据
	// your code

	// 解析固件的软硬件版本信息数据
	[FitCloudUtils resolveHardwareAndSoftwareVersionData:hsVersionData withCallbackBlock:^(NSData *projData, NSData *hardwareData, NSData *sdkData, NSData *patchData, NSData *flashData, NSData *fwAppData, NSData *seqData) {
	        // 你自己的处理
	    }];

	// 解析固件的软硬件版本信息数据成字符串，这里部分字符串参数需要提交给服务器用于固件版本信息检查
	[FitCloudUtils resolveHardwareAndSoftwareVersionDataToString:hsVersionData withCallbackBlock:^(NSString *projNum, NSString *hardware, NSString *sdkVersion, NSString *patchVerson, NSString *falshVersion, NSString *appVersion, NSString *serialNum) {
	   // 你自己的处理
	}];
  }];
}

```

---

### 3.  登录设备
如果app已经绑定，使用存储的UUID字符串直接扫描指定外设，连接后登录设备就可以正常使用了

#### 注册观察者
```objective-c
// 注册观察者通知，如果发现服务特征值则启动登录路程
[[NSNotificationCenter defaultCenter]addObserverForName:EVENT\_DISCOVER\_CHARACTERISTICS\_NOTIFY object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
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
				NSNumber *phoneModel = [NSNumber phoneModel];
				NSNumber *osType = [NSNumber osType];
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
	    else
	    {
	      if (state == FCSyncResponseStateError)
	      {
	        // 登录失败，移除绑定信息重新绑定
	      }
	      else
	      {
	         //超时，后者蓝牙未连接等做其他处理
	      }
	    }
	}];
```

---

### 4. 解除绑定
如果手表在连接状态，解绑设备时你需要对手表发送解绑指令，解绑成功可以移除绑定的`UUID`信息，如果蓝牙关闭或者断开连接，你可以不用发送解绑指令直接移除绑定的`UUID`信息直接解绑。
```objective-c
[[FitCloud shared]unBondDevice:^(FCSyncType syncType, FCSyncResponseState state)
    {
        if (state == FCSyncResponseStateNotConnected || state == FCSyncResponseStatePowerOff || state == FCSyncResponseStateSuccess) {

            BOOL ret =  [[FitCloud shared]removeBoundDevice];
            if (ret)
            {
                [ws hideLoadingHUDWithSuccess:KLocalString(@"解绑成功")];
                [[FitCloud shared]disconnect];
                // your code
								// ...
            }
            else
            {
                [ws hideLoadingHUDWithFailure:KLocalString(@"解绑失败")];
            }
        }
        else
        {
            [ws hideLoadingHUDWithFailure:KLocalString(@"解绑失败")];
        }
}];
```

---

### 5.  闹钟同步
最多可以设置8个闹钟，每个闹钟的响铃时间必须唯一,每次同步前需要对闹钟的ID进行编号，每个id唯一（0-7）
#### 获取闹钟列表
```objective-c
[[FitCloud shared]fcGetAlarmList:^(FCSyncType syncType, NSData \*data) {
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
NSMutableArray \*tmpArray = [[NSMutableArray alloc]init];
FCAlarmCycleModel \*cycleModel = [[FCAlarmCycleModel alloc]init];
cycleModel.sunday = YES;
FCAlarmModel \*alarmModel = [[FCAlarmModel alloc]init];
aModel.cycle = cycleModel.cycleValue;
aModel.isOn = YES;
aModel.year = @(16);
aModel.month = @(10);
aModel.day = @(31);
aModel.hour = @(20);
aModel.minute = @(30);
aModel.alarmId = @(0);
[tmpArray addObject:alarmModel];
NSData \*alarmData = [tmpArray alarmClockConfigurationData];
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
[FitCloudUtils resolveSystemSettingsData:data withCallbackBlock:^(NSData *notificationData, NSData *screenDisplayData, NSData *functionalSwitchData, NSData *hsVersionData, NSData *healthHistorymonitorData, NSData *longSitData, NSData *bloodPressureData, NSData *drinkWaterReminderData) {
	  // 序列化通知设置模型  
	  FCNotificationModel *notificationModel = [FCNotificationModel modelWithData:notificationData];
	  // 存储或者更新消息通知设置
}];
```
#### 更新消息通知设置
```objective-c

// 这里的model是模拟数据，实际使用你自己存储的数据
FCNotificationModel \*aModel = [[FCNotificationModel alloc]init];
aModel.shortMessage = YES;
aModel.phoneCall = YES;
aModel.weChat = YES;
aModel.QQ = YES;
aModel.facebook = YES;
aModel.instagram = YES;
NSData \*nfSettingsData = [aModel nfSettingData];
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
	// 相机进入前台，发送状态指令到手环
}

- (void)applicationDidEnterBackgroundNotification
{
	// 相机进入后台，发送状态指令到手环
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
这里会返回设备的电量和充电的状态，如果发现设备正在充电你可以在UI做动画提示
```objective-c
[[FitCloud shared]fcGetBatteryPowerAndChargingState:^(UInt8 powerValue, UInt8 chargingState) {

	    NSLog(@"--电量--%@",@(powerValue));
	    NSLog(@"--充电状态--%@",@(chargingState));
	    if (chargingState == 0)
	    {
	        // 未充电
	    }
	    else
	    {
	        // 正在充电
	    }

	} retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
	    if (state == FCSyncResponseStateSuccess)
	    {
	        // 电量获取成功
	    }
	    else
	    {
	       // 电量获取失败
	    }
	}];
```

---

### 9. 手环显示设置
手环屏幕显示条目可以根据需要设置，调用此接口你可以自定义手表的显示功能，当前手表显示条目如下：时间和日期、步数、距离、卡路里、睡眠、心率、血氧、血压、天气预报、查找手机、手表id。其中心率、血氧、血压等健康功能跟固件的flag有关，如果固件包含此功能，则手表会显示。

```objective-c
// 需要显示的属性设置为YES即可，在同步设置之前，你需要读取本地设置
FCDisplayModel \*displayModel = [[FCDisplayModel alloc]init];
displayModel.dateTime = YES;
displayModel.stepCount = YES;
displayModel.distance = YES;
displayModel.calorie = YES;
displayModel.sleep = YES;
displayModel.heartRate = YES;
displayModel.displayId = YES;
NSData \*data = [displayModel displayData];
[[FitCloud shared]fcSetDisplayData:data retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
	if (state == FCSyncResponseStateSuccess)
	{
	    // 成功更新显示设置，你可以更新本地存储的数据
	}
	else
	{

	}
}];
```


---

### 10. 手环功能开关设置
手表功能开关设置目前只有翻腕亮屏这一项，后续可能扩充功能
```objective-c
FCFunctionSwitchModel *fsModel = [[FCFunctionSwitchModel alloc]init];
fsModel.twLightScreen = sender.isOn;
NSData *data = [fsModel functionSwitchData];
[[FitCloud shared]fcSetFunctionSwitchData:data retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
  if (state == FCSyncResponseStateSuccess) {
      NSLog(@"设置成功");
  }
  else
  {
      NSLog(@"设置失败");
  }
}];
```

---

### 11. 手表固件升级与固件版本信息获取
#### 固件版本信息获取
通过`fcGetFirmwareVersion:retHandler:`API接口你可以获取手表当前的固件信息，获取后你需要保存这些信息用于检测固件升级和其他操作
```objective-c
// 获取固件版本信息
[[FitCloud shared]fcGetFirmwareVersion:^(FCSyncType syncType, NSData *data) {
        [ws didUpdateLocalFirmwareVersionWithData:data];
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            NSLog(@"--固件版本信息获取成功--");
        }
        else
        {
            NSLog(@"--固件版本信息获取失败--");
        }
}];

// 获取到固件版本信息后，你需要对固件版本信息解析存储
- (void)didUpdateLocalFirmwareVersionWithData:(NSData*)data
{
    if (!data) {
        return;
    }
    [FitCloudUtils resolveHardwareAndSoftwareVersionData:data withCallbackBlock:^(NSData *projData, NSData *hardwareData, NSData *sdkData, NSData *patchData, NSData *flashData, NSData *fwAppData, NSData *seqData) {
			// hardwareData 包含健康传感器表示，心率、血氧、血压、呼吸频率等功能是否存在可以通过此数据判断
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_SENSOR_FLAG_UPDATE_NOTIFY object:hardwareData];
    }];

    WS(ws);
    [FitCloudUtils resolveHardwareAndSoftwareVersionDataToString:data withCallbackBlock:^(NSString *projNum, NSString *hardware, NSString *sdkVersion, NSString *patchVerson, NSString *falshVersion, NSString *appVersion, NSString *serialNum) {
        NSString *prjHareWare = [NSString stringWithFormat:@"%@%@",projNum,hardware];
        NSString *patchApp = [NSString stringWithFormat:@"%@%@%@",patchVerson,falshVersion,appVersion];
        DEBUG_METHOD(@"--patchApp--%@",patchApp);
        DEBUG_METHOD(@"--prjHareWare--%@",prjHareWare);

        // 通过解析出的固件版本信息，你可以更新本地数据并查询最新固件版本
				// your code`
    }];
}
```

#### 固件升级
固件升级之前你需要从服务器下载最新固件，然后获取下载的固件路径调用`fcUpdateFirmwareWithPath:progress:retHandler:`进行升级操作
```objective-c
[[FitCloud shared]fcUpdateFirmwareWithPath:filePath progress:^(CGFloat progress) {
        // 在UI显示升级进度
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            // 升级成功
        }
        else if (state == FCSyncResponseStateLowPower)
        {
            // 电量过低，不能进行升级
        }
        else
        {
            // 升级是啊比
        }
    }];

```

---

### 12. 手表天气预报同步
你可以借助自己的后台服务器或者第三方服务获取当前天气，然后同步到手环，但是同步之前需要将天气状态转换成手表可以识别的状态，目前手表能够显示一下几种天气：
天气状态说明 | 天气状态吗
---|---
晴天 | 0x01
多云 | 0x02
阴天 | 0x03
阵雨 | 0x04
雷阵雨、雷阵雨伴有冰雹 | 0x05
小雨 | 0x06
中雨、大雨、暴雨 | 0x07
雨夹雪、冻雨 | 0x08
小雪 | 0x09
大雪、暴雪 | 0x0a
沙尘暴、浮尘 | 0x0b
雾、雾霾 | 0x0c


---

### 13. 手表健康实时测试

---

### 14. 手表历史数据同步

---

注意
----
至此，你已经能使用FitCloud终端SDK的API内容了。如果想更详细了解每个API函数的用法，请查阅 API文档 或自行下载阅读SDK Sample Demo源码。

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
