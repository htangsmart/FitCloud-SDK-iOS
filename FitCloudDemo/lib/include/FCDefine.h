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
    
    /*! Default Blood Pressure*/
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
    
    /*! Get the MAC address of the watch*/
    FCSyncTypeGetMacAddress = 52,
    
    /*! Gets the current day's total data*/
    FCSyncTypeDailyTotalData = 53,
    
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
