//
//  FCConfigManager.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCConfigManager.h"
#import <FitCloudKit.h>

@interface FCConfigManager ()
@property (nonatomic, strong) FCWatchSettingsObject *watchSetting;
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

#pragma mark - 从数据库加载手表配置

- (void)loadWatchSettingFromDB
{
    
}


- (void)updateConfigWithWatchSettingData:(NSData*)data
{
    if (!data || data.length < 53) {
        return;
    }
    _watchSetting = [FCWatchSettingsObject objectWithData:data];
    // 更新数据库
}


- (void)updateConfigWithVersionData:(NSData*)data
{
    if (!data || data.length < 32) {
        return;
    }
    _watchSetting.versionData = data;
    // 更新数据库
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

- (FCFeaturesObject*)featuresObject
{
    if (_watchSetting) {
        return [_watchSetting featuresObject];
    }
    return [FCFeaturesObject objectWithData:nil];
}
@end
