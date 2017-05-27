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
 登录设备同步流程
 */
typedef NS_ENUM(NSInteger, FCLoginSyncType)
{
    /*! 默认类型*/
    FCLoginSyncTypeUnknown = 0,
    /*! 登录设备*/
    FCLoginSyncTypeLogin = 1,
    /*! 同步功能开关设置到手表*/
    FCLoginSyncTypeFeatures = 2,
    /*! 同步系统时间*/
    FCLoginSyncTypeTime = 3,
    /*! 结束*/
    FCLoginSyncTypeEnd = 4,
};


/**
 绑定设备同步流程
 */
typedef NS_ENUM(NSInteger, FCBindSyncType)
{
    /*! 默认类型*/
    FCBindSyncTypeUnknown = 0,
    /*! 绑定设备*/
    FCBindSyncTypeBond = 1,
    /*! 同步功能开关设置到手表*/
    FCBindSyncTypeFeatures = 2,
    /*! 同步系统时间到手表*/
    FCBindSyncTypeTime = 3,
    /*! 同步用户资料到手表*/
    FCBindSyncTypeUserInfo = 4,
    /*! 同步佩戴方式到手表*/
    FCBindSyncTypeWearingStyle = 5,
    /*! 同步默认血压到手表*/
    FCBindSyncTypeDefaultBloodPressure = 6,
    /*! 同步手表系统设置到手机*/
    FCBindSyncTypeSystemSetting = 7,
    /*! 结束*/
    FCBindSyncTypeEnd = 8,
};

/**
 历史数据同步流程（部分同步功能是否执行由传感器标志决定
 */
typedef NS_ENUM(NSInteger, FCHistoryDataSyncType)
{
    /*! 默认类型*/
    FCHistoryDataSyncTypeUnknown = 0,
    /*! 同步时间制式*/
    FCHistoryDataSyncTypeFeatures = 1,
    /*! 同步系统时间*/
    FCHistoryDataSyncTypeTime = 2,
    /*! 同步各类型的日志数据（包括运动总步数、总距离、总卡路里等）*/
    FCHistoryDataSyncTypeTotalData = 3,
    /*! 同步运动量详细记录*/
    FCHistoryDataSyncTypeExercise = 4,
    /*! 同步睡眠详细记录*/
    FCHistoryDataSyncTypeSleep = 5,
    /*! 同步血氧详细记录*/
    FCHistoryDataSyncTypeBloodOxygen = 6,
    /*! 同步血压详细记录*/
    FCHistoryDataSyncTypeBloodPressure = 7,
    /*! 同步呼吸频率详细记录*/
    FCHistoryDataSyncTypeBreathingRate = 8,
    /*! 同步心率详细记录*/
    FCHistoryDataSyncTypeHeartRate = 9,
    /*! 同步紫外线详细记录*/
    FCHistoryDataSyncTypeUltraviolet = 10,
    /*! 同步睡眠总数据（包含七天以内的深睡眠和浅睡眠时长）*/
    FCHistoryDataSyncTypeSevenDaysSleepData = 11,
    /*! 结束*/
    FCHistoryDataSyncTypeEnd = 12,
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
    
    /*! 查找手表*/
    FCSyncTypeFindTheWatch = 4,
    
    /*! 获取闹钟列表*/
    FCSyncTypeGetAlarmList = 5,
    
    /*! 闹钟设置*/
    FCSyncTypeSetAlarmData = 6,
    
    /*! 电量和充电状态获取*/
    FCSyncTypeGetBatteryLevelAndState = 7,
    
    /*! 系统设置同步*/
    FCSyncTypeGetSystemSettings = 8,
    
    /*! 屏幕显示设置*/
    FCSyncTypeUpdateDisplaySettings = 9,
    
    /*! 功能开关设置*/
    FCSyncTypeUpdateFeaturesSettings = 10,
    
    /*! 通知开关设置*/
    FCSyncTypeUpdateNotificationSettings = 11,
    
    /*! 久坐提醒*/
    FCSyncTypeSetSedentaryReminder = 12,
    
    /*! 健康监测*/
    FCSyncTypeSetHealthMonitoring = 13,
    
    /*! 喝水提醒*/
    FCSyncTypeSetDrinkReminder = 14,
    
    /*! 佩戴方式*/
    FCSyncTypeSetWearingStyle = 15,
    
    /*! 相机状态设置*/
    FCSyncTypeSetCameraState = 16,
    
    /*! 默认血压设置*/
    FCSyncTypeSetDefaultBloodPressure = 17,
    
    /*! 天气更新*/
    FCSyncTypeUpdateWeather = 18,
    
    /*! 同步用户资料*/
    FCSyncTypeSetUserProfile = 19,
    
    /*! 历史数据同步*/
    FCSyncTypeGetHistoryData = 20,
    
    /*! 打开健康实时同步*/
    FCSyncTypeOpenRealtimeSync = 21,
    
    /*! 关闭健康实时同步*/
    FCSyncTypeCloseRealtimeSync = 22,
    
    /*! 请求固件升级*/
    FCSyncTypeFirmwareUpgrade = 23,
    
    /*! 获取固件版本*/
    FCSyncTypeGetFirmwareVersion = 24,
    
    /*! 发现手机回复*/
    FCSyncTypeFoundPhoneReplay = 25,
    
    /*! 获取手表mac地址*/
    FCSyncTypeGetMacAddress = 26,
    
    /*! 打开睡眠监测设定监测时间*/
    FCSyncTypeOpenSleepMonitoring = 27,
    
    /*! 关闭睡眠监测*/
    FCSyncTypeCloseSleepMonitoring = 28,
    
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
 同步响应结果
 */
typedef NS_ENUM(NSInteger, FCSyncResponseState) {

    /*! 未知类型*/
    FCSyncResponseStateUnKnown = 0,
    /*! 当前设备不支持蓝牙4.0*/
    KRSyncResponseStateUnsupported = 1,
    /*! 蓝牙未授权*/
    KRSyncResponseStateUnauthorized = 2,
    /*! 蓝牙重置状态*/
    KRSyncResponseStateResetting = 3,
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
    /*! 正在同步，蓝牙正在同步时发起同步操作会返回此结果*/
    KRSyncResponseStateSynchronizing = 9,
    /*! 同步响应成功*/
    FCSyncResponseStateSuccess = 10,
    /*! 同步响应失败*/
    FCSyncResponseStateError = 11,
    /*! 同步响应超时*/
    FCSyncResponseStateTimeOut = 12,
    /*! 健康实时同步超时*/
    FCSyncResponseStateRTTimeOut = 13,
    /*! 心电检测数据同步超时*/
    FCSyncResponseStateECGTimeOut = 14,
    /*! 低电量模式，固件升级时低电量提示*/
    FCSyncResponseStateLowPower = 15,
};


/**
 天气状态，你需要把自己获取的天气转换成以下状态同步到手表，手表才能显示正确的天气状态
 */
typedef NS_ENUM(NSInteger, FCWeatherState)
{
    /*! 未知天气*/
    FCWeatherStateUnknown = 0x00,
    /*! 晴天*/
    FCWeatherStateSunnyDay = 0x01,
    /*! 多云*/
    FCWeatherStateCloudy = 0x02,
    /*! 阴天*/
    FCWeatherStateOvercast = 0x03,
    /*! 阵雨*/
    FCWeatherStateShower = 0x04,
    /*! 雷阵雨、雷阵雨伴有冰雹*/
    FCWeatherStateThunderyShower = 0x05,
    /*! 小雨*/
    FCWeatherStateDrizzle = 0x06,
    /*! 中雨、大雨、暴雨*/
    FCWeatherStateHeavyRain = 0x07,
    /*! 雨夹雪、冻雨*/
    FCWeatherStateSleet = 0x08,
    /*! 小雪*/
    FCWeatherStateLightSnow = 0x09,
    /*! 大雪、暴雪*/
    FCWeatherStateHeavySnow = 0x0a,
    /*! 沙尘暴、浮尘*/
    FCWeatherStateSandstorm = 0x0b,
    /*! 雾、雾霾*/
    FCWeatherStateFogOrHaze = 0x0c,
};

#endif /* FCDefine_h */
