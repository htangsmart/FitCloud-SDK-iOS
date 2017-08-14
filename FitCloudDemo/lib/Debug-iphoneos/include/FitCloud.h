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
 app监听来自手表的拍照控制命令

 @param aBlock 响应结果回调
 */
- (void)fcSetListenTakePicturesCMDFromWatch:(dispatch_block_t)aBlock;


/**
 app监听手表查找手机指令

 @param aBlock 响应结果回调
 */
- (void)fcSetListenFindPhoneCMDFromWatch:(dispatch_block_t)aBlock;




#pragma mark - 传感器标志

/**
 判断当前类型的数据是否可以同步，手表绑定成功后调用有效

 @param type 同步类型
 @return YES／NO
 */
- (BOOL)isSyncEnable:(FCSensorFlagType)type;



#pragma mark - ---- 组合指令 ----

/**
 登录设备，蓝牙连接成功后，如果已经绑定过手表则需要执行登录操作

 @param aUser 用户资料
 @param stepCallback 登录流程回调
 @param retHandler 同步结果回调
 */
- (void)loginWithUser:(FCUserObject *)aUser stepCallback:(FCStepCallbackHandler)stepCallback result:(FCSyncResultHandler)retHandler;


/**
 绑定设备，第一次蓝牙配对成功后调用此接口绑定手表，绑定成功后将把蓝牙uuid保存在app，之后每次使用通过uuid自动扫描连接然后执行登录操作

 @param aUser 用户资料
 @param stepCallback 绑定流程回调
 @param retHandler 绑定结果回调，这里只有手表系统设置数据返回
 @warning  如果没有收到手表的系统配置数据，最好做绑定失败处理
 */
- (void)bindWithUser:(FCUserObject*)aUser stepCallback:(FCStepCallbackHandler)stepCallback result:(FCSyncDataResultHandler)retHandler;


/**
 同步手表历史数据，包括日总数据、运动量详细记录、睡眠详细记录、心率详细记录、血氧、血压和呼吸频率等。每次同步历史数据时会将系统时间和功能开关配置数据写入到手表
 
 @param aUser 用户资料对象
 @param stepCallback 同步流程回调
 @param dataCallback 同步数据回调，此处回多次回调不同类型的数据
 @param retHandler 同步结果回调
 */
- (void)fcGetHistoryDataWithUser:(FCUserObject*)aUser
                    stepCallback:(FCStepCallbackHandler)stepCallback
                    dataCallback:(FCSyncDataHandler)dataCallback
                          result:(FCSyncResultHandler)retHandler;



#pragma mark ----- 蓝牙指令 -----
#pragma mark - 你可以通过组合不同指令执行不同操作

/**
 登录设备

 @param data 登录同步数据
 @param retHandler 同步结果回调
 */
- (void)fcLoginDevice:(NSData*)data result:(FCSyncResultHandler)retHandler;


/**
 绑定设备

 @param data 绑定同步数据 
 @see FCWatchConfig
 @param retHandler 同步结果毁掉
 */
- (void)fcBindDevice:(NSData*)data result:(FCSyncResultHandler)retHandler;


/**
 解除绑定

 @param retHandler 解除绑定回调
 */
- (void)fcUnBindDevice:(FCSyncResultHandler)retHandler;



/**
 同步系统时间到手表

 @param retHandler 同步结果回调
 */
- (void)fcUpdateWatchTime:(FCSyncResultHandler)retHandler;



/**
 同步佩戴方式到手表
 
 @param bEnabled 是否是左右佩戴
 @param retHandler 同步结果回调
 */
- (void)fcSetLeftHandWearEnable:(BOOL)bEnabled result:(FCSyncResultHandler)retHandler;



/**
 同步手表的功能开关配置到手表
 
 @param data 功能开关配置数据
 @param retHandler 同步结果回调
 */
- (void)fcSetFeaturesData:(NSData*)data result:(FCSyncResultHandler)retHandler;



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

 @see FCAlarmClockObject
 @seealso FCAlarmClockCycleObject
 @param retHandler 同步结果回调
 */
- (void)fcGetAlarmList:(FCSyncDataResultHandler)retHandler;



/**
 获取手表的macAddress

 @param retHandler 同步结果回调
 */
- (void)fcGetMacAddress:(FCSyncDataResultHandler)retHandler;



/**
 获取手表系统设置，相关配置数据解析请查看<i>FCObject</i>和<i>FitCloudUtils</i>的相关对象和方法

 @param retHandler 同步结果回调
 */
- (void)fcGetWatchConfig:(FCSyncDataResultHandler)retHandler;



/**
 获取电池的电量和充电状态信息

 @param retHandler 同步结果回调
 */
- (void)fcGetBatteryLevelAndState:(FCSyncDataResultHandler)retHandler;



/**
 同步手表屏幕显示内容到手表

 @param data 屏幕显示设置数据
 @param retHandler 步结果回调
 */
- (void)fcSetWatchScreenDisplayData:(NSData*)data result:(FCSyncResultHandler)retHandler;



/**
 同步通知开关设置到手表

 @param data 通知开关数据
 @param retHandler 同步结果回调
 */
- (void)fcSetNotificationSettingData:(NSData*)data result:(FCSyncResultHandler)retHandler;



/**
 同步久坐提醒配置到手表

 @param data 久坐提醒数据
 @param retHandler 同步结果回调
 */
- (void)fcSetSedentaryRemindersData:(NSData*)data result:(FCSyncResultHandler)retHandler;



/**
 同步健康监测配置到手表

 @param data 健康监测配置数据
 @param retHandler 同步结果回调
 */
- (void)fcSetHealthMonitoringData:(NSData*)data result:(FCSyncResultHandler)retHandler;



/**
 同步喝水提醒配置到手表

 @param bEnabled 喝水提醒开关状态
 @param retHandler 同步结果回调
 */
- (void)fcSetDrinkRemindEnable:(BOOL)bEnabled result:(FCSyncResultHandler)retHandler;



/**
 同步相机前后台状态到手表

 @param bInForeground app是否在后台
 @param retHandler 同步结果回调
 */
- (void)fcSetCameraState:(BOOL)bInForeground result:(FCSyncResultHandler)retHandler;



/**
 同步用户资料到手表

 @param aUser 用户资料数据
 @param retHandler 同步结果回调
 */
- (void)fcSetUserProfile:(FCUserObject*)aUser result:(FCSyncResultHandler)retHandler;



/**
 同步默认参考血压到手表

 @param sbp 收缩压
 @param dbp 舒张压
 @param retHandler 同步结果回调
 */
- (void)fcSetBloodPressure:(UInt16)sbp dbp:(UInt16)dbp result:(FCSyncResultHandler)retHandler;



/**
 同步天气到手表

 @param weather 天气对象
 @param retHandler 同步结果回调
 */
- (void)fcSetWeather:(FCWeather*)weather result:(FCSyncResultHandler)retHandler;


/**
 同步系统语言到手表
 
 @param retHandler 同步结果回调
 */
- (void)fcSetANCSLanguage:(FCSyncResultHandler)retHandler;


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




#pragma mark  -实时同步


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


#pragma mark - 运动数据获取指令

/**
 获取日总运动数据

 @param retHandler 同步结果回调
 */
- (void)fcGetDailyTotalData:(FCSyncDataResultHandler)retHandler;

/**
 获取运动量详细数据

 @param retHandler 同步结果回调
 */
- (void)fcGetExerciseData:(FCSyncDataResultHandler)retHandler;

/**
 获取睡眠详细数据

 @param retHandler 同步结果回调
 */
- (void)fcGetSleepData:(FCSyncDataResultHandler)retHandler;

/**
 获取心率详细数据，此项需要判断传感器标志，如果存在心率标志，则可以进行心率同步

 @see <code>isSyncEnable:</code>
 @see <i>FCSensorFlagType</i>
 @param retHandler 同步结果回调
 */
- (void)fcGetHeartRateData:(FCSyncDataResultHandler)retHandler;

/**
 获取血氧详细数据，此项需要判断传感器标志，如果存在标志，则可以进行同步
 
 @see <code>isSyncEnable:</code>
 @see <i>FCSensorFlagType</i>
 @param retHandler 同步结果回调
 */
- (void)fcGetBloodOxygenData:(FCSyncDataResultHandler)retHandler;

/**
 获取紫外线详细数据，此项需要判断传感器标志，如果存在标志，则可以进行同步
 
 @see <code>isSyncEnable:</code>
 @see <i>FCSensorFlagType</i>
 @param retHandler 同步结果回调
 */
- (void)fcGetUltravioletData:(FCSyncDataResultHandler)retHandler;

/**
 获取血压详细数据，此项需要判断传感器标志，如果存在标志，则可以进行同步
 
 @see <code>isSyncEnable:</code>
 @see <i>FCSensorFlagType</i>
 @param retHandler 同步结果回调
 */
- (void)fcGetBloodPressureData:(FCSyncDataResultHandler)retHandler;

/**
 获取呼吸频率详细数据，此项需要判断传感器标志，如果存在标志，则可以进行同步
 
 @see <code>isSyncEnable:</code>
 @see <i>FCSensorFlagType</i>
 @param retHandler 同步结果回调
 */
- (void)fcGetBreathingRateData:(FCSyncDataResultHandler)retHandler;

/**
 获取七日睡眠总数据，此项需要判断传感器标志，如果存在标志，则可以进行同步
 
 @see <code>isSyncEnable:</code>
 @see <i>FCSensorFlagType</i>
 @param retHandler 同步结果回调
 */
- (void)fcGetSevenDaysSleepTotalData:(FCSyncDataResultHandler)retHandler;



#pragma mark - 固件升级

/**
 获取手表固件版本信息

 @param retHandler 同步结果回调
 */
- (void)fcGetFirmwareVersion:(FCSyncDataResultHandler)retHandler;


/**
 固件升级接口，掉用此接口，蓝牙将会断开连接并进入固件升级模式，升级成功后，手表会重启

 @param filePath 要升级的固件路径
 @param progressHandler 固件升级进度回调
 @param retHandler 同步结果回调
 */
- (void)fcUpdateFirmwareWithPath:(NSString*)filePath progress:(FCProgressHandler)progressHandler result:(FCSyncResultHandler)retHandler;
@end

