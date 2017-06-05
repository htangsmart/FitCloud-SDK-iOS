//
//  FCConfigManager.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCConfigManager.h"
#import <FitCloudKit.h>
#import "FitCloud+Category.h"
#import "FCWatchConfigDB.h"
#import <YYModel.h>

@interface FCConfigManager ()

@end

@implementation FCConfigManager
+ (instancetype)manager
{
    static FCConfigManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    __weak __typeof(self) ws = self;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ws alloc]init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadWatchSettingFromDB];
    }
    return self;
}

#pragma mark - 从数据库加载手表配置

- (void)loadWatchSettingFromDB
{
    NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
    _watchSetting = [FCWatchConfigDB getWatchConfigFromDBWithUUID:uuidString];
    NSLog(@"---_watchSetting--%@",_watchSetting.yy_modelDescription);
}


- (void)updateConfigWithWatchSettingData:(NSData*)data
{
    if (!data || data.length < 53) {
        return;
    }
    _watchSetting = [FCWatchSettingsObject objectWithData:data];
    // 更新数据库
    NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
    BOOL ret = [FCWatchConfigDB storeWatchConfig:_watchSetting forUUID:uuidString];
    if (ret) {
        NSLog(@"--存储手表配置---");
    }
}


- (void)updateConfigWithVersionData:(NSData*)data
{
    if (!data || data.length < 32) {
        return;
    }
    _watchSetting.versionData = data;
    // 更新数据库
    NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
    BOOL ret = [FCWatchConfigDB storeWatchConfig:_watchSetting forUUID:uuidString];
    if (ret) {
        NSLog(@"--存储手表配置---");
    }
}

- (NSArray*)getPageDisplayItems
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    FCPageDisplayFlagObject *pageDisplayFlag = [self pageDisplayFlagObject];
    if (pageDisplayFlag.dateTime)
    {
        [tmpArray addObject:@"时间和日期"];
    }
    if (pageDisplayFlag.stepCount)
    {
        [tmpArray addObject:@"步数"];
    }
    if (pageDisplayFlag.distance)
    {
        [tmpArray addObject:@"距离"];
    }
    if (pageDisplayFlag.calorie)
    {
        [tmpArray addObject:@"卡路里"];
    }
    if (pageDisplayFlag.sleep)
    {
        [tmpArray addObject:@"睡眠"];
    }
    if (pageDisplayFlag.heartRate)
    {
        [tmpArray addObject:@"心率"];
    }
    if (pageDisplayFlag.bloodOxygen)
    {
        [tmpArray addObject:@"血氧"];
    }
    if (pageDisplayFlag.bloodPressure)
    {
        [tmpArray addObject:@"血压"];
    }
    if (pageDisplayFlag.weatherForecast)
    {
        [tmpArray addObject:@"天气预报"];
    }
    if (pageDisplayFlag.findPhone)
    {
        [tmpArray addObject:@"查找手机"];
    }
    [tmpArray addObject:@"ID"];
    
    return [NSArray arrayWithArray:tmpArray];
}

- (NSDictionary*)defaultBloodPressure
{
    if (_watchSetting) {
        return [_watchSetting defaultBloodPressure];
    }
    return @{@"systolicBP":@(125),@"diastolicBP":@(80)};
}

- (BOOL)isDrinkRemimdEnabled
{
    if (_watchSetting) {
        return [_watchSetting drinkRemindEnabled];
    }
    return NO;
}

- (FCSedentaryReminderObject*)sedentaryReminderObject
{
    if (_watchSetting) {
        FCSedentaryReminderObject *obj = [_watchSetting sedentaryReminderObject];
        return obj;
    }
    return [FCSedentaryReminderObject objectWithData:nil];
}

- (FCHealthMonitoringObject*)healthMonitoringObject
{
    if (_watchSetting) {
        FCHealthMonitoringObject *obj = [_watchSetting healthMonitoringObject];
        return obj;
    }
    return [FCHealthMonitoringObject objectWithData:nil];
}

- (FCNotificationObject*)notificationObject
{
    if (_watchSetting) {
        FCNotificationObject *noteObj = [_watchSetting messageNotificationObject];
        return noteObj;
    }
    return [FCNotificationObject objectWithData:nil];
}

- (FCSensorFlagObject*)sensorFlagObject
{
    FCVersionDataObject *versionDataObj = [_watchSetting versionObject];
    if (versionDataObj)
    {
        FCSensorFlagObject *sensorFlagObj = [versionDataObj sensorTagObject];
        return sensorFlagObj;
    }
    return [FCSensorFlagObject objectWithData:nil];
}

- (FCPageDisplayFlagObject*)pageDisplayFlagObject
{
    if (_watchSetting)
    {
        FCVersionDataObject *versionDataObj = [_watchSetting versionObject];
        if (versionDataObj)
        {
            return [versionDataObj pageDisplayFlagObject];
        }
    }
    return [FCPageDisplayFlagObject objectWithData:nil];
}

- (FCScreenDisplayConfigObject*)screenDisplayConfigObject
{
    if (_watchSetting)
    {
        FCScreenDisplayConfigObject *sdObj = [_watchSetting watchScreenDisplayObject];
        return sdObj;
    }
    return [FCScreenDisplayConfigObject objectWithData:nil];
}


- (FCFeaturesObject*)featuresObject
{
    if (_watchSetting) {
        return [_watchSetting featuresObject];
    }
    return [FCFeaturesObject objectWithData:nil];
}
@end
