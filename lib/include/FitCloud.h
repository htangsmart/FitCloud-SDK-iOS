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


/*!
 * @class FitCloud
 * @classdesign Singleton mode
 * @since iOS8.0
 */

@interface FitCloud : NSObject
/*!
 *  @property centralManager
 *  @discussion Entry point to the central role. Commands should only be issued when its state is <code>CBCentralManagerStatePoweredOn</code>.
 */
@property (nonatomic, strong) CBCentralManager *centralManager;

/*!
 *  @property servicePeripheral
 *  @discussion Represents a peripheral.
 */
@property (nonatomic, strong) CBPeripheral *servicePeripheral;

/*!
 * @property syncType
 * @discussion The current synchronization type
 */
@property (nonatomic, assign, readonly) FCSyncType syncType;

/*!
 * @property isSynchronizing
 * @discussion Synchronization status，Indicates whether the current device is synchronized
 */
@property (nonatomic, assign, readonly) BOOL isSynchronizing;

/*!
 * @property findMobilePhoneBlock
 * @discussion This block will be called back after the phone receives an instruction from the hand ring
 */
@property (nonatomic, copy) dispatch_block_t findMobilePhoneBlock;

/*!
 * @property takePicturesBlock
 * @discussion This block will be called back after the phone receives a shot command from the bracelet
 */
@property (nonatomic, copy) dispatch_block_t takePicturesBlock;

/*!
 * @property age
 * @discussion User age, the default was born in 1990
 */
@property (nonatomic, assign) UInt32 age;
/*!
 * @property sex
 * @discussion The user's gender, the default is female 0
 */
@property (nonatomic, assign) UInt32 sex;
/*!
 * @property height
 * @discussion User's height in cm,The default height of women is 165cm, men are 175cm
 */
@property (nonatomic, assign) UInt32 height;
/*!
 * @property weight
 * @discussion The user's weight in kg
 */
@property (nonatomic, assign) UInt32 weight;

+ (instancetype)shared;


#pragma mark - 扫描与连接

/**
 * @method scanningPeripherals:
 * @brief Scans Bluetooth peripherals
 * @discussion Scans Bluetooth peripherals,Returns a peripheral that is currently being scanned and A list of <code>CBPeripheral</code> objects.
 * @param retHandler Scan result callback block
 */
- (void)scanningPeripherals:(FCDeviceListHandler)retHandler;


/*!
 * @brief Scans a peripheral that contains a uuid string
 * @param uuidString The uuid string of a peripheral
 * @param retHandler Scan result callback block
 */
- (void)scanningPeripheralWithUUID:(NSString *)uuidString retHandler:(FCPeripheralHandler)retHandler;


/*!
 * @brief Stop scanning the peripherals
 */
- (void)stopScanning;


/*!
 * @brief The result of the connection
 * @return Whether the peripheral has been connected
 */
- (BOOL)isConnected;

/*!
 * @brief Connect a peripheral
 * @param peripheral A peripheral to connect to
 * @return Whether the peripheral in connection mode
 */
- (BOOL)connectPeripheral:(CBPeripheral*)peripheral;


/*!
 * @brief Disconnect the peripheral
 * @param peripheral A peripheral to be disconnected
 * @return Whether the peripheral in disconnected mode
 */
- (BOOL)disconnectPeripheral:(CBPeripheral*)peripheral;

/*!
 * @brief Disconnect the current peripheral
 * @return Whether the current peripheral in disconnected mode
 */
- (BOOL)disconnect;


#pragma mark - 控制监听

/*!
 * @discussion Find the watch，The watch starts to vibrate when it receives a command from the app
 * @param retHandler Synchronous result callback
 */
- (void)fcFindWristband:(FCSyncResultHandler)retHandler;

/*!
 * @discussion When the phone received a command issued by the watch,it needs to send a reply to the watch.
 * @param retHandler Synchronous result callback
 */
- (void)fcFoundMyCellPhone:(FCSyncResultHandler)retHandler;



#pragma mark - 手表登录、绑定或解绑操作
/*!
 * @method bondDevice:dataHandler:retHandler:
 * @brief Bond the device
 * @param paramsHandler The block parameter is used to set user information。
 * @param dataHandler   The system setting data callback block
 * @param retHandler    Synchronous result callback
 */
- (void)bondDevice:(FCBoundDataHandler)paramsHandler dataHandler:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method loginDevice:retHandler:
 * @brief Login the device
 * @param paramHandler The block parameter is used to set user information
 * @param retHandler   Synchronous result callback
 */
- (void)loginDevice:(FCLoginDatahandler)paramHandler retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Unbind the watch
 * @param retHandler Synchronous result callback
 */
- (void)unBondDevice:(FCSyncResultHandler)retHandler;



#pragma mark - 闹钟同步
/*!
 * @brief Set alarm clock data
 * @param data       Alarm clock data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetAlarmData:(NSData*)data retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Get the list of alarms
 * @param dataHandler Alarm list data callback
 * @param retHandler  Synchronous result callback
 */
- (void)fcGetAlarmList:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;


#pragma mark - 功能设置

/*!
 * @brief Get the MAC address of the watch
 * @param dataHandler MAC address data callback block
 * @param retHandler Synchronous result callback block
 */
- (void)fcGetMacAddress:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Gets the system settings
 * @param dataHandler The system setting data callback
 * @param retHandler Synchronous result callback
 */
- (void)fcGetSystemSetting:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Get power and charge status
 * @param dataHandler  Power and charge state callback
 * @param retHandler   Synchronous result callback
 */
- (void)fcGetBatteryPowerAndChargingState:(FCSyncPowerAndChargingStateHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the screen display items
 * @param data       The screen display data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetDisplayData:(NSData*)data retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the watch function switch
 * @param data       Function switch data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetFunctionSwitchData:(NSData*)data retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @brief Set the notification switch
 * @param data       Notification switch data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetNotificationSettingData:(NSData*)data retHandler:(FCSyncResultHandler)retHandler;


/**
 * @brief Set up sedentary reminders
 * @param data       Sedentary reminder data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetLongSitData:(NSData*)data retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the health of real-time monitoring
 * @param data       Health real-time monitoring data
 * @param retHandler Synchronous result callback
 */
- (void)fcSetHealthMonitorData:(NSData*)data retHandler:(FCSyncResultHandler)retHandler;



/*!
 * @brief Set reminders to drink water
 * @param bEnabled   Reminder to drink water switch status
 * @param retHandler Synchronous result callback
 */
- (void)fcSetDrinkRemindEnable:(BOOL)bEnabled retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the wearing style

 @param bEnabled   Left hand wear
 @param retHandler Synchronous result callback
 */
- (void)fcSetLeftHandWearEnable:(BOOL)bEnabled retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @brief Set the camera status
 * @param bInForeground in the foreground
 * @param retHandler    Synchronous result callback
 */
- (void)fcSetCameraState:(BOOL)bInForeground retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method fcSetUserProfile:age:height:weight:retHandler:
 * @brief Set the user profile
 * @param sex        sex 
 * @param age        age
 * @param height     height
 * @param weight     weight
 * @param retHandler Synchronous result callback
 */
- (void)fcSetUserProfile:(UInt32)sex
                     age:(UInt32)age
                  height:(UInt32)height
                  weight:(UInt32)weight
              retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method fcSetBloodPressure:dbp:retHandler:
 * @brief Set the default blood pressure
 * @param sbp        Systolic blood pressure
 * @param dbp        Diastolic blood pressure
 * @param retHandler Synchronous result callback
 */
- (void)fcSetBloodPressure:(UInt16)sbp dbp:(UInt16)dbp retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method fcSetWeather:highTemp:lowTemp:state:cityName:retHandler:
 * @brief Set up the latest weather
 * @param temperature Current temperature
 * @param hTemp       Maximum temperature
 * @param lTemp       lowest temperature
 * @param state       Weather conditions
 * @param cityName    City name
 * @param retHandler  Synchronous result callback
 */
- (void)fcSetWeather:(int)temperature
            highTemp:(int)hTemp
             lowTemp:(int)lTemp
               state:(int)state
            cityName:(NSString*)cityName
          retHandler:(FCSyncResultHandler)retHandler;


#pragma mark - 健康实时同步

/*!
 * @method fcOpenRealTimeSync:dataHandler:retHandler:
 * @brief Turn on Healthy real-time synchronization
 * @param syncType    Real-time synchronization type
 * @param dataHandler Health real-time synchronization data callback
 * @param retHandler  Synchronous result callback
 */
- (void)fcOpenRealTimeSync:(FCRTSyncType)syncType dataHandler:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;


/*!
 * @method fcCloseRealTimeSync:
 * @brief Turn off healthy real-time synchronization
 * @param retHandler Synchronous result callback
 */
- (void)fcCloseRealTimeSync:(FCSyncResultHandler)retHandler;


#pragma mark - 历史数据同步

/*!
 * @method fcGetHistoryData:dataHandler:retHandler:
 * @brief Synchronize historical data
 * @discussion Synchronize historical data，including the total data for the day,exercise, sleep, heart rate, blood oxygen, blood pressure and respiratory rate.
 * @param syncStepHandler This block shows you which step to synchronizes，
 * @param dataHandler     It returns a type of data that is synchronized,This Block is called multiple times.
 * @param retHandler  It will be called when synchronization is completed or an error occurs.
 */
- (void)fcGetHistoryData:(FCSyncStepHandler)syncStepHandler dataHandler:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;


#pragma mark - 固件升级

/*!
 * @method fcGetFirmwareVersion:retHandler:
 * @discussion Get the firmware version information
 * @param dataHandler Firmware Version Data Callback
 * @param retHandler Synchronous result callback
 */
- (void)fcGetFirmwareVersion:(FCSyncDataHandler)dataHandler retHandler:(FCSyncResultHandler)retHandler;

/*!
 * @method fcUpdateFirmwareWithPath:progress:retHandler:
 * @brief Firmware upgrade
 * @discussion Firmware upgrade interface, when calling this API peripherals will be disconnected and enter the firmware upgrade mode
 * @param filePath Firmware path
 * @param progressHandler Upgrade progress callback
 * @param retHandler Upgrade result callback
 */
- (void)fcUpdateFirmwareWithPath:(NSString*)filePath progress:(FCProgressHandler)progressHandler retHandler:(FCSyncResultHandler)retHandler;
@end

