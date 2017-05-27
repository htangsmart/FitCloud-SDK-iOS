//
//  FCObject.h
//  FitCloud
//
//  Created by 远征 马 on 2016/10/18.
//  Copyright © 2016年 远征 马. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "FCDefine.h"


@protocol FCObjectProtocal <NSObject>

@optional
/**
 @discussion 使用<i>data</i>初始化对象
 @param data data
 @return 对象模型
 */
+ (instancetype)objectWithData:(NSData*)data;

/**
 @discussion 使用<i>value</i>初始化数据
 @param value value
 @return 对象模型
 */
+ (instancetype)objectWithValue:(NSNumber*)value;

/**
 @discussion 遵循蓝牙协议的二进制数据,可用于蓝牙通讯写入数据
 @return <code>NSData</code>二进制数据
 */
- (NSData*)writeBytes;
@end




#pragma mark - FCUserObject

@interface FCUserObject : NSObject <FCObjectProtocal>
@property (nonatomic, assign) UInt64 guestId;
/*!
 @discussion 手机型号,如iphone6、iphone6s
 @property phoneModel
 */
@property (nonatomic, assign) UInt8 phoneModel;
@property (nonatomic, assign) UInt8 osVersion;

/*!
 @discussion 用户年龄，默认1990出生
 */
@property (nonatomic, assign) UInt32 age;

/*!
 @discussion 性别。默认为女性 0
 */
@property (nonatomic, assign) UInt32 sex;
@property (nonatomic, assign) UInt32 weight;

/**
 @discussion 用户身高，女性默认 165cm, 男性默认 175cm
 @property height
 */
@property (nonatomic, assign) UInt32 height;
@property (nonatomic, assign) UInt16 systolicBP;
@property (nonatomic, assign) UInt16 diastolicBP;
@property (nonatomic, assign) BOOL isLeftHandWearEnabled;

- (NSData*)writeDataOfLoginOrBind;
- (NSData*)writeDataOfUserProfile;
@end




#pragma mark - FCWeather

@interface FCWeather : NSObject <FCObjectProtocal>
@property (nonatomic, assign) NSInteger temperature;
@property (nonatomic, assign) NSInteger maxTemperature;
@property (nonatomic, assign) NSInteger minTemperature;
@property (nonatomic, assign) FCWeatherState weatherState;
@property (nonatomic, strong) NSString *city;
@end



#pragma mark - FCCycleOfAlarmClockObject

/*!
 * @class FCCycleOfAlarmClockObject
 * @discussion 闹钟周期, 如果周一到周日无设置，则表示闹钟当日有效
 */
@interface FCCycleOfAlarmClockObject : NSObject
@property (nonatomic, assign) BOOL monday;
@property (nonatomic, assign) BOOL tuesday;
@property (nonatomic, assign) BOOL wednesday;
@property (nonatomic, assign) BOOL thursday;
@property (nonatomic, assign) BOOL firday;
@property (nonatomic, assign) BOOL saturday;
@property (nonatomic, assign) BOOL sunday;

/*!
 * @discussion 通过闹钟周期<i>cycleValue</i>初始化<code>FCCycleOfAlarmClockObject</code>对象
 * @param cycleValue 闹钟周期数值
 * @return   <code>FCCycleOfAlarmClockObject</code> 实例对象
 */
+ (instancetype)cycleWithValue:(NSNumber*)cycleValue;

/*!
 * @discussion 获取闹钟周期数值（7 bits），从低位到高位表示周一到周日；如果所有字节为0，则表示闹钟当日有效。
 * @return 闹钟周期数值
 */
- (NSNumber*)cycleValue;
@end




#pragma mark - FCAlarmClockObject

@interface FCAlarmClockObject : NSObject <FCObjectProtocal>
@property (nonatomic, strong) NSNumber *alarmId;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *hour;
@property (nonatomic, strong) NSNumber *minute;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) NSNumber *cycle;
@property (nonatomic, strong) FCCycleOfAlarmClockObject *cycleObject;

/*!
 @discussion 响铃时间
 @return 响铃时间字符串 格式："HH: mm"
 */
- (NSString*)ringTime;
@end


#pragma mark - FCNotificationObject
/*!
 * @class FCNotificationModel
 * @discussion The notification settings data model
 */
@interface FCNotificationObject : NSObject <FCObjectProtocal>
/*!
 * @property incomingCall
 * @discussion 手机有新来电时手表会通知用户
 */
@property (nonatomic, assign) BOOL incomingCall;
/*!
 * @property smsAlert
 * @discussion 手机有新短信时手表会通知用户
 */
@property (nonatomic, assign) BOOL smsAlerts;
@property (nonatomic, assign) BOOL qqMessage;
@property (nonatomic, assign) BOOL wechatMessage;
@property (nonatomic, assign) BOOL facebook;
@property (nonatomic, assign) BOOL twitter;
@property (nonatomic, assign) BOOL linkedin;
@property (nonatomic, assign) BOOL instagram;
@property (nonatomic, assign) BOOL pinterest;
@property (nonatomic, assign) BOOL whatsapp;
@property (nonatomic, assign) BOOL line;
@property (nonatomic, assign) BOOL facebookMessage;
/*!
 * @property otherApp
 * @discussion 打开此项，其他app来消息时，手表会及时通知用户
 */
@property (nonatomic, assign) BOOL otherApp;
/*!
 * @property messageDisplayEnable
 * @discussion 消息内容是否在手表屏幕上显示，打开此项短消息内容会即时显示在手表屏幕上
 */
@property (nonatomic, assign) BOOL messageDisplayEnabled;
/*!
 * @property bleDisconnectAlerts
 * @discussion 蓝牙断开提醒，当手表和手机断开连接，手机app会及时提醒用户
 */
@property (nonatomic, assign) BOOL bleDisconnectAlerts;
/*!
 * @property deviceDisconnectAlerts
 * @discussion 手表断开提醒，当手表和手机断开连接，手表会震动提醒
 */
@property (nonatomic, assign) BOOL deviceDisconnectAlerts;
/*!
 * @property heartRateMonitoringEnable
 * @discussion 心率实时监测，打开此开关，手表会持续采集用户心率数据
 */
@property (nonatomic, assign) BOOL heartRateMonitoringEnabled;
@end


#pragma mark - FCWatchScreenDisplayObject

/**
 @discussion 手表屏幕显示设置，屏幕显示设置项需要先根据传感器标志来判断，如果传感器标志功能不存在，则屏幕设置项需要设置为无效
 @class FCWatchScreenDisplayObject
 */
@interface FCWatchScreenDisplayObject : NSObject <FCObjectProtocal>
@property (nonatomic, assign) BOOL dateTime;
@property (nonatomic, assign) BOOL stepCount;
@property (nonatomic, assign) BOOL calorie;
@property (nonatomic, assign) BOOL distance;
@property (nonatomic, assign) BOOL sleep;
@property (nonatomic, assign) BOOL heartRate;
@property (nonatomic, assign) BOOL bloodOxygen;
@property (nonatomic, assign) BOOL bloodPressure;
@property (nonatomic, assign) BOOL weatherForecast;
@property (nonatomic, assign) BOOL findPhone;
@property (nonatomic, assign) BOOL displayId;
@end



#pragma mark - FCFeaturesObject

/*!
 @discussion 手表功能开关设置对象
 @class FCFeaturesObject
 */
@interface FCFeaturesObject : NSObject <FCObjectProtocal>

/*!
 @discussion 反动手腕时点亮手表屏幕
 @property flipWristToLightScreen
 */
@property (nonatomic, assign) BOOL flipWristToLightScreen;

/*!
 @discussion 加强测量，心率等测量不出来时，手环会开启加强光反射
 @property enhanceSurveyEnabled
 */
@property (nonatomic, assign) BOOL enhanceSurveyEnabled;


/*!
 @discussion 12小时时间制式，如果为NO，则使用24小时时间制式
 @property twelveHoursSystem
 */
@property (nonatomic, assign) BOOL twelveHoursSystem;
@end


#pragma mark -  FCSensorTagObject

/**
 @discussion 传感器标志（受不同手环型号影响），部分UI功能会根据传感器标志动态配置。
 @class FCSensorTagObject
 */
@interface FCSensorTagObject : NSObject <FCObjectProtocal>
@property (nonatomic, assign) BOOL heartRate;
@property (nonatomic, assign) BOOL ultraviolet;
@property (nonatomic, assign) BOOL weather;
@property (nonatomic, assign) BOOL bloodOxygen;
@property (nonatomic, assign) BOOL bloodPressure;
@property (nonatomic, assign) BOOL breathingRate;

/**
 @discussion 心率加强监测
 @property enhanceSurvey
 */
@property (nonatomic, assign) BOOL enhanceSurvey;
@property (nonatomic, assign) BOOL sleepMonitoring;
@end


#pragma mark - FCVersionDataObject

/**
 @discussion 手表系统版本信息
 @class FCVersionDataObject
 */
@interface FCVersionDataObject : NSObject <FCObjectProtocal>
/**
 @discussion 项目的编号
 @property fwNumberData
 */
@property (nonatomic, strong) NSData *fwNumberData;

/**
 @discussion 硬件号亦为手环传感器或功能标志位，组成的32bit，每个bit代表某一传感器或功能在该项目是否存在，手机APP根据该硬件号判断在手机APP上是否显示该功能和是否同步该项数据，
 @property  sensorTagData
 @see <code>FCSensorTagObject</code>
 */
@property (nonatomic, strong) NSData *sensorTagData;

/**
 @discussion 手环页面标号为该项目手环上能显示的所有页面的标志，共32bit，每个bit代表一个页面，手机APP上根据该标号来确定有哪些显示页面可以给用户设置。此处数据暂不使用，可以通过<code>FCSystemSettingObject</code> 的 <i>wsdisplayData</i>获取设置信息  4byte
 @property pageDisplayData
 @see <code>FCWatchScreenDisplayObject</code>
 */
@property (nonatomic, strong) NSData *pageDisplayData;

/**
 @discussion 手环底层patch的版本号 6byte
 @property patchData
 */
@property (nonatomic, strong) NSData *patchData;


/**
 @discussion flash文件版本号 4byte
 @property flashData
 */
@property (nonatomic, strong) NSData *flashData;

/**
 @discussion 固件app版本号 4byte
 @property fwAppData
 */
@property (nonatomic, strong) NSData *fwAppData;

/**
 @discussion 固件版本时间序号 4byte
 @property timeSeqNumData
 */
@property (nonatomic, strong) NSData *timeSeqNumData;

- (FCSensorTagObject*)sensorTagObject;

@end




#pragma mark - FCHealthMonitoringObject
/*!
 * @discussion 手表健康定时监测
 * @class FCHealthMonitoringObject
 */
@interface FCHealthMonitoringObject : NSObject <FCObjectProtocal>

/*!
 * @discussion 健康监测开关状态
 * @property isOn
 */
@property (nonatomic, assign) BOOL isOn;

/*!
 * @discussion 健康监测开始时间（从0点开始的分钟数）.
 * @property stMinute
 */
@property (nonatomic, assign) NSUInteger stMinute;

/*!
 * @discussion 健康监测结束时间（从0点开始的分钟数）.
 * @property edMinute
 */
@property (nonatomic, assign) NSUInteger edMinute;
@end




#pragma mark - FCSedentaryReminderObject
/*!
 * @discussion 久坐提醒,手表会在长时间不运动时发出提醒，通知用户起身运动
 * @class FCSedentaryReminderObject
 */
@interface FCSedentaryReminderObject : NSObject <FCObjectProtocal>

/*!
 * @property isOn
 * @discussion 久坐提醒开关
 */
@property (nonatomic, assign) BOOL isOn;

/*!
 * @property restTimeNotDisturbEnabled
 * @discussion 午休免打扰
 */
@property (nonatomic, assign) BOOL restTimeNotDisturbEnabled;

/*!
 * @property stMinute
 * @discussion 久坐提醒开始时间，数值为从0开始的分钟数
 */
@property (nonatomic, assign) NSUInteger stMinute;

/*!
 * @property edMinute
 * @discussion 久坐提醒结束时间，数值为从0开始的分钟数
 */
@property (nonatomic, assign) NSUInteger edMinute;

/*!
 判断是否处于午休时间，午休时间为12:00-14:00,如果处于这个范围则为午休时间。
 
 @return 是否处于午休时间
 */
- (BOOL)isAtRestTime;

@end





#pragma mark - FCWatchSettingsObject

/*!
 @discussion 手表配置
 @class FCWatchSettingsObject
 */
@interface FCWatchSettingsObject : NSObject <FCObjectProtocal>

/*!
 @discussion 消息通知开关配置 4byte
 @property nfSettingData
 @see <code>FCNotificationObject</code>
 */
@property (nonatomic, strong) NSData *nfSettingData;

/*!
 @discussion 手表屏幕显示设置 2byte
 @property wsdisplayData
 @see <code>FCWatchScreenDisplayObject</code>
 */
@property (nonatomic, strong) NSData *wsdisplayData;

/*!
 @discussion 手表功能开关配置 2byte
 @property featuresData
 @see FCFeaturesObject
 */
@property (nonatomic, strong) NSData *featuresData;

/*!
 @discussion 手表系统软硬件版本信息 32byte
 @property versionData
 @see FCVersionDataObject
 */
@property (nonatomic, strong) NSData *versionData;

/*!
 @discussion 健康定时监测 5byte
 @property healthMonitoringData
 @see <code>FCHealthMonitoringObject</code>
 */
@property (nonatomic, strong) NSData *healthMonitoringData;

/*!
 @discussion 久坐提醒数据 5bytes
 @property sedentaryReminderData
 @see <code>FCSedentaryReminderObject</code>
 */
@property (nonatomic, strong) NSData *sedentaryReminderData;

/*!
 @discussion 默认血压
 @property defaultBloodPressureData
 */
@property (nonatomic, strong) NSData *defaultBloodPressureData;

/*!
 @discussion 喝水提醒
 @property drinkReminderData
 */
@property (nonatomic, strong) NSData *drinkReminderData;

- (FCNotificationObject*)messageNotificationObject;
- (FCWatchScreenDisplayObject*)watchScreenDisplayObject;
- (FCFeaturesObject*)featuresObject;
- (FCVersionDataObject*)versionObject;
- (FCHealthMonitoringObject*)healthMonitoringObject;
- (FCSedentaryReminderObject*)sedentaryReminderObject;
- (NSDictionary*)defaultBloodPressure;
- (BOOL)drinkRemindEnabled;
@end



#pragma mark - FCDataObject

@interface FCDataObject : NSObject
/*!
 * @property dataType
 * @discussion 数据类型，用于区分不同的数据，详细见<i>FCDataType</i>
 */
@property (nonatomic, assign) FCDataType DataType;
/*!
 * @property timestamp
 * @discussion 自1970开始的时间戳
 */
@property (nonatomic, strong) NSNumber *timeStamp;

/*!
 * @property value
 * @discussion 运动和健康数据，dataType为一下类型时分别对应一下数据
 <i>FCDataTypeExercise</i>：value为运动的步数；
 <i>FCDataTypeSleep</i>：value为睡眠状态（1：深睡眠 2：浅睡眠 3：清醒）；
 <i>FCDataTypeHeartRate</i>：value为平均心率；
 <i>FCDataTypeBloodOxygen</i>：value为血氧数值；
 <i>FCDataTypeBloodPressure</i>：value为收缩压，extravalue为舒张压；
 <i>FCDataTypeBreathingRate</i>：value为呼吸频率
 */
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSNumber *extraValue;
@end

