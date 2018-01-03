//
//  FCWatchConfigUtils.h
//  FitCloud
//
//  Created by 马远征 on 2017/11/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCScreenDisplayConfigObject.h"
#import "FCNotificationObject.h"
#import "FCPageDisplayFlagObject.h"
#import "FCFeaturesObject.h"
#import "FCHealthMonitoringObject.h"
#import "FCSedentaryReminderObject.h"
#import "FCSensorFlagObject.h"
#import "FCDrinkRemindObject.h"
#import "FCFlipWristToLightUpScreenObject.h"
#import "FCSensorFlagObject.h"


/**
 手表数据配置类型
 */
typedef NS_ENUM(NSInteger, WatchConfigType)
{
    /*! 未知类型*/
    WatchConfigTypeUnknown,
    /*! 消息通知*/
    WatchConfigTypeNotification,
    /*! 屏幕显示配置*/
    WatchConfigTypeScreenDisplayConfig,
    /*! 功能开关配置*/
    WatchConfigTypeFeatures,
    /*! 健康监测*/
    WatchConfigTypeHealthMonitoring,
    /*! 久坐提醒*/
    WatchConfigTypeSendentaryReminder,
    /*! 默认血压*/
    WatchConfigTypeDefaultBloodPressure,
    /*! 喝水提醒*/
    WatchConfigTypeDrinkWaterReminder,
    /*! 带时间设置的喝水提醒*/
    WatchConfigTypeDrinkWaterReminderWithTime,
    /*! 翻腕亮屏*/
    WatchConfigTypeTurnWristToLightUpScreen,
    /*! 固件版本*/
    WatchConfigTypeFirmwareVersion,
};



/**
 手表配置解析与更新
 */
@interface FCWatchConfigUtils : NSObject


/**
 更新手环系统配置
 注：为了适应后续的协议变化使用时直接将手表系统配置Data以BLOB的方式存储到数据库，如果配置有更新，则通过此接口更新配置并保存新的系统配置到数据库

 @param watchConfigData 待更新的手环系统配置
 @param data 新的数据配置
 @param dataType 更新数据类型
 @return 更新后的手环系统配置（如果更新异常，则返回watchConfigData）
 */
+ (NSData*)updateWatchConfig:(NSData*)watchConfigData withData:(NSData*)data andDataType:(WatchConfigType)dataType;


#pragma mark - 消息通知
/**
 获取消息通知开关

 @param data 手表系统设置
 @return <i>FCNotificationObject</i>对象
 */
+ (FCNotificationObject*)notificationFromWatchConfig:(NSData*)data;


#pragma mark - 屏幕显示配置
/**
 获取手环当前屏幕显示配置

 @param data 手表系统设置
 @return <i>FCScreenDisplayConfigObject</i>对象
 */
+ (FCScreenDisplayConfigObject*)getScreenDisplayConfigFromWatchConfig:(NSData*)data;



#pragma mark - 功能开关配置
/**
 获取手环功能开关配置

 @param data 手环系统配置
 @return <i>FCFeaturesObject</i>对象
 */
+ (FCFeaturesObject*)featuresFromWatchConfig:(NSData*)data;



#pragma mark - 传感器标志
/**
 获取传感器标志位配置
 
 @param data 手环系统社会组
 @return <i>FCSensorFlagObject</i>对象
 */
+ (FCSensorFlagObject*)sensorFlagFromWatchConfig:(NSData*)data;


/**
 获取手环页面标号配置（此页面标号决定手环屏幕显示设置）
 
 @param data 手环系统配置
 @return <i>FCPageDisplayFlagObject</i>对象
 */
+ (FCPageDisplayFlagObject*)getPageDisplayFlagFromWatchConfig:(NSData*)data;



#pragma mark - 版本号

/**
 获取固件信息字符串 eg。 003020000203040540020020...
 注：此字符串用户固件升级新版本检查
 
 @param data 手环系统设置
 @return 固件信息字符串
 */
+ (NSString*)hardwareVersionFromWatchConfig:(NSData*)data;


/**
 获取固件版本号 eg。 01.3457.11
 注：此字符串用于固件版本显示
 
 @param data 手环系统设置
 @return 格式化的固件版本号
 */
+ (NSString*)getFirmwareDisplayVersionFromWatchConfig:(NSData*)data;


/**
 获取手表patchApp版本号

 @param data 手环系统设置
 @return patchApp Version 字符串
 */
+ (NSString*)getPatchAppVersionFromWatchConfig:(NSData*)data;


/**
 获取手环的flash版本号

 @param data 手环系统设置
 @return flash version
 */
+ (NSString*)getFlashVersionFromWatchConfig:(NSData*)data;


/**
 获取固件app版本号

 @param data 手环系统配置
 @return firmware version
 */
+ (NSString*)getFirmwareAppVersionFromWatchConfig:(NSData*)data;


#pragma mark - 健康定时监测

/**
 获取健康定时检测配置

 @param data 手环系统配置
 @return <i>FCHealthMonitoringObject</i>对象
 */
+ (FCHealthMonitoringObject*)healthMonitoringFromWatchConfig:(NSData*)data;


#pragma mark - 久坐提醒

/**
 获取手环久坐提醒配置

 @param data 手环系统配置
 @return <i>FCSedentaryReminderObject</i>对象
 */
+ (FCSedentaryReminderObject*)sendentaryReminderFromWatchConfig:(NSData*)data;


#pragma mark - 默认血压
/**
 获取手环默认血压配置
 
 @param data 系统配置数据
 @return
 {
    @"systolicBP":125,
    @"diastolicBP":80
 }
 注：如果解析出错，则返回默认值
 */
+ (NSDictionary*)defaultBloodPressureFromWatchConfig:(NSData*)data;




#pragma mark - 喝水提醒

/**
 获取喝水提醒开关配置

 @param data 手环系统配置
 @return YES/NO
 */
+ (BOOL)drinkWatchReminderEnableFromWatchConfig:(NSData*)data;



/**
 获取喝水提醒配置
 注：此处的喝水提醒配置带时间设置，部分低版本固件或旧硬件没有此功能，将会返回空数据
 UI应该根据<i>FCSensorFlagObject</i>的drinkRemindAndFWTLS来判断是否支持新的喝水提醒协议

 @param data 手表系统设置
 @return <i>FCDrinkRemindObject</i>对象
 */
+ (FCDrinkRemindObject*)drinkWaterReminderFromWatchConfig:(NSData*)data;



#pragma mark - 翻腕亮屏
/**
 获取翻腕亮屏配置
 注：此功能在部分低版本固件或旧硬件上不可用，将会返回空数据
 UI应该根据<i>FCSensorFlagObject</i>的drinkRemindAndFWTLS来判断是否支持新的翻腕亮屏协议
 
 
 @param data 手表系统设置
 @return <i>FCFlipWristToLightUpScreenObject</i>对象
 */
+ (FCFlipWristToLightUpScreenObject*)flipWristToLightUpScreenFromWatchConfig:(NSData*)data;
@end
