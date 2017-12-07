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

/**
 蓝牙状态定义
 */
typedef NS_ENUM(NSInteger, FCManagerState) {
    /*! 未知错误*/
    FCManagerStateUnknown,
    /*! 蓝牙重置状态*/
    FCManagerStateResetting,
    /*! 设备不支持状态*/
    FCManagerStateUnsupported,
    /*! 设备未授权状态*/
    FCManagerStateUnauthorized,
    /*! 蓝牙关闭*/
    FCManagerStatePoweredOff,
    /*! 蓝牙打开*/
    FCManagerStatePoweredOn,
};


/**
 传感器标志，如果存在某个标志可以进行某项数据同步
 */
typedef NS_OPTIONS(UInt32, FCSensorFlagType)
{
    /*! 心率*/
    FCSensorFlagTypeHeartRate = 1,
    /*! 紫外线*/
    FCSensorFlagTypeUV = 1 << 1,
    /*! 天气预报*/
    FCSensorFlagTypeWeather = 1 << 2,
    /*! 血氧，有此标志则存在血氧功能*/
    FCSensorFlagTypeBloodOxygen = 1 << 3,
    /*! 血压，有此标志则存在血压功能*/
    FCSensorFlagTypeBloodPressure = 1 << 4,
    /*! 呼吸频率*/
    FCSensorFlagTypeBreathingRate = 1 << 5,
    /*! 加强检测*/
    FCSensorFlagTypeEnhanceMeasurement = 1 << 6,
    /*! 睡眠七天历史数据*/
    FCSensorFlagTypeSevenDaysSleep = 1 << 7,
    /*! 心电*/
    FCSensorFlagTypeECG = 1 << 8,
    /*! 外部Flash OTA*/
    FCSensorFlagTypeFlashOTA = 1 << 9,
    /*! 手机系统语言设置*/
    FCSensorFlagTypeANCS = 1 << 10,
    /*! 喝水提醒和翻腕亮屏新设置*/
    FCSensorFlagTypeDinkRemindAndFWLS = 1 << 11,
    /*! 跑步*/
    FCSensorFlagTypeRuning = 1 << 12,
    /*! 日语ANCS字库*/
    FCSensorFlagTypeANCSJapanese = 1 << 13,
};

/**
 同步数据的类型，用于区分FCDataObject数据类型
 */
typedef NS_ENUM(NSInteger, FCDataType)
{
    /*!  默认未知类型*/
    FCDataTypeUnknown = 0,
    /*!  运动量*/
    FCDataTypeExercise,
    /*!  睡眠*/
    FCDataTypeSleep,
    /*!  心率*/
    FCDataTypeHeartRate,
    /*!  血氧*/
    FCDataTypeBloodOxygen,
    /*!  血压*/
    FCDataTypeBloodPressure,
    /*!  呼吸频率*/
    FCDataTypeBreathingRate,
    /*!  七天日总睡眠数据*/
    FCDataTypeSevenDaysSleepData,
};


/**
 手环数据同步标志
 */
typedef NS_ENUM(NSInteger, FCSyncType) {
    
    /*! 默认类型*/
    FCSyncTypeUnknown = 0,
    
    /*! 解绑设备*/
    FCSyncTypeUnBindDevice = 1,
    
    /*! 登录设备*/
    FCSyncTypeLoginDevice = 2,
    
    /*! 绑定设备*/
    FCSyncTypeBindDevice = 3,
    
    /*! 设置系统时间*/
    FCSyncTypeUpdateWatchTime = 4,
    
    /*! 更新功能开关*/
    FCSyncTypeSetFeatures = 5,
    
    /*! 更新佩戴方式*/
    FCSyncTypeSetWearingStyle = 6,
    
    /*! 更新用户资料*/
    FCSyncTypeSetUserProfile = 7,
    
    /*! 更新默认参考血压*/
    FCSyncTypeSetDefaultBloodPressure = 8,
    
    /*! 获取手表配置*/
    FCSyncTypeGetWatchConfig = 9,
    
    /*! 查找手表*/
    FCSyncTypeFindTheWatch = 10,
    
    /*! 获取闹钟列表*/
    FCSyncTypeGetAlarmList = 11,
    
    /*! 闹钟设置*/
    FCSyncTypeSetAlarmData = 12,
    
    /*! 电量和充电状态获取*/
    FCSyncTypeGetBatteryLevelAndState = 13,
    
    /*! 屏幕显示设置*/
    FCSyncTypeSetScreenDisplay = 14,
    
    /*! 通知开关设置*/
    FCSyncTypeSetNotification = 15,
    
    /*! 久坐提醒*/
    FCSyncTypeSetSedentaryReminder = 16,
    
    /*! 健康监测*/
    FCSyncTypeSetHealthMonitoring = 17,
    
    /*! 喝水提醒*/
    FCSyncTypeSetDrinkReminder = 18,
    
    /*! 相机状态设置*/
    FCSyncTypeSetCameraState = 19,
    
    /*! 天气更新*/
    FCSyncTypeUpdateWeather = 20,
    
    /*! 打开健康实时同步*/
    FCSyncTypeOpenRealtimeSync = 21,
    
    /*! 关闭健康实时同步*/
    FCSyncTypeCloseRealtimeSync = 22,
    
    /*! 请求固件升级*/
    FCSyncTypeFirmwareUpgrade = 23,
    
    /*! 获取固件版本*/
    FCSyncTypeGetFirmwareVersion = 24,
    
    /*! 获取手表mac地址*/
    FCSyncTypeGetMacAddress = 25,
    
    /*! 发现手机回复*/
    FCSyncTypeFoundPhoneReplay = 26,
    
    /*! 设置ANCS语言*/
    FCSyncTypeSetANCSLanguage = 27,
    
    /*! 获取日总数据包括运动总步数、总距离、总卡路里等*/
    FCSyncTypeGetDayTotalData = 29,
    
    /*! 获取运动量详细记录*/
    FCSyncTypeGetExerciseData = 30,
    
    /*! 获取睡眠详细记录*/
    FCSyncTypeGetSleepData = 31,
    
    /*! 获取血氧记录*/
    FCSyncTypeGetBloodOxygenData = 32,
    
    /*! 获取血压记录*/
    FCSyncTypeGetBloodPressureData = 33,
    
    /*! 获取呼吸频率记录*/
    FCSyncTypeGetBreathingRateData = 34,
    
    /*! 获取心率记录*/
    FCSyncTypeGetHeartRateData = 35,
    
    /*! 获取紫外线记录*/
    FCSyncTypeGetUltravioletData = 36,
    
    /*! 获取七日睡眠总数据*/
    FCSyncTypeGetSevenDaysSleepData = 37,
    
    /*! 翻腕亮屏设置*/
    FCSyncTypeSetFlipWristToLightScreen = 38,
    
    /*! 跑步指令设置*/
    FCSyncTypeSetRuningSwitchData = 39,
    
    /*! 跑步指令开关状态设置*/
    FCSyncTypeSetRuningSwitchStateData = 40,
    
    /*! 获取跑步状态*/
    FCSyncTypeGetRuningState = 41,
    
    /*! 获取跑步数据*/
    FCSyncTypeGetRuningData = 42,
    
    /*! 获取跑步详细数据*/
    FCSyncTypeGetRuningDetailData = 43,
    /*! 重启手表*/
    FCSyncTypeRestartWatch,
    /*! 结束*/
    FCSyncTypeEnd = 100,
};


/**
 实时同步类型
 */
typedef NS_ENUM(NSInteger, FCRTSyncType)
{
    /*! 默认*/
    FCRTSyncTypeUnknown = 0,
    /*! 心率*/
    FCRTSyncTypeHeartRate,
    /*! 实时血氧*/
    FCRTSyncTypeBloodOxygen,
    /*! 血压e*/
    FCRTSyncTypeBloodPressure,
    /*! 呼吸频率*/
    FCRTSyncTypeBreathingRate,
    /*! 心电图*/
    FCRTSyncTypeECG,
};


/**
 健康实时同步操作类型
 */
typedef NS_ENUM(NSInteger, FCHealthRTSyncType)
{
    /*! 未知健康同步操作*/
    FCHealthRTSyncTypeUnKnown = 0,
    /*! 打开健康实时同步*/
    FCHealthRTSyncTypeOpenRTSync,
    /*! 关闭健康实时同步*/
    FCHealthRTSyncTypeCloseRTSync,
    /*! 打开心电检测*/
    FCHealthRTSyncTypeOpenECG,
    /*! 关闭心电检测*/
    FCHealthRTSyncTypeCloseECG,
};

/**
 同步响应结果，如果蓝牙在通讯过程中centralManager发生状态变化，部分蓝牙相关状态被回调
 */
typedef NS_ENUM(NSInteger, FCSyncResponseState) {

    /*! 未知类型*/
    FCSyncResponseStateUnKnown = 0,
    
    /*! 当前设备不支持蓝牙4.0*/
    FCSyncResponseStateUnsupported = 1,
    
    /*! 蓝牙未授权*/
    FCSyncResponseStateUnauthorized = 2,
    
    /*! 蓝牙重置状态*/
    FCSyncResponseStateResetting = 3,
    
    /*! 蓝牙未连接*/
    FCSyncResponseStateNotConnected = 4,
    
    /*! 蓝牙关闭，主动关闭蓝牙时回调*/
    FCSyncResponseStatePowerOff = 5,
    
    /*! 蓝牙打开，主动打开蓝牙时回调*/
    FCSyncResponseStatePowerOn = 6,
    
    /*! 蓝牙断开连接，主动或者被动断开都会调用*/
    FCSyncResponseStateDisconnect = 7,
    
    /*! 同步参数错误*/
    FCSyncResponseStateParameterError = 8,
    
    /*! 无传感器同步标志,不能同步数据*/
    FCSyncResponseStateNoSensorFlag = 9,
    
    /*! 正在同步，蓝牙正在同步时发起同步操作会返回此结果*/
    FCSyncResponseStateSynchronizing = 10,
    
    /*! 同步响应成功*/
    FCSyncResponseStateSuccess = 11,
    
    /*! 同步响应失败*/
    FCSyncResponseStateError = 12,
    
    /*! 同步响应超时*/
    FCSyncResponseStateTimeOut = 13,
    
    /*! 健康实时同步超时*/
    FCSyncResponseStateRTTimeOut = 14,
    
    /*! 心电检测数据同步超时*/
    FCSyncResponseStateECGTimeOut = 15,
    
    /*! 低电量模式，固件升级时低电量提示*/
    FCSyncResponseStateLowPower = 16,
};


#endif /* FCDefine_h */
