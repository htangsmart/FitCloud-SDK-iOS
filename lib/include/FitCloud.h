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



@class FCWeather;
@class FCUserObject;
@interface FitCloud : NSObject
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *servicePeripheral;
@property (nonatomic, assign, readonly) FCSyncType syncType;
@property (nonatomic, assign, readonly) BOOL isSynchronizing;

+ (instancetype)shared;

/*!
 获取SDK版本
 
 @return SDK 版本字符串
 */
+ (NSString*)SDKVersion;


#pragma mark - 扫描与连接

/*!
 @discussion 扫描蓝牙外设,返回当前被扫描到的外设和已经扫描到的<code>CBPeripheral</code>外设列表
 @param retHandler 扫描结果回调block
 */
- (void)scanningPeripherals:(FCDeviceListHandler)retHandler;


/*!
 @discussion 扫描制定uuid的蓝牙外设，返回当前被扫描到的目标外设
 @param uuidString 蓝牙uuid
 @param retHandler 扫描结果回调
 */
- (void)scanningPeripheralWithUUID:(NSString *)uuidString
                        retHandler:(FCPeripheralHandler)retHandler;


/*!
 @discussion 停止扫描
 */
- (void)stopScanning;


/*!
 @discussion 判断当前的<code>servicePeripheral</code>是否已链接
 @return YES/NO
 */
- (BOOL)isConnected;


/*!
 @discussion连接蓝牙外设外设
 @param peripheral 要连接的外设
 @see EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY
 @seealso EVENT_CONNECT_PERIPHERAL_NOTIFY
 @return YES/NO,如果外设进入连接返回YES
 */
- (BOOL)connectPeripheral:(CBPeripheral*)peripheral;


/*!
 @discussion 断开<i>peripheral</i>连接, 断开结果回调请接收通知 {@link EVENT_DISCONNECT_PERIPHERAL_NOTIFY}
 @param peripheral 目标外设
 @see EVENT_DISCONNECT_PERIPHERAL_NOTIFY
 @return YES/NO, 如果执行了断开操作返回YES
 */
- (BOOL)disconnectPeripheral:(CBPeripheral*)peripheral;


/*!
 @discussion 断开<i>servicePeripheral</i>连接，断开结果回调请接收通知 {@link EVENT_DISCONNECT_PERIPHERAL_NOTIFY}
 @see EVENT_DISCONNECT_PERIPHERAL_NOTIFY
 @return YES/NO
 */
- (BOOL)disconnect;




#pragma mark - 控制监听

/*!
 @discussion 查找手表，如果蓝牙处于连接状态，当收到手机app发出的查找手表命令后手表开始震动
 @param retHandler 响应结果回调block
 */
- (void)fcFindTheWatch:(FCSyncResultHandler)retHandler;




/*!
 @discussion 回复找到手机，如果蓝牙处于连接状态，当收到手表发出的查找手机命令后，手机发送一个回复给手表表示找到手机
 @param retHandler 响应结果回调block
 */
- (void)fcFineThePhoneReply:(FCSyncResultHandler)retHandler;




/*!
 @discussion 手机监听来自手表的拍照控制命令
 @param aBlock 响应回调block
 */
- (void)fcSetOnReceivedTakePicturesCommandFromWatch:(dispatch_block_t)aBlock;




/*!
 @discussion 手机监听手表查找手机指令
 @param aBlock 响应回调block
 */
- (void)fcSetOnReceivedFindMobileCommandFromWatch:(dispatch_block_t)aBlock;





#pragma mark - 手表登录、绑定或解绑操作

/*!
 @discussion 登录设备，蓝牙连接成功后，如果已经绑定过手表则需要执行登录操作
 @param aUser 用户对象
 @param stepCallBack 登录流程步骤回调
 @param retHandler 登录结果回调block
 */
- (void)loginWithUser:(FCUserObject*)aUser
         stepCallback:(FCStepCallbackHandler)stepCallBack
           retHandler:(FCLoginResultHandler)retHandler;


/*!
 @discussion 绑定设备，第一次配对成功后需要执行绑定操作，将用户账户与手表绑定，绑定成功后app需要把蓝牙uuid保存在客户端，下次蓝牙连接检查此uuid如果存在直接执行登陆操作
 @param aUser 用户信息对象
 @param stepCallBack 登录流程步骤回调
 @param dataCallback 系统设置数据回调block
 @param retHandler 绑定结果回调block
 */
- (void)bindWithUser:(FCUserObject*)aUser
        stepCallback:(FCStepCallbackHandler)stepCallBack
        dataCallback:(FCSyncDataHandler)dataCallback
          retHandler:(FCBindResultHandler)retHandler;



/**
 @discussion 解除绑定，此操作会解除手表与app用户账号的绑定
 @param retHandler 解绑结果回调block
 */
- (void)unbindDevice:(FCSyncResultHandler)retHandler;



#pragma mark - 闹钟同步
/*!
 * @brief Set alarm clock data
 * @param data       Alarm clock data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetAlarmData:(NSData*)data
            retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Get the list of alarms
 * @param dataHandler Alarm list data callback
 * @param retHandler  Synchronous result callback
 */
- (void)fcGetAlarmList:(FCSyncDataHandler)dataHandler
            retHandler:(FCSyncResultHandler)retHandler;



#pragma mark - 功能设置

/*!
 * @brief Get the MAC address of the watch
 * @param dataHandler MAC address data callback block
 * @param retHandler Synchronous result callback block
 */
- (void)fcGetMacAddress:(FCSyncDataHandler)dataHandler
             retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Gets the system settings
 * @param dataHandler The system setting data callback
 * @param retHandler Synchronous result callback
 */
- (void)fcGetSystemSetting:(FCSyncDataHandler)dataHandler
                retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @discussion 获取电池的电量和充电信息
 * @param dataHandler  电量和充电信息回调block
 * @param retHandler   同步结果回调block
 */
- (void)fcGetBatteryPowerAndChargingState:(FCSyncPowerAndChargingStateHandler)dataHandler
                               retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @discussion 设置手表屏幕显示内容
 * @param data       屏幕显示设置数据
 * @param retHandler 同步结果回调block
 */
- (void)fcSetWatchScreenDisplayData:(NSData*)data
                         retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @discussion 设置手表的功能开关配置
 * @param data       功能开关配置数据
 * @param retHandler 同步结果回调block
 */
- (void)fcSetFeaturesData:(NSData*)data
               retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Set the notification switch
 * @param data       Notification switch data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetNotificationSettingData:(NSData*)data
                          retHandler:(FCSyncResultHandler)retHandler;


/**
 * @brief Set up sedentary reminders
 * @param data       Sedentary reminder data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetSedentaryRemindersData:(NSData*)data
                         retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the health of real-time monitoring
 * @param data       Health real-time monitoring data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetHealthMonitoringData:(NSData*)data
                       retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set reminders to drink water
 * @param bEnabled   Reminder to drink water switch status
 * @param retHandler Synchronous result callback
 */
- (void)fcSetDrinkRemindEnable:(BOOL)bEnabled
                    retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the wearing style

 @param bEnabled   Left hand wear
 @param retHandler Synchronous result callback
 */
- (void)fcSetLeftHandWearEnable:(BOOL)bEnabled
                     retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the camera status
 * @param bInForeground in the foreground
 * @param retHandler    Synchronous result callback
 */
- (void)fcSetCameraState:(BOOL)bInForeground
              retHandler:(FCSyncResultHandler)retHandler;


/*!
 @discussion 同步用户资料到手表
 @param aUser 用户资料对象
 @param retHandler 同步结果回调block
 */
- (void)fcSetUserProfile:(FCUserObject*)aUser
              retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method fcSetBloodPressure:dbp:retHandler:
 * @brief Set the default blood pressure
 * @param sbp        Systolic blood pressure
 * @param dbp        Diastolic blood pressure
 * @param retHandler Synchronous result callback
 */
- (void)fcSetBloodPressure:(UInt16)sbp
                       dbp:(UInt16)dbp
                retHandler:(FCSyncResultHandler)retHandler;


/*!
 @discussion 更新最新天气到手表
 @param weather 天气对象
 @param retHandler 同步结果回调block
 */
- (void)fcSetWeather:(FCWeather*)weather
          retHandler:(FCSyncResultHandler)retHandler;



#pragma mark - 睡眠监测
/*!
 * @brief 设置睡眠监测时间，包含睡眠监测开始时间和结束时间
 * @param data       睡眠监测时间数据
 * @param retHandler 同步结果回调
 */
- (void)fcOpenSleepMonitoringData:(NSData*)data
                       retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief 关闭睡眠监测，关闭后手表不在记录睡眠数据
 * @param retHandler 同步结果回调
 */
- (void)fcCloseSleepMonitoring:(FCSyncResultHandler)retHandler;



#pragma mark - 健康实时同步

/*!
 * @method fcOpenRealTimeSync:dataHandler:retHandler:
 * @brief Turn on Healthy real-time synchronization
 * @param syncType    Real-time synchronization type
 * @param dataHandler Health real-time synchronization data callback
 * @param retHandler  Synchronous result callback
 */
- (void)fcOpenRealTimeSync:(FCRTSyncType)syncType
               dataHandler:(FCSyncDataHandler)dataHandler
                retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method fcCloseRealTimeSync:
 * @brief Turn off healthy real-time synchronization
 * @param retHandler Synchronous result callback
 */
- (void)fcCloseRealTimeSync:(FCSyncResultHandler)retHandler;


#pragma mark - 历史数据同步

/*!
 @discussion 同步手表历史数据，包括日总数据、运动量详细记录、睡眠详细记录、心率详细记录、血氧、血压和呼吸频率等
 @method fcGetHistoryData:dataHandler:retHandler:
 @param stepCallback 同步步骤回调block
 @param dataCallback 同步数据回调block，此block会多次调用
 @param retHandler 同步结果回调block，当同步完成或者中途同步失败，此block被调用
 */
- (void)fcGetHistoryData:(FCStepCallbackHandler)stepCallback
             dataCallback:(FCHistoryDataHandler)dataCallback
              retHandler:(FCHistoryDataResultHandler)retHandler;


/*!
 @discussion 同步历史总睡眠数据，此睡眠数据包含当天及以前的七天内日总睡眠时长（深睡眠和浅睡眠时长）
 @method fcGetHistoryTotalSleepData:retHandler:
 @param dataHandler 睡觉数据回调block
 @param retHandler 同步结果回调block
 */
- (void)fcGetHistoryTotalSleepData:(FCSyncDataHandler)dataHandler
                        retHandler:(FCSyncResultHandler)retHandler;


#pragma mark - 固件升级

/*!
 @discussion 获取手表固件版本信息
 @method fcGetFirmwareVersion:retHandler:
 @param dataHandler 固件版本信息数据回调
 @param retHandler 获取固件版本信息结果回调
 */
- (void)fcGetFirmwareVersion:(FCSyncDataHandler)dataHandler
                  retHandler:(FCSyncResultHandler)retHandler;


/*!
 @discussion 固件升级接口，掉用此接口，蓝牙将会断开连接并进入固件升级模式
 @method fcUpdateFirmwareWithPath:progress:retHandler:
 @param filePath 要升级的固件路径
 @param progressHandler 固件升级进度回调block
 @param retHandler 固件升级结果回调block
 */
- (void)fcUpdateFirmwareWithPath:(NSString*)filePath
                        progress:(FCProgressHandler)progressHandler
                      retHandler:(FCSyncResultHandler)retHandler;
@end

