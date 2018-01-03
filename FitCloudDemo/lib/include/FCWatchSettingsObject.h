//
//  FCWatchSettingsObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"
#import "FCPageDisplayFlagObject.h"
#import "FCScreenDisplayConfigObject.h"
#import "FCNotificationObject.h"
#import "FCFeaturesObject.h"
#import "FCVersionDataObject.h"
#import "FCHealthMonitoringObject.h"
#import "FCSensorFlagObject.h"
#import "FCSedentaryReminderObject.h"


/**
 手表配置
 注：此对象可以弃用，存储时直接存储系统配置二进制数据
 */
@interface FCWatchSettingsObject : NSObject <FCObjectProtocal>

/**
 消息通知开关配置 4byte
 
 @see FCNotificationObject
 */
@property (nonatomic, strong) NSData *nfSettingData;

/**
 手表屏幕显示设置 2byte
 
 @see FCScreenDisplayConfigObject
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

/**
 通知消息对象。
 
 @return 通知消息对象
 */
- (FCNotificationObject*)messageNotificationObject;


/**
 手环显示设置对象，其属性能否修改由<i>FCPageDisplayFlagObject</i>对应属性决定
 
 @return 显示设置对象
 */
- (FCScreenDisplayConfigObject*)watchScreenDisplayObject;

/**
 手表功能特征参数
 
 @return 功能特征模型
 */
- (FCFeaturesObject*)featuresObject;

/**
 手表固件版本信息
 
 @return 固件版本信息对象模型
 */
- (FCVersionDataObject*)versionObject;

- (FCHealthMonitoringObject*)healthMonitoringObject;

- (FCSedentaryReminderObject*)sedentaryReminderObject;

- (NSDictionary*)defaultBloodPressure;

- (BOOL)drinkRemindEnabled;
@end

