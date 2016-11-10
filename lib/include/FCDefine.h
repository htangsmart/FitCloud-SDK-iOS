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
    
    /* Gets the current day's total data*/
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

#endif /* FCDefine_h */
