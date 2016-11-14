//
//  FitCloudBlock.h
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FCDefine.h"


#ifndef FitCloudBlock_h
#define FitCloudBlock_h


/*!
 * @discussion Detailed records of health data,The current data is generated from the heart rate data simulation.

 @param heartRateArray a list of <i>FCHeathModel</i> objects,The property <i>heartRate</i> will be assigned
 @param bloodOxygenArray a list of <i>FCHeathModel</i> objects,The property <i>bloodOxygen</i> will be assigned
 @param bloodPressureArray a list of <i>FCHeathModel</i> objects,The property <i>systolicBloodPressure</i> and <i>diastolicBloodPressure</i> will be assigned
 @param breathingRateArray a list of <i>FCHeathModel</i> objects,The property <i>breathingRate</i> will be assigned
 */
typedef void (^FCHealthDataModelBlock)(NSArray *heartRateArray,NSArray *bloodOxygenArray,NSArray *bloodPressureArray,NSArray *breathingRateArray);


/*!
 * @discussion Day total data, including the total number of steps, total distance, total calories, deep sleep duration, light sleep duration, average heart rate
 @param steps           Total number of steps
 @param distance        Total distance
 @param calorie         Total calories
 @param deepSleep       Deep sleep duration
 @param lightSleep      Light sleep duration
 @param avgHeartRate    Average heart rate
 */
typedef void (^FCDayTotalDataBlock)(UInt32 steps, UInt32 distance, UInt32 calorie, UInt32 deepSleep, UInt32 lightSleep, UInt32 avgHeartRate);

/*!
 *  @discussion System Setting Information Callback Block
 *
 *  @param notificationData    Notification switch (4byte)
 *  @param screenDisplayData  Screen display settings data (2byte)
 *  @param functionalSwitchData Function switch setting data (2byte)
 *  @param hsVersionData  Hardware and software version information data (32byte)
 *  @param healthHistorymonitorData  Health history monitoring data (5byte)
 *  @param longSitData  Sedentary reminder data (5byte)
 *  @param bloodPressureData       Default blood pressure data (2byte)
 *  @param drinkWaterReminderData    Drinking water reminder settings data (1byte)
 */
typedef void (^FCSystemSettingDataBlock)(NSData *notificationData, NSData *screenDisplayData,NSData *functionalSwitchData,NSData *hsVersionData,NSData *healthHistorymonitorData,NSData *longSitData,NSData *bloodPressureData,NSData *drinkWaterReminderData);

/*!
 *  @discussion  Hardware and software version information string callback Block
 *
 *  @param projNum     Project number (6byte)
 *  @param hardware    Hardware number (4byte)
 *  @param sdkVersion      Sdk version number (4byte)
 *  @param patchVerson    Software patch version number (6byte)
 *  @param falshVersion    The version number of the flash (4byte)
 *  @param appVersion   Firmware app version number (4byte)
 *  @param serialNum      Serial number (4byte)
 */

typedef void (^FCHardwareAndSoftwareVersionStringBlock)(NSString *projNum,NSString *hardware,NSString *sdkVersion,NSString *patchVerson,NSString *falshVersion,NSString *appVersion,NSString *serialNum);


/**
 *  @discussion Hardware and software version information callback block
 *
 *  @param projData     Project number (6byte)
 *  @param hardwareData Hardware number (4byte)
 *  @param sdkData      Sdk version number (4byte)
 *  @param patchData    Software patch version number (6byte)
 *  @param flashData    The version number of the flash (4byte)
 *  @param appVersionData   Firmware app version number (4byte)
 *  @param seqData      Serial number (4byte)
 */
typedef void (^FCHardwareAndSoftwareVersionDataBlock)(NSData *projData,NSData *hardwareData,NSData *sdkData,NSData *patchData,NSData *flashData,NSData *appVersionData,NSData *seqData);


/*!
 * @discussion A block is used for the progress callback
 * @param progress Progress value,a floating point number between 0 and 1
 */
typedef void (^FCProgressHandler)(CGFloat progress);


/*!
 * @brief A block is used for the Bluetooth peripheral scan callback
 * @param aPeripheral A peripheral to be scanned
 */
typedef void (^FCPeripheralHandler)(CBPeripheral *aPeripheral);


/*!
 * @discussion A block is used to call back all the peripherals scanned,This block will be called when a new peripheral is scanned
 * @param retArray    A list of <i>CBPeripheral</i> objects
 * @param aPeripheral A peripheral to be scanned
 */
typedef void (^FCDeviceListHandler)(NSArray<CBPeripheral*>*retArray,CBPeripheral *aPeripheral);


/*!
 * @discussion A Block is used to log in and bind the watch to set the user ID and phone information
 * @param guestId     The user's unique id
 * @param phoneModel  Phone models, such as iPhone5s
 * @param OS          The operating system version of the phone
 */
typedef void (^FCAuthDataHandler)(UInt64 guestId, UInt8 phoneModel, UInt8 OS);


/*!
 * @discussion Login to set the parameter block
 * @param authDataHandler A block is used to set the device login information
 */
typedef void (^FCLoginDatahandler)(FCAuthDataHandler authDataHandler);


/*!
 * @discussion This block is used to set up user information, including user gender, age, height and weight.
 * @param sex    User gender
 * @param age    User age
 * @param weight User Weight
 * @param height User height
 */
typedef void (^FCUserDataHandler)(UInt32 sex, UInt32 age, UInt32 weight, UInt32 height);


/*!
 * @discussion A block is used to set the wear mode
 * @param lefthHand Whether it is left-handed
 */
typedef void (^FCWearStyleHandler)(BOOL lefthHand);


/*!
 * @discussion This block is used to set the binding parameters, user information, and wear mode
 * @param authDataHandler  Set hardware binding information
 * @param userDataHandler  Set user information
 * @param wearStyleHandler Set the way to wear
 */
typedef void (^FCBoundDataHandler)(FCAuthDataHandler authDataHandler,FCUserDataHandler userDataHandler,FCWearStyleHandler wearStyleHandler);


/*!
 * @discussion  When the synchronization is complete, this block returns the current synchronization type and the status of the synchronization response. If the status is <i>FCSyncResponseStateSuccess</i>, it means that the operation is complete.
 * @param syncType Synchronization type
 * @param state    The status of the synchronization response
 * @see FCSyncType
 * @see FCSyncResponseState
 */
typedef void (^FCSyncResultHandler)(FCSyncType syncType, FCSyncResponseState state);


/*!
 * @discussion This block returns the type that is currently being synchronized
 * @param syncType Synchronization type
 * @see FCSyncType
 */
typedef void (^FCSyncStepHandler)(FCSyncType syncType);


/*!
 * @discussion This block returns the currently synchronized data and synchronization type. If there is no data, it will not be called
 * @param syncType Synchronization type
 * @param data     Synchronized data
 * @see FCSyncType
 */
typedef void (^FCSyncDataHandler)(FCSyncType syncType, NSData *data);


/*!
 * @discussion This block returns the number of records currently synchronized.
 * @param count The number of records that have been synchronized
 */
typedef void (^FCSyncCountHandler) (UInt16 count);


/*!
 * @discussion This block returns the real-time health data that is currently being synchronized.
 * @param data  Real-time health data
 */
typedef void (^FCRTSyncDataHandler)(NSData *data);


/*!
 * @discussion This block returns the percentage of battery power and the charge status of the watch.
 * @param powerValue    The percentage of battery power
 * @param chargingState The charge status of the watch
 */
typedef void (^FCSyncPowerAndChargingStateHandler)(UInt8 powerValue, UInt8 chargingState);

#endif /* FitCloudBlock_h */
