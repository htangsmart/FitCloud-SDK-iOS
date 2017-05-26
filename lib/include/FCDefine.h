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
 * @enum FCDataType
 * @discussion  同步数据的类型，用于区分FCDataModel所属的数据
 */
typedef NS_ENUM(NSInteger, FCDataType)
{
    /*!  默认未知类型*/
    FCDataTypeUnknown,
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
};



/*!
 * @enum FCLoginSyncType
 * @discussion 登录设备同步流程
 */
typedef NS_ENUM(NSInteger, FCLoginSyncType)
{
    /*! 默认类型*/
    FCLoginSyncTypeUnknown = 0,
    /*! 登录设备*/
    FCLoginSyncTypeLogin = 1,
    /*! 同步系统时间*/
    FCLoginSyncTypeTime = 2,
    /*! 时间制式，根据系统制式类型来判断是采用12小时制还是24小时制*/
    FCLoginSyncTypeHourSystem = 3,
    /*! 结束*/
    FCLoginSyncTypeEnd = 4,
};



/*!
 * @enum FCBondSyncType
 * @discussion 绑定设备同步流程
 */
typedef NS_ENUM(NSInteger, FCBindSyncType)
{
    /*! 默认类型*/
    FCBindSyncTypeUnknown = 0,
    /*! 绑定设备*/
    FCBindSyncTypeBond = 1,
    /*! 同步系统时间到手表*/
    FCBindSyncTypeTime = 2,
    /*! 同步用户资料到手表*/
    FCBindSyncTypeUserInfo = 3,
    /*! 同步佩戴方式到手表*/
    FCBindSyncTypeWearingStyle = 4,
    /*! 同步默认血压到手表*/
    FCBindSyncTypeDefaultBloodPressure = 5,
    /*! 同步手表系统设置*/
    FCBindSyncTypeSystemSetting = 6,
    /*! 结束*/
    FCBindSyncTypeEnd = 7,
};



/*!
 * @enum FCHistoryDataSyncType
 * @discussion 历史数据同步流程（部分同步功能是否执行由传感器标志决定）
 */
typedef NS_ENUM(NSInteger, FCHistoryDataSyncType)
{
    /*! 默认类型*/
    FCHistoryDataSyncTypeUnknown = 0,
    /*! 同步系统时间*/
    FCHistoryDataSyncTypeTime = 1,
    /*! 同步各类型的日志数据（包括运动总步数、总距离、总卡路里等）*/
    FCHistoryDataSyncTypeTotalData = 2,
    /*! 同步运动量详细记录*/
    FCHistoryDataSyncTypeExercise = 3,
    /*! 同步睡眠详细记录*/
    FCHistoryDataSyncTypeSleep = 4,
    /*! 同步血氧详细记录*/
    FCHistoryDataSyncTypeBloodOxygen = 5,
    /*! 同步血压详细记录*/
    FCHistoryDataSyncTypeBloodPressure = 6,
    /*! 同步呼吸频率详细记录*/
    FCHistoryDataSyncTypeBreathingRate = 7,
    /*! 同步心率详细记录*/
    FCHistoryDataSyncTypeHeartRate = 8,
    /*! 同步紫外线详细记录*/
    FCHistoryDataSyncTypeUltraviolet = 9,
    /*! 同步睡眠总数据（包含七天以内的深睡眠和浅睡眠时长）*/
    FCHistoryDataSyncTypeTotalSleep = 10,
    /*! 结束*/
    FCHistoryDataSyncTypeEnd = 11,
};



/*!
 * @enum FCSyncType
 * @discussion 手环数据同步标志
 */
typedef NS_ENUM(NSInteger, FCSyncType) {
    
    /*! 默认类型*/
    FCSyncTypeUnknown = 0,
    
    /*! 解绑设备*/
    FCSyncTypeUnBindDevice = 18,
    
    /*! 登录设备*/
    FCSyncTypeLoginDevice = 19,
    
    /*! 绑定设备*/
    FCSyncTypeBindDevice = 20,
    
    /*! Find the watch*/
    FCSyncTypeFindTheWatch = 23,
    
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
    FCSyncTypeFeaturesSettings = 29,
    
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
    
    /*! Default Blood Pressure*/
    FCSyncTypeDefaultBloodPressure = 36,
    
    /*! Weather settings*/
    FCSyncTypeUpdateWeather = 37,
    
    /*! Set the user profile*/
    FCSyncTypeUserProfile = 38,
    
    /*! Historical data synchronization*/
    FCSyncTypeHistoryData = 39,
    
    /*! Turns on real-time health sync*/
    FCSyncTypeOpenRealtimeSync = 47,
    
    /*! Turn off health real-time synchronization*/
    FCSyncTypeCloseRealtimeSync = 48,
    
    /*! Firmware upgrade*/
    FCSyncTypeFirmwareUpgrade = 49,
    
    /*! Firmware version*/
    FCSyncTypeFirmwareVersion = 50,
    
    /*! Found my cell phone.*/
    FCSyncTypeFoundPhoneReplay = 51,
    
    /*! Get the MAC address of the watch*/
    FCSyncTypeGetMacAddress = 52,
    
    /*! 打开睡眠监测设定监测时间*/
    FCSyncTypeOpenSleepMonitoring = 54,
    
    /*! 关闭睡眠监测*/
    FCSyncTypeCloseSleepMonitoring = 55,
    
    /*! 日总睡眠数据*/
    FCSyncTypeTotalSleepData = 56,
    
    /*! 历史数据同步同步七天睡眠日总数据*/
    FCSyncTypeHistoryTotalSleepData = 57,
    
    /*! Finished*/
    FCSyncTypeEnd = 100,
};


/*!
 * @enum FCRTSyncType
 * @discussion The type of operation for real-time detection of health
 */
typedef NS_ENUM(NSInteger, FCRTSyncType)
{
    /*! The default type*/
    FCRTSyncTypeNone = 0,
    
    /*! Real time measurement of heart rate*/
    FCRTSyncTypeHeartRate,
    
    /*! Real time measurement of blood oxygen*/
    FCRTSyncTypeBloodOxygen,
    
    /*! Real time measurement of blood pressure*/
    FCRTSyncTypeBloodPressure,
    
    /*! Real time measurement of respiratory rate*/
    FCRTSyncTypeBreathingRate,
};

/*!
 * @enum FCSyncResponseState
 * @discussion  synchronization response status
 */
typedef NS_ENUM(NSInteger, FCSyncResponseState) {

    /*! The default type*/
    FCSyncResponseStateNone = 0,
    
    /*! 蓝牙未打开*/
    FCSyncResponseStatePowerOff = 1,
    
    /*! Bluetooth is not connected*/
    FCSyncResponseStateNotConnected = 2,
    
    /*! 蓝牙关闭，主动关闭蓝牙时回调*/
    FCSyncResponseStateTurnedOff = 3,
    
    /*! 蓝牙断开连接，主动或者被动断开都会调用*/
    FCSyncResponseStateDisconnect = 4,
    
    /*! 同步参数错误*/
    FCSyncResponseStateParameterError = 5,
    
    /*! Synchronizing data*/
    FCSyncResponseStateSyncing = 6,
    
    /*! Synchronization succeeded*/
    FCSyncResponseStateSuccess = 7,
    
    /*! Synchronization failed*/
    FCSyncResponseStateError = 8,
    
    /*! Synchronization timeout*/
    FCSyncResponseStateTimeOut = 9,
    
    /*! Healthy real-time synchronization timeout*/
    FCSyncResponseStateRTTimeOut = 10,
    
    /*! Power is too low to upgrade*/
    FCSyncResponseStateLowPower = 11,
};



/*!
 * @enum FCWeatherState
 * @discussion  天气状态，你需要把自己获取的天气转换成以下状态同步到手表，手表才能显示正确的天气状态
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
