//
//  FCDefine.h
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#ifndef FCDefine_h
#define FCDefine_h

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>



/*!
 * @enum FCSyncType
 * @discussion Bluetooth data synchronization type
 */
typedef NS_ENUM(NSInteger, FCSyncType) {
    /*! The default type*/
    FCSyncTypeNone = 0,
    /*! Unbind the device*/
    FCSyncTypeUnBindDevice = 18,
    /*! Login the device*/
    FCSyncTypeLoginDevice = 19,
    /*! Bond the device*/
    FCSyncTypeBindDevice = 20,
    /*! Login to the device to synchronize the time*/
    FCSyncTypeLoginToSyncTime = 21,
    /*! Find the watch*/
    FCSyncTypeFindWristband = 23,
    /*! Synchronize the alarm list*/
    FCSyncTypeGetAlarmList = 24,
    /*! Alarm settings*/
    FCSyncTypeSetAlarmData = 25,
    /*! Get power and charge status*/
    FCSyncTypeBatteryPowerAndChargingState = 26,
    /*! Get the system settings*/
    FCSyncTypeGetSystemSettings = 27,
    /*! Watch display settings*/
    FCSyncTypeDisplaySettings = 28,
    /*! Watch function switch settings*/
    FCSyncTypeFunctionSwitchSettings = 29,
    /*! notification switch settings*/
    FCSyncTypeNotificationSettings = 30,
    /*! The sedentary reminder setting*/
    FCSyncTypeSedentaryReminder = 31,
    /*! Health monitoring settings*/
    FCSyncTypeHealthMonitoring = 32,
    /*! Drink water to remind*/
    FCSyncTypeDrinkReminder = 33,
    /*! Wearing style settings*/
    FCSyncTypeWearingStyle = 34,
    /*! Camera states*/
    FCSyncTypeCameraState = 35,
    /*! Default Blood Pressure压*/
    FCSyncTypeDefaultBloodPressure = 36,
    /*! Weather settings*/
    FCSyncTypeUpdateWeather = 37,
    /*! Set the user profile*/
    FCSyncTypeUserProfile = 38,
    /*! Historical data synchronization*/
    FCSyncTypeHistoryData = 39,
    /*! Exercise synchronization*/
    FCSyncTypeExercise = 40,
    /*! sleep data synchronization*/
    FCSyncTypeSleep = 41,
    /*! Heart rate data synchronization*/
    FCSyncTypeHeartRate = 42,
    /*! Blood oxygenation data synchronization*/
    FCSyncTypeBloodOxygen = 43,
    /*! UV data synchronization*/
    FCSyncTypeUltraviolet = 44,
    /*! Respiratory frequency data synchronization*/
    FCSyncTypeBreathingRate = 45,
    /*! Blood Pressure Data Synchronization*/
    FCSyncTypeBloodPressure = 46,
    /*! Turns on real-time health sync*/
    FCSyncTypeOpenRealtimeSync = 47,
    /*! Turn off health real-time synchronization*/
    FCSyncTypeCloseRealtimeSync = 48,
    /*! Firmware upgrade*/
    FCSyncTypeFirmwareUpgrade = 49,
    /*! Firmware version*/
    FCSyncTypeFirmwareVersion = 50,
    /*! Found my cell phone.*/
    FCSyncTypeFoundMyCellPhone = 51,
    /*! Finished*/
    FCSyncTypeEnd = 100,
};


/*!
 * @enum FCRTSyncType
 * @discussion Real-time synchronization type
 */
typedef NS_ENUM(NSInteger, FCRTSyncType)
{
    /*! The default type*/
    FCRTSyncTypeNone = 0,
    /*! Heart rate real-time synchronization*/
    FCRTSyncTypeHeartRate,
    /*! Blood oxygen real-time synchronization步*/
    FCRTSyncTypeBloodOxygen,
    /*! Blood pressure real-time synchronization*/
    FCRTSyncTypeBloodPressure,
    /*! Respiratory rate real-time synchronization*/
    FCRTSyncTypeBreathingRate,
};

/*!
 * @enum FCSyncResponseState
 * @discussion  synchronization response status
 */
typedef NS_ENUM(NSInteger, FCSyncResponseState) {

    /*! The default type*/
    FCSyncResponseStateNone = 0,
    /*! Bluetooth is poweroff*/
    FCSyncResponseStatePowerOff = 1,
    /*! Bluetooth is not connected*/
    FCSyncResponseStateNotConnected = 2,
    /*! Bluetooth disconnected*/
    FCSyncResponseStateDisconnect = 3,
    /*! Parameter error*/
    FCSyncResponseStateParameterError = 4,
    /*! Synchronizing data*/
    FCSyncResponseStateSyncing = 5,
    /*! Synchronization succeeded*/
    FCSyncResponseStateSuccess = 6,
    /*! Synchronization failed*/
    FCSyncResponseStateError = 7,
    /*! Synchronization timeout*/
    FCSyncResponseStateTimeOut = 8,
    /*! Healthy real-time synchronization timeout*/
    FCSyncResponseStateRTTimeOut = 9,
};


/*!
 * @discussion Firmware upgrade progress callback
 * @param progress Percentage of progress
 */
typedef void (^FCProgressHandler)(CGFloat progress);

/*!
 * @discussion A list of peripherals that are scanned for callbacks
 * @param retArray    A list of peripherals that are scanned
 * @param aPeripheral A peripheral to be scanned
 */
typedef void (^FCDeviceListHandler)(NSArray<CBPeripheral*>*retArray,CBPeripheral *aPeripheral);


/*!
 * @brief Bluetooth scan callback
 * @param aPeripheral A peripheral to be scanned
 */
typedef void (^FCPeripheralHandler)(CBPeripheral *aPeripheral);


/**
 绑定所需用户信息

 @param sex    用户性别
 @param age    用户年龄
 @param weight 用户体重
 @param height 用户身高
 */
typedef void (^FCUserDataHandler)(UInt32 sex, UInt32 age, UInt32 weight, UInt32 height);


/**
 手表穿戴方式

 @param lefthHand 是否是左手佩戴
 */
typedef void (^FCWearStyleHandler)(BOOL lefthHand);



/**
 登录、绑定所需用户和手机信息回调

 @param guestId 用户唯一id
 @param mode    手机系统版本
 @param os      手机系统类型
 */
typedef void (^FCAuthDataHandler)(UInt64 guestId, UInt8 mode, UInt8 os);


/**
 *  同步结果回调
 *
 *  @param syncType 当前同步类型，当state为FCSyncResponseStateSuccess返回最后一种同步类型
 *  @param state    同步结果返回状态
 */
typedef void (^FCSyncResultHandler)(FCSyncType syncType, FCSyncResponseState state);


/**
 同步流程回调

 @param syncType 当前同步的类型
 */
typedef void (^FCSyncStepHandler)(FCSyncType syncType);


/**
 手表绑定入参block

 @param authDataHandler  用户id和手机系统信息，注：FCAuthDataHandler参数必填
 @param userDataHandler  用户信息，如不设置则使用默认数据
 @param wearStyleHandler 穿戴方式，如不设置则使用默认值
 */
typedef void (^FCBoundDataHandler)(FCAuthDataHandler authDataHandler,FCUserDataHandler userDataHandler,FCWearStyleHandler wearStyleHandler);


/**
 登录数据

 @param authDataHandler 用户登录信息设置block
 */
typedef void (^FCLoginDatahandler)(FCAuthDataHandler authDataHandler);

/**
 *  同步数据回调
 *
 *  @param syncType 同步数据的类型
 *  @param data     同步的数据
 */
typedef void (^FCSyncDataHandler)(FCSyncType syncType, NSData *data);


/**
 *  同步数据记录条数回调
 *
 *  @param count 同步记录个数
 */
typedef void (^FCSyncCountHandler) (UInt16 count);


/**
 *  解除绑定回调
 *
 *  @param state  同步响应结果
 *  @param status 解绑结果
 */
typedef void (^FCSyncUnBoundHandler)(FCSyncResponseState state, UInt8 status);


/**
 *  数据实时同步回调
 *
 *  @param data 实时同步响应数据
 */
typedef void (^FCRTSyncDataHandler)(NSData *data);


/**
 *  手表电池电量和充电状态回调
 *
 *  @param powerValue    电池电量
 *  @param chargingState 充电状态
 */
typedef void (^FCSyncPowerAndChargingStateHandler)(UInt8 powerValue, UInt8 chargingState);


/**
 *  手环系统配置信息回调
 *
 *  @param msgNFData    消息通知开关 4byte
 *  @param displayData  手环显示配置 2byte
 *  @param fcSwitchData 功能开关配置 2byte
 *  @param versionData  软硬件版本信息配置 32byte
 *  @param monitorData  健康实时监测配置 5byte
 *  @param longSitData  久坐提醒配置 5byte
 *  @param bpData       默认血压配置 2byte
 *  @param drinkData    喝水提醒配置 1byte
 */
typedef void (^FCSysSettingDataHandler)(NSData *msgNFData, NSData *displayData,NSData *fcSwitchData,NSData *versionData,NSData *monitorData,NSData *longSitData,NSData *bpData,NSData *drinkData);


/**
 *  手环软硬件版本信息回调
 *
 *  @param projData     项目号 6byte
 *  @param hardwareData 硬件号 4byte
 *  @param sdkData      sdk版本号 4byte
 *  @param patchData    软件patch版本号 6byte
 *  @param flashData    flash版本号 4byte
 *  @param fwAppData    固件app版本号 4byte
 *  @param seqData      序号 4byte
 */
typedef void (^FCVersionDataHandler)(NSData *projData,NSData *hardwareData,NSData *sdkData,NSData *patchData,NSData *flashData,NSData *fwAppData,NSData *seqData);


/*!
 * @discussion  手环软硬件版本信息字符串回调
 *
 *  @param projNum       项目号
 *  @param hardware      硬件号
 *  @param sdkVersion    sdk版本号
 *  @param patchVerson   软件patch版本号
 *  @param falshVersion  flash版本号
 *  @param appVersion    固件app版本号
 *  @param serialNum     序号
 */
typedef void (^FCVersionStringHandler)(NSString *projNum,NSString *hardware,NSString *sdkVersion,NSString *patchVerson,NSString *falshVersion,NSString *appVersion,NSString *serialNum);


/*!
 * @discussion 每日运动总数据结果回调
 * @param steps        日总运动步数
 * @param distance     日总运动距离
 * @param calorie      日总运动卡路里
 * @param dSleepTime   日总共深睡眠时间
 * @param lSleepTime   日总浅睡眠时间
 * @param avgHeartRate 平均心率
 */
typedef void (^FCTotalDailyDataHandler)(UInt32 steps, UInt32 distance, UInt32 calorie, UInt32 dSleepTime, UInt32 lSleepTime,UInt32 avgHeartRate);


#endif /* FCDefine_h */
