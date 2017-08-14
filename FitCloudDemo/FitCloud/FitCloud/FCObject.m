//
//  FCObject.m
//  FitCloud
//
//  Created by 远征 马 on 2016/10/18.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import "FCObject.h"
#import "FitCloudUtils.h"


#pragma mark - FCWatchConfig

@implementation FCWatchConfig

@end


#pragma mark - FCUserObject

@implementation FCUserObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.systolicBP = 125;
        self.diastolicBP = 80;
        self.weight = 60; // kg
        self.height = 175; // 男 175 女 165
    }
    return self;
}

- (NSData*)writeDataForUserProfile
{
    Byte byte[4] = {0};
    byte[0] = ((self.sex & 0x01) << 7) + (self.age & 0x7E);
    byte[1] = ((self.height*2) >> 1);
    byte[2] = (((self.height*2) & 0x01) << 7) + ((self.weight*2) >> 3);
    byte[3] = (((self.weight*2) & 0x07) << 5);
    NSData *data = [NSData dataWithBytes:byte length:4];
    return data;
}

- (NSData*)writeDataForLoginOrBind
{
    Byte byte[32] = {0};
    byte[0] = self.guestId & 0xFF;
    byte[1] = (self.guestId >> 8) & 0xFF;
    byte[2] = (self.guestId >> 16) & 0XFF;
    byte[3] = (self.guestId >> 24) & 0XFF;
    byte[29] = 0x01;
    byte[30] = self.phoneModel;
    byte[31] = self.osVersion;
    NSData *data = [NSData dataWithBytes:byte length:32];
    return data;
}

@end


@implementation FCWeather

- (NSData*)writeData
{
    Byte byte[35] = {0};
    byte[0] = self.temperature;
    byte[1] = self.maxTemperature;
    byte[2] = self.minTemperature;
    byte[3] = self.weatherState;
    if (self.city)
    {
        NSData *cityData = [self.city dataUsingEncoding:NSUTF8StringEncoding];
        byte[4] = cityData.length;
        NSMutableData *data = [NSMutableData dataWithBytes:byte length:35];
        [data replaceBytesInRange:NSMakeRange(5, cityData.length) withBytes:[cityData bytes]];
        return data;
    }
    else
    {
        NSData *data = [NSData dataWithBytes:byte length:35];
        return data;
    }
    
}
@end


#pragma mark - FCAlarmClockCycleObject

@implementation FCAlarmClockCycleObject

+ (instancetype)cycleWithValue:(NSNumber*)cycle
{
    return [[self alloc]initWithValue:cycle];
}

- (instancetype)initWithValue:(NSNumber*)cycle
{
    self = [super init];
    if (self && cycle)
    {
        self.monday = (cycle.intValue & 0x01);
        self.tuesday = (cycle.intValue & 0x02);
        self.wednesday = (cycle.intValue & 0x04);
        self.thursday = (cycle.intValue & 0x08);
        self.firday = (cycle.intValue & 0x010);
        self.saturday = (cycle.intValue & 0x20);
        self.sunday = (cycle.intValue & 0x40);
    }
    return self;
}

- (NSNumber*)cycleValue
{
    UInt8 value = 0;
    value += (self.monday ? 1 : 0);
    value += (self.tuesday ? (1 << 1) : 0);
    value += (self.wednesday ? (1 << 2) : 0);
    value += (self.thursday ? (1 << 3) : 0);
    value += (self.firday ? (1 << 4) : 0);
    value += (self.saturday ? (1 << 5) : 0);
    value += (self.sunday ? (1 << 6) : 0);
    return @(value);
}
@end


#pragma mark - FCAlarmClockObject (闹钟)

@implementation FCAlarmClockObject

- (NSNumber*)cycle
{
    if (_cycle) {
        return _cycle;
    }
    if (_cycleObject) {
        _cycle = [_cycleObject cycleValue];
    }
    return _cycle;
}

- (FCAlarmClockCycleObject*)cycleObject
{
    if (_cycleObject) {
        return _cycleObject;
    }
    if (_cycle) {
        _cycleObject = [FCAlarmClockCycleObject cycleWithValue:_cycle];
    }
    return _cycleObject;
}

- (NSString*)ringTime
{
    if (self.hour && self.minute)
    {
        NSString *hourString = (self.hour.integerValue < 10) ? [NSString stringWithFormat:@"0%@",self.hour]:self.hour.stringValue;
        NSString *minuteString = (self.minute.integerValue < 10) ? [NSString stringWithFormat:@"0%@",self.minute]:self.minute.stringValue;
        return [NSString stringWithFormat:@"%@:%@",hourString,minuteString];
    }
    return nil;
}

- (NSData*)writeData
{
    Byte byte[5] = {0};
    byte[0] = ((self.year.intValue & 0x3F) << 2) + ((self.month.intValue >> 2) & 0x03);
    byte[1] = ((self.month.intValue & 0x03) << 6) + ((self.day.intValue & 0x1F) << 1) + ((self.hour.intValue >> 4) & 0x01);
    byte[2] = ((self.hour.intValue & 0x0F) << 4) + ((self.minute.intValue >> 2) & 0x0F);
    byte[3] = ((self.minute.intValue & 0x03) << 6) + ((self.alarmId.intValue & 0x07) << 3) + ((self.isOn >> 1) & 0x07);
    byte[4] = ((self.isOn & 0x01) << 7) + (self.cycle.intValue & 0x7F);
    NSData *data = [NSData dataWithBytes:byte length:5];
    return data;
}
@end




#pragma mark - FCNotificationObject (消息通知设置)

@implementation FCNotificationObject

+ (instancetype)objectWithData:(NSData*)data;
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self && data && data.length >= 4)
    {
        
        Byte *byte = (Byte*)[data bytes];
        
        self.incomingCall = (byte[3] & (1 << 0));
        self.smsAlerts = (byte[3] & (1 << 1));
        self.qqMessage = (byte[3] & (1 << 2));
        self.wechatMessage = (byte[3] & (1 << 3));
        self.facebook = (byte[3] & (1 << 4));
        self.twitter = (byte[3] & (1 << 5));
        self.linkedin = (byte[3] & (1 << 6));
        self.instagram = (byte[3] & (1 << 7));
        
        self.pinterest = (byte[2] & (1 << 0));
        self.whatsapp = (byte[2] & (1 << 1));
        self.line = (byte[2] & (1 << 2));
        self.facebookMessage = (byte[2] & (1 << 3));
        self.otherApp = (byte[2] & (1 << 4));
        self.messageDisplayEnabled = (byte[2] & (1 << 5));
        self.appDisconnectAlerts = (byte[2] & (1 << 6));
        self.watchDisconnectAlerts = (byte[2] & (1 << 7));
        
        self.kakaoMessage = (byte[1] & (1 << 0));
    }
    return self;
}

- (NSData*)writeData
{
    Byte byte[4] = {0};
    byte[3] += (self.incomingCall ? 1 : 0);
    byte[3] += (self.smsAlerts ? (1 << 1) : 0);
    byte[3] += (self.qqMessage ? (1 << 2) : 0);
    byte[3] += (self.wechatMessage ? (1 << 3) : 0);
    byte[3] += (self.facebook ? (1 << 4) : 0);
    byte[3] += (self.twitter ? (1 << 5) : 0);
    byte[3] += (self.linkedin ? (1 << 6) : 0);
    byte[3] += (self.instagram ? (1 << 7) : 0);
    
    byte[2] += (self.pinterest ? 1 : 0);
    byte[2] += (self.whatsapp ? (1 << 1) : 0);
    byte[2] += (self.line ? (1 << 2) : 0);
    byte[2] += (self.facebookMessage ? (1 << 3) : 0);
    byte[2] += (self.otherApp ? (1 << 4) : 0);
    byte[2] += (self.messageDisplayEnabled ? (1 << 5) : 0);
    byte[2] += (self.appDisconnectAlerts ? (1 << 6) : 0);
    byte[2] += (self.watchDisconnectAlerts ? (1 << 7) : 0);
    
    byte[1] += (self.kakaoMessage ? 1 : 0);
    
    NSData *payload = [NSData dataWithBytes:byte length:4];
    return payload;
}

@end


#pragma mark -  FCFeaturesObject (功能开关)

@implementation FCFeaturesObject
+ (instancetype)objectWithData:(NSData*)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self && data && data.length >= 2)
    {
        Byte *byte = (Byte*)[data bytes];
        self.flipWristToLightScreen = @(byte[1] & 0x01).boolValue;
        self.enhanceSurveyEnabled = @(byte[1] & 0x02).boolValue;
        self.twelveHoursSystem = @(byte[1] & 0x04).boolValue;
        self.isImperialUnits = @(byte[1] & 0x08).boolValue;
    }
    return self;
}

- (NSData*)writeData
{
    Byte byte[2] = {0};
    byte[1] += (self.flipWristToLightScreen ? 1 : 0);
    byte[1] += (self.enhanceSurveyEnabled ? (1 << 1) : 0);
    byte[1] += (self.twelveHoursSystem ? (1 << 2) : 0);
    byte[1] += (self.isImperialUnits ? (1 << 2) : 0);
    NSData *payload = [NSData dataWithBytes:byte length:2];
    return payload;
}

@end





#pragma mark - FCSensorFlagObject

@implementation FCSensorFlagObject

+ (instancetype)objectWithData:(NSData*)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self && data && data.length >= 4)
    {
        Byte *byte = (Byte*)[data bytes];
        
        self.heartRate = @((byte[3] & 0x01)).boolValue;
        self.ultraviolet = @((byte[3] & (1 << 1))).boolValue;
        self.weather = @((byte[3] & (1 << 2))).boolValue;
        self.bloodOxygen = @((byte[3] & (1 << 3))).boolValue;
        self.bloodPressure = @((byte[3] & (1 << 4))).boolValue;
        self.breathingRate = @((byte[3] & (1 << 5))).boolValue;
        self.enhanceSurvey = @((byte[3] & (1 << 6))).boolValue;
        self.sleepHistoryOfSevenDays = @((byte[3] & (1 << 7))).boolValue;
        self.ECG = @((byte[2] & 0x01)).boolValue;
        self.flashOTA = @((byte[2] & (1 << 1))).boolValue;
        self.ancsLanguage = @((byte[2] & (1 << 2))).boolValue;
    }
    return self;
}

@end

#pragma mark - FCScreenDisplayConfigObject

@implementation FCScreenDisplayConfigObject

+ (instancetype)objectWithData:(NSData*)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self && data && data.length >= 2)
    {
        Byte *byte = (Byte*)[data bytes];
        
        self.dateTime = YES;
        self.stepCount = @(byte[1] & (1 << 1)).boolValue;
        self.distance = @(byte[1] & (1 << 2)).boolValue;
        self.calorie = @(byte[1] & (1 << 3)).boolValue;
        self.sleep = @(byte[1] & (1 << 4)).boolValue;
        self.heartRate = @(byte[1] & (1 << 5)).boolValue;
        self.bloodOxygen = @(byte[1] & (1 << 6)).boolValue;
        self.bloodPressure = @(byte[1] & (1 << 7)).boolValue;
        
        self.weatherForecast = @(byte[0] & 0x01).boolValue;
        self.findPhone = @(byte[0] & (1 << 1)).boolValue;
        self.displayId = @(byte[0] & (1 << 2)).boolValue;
    }
    return self;
}


- (NSData*)writeData
{
    Byte byte[2] = {0};
    byte[0] += (self.weatherForecast ? 1 : 0);
    byte[0] += (self.findPhone ? (1 << 1) : 0);
    byte[0] += (self.displayId ? (1 << 2) : 0);
    
    byte[1] += 1;
    byte[1] += (self.stepCount ? (1 << 1) : 0);
    byte[1] += (self.distance ? (1 << 2) : 0);
    byte[1] += (self.calorie ? (1 << 3) : 0);
    byte[1] += (self.sleep ? (1 << 4) : 0);
    byte[1] += (self.heartRate ? (1 << 5) : 0);
    byte[1] += (self.bloodOxygen ? (1 << 6) : 0);
    byte[1] += (self.bloodPressure ? (1 << 7) : 0);
    
    NSData *data = [NSData dataWithBytes:byte length:2];
    return data;
}
@end


#pragma mark - FCPageDisplayFlagObject

@implementation FCPageDisplayFlagObject

+ (instancetype)objectWithData:(NSData*)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self && data && data.length >= 4)
    {
        Byte *byte = (Byte*)[data bytes];
        
        self.dateTime = YES;
        self.stepCount = @(byte[3] & (1 << 1)).boolValue;
        self.distance = @(byte[3] & (1 << 2)).boolValue;
        self.calorie = @(byte[3] & (1 << 3)).boolValue;
        self.sleep = @(byte[3] & (1 << 4)).boolValue;
        self.heartRate = @(byte[3] & (1 << 5)).boolValue;
        self.bloodOxygen = @(byte[3] & (1 << 6)).boolValue;
        self.bloodPressure = @(byte[3] & (1 << 7)).boolValue;
        
        self.weatherForecast = @(byte[2] & 0x01).boolValue;
        self.findPhone = @(byte[2] & (1 << 1)).boolValue;
        self.displayId = @(byte[2] & (1 << 2)).boolValue;
    }
    return self;
}
@end


#pragma mark - FCVersionDataObject

@implementation FCVersionDataObject

+ (instancetype)objectWithData:(NSData *)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        if (data && data.length >= 32)
        {
            Byte *byte = (Byte*)[data bytes];
            self.fwNumberData = [NSData dataWithBytes:&byte[0] length:6];
            self.sensorTagData = [NSData dataWithBytes:&byte[6] length:4];
            self.pageDisplayData = [NSData dataWithBytes:&byte[10] length:4];
            self.patchData = [NSData dataWithBytes:&byte[14] length:6];
            self.flashData = [NSData dataWithBytes:&byte[20] length:4];
            self.fwAppData = [NSData dataWithBytes:&byte[24] length:4];
            self.timeSeqNumData = [NSData dataWithBytes:&byte[28] length:4];
        }
    }
    return self;
}

- (FCSensorFlagObject*)sensorTagObject
{
    FCSensorFlagObject *sensorTag = [FCSensorFlagObject objectWithData:self.sensorTagData];
    return sensorTag;
}

- (FCPageDisplayFlagObject*)pageDisplayFlagObject
{
    FCPageDisplayFlagObject *pageDisplayFlagObj = [FCPageDisplayFlagObject objectWithData:self.pageDisplayData];
    return pageDisplayFlagObj;
}

@end



#pragma mark - FCHealthMonitoringObject (健康监测)

@implementation FCHealthMonitoringObject

+ (instancetype)objectWithData:(NSData *)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self)
    {
        if (data && data.length >= 5)
        {
            Byte *byte = (Byte*)[data bytes];
            self.isOn = byte[0];
            self.stMinute = (byte[1] << 8) + byte[2];
            self.edMinute = (byte[3] << 8) + byte[4];
            // 如果开始时间等于结束时间则使用默认时间
            if (self.stMinute == self.edMinute) {
                self.stMinute = 480;
                self.edMinute = 1380;
            }
        }
        else
        {
            self.isOn = NO;
            self.stMinute = 480;
            self.edMinute = 1380;
        }
    }
    return self;
}

- (NSData*)writeData
{
    Byte byte[5] = {0};
    byte[0] = self.isOn ;
    byte[1] = (self.stMinute >> 8);
    byte[2] = (self.stMinute & 0xFF);
    byte[3] = (self.edMinute >> 8);
    byte[4] = (self.edMinute & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:5];
    return data;
}
@end


#pragma mark - FCSedentaryReminderObject (久坐提醒)

@implementation FCSedentaryReminderObject

+ (instancetype)objectWithData:(NSData*)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self)
    {
        if (data && data.length >= 5)
        {
            Byte *byte = (Byte*)[data bytes];
            self.isOn = (byte[0] & 0x01);
            self.restTimeNotDisturbEnabled = (byte[0] & 0x02);
            self.stMinute = (byte[1] << 8) + byte[2];
            self.edMinute = (byte[3] << 8) + byte[4];
            
            // 如果开始时间等于结束时间则使用默认时间
            if (self.stMinute == self.edMinute)
            {
                self.stMinute = 480;
                self.edMinute = 1200;
            }
        }
        else
        {
            self.isOn = NO;
            self.restTimeNotDisturbEnabled = NO;
            self.stMinute = 480;
            self.edMinute = 1200;
        }
    }
    return self;
}

- (NSData*)writeData
{
    Byte byte[5] = {0};
    byte[0] = (self.isOn & 0x01) + ((self.restTimeNotDisturbEnabled & 0x01) << 1);
    byte[1] = (self.stMinute >> 8);
    byte[2] = (self.stMinute & 0xFF);
    byte[3] = (self.edMinute >> 8);
    byte[4] = (self.edMinute & 0xFF);
    NSData *data = [NSData dataWithBytes:byte length:5];
    return data;
}

- (BOOL)isAtRestTime
{
    return !(self.edMinute < 720 && self.stMinute > 840);
}
@end


#pragma mark - FCWatchSettingsObject

@implementation FCWatchSettingsObject

+ (instancetype)objectWithData:(NSData *)data
{
    return [[self alloc]initWithData:data];
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        if (data && data.length >= 53)
        {
            Byte *byte = (Byte*)[data bytes];
            self.nfSettingData = [NSData dataWithBytes:&byte[0] length:4];
            self.wsdisplayData = [NSData dataWithBytes:&byte[4] length:2];
            self.featuresData = [NSData dataWithBytes:&byte[6] length:2];
            self.versionData = [NSData dataWithBytes:&byte[8] length:32];
            self.healthMonitoringData = [NSData dataWithBytes:&byte[40] length:5];
            self.sedentaryReminderData = [NSData dataWithBytes:&byte[45] length:5];
            self.defaultBloodPressureData = [NSData dataWithBytes:&byte[50] length:2];
            self.drinkReminderData = [NSData dataWithBytes:&byte[52] length:1];
        }
    }
    return self;
}

- (FCNotificationObject*)messageNotificationObject
{
    FCNotificationObject *noteObject = [FCNotificationObject objectWithData:self.nfSettingData];
    return noteObject;
}

- (FCScreenDisplayConfigObject*)watchScreenDisplayObject
{
    FCScreenDisplayConfigObject *wsDisplayObject = [FCScreenDisplayConfigObject objectWithData:self.wsdisplayData];
    return wsDisplayObject;
}

- (FCFeaturesObject*)featuresObject
{
    FCFeaturesObject *featuresObject = [FCFeaturesObject objectWithData:self.featuresData];
    return featuresObject;
}

- (FCVersionDataObject*)versionObject
{
    FCVersionDataObject *versionDataObject = [FCVersionDataObject objectWithData:self.versionData];
    return versionDataObject;
}

- (FCHealthMonitoringObject*)healthMonitoringObject
{
    FCHealthMonitoringObject *healthMonitoring = [FCHealthMonitoringObject objectWithData:self.healthMonitoringData];
    return healthMonitoring;
}

- (FCSedentaryReminderObject*)sedentaryReminderObject
{
    FCSedentaryReminderObject *sedentaryReminder = [FCSedentaryReminderObject objectWithData:self.sedentaryReminderData];
    return sedentaryReminder;
}

- (NSDictionary*)defaultBloodPressure
{
    if (self.defaultBloodPressureData) {
        Byte byte[2] = {0};
        [self.defaultBloodPressureData getBytes:byte range:NSMakeRange(0, 2)];
        return @{@"systolicBP":@(byte[1]),@"diastolicBP":@(byte[0])};
    }
    return @{@"systolicBP":@(125),@"diastolicBP":@(80)};
}

- (BOOL)drinkRemindEnabled
{
    if (self.drinkReminderData)
    {
        Byte byte[1] = {0};
        [self.drinkReminderData getBytes:byte range:NSMakeRange(0, 1)];
        return byte[0];
    }
    return NO;
}
@end



#pragma mark - FCDataObject

@implementation FCDataObject


@end
