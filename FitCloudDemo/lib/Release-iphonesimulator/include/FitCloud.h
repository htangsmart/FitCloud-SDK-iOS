//
//  FitCloud.h
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FitCloudBlock.h"
#import "FCDefine.h"



@class FCWeather;
@class FCUserObject;

/*!
 @class FitCloud
 @discussion 蓝牙通讯核心文件
 */
@interface FitCloud : NSObject
@property (nonatomic, strong, readonly) CBCentralManager *centralManager;
@property (nonatomic, strong, readonly) CBPeripheral *servicePeripheral;
@property (nonatomic, assign, readonly) FCSyncType syncType;
@property (nonatomic, assign, readonly, getter=isSynchronizing) BOOL synchronizing;
@property (nonatomic, assign, readonly) FCManagerState managerState;


+ (instancetype)shared;

/**
 获取SDK版本号

 @return SDK 版本字符串
 */
+ (NSString*)SDKVersion;


#pragma mark - 扫描与连接

/**
 扫描蓝牙外设，如果uuidString存在则返回指定uuidString的外设，不存在则扫描所有符合条件的外设

 @param uuidString 蓝牙外设uuid字符串
 @param retHandler 扫描结果回调
 */
- (void)scanForPeripherals:(NSString*)uuidString result:(FCPeripheralsHandler)retHandler;


/**
 停止蓝牙扫描
 */
- (void)stopScanning;


/**
 判断当前的<code>servicePeripheral</code>是否已链接

 @return YES/NO
 */
- (BOOL)isConnected;


/**
 连接蓝牙外设外设

 @param peripheral 要连接的外设
 @seealso EVENT_CONNECT_PERIPHERAL_NOTIFY,EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY
 @return YES/NO,如果外设进入连接状态返回YES
 */
- (BOOL)connectPeripheral:(CBPeripheral*)peripheral;


/**
 断开<i>peripheral</i>连接, 断开结果回调请接收通知 {@see EVENT_DISCONNECT_PERIPHERAL_NOTIFY}

 @param peripheral 要断开的外设
 @return YES/NO, 如果进入了断开流程返回YES
 */
- (BOOL)disconnectPeripheral:(CBPeripheral*)peripheral;


/**
 断开<i>servicePeripheral</i>连接，断开结果回调请接收通知 {@see EVENT_DISCONNECT_PERIPHERAL_NOTIFY}

 @return YES/NO, 如果进入了断开流程返回YES
 */
- (BOOL)disconnect;



#pragma mark - 控制监听

/**
 查找手表，如果蓝牙处于连接状态，当收到手机app发出的查找手表命令后手表开始震动

 @param retHandler 同步结果回调
 */
- (void)fcFindTheWatch:(FCSyncResultHandler)retHandler;


/**
 向手表回复找到手机，如果蓝牙处于连接状态，当收到手表发出的查找手机命令后，手机发送一个回复给手表表示找到手机

 @param retHandler 同步结果回调
 */
- (void)fcFindThePhoneReply:(FCSyncResultHandler)retHandler;


/**
 app监听来自手表的拍照控制命令

 @param aBlock 响应结果回调
 */
- (void)fcSetListenTakePicturesCMDFromWatch:(dispatch_block_t)aBlock;


/**
 app监听手表查找手机指令

 @param aBlock 响应结果回调
 */
- (void)fcSetListenFindPhoneCMDFromWatch:(dispatch_block_t)aBlock;




#pragma mark - 手表登录、绑定或解绑操作

/**
 登录设备，蓝牙连接成功后，如果已经绑定过手表则需要执行登录操作

 @param aUser 用户资料
 @param stepCallBack 登录流程回调
 @param retHandler 同步结果回调
 */
- (void)loginWithUser:(FCUserObject*)aUser stepCallback:(FCStepCallbackHandler)stepCallBack result:(FCLoginResultHandler)retHandler;


/**
 绑定设备，第一次蓝牙配对成功后调用此接口绑定手表，绑定成功后将把蓝牙uuid保存在app，之后每次使用通过uuid自动扫描连接然后执行登录操作

 @param aUser 用户资料
 @param stepCallBack 绑定流程回调
 @param dataCallback 绑定数据回调，这里只有手表系统设置数据返回。
 @warning  如果没有收到手表的系统配置数据，最好做绑定失败处理
 @param retHandler 同步结果回调
 */
- (void)bindWithUser:(FCUserObject*)aUser stepCallback:(FCStepCallbackHandler)stepCallBack dataCallback:(FCSyncDataHandler)dataCallback result:(FCBindResultHandler)retHandler;


/**
 解除绑定，此操作会解除手表与app用户id的绑定

 @param retHandler 同步结果回调
 */
- (void)unbindDevice:(FCSyncResultHandler)retHandler;





#pragma mark - 设置佩戴方式
/**
 同步佩戴方式到手表
 
 @param bEnabled 是否是左右佩戴
 @param retHandler 同步结果回调
 */
- (void)fcSetLeftHandWearEnable:(BOOL)bEnabled result:(FCSyncResultHandler)retHandler;



#pragma mark - 闹钟同步

/**
 同步闹钟数据

 @param data 闹钟数据，最多只能设置8个闹钟
 @see  FCAlarmClockObject
 @seealso  FCAlarmClockCycleObject
 @param retHandler 同步结果回调
 */
- (void)fcSetAlarmData:(NSData*)data result:(FCSyncResultHandler)retHandler;



/**
 获取闹钟列表数据，回调数据通过<i>FitCloudUtils</i>的<code>getAlarmClocksFromData</code>解析可以获取闹钟对象列表

 @param dataCallback 闹钟数据回调
 @see FCAlarmClockObject
 @seealso FCAlarmClockCycleObject
 @param retHandler 同步结果回调
 */
- (void)fcGetAlarmList:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler;



#pragma mark - 获取mac地址

/**
 获取手表的macAddress

 @param dataCallback macAddress回调
 @param retHandler 同步结果回调
 */
- (void)fcGetMacAddress:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler;


#pragma mark - 获取手表系统设置

/**
 获取手表系统设置，相关配置数据解析请查看<i>FCObject</i>和<i>FitCloudUtils</i>的相关对象和方法

 @param dataCallback 手表配置数据回调
 @param retHandler 同步结果回调
 */
- (void)fcGetSystemSetting:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler;




#pragma mark - 获取电池的电量和充电状态信息
/**
 获取电池的电量和充电状态信息

 @param dataCallback 电量和充电信息回调
 @param retHandler 同步结果回调
 */
- (void)fcGetBatteryLevelAndState:(FCSyncBatteryLevelAndStateHandler)dataCallback  result:(FCSyncResultHandler)retHandler;


#pragma mark - 设置手表屏幕显示数据

/**
 同步手表屏幕显示内容到手表

 @param data 屏幕显示设置数据
 @param retHandler 步结果回调
 */
- (void)fcSetWatchScreenDisplayData:(NSData*)data result:(FCSyncResultHandler)retHandler;


#pragma mark - 手表的功能开关设置

/**
 同步手表的功能开关配置到手表

 @param data 功能开关配置数据
 @param retHandler 同步结果回调
 */
- (void)fcSetFeaturesData:(NSData*)data result:(FCSyncResultHandler)retHandler;


#pragma mark - 通知开关设置

/**
 同步通知开关设置到手表

 @param data 通知开关数据
 @param retHandler 同步结果回调
 */
- (void)fcSetNotificationSettingData:(NSData*)data result:(FCSyncResultHandler)retHandler;


#pragma mark - 久坐提醒设置

/**
 同步久坐提醒配置到手表

 @param data 久坐提醒数据
 @param retHandler 同步结果回调
 */
- (void)fcSetSedentaryRemindersData:(NSData*)data result:(FCSyncResultHandler)retHandler;


#pragma mark - 健康监测设置

/**
 同步健康监测配置到手表

 @param data 健康监测配置数据
 @param retHandler 同步结果回调
 */
- (void)fcSetHealthMonitoringData:(NSData*)data result:(FCSyncResultHandler)retHandler;


#pragma mark - 喝水提醒设置

/**
 同步喝水提醒配置到手表

 @param bEnabled 喝水提醒开关状态
 @param retHandler 同步结果回调
 */
- (void)fcSetDrinkRemindEnable:(BOOL)bEnabled result:(FCSyncResultHandler)retHandler;


#pragma mark - 相机前后台状态设置

/**
 同步相机前后台状态到手表

 @param bInForeground app是否在后台
 @param retHandler 同步结果回调
 */
- (void)fcSetCameraState:(BOOL)bInForeground result:(FCSyncResultHandler)retHandler;


#pragma mark - 用户资料设置

/**
 同步用户资料到手表

 @param aUser 用户资料数据
 @param retHandler 同步结果回调
 */
- (void)fcSetUserProfile:(FCUserObject*)aUser result:(FCSyncResultHandler)retHandler;


#pragma mark - 默认参考血压设置

/**
 同步默认参考血压到手表

 @param sbp 收缩压
 @param dbp 舒张压
 @param retHandler 同步结果回调
 */
- (void)fcSetBloodPressure:(UInt16)sbp dbp:(UInt16)dbp result:(FCSyncResultHandler)retHandler;


#pragma mark - 天气设置

/**
 同步天气到手表

 @param weather 天气对象
 @param retHandler 同步结果回调
 */
- (void)fcSetWeather:(FCWeather*)weather result:(FCSyncResultHandler)retHandler;



#pragma mark - 睡眠监测

/**
 打开睡眠监测

 @param data 睡眠监测配置数据
 @param retHandler 同步结果回调
 */
- (void)fcOpenSleepMonitoringData:(NSData*)data result:(FCSyncResultHandler)retHandler;


/**
 关闭睡眠监测，关闭后手表不在记录睡眠数据

 @param retHandler 同步结果回调
 */
- (void)fcCloseSleepMonitoring:(FCSyncResultHandler)retHandler;



#pragma mark - 健康实时同步

/**
 打开健康实时同步

 @param syncType 健康实时同步操作类型
 @param dataCallback 实时同步数据回调
 @param retHandler 同步结果回调
 */
- (void)fcOpenRealTimeSync:(FCRTSyncType)syncType dataCallback:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler;


/**
 关闭健康实时同步

 @param retHandler 同步结果回调
 */
- (void)fcCloseRealTimeSync:(FCSyncResultHandler)retHandler;


#pragma mark - 历史数据同步

/**
 同步手表历史数据，包括日总数据、运动量详细记录、睡眠详细记录、心率详细记录、血氧、血压和呼吸频率等。每次同步历史数据时会将系统时间和功能开关配置数据写入到手表

 @param aUser 用户资料对象
 @param stepCallback 同步流程回调
 @param dataCallback 同步数据回调，此处回多次回调不同类型的数据
 @param retHandler 同步结果回调
 */
- (void)fcGetHistoryDataWithUser:(FCUserObject*)aUser stepCallback:(FCStepCallbackHandler)stepCallback  dataCallback:(FCHistoryDataHandler)dataCallback result:(FCHistoryDataResultHandler)retHandler;





#pragma mark - 固件升级

/**
 获取手表固件版本信息

 @param dataCallback 固件版本信息数据回调
 @param retHandler 同步结果回调
 */
- (void)fcGetFirmwareVersion:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler;


/**
 固件升级接口，掉用此接口，蓝牙将会断开连接并进入固件升级模式，升级成功后，手表会重启

 @param filePath 要升级的固件路径
 @param progressHandler 固件升级进度回调
 @param retHandler 同步结果回调
 */
- (void)fcUpdateFirmwareWithPath:(NSString*)filePath progress:(FCProgressHandler)progressHandler result:(FCSyncResultHandler)retHandler;
@end

