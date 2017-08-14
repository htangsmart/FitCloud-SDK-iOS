//
//  FCSysConfigUtils.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/6.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObject.h"


@interface FCSysConfigUtils : NSObject

#pragma mark - 系统设置

/**
 获取系统设置，系统设置数据包括消息通知开关配置、手环显示配置、手环功能开关配置、手环软硬件版本信息、健康定时检测开关、久坐提醒配置、默认血压、喝水提醒开关
 
 @param data 系统设置源数据
 @return 系统设置详细数据,value为<i>NSData</i>类型
 */
+ (NSDictionary*)getWatchSettingsFromSysConfig:(NSData*)data;



/**
 获取通知开关设置

 @param data 手表配置数据
 @return 通知开关设置对象模型
 */
+ (FCNotificationObject*)getNotificationFromSysConfig:(NSData*)data;



/**
 获取系统功能开关设置

 @param data 手表配置数据
 @return 功能开关设置对象模型
 */
+ (FCFeaturesObject*)getFeaturesFromSysConfig:(NSData*)data;



/**
 获取传感器标志

 @param data 手表配置数据
 @return 传感器标志对象模型
 */
+ (FCSensorFlagObject*)getSensorFlagFromSysConfig:(NSData*)data;



/**
 获取手表页面显示标志

 @param data 手表配置数据
 @return 页面显示标志对象模型
 */
+ (FCPageDisplayFlagObject*)getPageDisplayFromSysConfig:(NSData*)data;



/**
 获取久坐提醒设置

 @param data 手表配置数据
 @return 久坐提醒对象模型
 */
+  (FCSedentaryReminderObject*)getSedentaryReminderFromSysConfg:(NSData*)data;



#pragma mark - 获取默认血压

/**
 获取默认血压
 
 @param data 系统配置数据
 @return {
     @"systolicBP":120,
     @"diastolicBP":80
 }
 */
+ (NSDictionary*)getDefaultBloodPressureFromSysConfig:(NSData*)data;




#pragma mark - 固件版本

/**
 获取固件版本号信息字符串 eg。 01.3457.11
 注：此字符串用户固件版本显示
 
 @param data 手表配置数据
 @return 固件版本号信息字符串
 */
+ (NSString*)getFirmwareVersionNumFromSysConfig:(NSData*)data;



/**
 获取固件版本号信息字符串 eg。 01.3457.11
 注：此字符串用户固件版本显示

 @param versionString 固件版本信息字符串
 @see getFirmwareVersionInfoStringFromSysConfig:
 @return 固件版本号信息字符串
 */
+ (NSString*)getFirmwareVersionNumFromVersionString:(NSString*)versionString;



/**
 获取固件信息字符串 eg。 003020000203040540020020
 注：此字符串用户固件升级新版本检查

 @param data 手表配置数据
 @return 固件信息字符串
 */
+ (NSString*)getFirmwareVersionInfoStringFromSysConfig:(NSData*)data;



/**
 获取软硬件版本信息详细数据
 
 @param data 软硬件版本信息数据
 @return {
     @“fwNumberData”:data,
     @"sensorTagData":data,
     @"pageDisplayData":data,
     @"patchData":data,
     @"flashData":data,
     @"fwAppData":data,
     @"timeSeqNumData":data
 }
 */
+ (NSDictionary*)getFirmwareVersionDetailedDataFromVersionData:(NSData*)data;



/**
 获取软硬件版本信息详细字符串
 
 @param data 软硬件版本信息数据
 @return {
     @“fwNumberData”:string,
     @"sensorTagData":string,
     @"pageDisplayData":string,
     @"patchData":string,
     @"flashData":string,
     @"fwAppData":string,
     @"timeSeqNumData":string
 }
 */
+ (NSDictionary*)getFirmwareVersionDetailedStringFromVersionData:(NSData*)data;



#pragma mark - 闹钟

/**
 获取闹钟列表，最多可以设置8个无重复的闹钟

 @param data 闹钟配置数据
 @return 包含<i>FCAlarmClockObject</i>对象闹钟列表
 */
+ (NSArray*)getAlarmClockListFromData:(NSData*)data;



/**
 将闹钟列表转换为闹钟配置数据。用户闹钟同步

 @param array 包含<i>FCAlarmClockObject</i>对象的闹钟数组
 @return 闹钟配置数据
 */
+ (NSData*)getAlarmClockConfigDataFromArray:(NSArray*)array;
@end
