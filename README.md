##iOS  SDK 集成指南

注：本文为FitCloud iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉XCode开发工具的基本使用方法，以及具有一定的编程知识基础等。

---
####1、SDK功能介绍

##### FitCloud 是基于移动设备低功耗蓝牙与手表通讯，主要提供以下功能：

- [x] 登录、绑定、解绑设备
- 初次使用需要先绑定设备，用户可以将绑定的设备的uuid存储在客户端
- 绑定固定设备后每次蓝牙连接成功都需要调用一次登录接口登录设备，登录失败需要重新扫描绑定一次
- 解除绑定后需要进入设置页面忽略蓝牙列表当前连接的蓝牙
- [x] 设置用户资料 
- 蓝牙连接成功，可以调用设置用户资料和默认血压接口设置用户出生年月、性别、身高、体重以及收缩压、舒张压。
- [x] 通知设置
- 通知设置可以实现手机app和手环在特定条件下相互提醒功能，如电话、短信通知等设置后，可以在手机收到电话或者短信的时候，手环给予震动和声音提醒用户，详细见代码。
- [x] 闹钟设置
- 手环可以设置多达五个闹钟，在不同的时间段及时提醒用户
- [x] 显示设置
- 可以根据需要设置手环UI界面显示条目，可设置的具体选项为时间和日期、步数、距离、卡路里、睡眠、心率、血氧、天气预报、查找手机，手环ID等。
- [x] 其他设置与功能
- 设置手环的佩戴方式
- 设置是否需要翻腕亮屏
- 设置健康检测起止时间
- 设置喝水提醒和久坐提醒
- 检测电量或者充电状态
- 查找手环、拍照控制等等
- [x] 手环数据同步，每五分钟一个数据记录（健康实时监测除外）
- 运动数据
- 睡眠数据
- 血氧数据
- 心率数据
- 血压数据
- 呼吸频率
- 健康实时监测数据

---
####2、SDK文件资源介绍
> libFitCloud.a // 库文件

> FCConstants.h // 通知定义文件

> FCDefine.h // 类型定义

> FCObject.h // 对象模型

> FitCloud.h // sdk核心文件
   
 ---
####3、SDK资源下载地址   
>  [sdk下载地址](https://github.com/myz1104/FitCloud-SDK.git)

>  [demo下载地址](https://github.com/myz1104/FCDemo.git)

---
####4、搭建开发环境
1.在XCode中建立你的工程。

2.将SDK文件中包含的 libFitCloud.a，FCConstants.h，FCDefine.h，FCObject.h，FitCloud.h  几个文件添加到你所建的工程中（如果只是把库文件放到工程文件夹内而没有把库文件导入工程，请设置库文件和头文件的搜索路径，如下图）
![Alt text](http://p1.bqimg.com/1949/6dde697bfc40636b.png)

3.SDK使用了蓝牙功能，需要在工程中链接上CoreBluetooth.framework。

4.蓝牙需要后台同步，请设置背后模式
![Alt text](http://p1.bqimg.com/1949/cd775744c0cf1ba8.png)

---
####5、使用SDK文件包进行APP开发
1. 在手表能正常通讯之前我们需要先扫描并绑定蓝牙
```
// 此接口将会扫描到指定类型的蓝牙
 [[FitCloud shared]scanningPeripherals:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) {
        NSLog(@"---retArray---%@",retArray);
    }];
    
// 在扫描到的蓝牙列表中选择一个连接
[[FitCloud shared]connectPeripheral:aPeripheral];

// 在我们注册的观察者里捕捉蓝牙连接结果,因为需要进行蓝牙写入数据操作，所以我们需要在蓝牙连接成功并且扫描到特征值服务后进行其他操作
[[NSNotificationCenter defaultCenter]addObserverForName:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {}];

// 调用绑定接口进行绑定操作,绑定成功后需要存储绑定的蓝牙的UUID用户以后连接登录
[[FitCloud shared]fcSetBindDevice:^(FCAuthDataHandler authDataHandler, FCUserDataHandler userDataHandler, FCWearStyleHandler wearStyleHandler) {
		// 设置用户数据
        if (authDataHandler) {
            authDataHandler(10,0,1);
        }
        if (userDataHandler) {
            userDataHandler(1,87,65,183);
        }
        if (wearStyleHandler) {
            wearStyleHandler(YES);
        }
    } dataHandler:^(FCSyncType syncType, NSData *data) {
        
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            // 存储当前连接的蓝牙uuid
        }
        else
        {
            // 错误处理
        }
    }];

```
2. 再次启动app，根据存储的UUID扫描对应的蓝牙外设，连接成功后启动登录
```
// 通过绑定的uuid扫描指定的蓝牙外设
[[FitCloud shared]scanningPeripheralWithUUID:@"xxx" retHandler:^(CBPeripheral *aPeripheral) {}];

// 连接外设，并观察外设连接结果
[[NSNotificationCenter defaultCenter]addObserverForName:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {}];

// 连接成功调用登录接口登录设备
[[FitCloud shared]fcSetLoginDevice:^(FCAuthDataHandler authDataHandler) {
        if (authDataHandler) {
            authDataHandler(10,0,1);
        }
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (syncType == FCSyncTypeLoginDevice && state != FCSyncResponseStateSuccess) {
            // 登录失败，清除绑定数据，重新绑定设备
        }
        else
        {
            
        }
    }];
```
3. 根据需要设置手表数据，详细见API接口
4. 同步数据
```
// 同步历史运动数据，同步操作为：系统时间同步->运动数据同步->睡眠数据同步->（血氧数据同步->血压数据同步->呼吸频率同步->心率同步）->同步完成，括号中的同步类型根据传感器标志会有所不同
[[FitCloud shared]fcGetHistoryData:^(FCSyncType syncType) {
        // 返回当前正在操作的类型
    } dataHandler:^(FCSyncType syncType, NSData *data) {
        // 返回当前同步的某种类型的数据
        if (syncType == FCSyncTypeExercise) {
            // 处理运动数据
        }
        else if (syncType == FCSyncTypeSleep)
        {
            // 处理睡眠数据
        }
        else if (syncType == FCSyncTypeHeartRate)
        {
            // 处理心率数据
        }
        else if (syncType == FCSyncTypeBloodOxygen)
        {
            // 处理血氧数据
        }
        else if (syncType == FCSyncTypeBloodPressure)
        {
            // 处理血压数据
        }
        else if (syncType == FCSyncTypeBreathingRate)
        {
            // 处理呼吸频率数据
        }
        
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        // 返回同步结果
        if (state == FCSyncResponseStateSuccess) {
            
        }
        else
        {
            // 错误处理
        }
    }];
```
5. 至此，你已经能使用FitCloud终端SDK的API内容了。如果想更详细了解每个API函数的用法，请查阅 API文档 或自行下载阅读SDK Sample Demo源码。

