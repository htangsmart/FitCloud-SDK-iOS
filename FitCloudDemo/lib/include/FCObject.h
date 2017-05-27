//
//  FCObject.h
//  FitCloud
//
//  Created by 远征 马 on 2016/10/18.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCDefine.h"


/**
 数据模型协议
 */
@protocol FCObjectProtocal <NSObject>

@optional
+ (instancetype)objectWithData:(NSData*)data;
+ (instancetype)objectWithValue:(NSNumber*)value;

/**
 经过协议编码的蓝牙数据

 @return <i>NSData</i>类型的二进制数据
 */
- (NSData*)writeData;
@end





#pragma mark - FCUserObject

/**
 用户资料,主要用途手表绑定、登录、同步等更新配置信息使用
 */
@interface FCUserObject : NSObject <FCObjectProtocal>

/**
 用户id，由自己服务器为每个用户分配。登录、绑定都需要此参数
 */
@property (nonatomic, assign) UInt64 guestId;

/**
 手机型号,如iphone6、iphone6s,通过<i>FitCloudUtils</i>可以获取到。登录、绑定都需要此参数
 */
@property (nonatomic, assign) UInt8 phoneModel;

/**
 系统版本,通过<i>FitCloudUtils</i>可以获取到。登录、绑定都需要此参数
 */
@property (nonatomic, assign) UInt8 osVersion;

/**
 用户年龄，默认1990出生。 绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 age;

/**
 性别，默认为女性 0。 绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 sex;

/**
 用户体重，默认60kg。绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 weight;

/**
 用户身高，女性默认 165cm, 男性默认 175cm。 绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 height;

/**
 收缩压参考值，默认125。绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt16 systolicBP;

/**
 舒张压参考值，默认80。绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt16 diastolicBP;

/**
 佩戴方式，左右佩戴？右手佩戴。 绑定手表需要此参数
 */
@property (nonatomic, assign) BOOL isLeftHandWearEnabled;

/**
 手表功能开关数据，详细参数见 <i>FCFeaturesObject</i> ,手表绑定、登录或者同步历史数据时如果对此参数赋值，会将手表时间制式、单位等同步到手表，如果为nil则不同步此配置
 */
@property (nonatomic, strong) NSData  *featuresData;

/**
 登录或者绑定手表时蓝牙需要写入的数据
 */
- (NSData*)writeDataForLoginOrBind;

/**
 同步用户资料时蓝牙需要写入的数据
 */
- (NSData*)writeDataForUserProfile;
@end




#pragma mark - FCWeather

/**
 天气
 */
@interface FCWeather : NSObject <FCObjectProtocal>

/**
 当前温度
 */
@property (nonatomic, assign) NSInteger temperature;

/**
 最高温度
 */
@property (nonatomic, assign) NSInteger maxTemperature;

/**
 最低温度
 */
@property (nonatomic, assign) NSInteger minTemperature;

/**
 天气状况，从服务器获取天气状态后，你需要转换为枚举值对应的天气
 */
@property (nonatomic, assign) FCWeatherState weatherState;

/**
 当前天气所在城市
 */
@property (nonatomic, strong) NSString *city;
@end




#pragma mark - FCAlarmClockCycleObject

/**
 闹钟周期, 如果周一到周日无设置，则表示闹钟当日有效
 */
@interface FCAlarmClockCycleObject : NSObject
@property (nonatomic, assign) BOOL monday;
@property (nonatomic, assign) BOOL tuesday;
@property (nonatomic, assign) BOOL wednesday;
@property (nonatomic, assign) BOOL thursday;
@property (nonatomic, assign) BOOL firday;
@property (nonatomic, assign) BOOL saturday;
@property (nonatomic, assign) BOOL sunday;

/**
 通过闹钟周期<i>cycleValue</i>初始化<i>FCCycleOfAlarmClockObject</i>对象

 @param cycleValue 闹钟周期数值
 @return <i>FCCycleOfAlarmClockObject</i> 实例对象
 */
+ (instancetype)cycleWithValue:(NSNumber*)cycleValue;

/**
 获取闹钟周期数值（7 bits），从低位到高位表示周一到周日；如果所有字节为0，则表示闹钟当日有效.

 @return 闹钟周期数值
 */
- (NSNumber*)cycleValue;
@end




#pragma mark - FCAlarmClockObject

/**
 闹钟对象
 */
@interface FCAlarmClockObject : NSObject <FCObjectProtocal>
@property (nonatomic, strong) NSNumber *alarmId;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *hour;
@property (nonatomic, strong) NSNumber *minute;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) NSNumber *cycle;
@property (nonatomic, strong) FCAlarmClockCycleObject *cycleObject;

/**
 响铃时间

 @return 响铃时间字符串 格式："HH: mm"
 */
- (NSString*)ringTime;
@end


#pragma mark - FCNotificationObject

/**
 手表通知开关对象
 */
@interface FCNotificationObject : NSObject <FCObjectProtocal>

/**
 手机来电通知，有新来电时手表会震动提醒
 */
@property (nonatomic, assign) BOOL incomingCall;

/**
 短信通知，有新短信时手表会提醒
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

/**
 打开此项，其他app来消息时，手表会及时通知用户
 */
@property (nonatomic, assign) BOOL otherApp;

/**
 消息内容是否在手表屏幕上显示，打开此项短消息内容会即时显示在手表屏幕上
 */
@property (nonatomic, assign) BOOL messageDisplayEnabled;

/**
 蓝牙断开提醒，当手表和手机断开连接，手机app会及时提醒用户,此处需要用户自己去做app提醒
 */
@property (nonatomic, assign) BOOL appDisconnectAlerts;

/**
 手表断开提醒，当手表和手机断开连接，手表会震动提醒
 */
@property (nonatomic, assign) BOOL watchDisconnectAlerts;

/**
 心率实时监测，打开此开关，手表会持续采集用户心率数据
 */
@property (nonatomic, assign) BOOL heartRateMonitoringEnabled;
@end


#pragma mark - FCWatchScreenDisplayObject

/**
 手表屏幕显示设置，屏幕显示设置项需要先根据传感器标志来判断，如果传感器标志功能不存在，则屏幕设置项需要设置为无效
 */
@interface FCScreenDisplayConfigObject : NSObject <FCObjectProtocal>
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

/**
 手表功能开关设置对象
 */
@interface FCFeaturesObject : NSObject <FCObjectProtocal>

/**
 翻动手腕时点亮手表屏幕
 */
@property (nonatomic, assign) BOOL flipWristToLightScreen;

/**
 加强测量，心率等测量不出来时，手环会开启加强光反射
 */
@property (nonatomic, assign) BOOL enhanceSurveyEnabled;

/**
 12小时时间制式，如果为NO，则使用24小时时间制式
 */
@property (nonatomic, assign) BOOL twelveHoursSystem;


/**
 距离和重量单位，0 为公制单位  1 英制单位
 */
@property (nonatomic, assign) BOOL isImperialUnits;
@end


#pragma mark -  FCSensorFlagObject

/**
 传感器标志。硬件号亦为手环传感器或功能标志位，组成的32bit，每个bit代表某一传感器或功能在该项目是否存在，手机APP根据该硬件号判断在手机APP上是否显示该功能和是否同步该项数据，详细请看下面定义
 */
@interface FCSensorFlagObject : NSObject <FCObjectProtocal>
@property (nonatomic, assign) BOOL heartRate;
@property (nonatomic, assign) BOOL ultraviolet;
@property (nonatomic, assign) BOOL weather;
@property (nonatomic, assign) BOOL bloodOxygen;
@property (nonatomic, assign) BOOL bloodPressure;
@property (nonatomic, assign) BOOL breathingRate;

/**
 心率加强监测，对于一些测不出心率的特殊人群，开启加强检测有助于心率测量
 */
@property (nonatomic, assign) BOOL enhanceSurvey;

/**
 七天历史睡眠总数据,如果有此标志位，可以同步七天睡眠总数据
 */
@property (nonatomic, assign) BOOL sleepHistoryOfSevenDays;

/**
 心电功能标志
 */
@property (nonatomic, assign) BOOL ECG;
@end


/*!
 手环页面标号。手环页面标号为该项目手环上能显示的所有页面的标志，共32bit，每个bit代表一个页面，手机APP上根据该标号来确定有哪些显示页面可以给用户设置，具体每一位代表哪一个页面请看下面定义
 */
@interface FCPageDisplayFlagObject : NSObject
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




#pragma mark - FCVersionDataObject

/**
 手表系统版本信息
 */
@interface FCVersionDataObject : NSObject <FCObjectProtocal>

/**
 项目的编号
 */
@property (nonatomic, strong) NSData *fwNumberData;

/**
 硬件号亦为手环传感器或功能标志位，组成的32bit，每个bit代表某一传感器或功能在该项目是否存在，手机APP根据该硬件号判断在手机APP上是否显示该功能和是否同步该项数据，
 
 @see FCSensorTagObject
 */
@property (nonatomic, strong) NSData *sensorTagData;

/**
 手环页面标号为该项目手环上能显示的所有页面的标志，共32bit，每个bit代表一个页面，手机APP上根据该标号来确定有哪些显示页面可以给用户设置。此处数据暂不使用，可以通过<i>FCSystemSettingObject</i> 的 <i>wsdisplayData</i>获取设置信息  4byte
 
 @see FCWatchScreenDisplayObject
 */
@property (nonatomic, strong) NSData *pageDisplayData;

/**
 手环底层patch的版本号 6byte
 */
@property (nonatomic, strong) NSData *patchData;

/**
 flash文件版本号 4byte
 */
@property (nonatomic, strong) NSData *flashData;

/**
 固件app版本号 4byte
 */
@property (nonatomic, strong) NSData *fwAppData;

/**
 固件版本时间序号 4byte
 */
@property (nonatomic, strong) NSData *timeSeqNumData;


/**
 通过系统版本数据获取传感器标志位对象

 @return 传感器标志对象
 */
- (FCSensorFlagObject*)sensorTagObject;

@end




#pragma mark - FCHealthMonitoringObject

/**
 手表健康定时监测
 */
@interface FCHealthMonitoringObject : NSObject <FCObjectProtocal>

/**
 健康监测开关状态
 */
@property (nonatomic, assign) BOOL isOn;

/**
 健康监测开始时间（从0点开始的分钟数）.
 */
@property (nonatomic, assign) NSUInteger stMinute;

/**
 健康监测结束时间（从0点开始的分钟数）.
 */
@property (nonatomic, assign) NSUInteger edMinute;
@end




#pragma mark - FCSedentaryReminderObject

/**
 久坐提醒,手表会在长时间不运动时发出提醒，通知用户起身运动
 */
@interface FCSedentaryReminderObject : NSObject <FCObjectProtocal>

/**
 久坐提醒开关
 */
@property (nonatomic, assign) BOOL isOn;

/**
 午休免打扰，打开此项，午休时间将不会提醒
 */
@property (nonatomic, assign) BOOL restTimeNotDisturbEnabled;

/**
 久坐提醒开始时间，数值为从0开始的分钟数
 */
@property (nonatomic, assign) NSUInteger stMinute;

/**
 久坐提醒结束时间，数值为从0开始的分钟数
 */
@property (nonatomic, assign) NSUInteger edMinute;

/**
 判断是否处于午休时间，午休时间为12:00-14:00,如果处于这个范围则为午休时间。
 
 @return 是否处于午休时间
 */
- (BOOL)isAtRestTime;

@end





#pragma mark - FCWatchSettingsObject

/**
 手表配置
 */
@interface FCWatchSettingsObject : NSObject <FCObjectProtocal>

/**
 消息通知开关配置 4byte
 
 @see FCNotificationObject
 */
@property (nonatomic, strong) NSData *nfSettingData;

/**
 手表屏幕显示设置 2byte
 
 @see FCWatchScreenDisplayObject
 */
@property (nonatomic, strong) NSData *wsdisplayData;

/**
 手表功能开关配置 2byte
 
 @see FCFeaturesObject
 */
@property (nonatomic, strong) NSData *featuresData;

/**
 手表系统软硬件版本信息 32byte
 
 @see FCVersionDataObject
 */
@property (nonatomic, strong) NSData *versionData;

/**
 健康定时监测 5byte
 
 @see FCHealthMonitoringObject
 */
@property (nonatomic, strong) NSData *healthMonitoringData;

/**
 久坐提醒数据 5bytes
 
 @see FCSedentaryReminderObject
 */
@property (nonatomic, strong) NSData *sedentaryReminderData;

/**
 默认血压
 */
@property (nonatomic, strong) NSData *defaultBloodPressureData;

/**
 喝水提醒
 */
@property (nonatomic, strong) NSData *drinkReminderData;

- (FCNotificationObject*)messageNotificationObject;
- (FCScreenDisplayConfigObject*)watchScreenDisplayObject;
- (FCFeaturesObject*)featuresObject;
- (FCVersionDataObject*)versionObject;
- (FCHealthMonitoringObject*)healthMonitoringObject;
- (FCSedentaryReminderObject*)sedentaryReminderObject;
- (NSDictionary*)defaultBloodPressure;
- (BOOL)drinkRemindEnabled;
@end



#pragma mark - FCDataObject

/**
 手表同步数据模型
 */
@interface FCDataObject : NSObject

/**
 数据类型，用于区分不同的数据，详细见<i>FCDataType</i>
 */
@property (nonatomic, assign) FCDataType DataType;

/**
 自1970开始的时间戳
 */
@property (nonatomic, strong) NSNumber *timeStamp;

/**
 运动和健康数据，dataType为一下类型时分别对应一下数据
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

