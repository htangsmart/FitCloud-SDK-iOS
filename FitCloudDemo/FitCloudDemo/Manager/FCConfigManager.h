//
//  FCConfigManager.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FitCloudKit.h>

// 用于手表配置信息管理
@interface FCConfigManager : NSObject
@property (nonatomic, assign) BOOL sensorFlagUpdate;
@property (nonatomic, strong) FCWatchSettingsObject *watchSetting;

+ (instancetype)manager;

- (void)updateConfigWithWatchSettingData:(NSData*)data;
- (void)updateConfigWithVersionData:(NSData*)data;

/**
 默认血压

 @return key-value对象 {@"systolicBP":@(125),@"diastolicBP":@(80)}
 */
- (NSDictionary*)defaultBloodPressure;


/**
 喝水提醒

 @return YES/NO
 */
- (BOOL)isDrinkRemimdEnabled;


/**
 久坐提醒设置

 @return 久坐提醒对象
 */
- (FCSedentaryReminderObject*)sedentaryReminderObject;


/**
 健康实时监测

 @return 健康监测对象
 */
- (FCHealthMonitoringObject*)healthMonitoringObject;

/**
 获取消息通知开关设置

 @return 消息通知对象
 */
- (FCNotificationObject*)notificationObject;


/**
 获取传感器标志

 @return 传感器标志对象
 */
- (FCSensorFlagObject*)sensorFlagObject;


/**
 获取手环页面标志

 @return 手环页面标志对象
 */
- (FCPageDisplayFlagObject*)pageDisplayFlagObject;


/**
 手环Feature对象

 @return Feature对象
 */
- (FCFeaturesObject*)featuresObject;


@end
