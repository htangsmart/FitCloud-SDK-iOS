//
//  FCObject.h
//  FitCloud
//
//  Created by 远征 马 on 2016/10/18.
//  Copyright © 2016年 远征 马. All rights reserved.
//



#import <Foundation/Foundation.h>

#pragma mark - FCAlarmCycleModel

/*!
 * @class FCAlarmCycleModel
 * @discussion The alarm clock cycle data model
 */

@interface FCAlarmCycleModel : NSObject
/*!
 * @property monday
 */
@property (nonatomic, assign) BOOL monday;
/*!
 * @property tuesday
 */
@property (nonatomic, assign) BOOL tuesday;
/*!
 * @property wednesday
 */
@property (nonatomic, assign) BOOL wednesday;
/*!
 * @property thursday
 */
@property (nonatomic, assign) BOOL thursday;
/*!
 * @property firday
 */
@property (nonatomic, assign) BOOL firday;
/*!
 * @property saturday
 */
@property (nonatomic, assign) BOOL saturday;
/*!
 * @property sunday
 */
@property (nonatomic, assign) BOOL sunday;

/*!
 * @brief instantiate an model with the given data
 * @param cycle The alarm clock cycle
 * @return  an alarm clock cycle model of <code>FCAlarmCycleModel</code> object
 */
+ (instancetype)modelWithCycle:(NSNumber*)cycle;

/*!
 * @brief The alarm clock cycle (7bits).From low to high indicates Monday to Sunday.All bits are 0, indicating that the day is valid
 * @return alarm clock cycle value
 */
- (NSNumber*)cycleValue;
@end



#pragma mark - FCAlarmModel

/*!
 * @class FCAlarmModel
 * @discussion The alarm clock data model
 */
@interface FCAlarmModel : NSObject
/*!
 * @property alarmId
 * @discussion The ID of the alarm clock
 */
@property (nonatomic, strong) NSNumber *alarmId;
/*!
 * @property year
 * @discussion The year of the alarm，The value of year is the current year minus 2000
 */
@property (nonatomic, strong) NSNumber *year;
/*!
 * @property month
 * @discussion The month of the alarm clock
 */
@property (nonatomic, strong) NSNumber *month;
/*!
 * @property day
 * @discussion The day of the alarm clock
 */
@property (nonatomic, strong) NSNumber *day;
/*!
 * @property hour
 * @discussion The hour of the alarm clock
 */
@property (nonatomic, strong) NSNumber *hour;
/*!
 * @property minute
 * @discussion The minute of the alarm clock
 */
@property (nonatomic, strong) NSNumber *minute;
/*!
 * @property isOn
 * @discussion The alarm switch status
 */
@property (nonatomic, assign) BOOL isOn;
/*!
 * @property cycle
 * @discussion The alarm clock cycle (7bits).From low to high indicates Monday to Sunday.All bits are 0, indicating that the day is valid
 */
@property (nonatomic, strong) NSNumber *cycle;

- (NSString*)workTime;
/*!
 * @brief Convert the alarm clock model to NSData
 * @return The converted data
 */
- (NSData*)alarmData;
@end


#pragma mark - FCDisplayModel
/*!
 * @class FCDisplayModel
 * @discussion A data model for the display settings of the watch screen
 */
@interface FCDisplayModel : NSObject
/*!
 * @property dateTime
 * @discussion The time and date
 */
@property (nonatomic, assign) BOOL dateTime;
/*!
 * @property stepCount
 * @discussion The number of steps in the day
 */
@property (nonatomic, assign) BOOL stepCount;
/*!
 * @property calorie
 * @discussion Total calories consumed on that day
 */
@property (nonatomic, assign) BOOL calorie;
/*!
 * @property distance
 * @discussion The total distance of the day
 */
@property (nonatomic, assign) BOOL distance;
/*!
 * @property sleep
 * @discussion The total sleep time of the day
 */
@property (nonatomic, assign) BOOL sleep;
/*!
 * @property heartRate
 * @discussion Total daily heart rate of the day
 */
@property (nonatomic, assign) BOOL heartRate;
/*!
 * @property bloodOxygen
 * @discussion The total blood oxygen of the day
 */
@property (nonatomic, assign) BOOL bloodOxygen;
/*!
 * @property bloodPressure
 * @discussion The total blood pressure of the day
 */
@property (nonatomic, assign) BOOL bloodPressure;
/*!
 * @property weatherForecast
 * @discussion the weather
 */
@property (nonatomic, assign) BOOL weatherForecast;
/*!
 * @property findPhone
 * @discussion Find the phone
 */
@property (nonatomic, assign) BOOL findPhone;
/*!
 * @property displayId
 * @discussion The ID of the watch
 */
@property (nonatomic, assign) BOOL displayId;
/*!
 * @brief instantiate an display model with the given data
 * @param data The alarm clock data
 * @return  an alarm clock model of <code>FCAlarmModel</code> object
 */
+ (instancetype)modelWithData:(NSData*)data;
/*!
 * @brief Convert the display model to NSData
 * @return The converted data
 */
- (NSData*)displayData;
@end


#pragma mark - FCNotificationModel
/*!
 * @class FCNotificationModel
 * @discussion The notification settings data model
 */
@interface FCNotificationModel : NSObject
@property (nonatomic, assign) BOOL callEnable;
@property (nonatomic, assign) BOOL smsEnable;
@property (nonatomic, assign) BOOL qqEnable;
@property (nonatomic, assign) BOOL weChatEnable;
@property (nonatomic, assign) BOOL facebookEnable;
@property (nonatomic, assign) BOOL twitterEnable;
@property (nonatomic, assign) BOOL linkedinEnable;
@property (nonatomic, assign) BOOL instagramEnable;
@property (nonatomic, assign) BOOL pinterestEnable;
@property (nonatomic, assign) BOOL whatsappEnable;
@property (nonatomic, assign) BOOL lineEnable;
@property (nonatomic, assign) BOOL fbMessageEnable;
@property (nonatomic, assign) BOOL otherAppEnable;
@property (nonatomic, assign) BOOL showMsgEnable;
@property (nonatomic, assign) BOOL disconnectPhoneEnable;
@property (nonatomic, assign) BOOL disconnectDeviceEnable;
@property (nonatomic, assign) BOOL heartRateEnable;
/*!
 * @brief instantiate an model with the given data
 * @param data The given data
 * @return  an model of <code>FCNotificationModel</code> object
 */
+ (instancetype)modelWithData:(NSData*)data;
/*!
 * @brief Convert the model to NSData
 * @return The converted data
 */
- (NSData*)nfSettingData;
@end

#pragma mark -  FCFunctionSwitchModel
/*!
 * @class FCFunctionSwitchModel
 * @discussion The functional switch data model
 */
@interface FCFunctionSwitchModel : NSObject
/*!
 * @property twLightScreen
 * @discussion The screen lights up after turning the wrist
 */
@property (nonatomic, assign) BOOL twLightScreen;
/*!
 * @brief instantiate an model with the given data
 * @param data The given data
 * @return  an model of <code>FCFunctionSwitchModel</code> object
 */
+ (instancetype)modelWithData:(NSData*)data;
/*!
 * @brief Convert the display model to NSData
 * @return The converted display data type of NSData
 */
- (NSData*)functionSwitchData;
@end


#pragma mark - FCLongSitModel
/*!
 * @class FCLongSitModel
 * @discussion The sedentary reminder data model
 */
@interface FCLongSitModel : NSObject
/*!
 * @property isOn
 * @discussion Sedentary reminder switch
 */
@property (nonatomic, assign) BOOL isOn;
/*!
 * @property isLunchBreakFree
 * @discussion Lump-free break switch
 */
@property (nonatomic, assign) BOOL isLunchBreakFree;
/*!
 * @property stMinute
 * @discussion The start time for the sedentary reminder. The value is the number of minutes from zero
 */
@property (nonatomic, assign) NSUInteger stMinute;
/*!
 * @property edMinute
 * @discussion TThe end time of the sedentary reminder. The value is the number of minutes from zero
 */
@property (nonatomic, assign) NSUInteger edMinute;

/*!
 * @brief instantiate an model with the given data
 * @param data The given data
 * @return  an model of <code>FCLongSitModel</code> object
 */
+ (instancetype)modelWithData:(NSData*)data;

/*!
 * @brief Convert the model to NSData
 * @return The converted data
 */
- (NSData*)longSitData;

/*!
 * @brief To determine whether the lunch break DND is available
 * @return The state of the switch without disturb
 */
- (BOOL)isLunchDNDEnable;
@end


#pragma mark - FCHealthMonitoringModel
/*!
 * @class FCRTHealthModel
 * @discussion The Health monitoringe monitoring data model
 */
@interface FCHealthMonitoringModel : NSObject
/*!
 * @property isOn
 * @discussion The state of health monitoring switch
 */
@property (nonatomic, assign) BOOL isOn;
/*!
 * @property stMinute
 * @discussion The start time for health monitoring. The value is the number of minutes from zero
 */
@property (nonatomic, assign) NSUInteger stMinute;
/*!
 * @property edMinute
 * @discussion The start time for health monitoring. The value is the number of minutes from zero
 */
@property (nonatomic, assign) NSUInteger edMinute;
/*!
 * @brief instantiate an model with the given data
 * @param data The given data
 * @return  an model of <code>FCHealthMonitoringModel</code> object
 */
+ (instancetype)modelWithData:(NSData*)data;
/*!
 * @brief Convert the model to NSData
 * @return The converted data
 */
- (NSData*)healthMonitoringData;
@end


#pragma mark - FCHardwareNumModel 
/*!
 * @class FCHardwareNumModel
 * @discussion The Hardware Number Data Model
 */
@interface FCHardwareNumModel : NSObject
/*!
 * @property heartRate
 */
@property (nonatomic, assign) BOOL heartRate;
/*!
 * @property ultraviolet
 */
@property (nonatomic, assign) BOOL ultraviolet;
/*!
 * @property weather
 */
@property (nonatomic, assign) BOOL weather;
/*!
 * @property bloodOxygen
 */
@property (nonatomic, assign) BOOL bloodOxygen;
/*!
 * @property bloodPressure
 */
@property (nonatomic, assign) BOOL bloodPressure;
/*!
 * @property breathingRate
 */
@property (nonatomic, assign) BOOL breathingRate;
/*!
 * @brief instantiate an model with the given data
 * @param data The given data
 * @return  an model of <code>FCHardwareNumModel</code> object
 */
+ (instancetype)modelWithData:(NSData*)data;
@end

#pragma mark - FCExerciseModel
/*!
 * @class FCExerciseModel
 * @discussion The sports data model
 */
@interface FCExerciseModel : NSObject
/*!
 * @property year
 * @discussion The value of year is the current year minus 2000
 */
@property (nonatomic, strong) NSNumber *year;
/*!
 * @property month
 */
@property (nonatomic, strong) NSNumber *month;
/*!
 * @property day
 */
@property (nonatomic, strong) NSNumber *day;
/*!
 * @property minutes
 * @discussion The number of minutes from zero
 */
@property (nonatomic, strong) NSNumber *minutes;
/*!
 * @property stepCount
 */
@property (nonatomic, strong) NSNumber *stepCount;
@end



#pragma mark - FCSleepModel
/*!
 * @class FCSleepModel
 * @discussion The sleep data model
 */
@interface FCSleepModel : NSObject
/*!
 * @property year
 * @discussion The value of year is the current year minus 2000
 */
@property (nonatomic, strong) NSNumber *year;
/*!
 * @property month
 */
@property (nonatomic, strong) NSNumber *month;
/*!
 * @property day
 */
@property (nonatomic, strong) NSNumber *day;
/*!
 * @property minutes
 * @discussion The number of minutes from zero
 */
@property (nonatomic, strong) NSNumber *minutes;
/*!
 * @property sleep
 */
@property (nonatomic, strong) NSNumber *sleep;
@end


#pragma mark - FCHealthModel
/*!
 * @class FCHealthModel
 * @discussion The health data model
 */
@interface FCHealthModel : NSObject
/*!
 * @property year
 * @discussion The value of year is the current year minus 2000
 */
@property (nonatomic, strong) NSNumber *year;
/*!
 * @property month
 */
@property (nonatomic, strong) NSNumber *month;
/*!
 * @property day
 */
@property (nonatomic, strong) NSNumber *day;
/*!
 * @property minutes
 * @discussion The number of minutes from zero
 */
@property (nonatomic, strong) NSNumber *minutes;
/*!
 * @property heartRate
 */
@property (nonatomic, strong) NSNumber *heartRate; 
@end
