//
//  FCSyncUtils.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/9.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCAlarmClock.h"

/**
 运动数据同步结果解析
 */
@interface FCSyncUtils : NSObject


#pragma mark - 获取日总数据详细
/**
 获取当日多项总数据记录，包括总步数、总距离、总卡路里、深睡眠时长、浅睡眠时长、平均心率
 返回结果：{
     "stepCount": 0, // 步数,单位 步
     "distance": 0, // 距离，单位 m
     "calorie": 0, // 卡路里， 单位 cal
     "deepSleep": 0, // 深睡眠， 单位 min
     "lightSleep": 0,// 浅睡眠， 单位 min
     "avgHeartRate": 0, // 评价心率， 单位 次/分
 }
 
 
 @param data 手表返回的日总数据
 @return 日总数据详细记录
 */

+ (NSDictionary*)getDaySummary:(NSData*)data;


#pragma mark - 七日睡眠总数据详细
/**
 获取七日内的睡眠总数据，手表返回七天或者少于7天的睡眠时长数据
 注意：只返回睡眠总时长（深睡眠时长+浅睡眠时长）大于0的日总睡眠记录
 返回结果：[{
     @"timeStamp":时间戳,
     @"deepSleep":深睡眠,
     @"lightSleep":浅睡眠
 },....];
 @param data 睡眠总数据
 @return 七日睡眠记录
 */

+ (NSArray*)getSevenDaysSleepTotalData:(NSData*)data;


#pragma mark - 获取运动量详细记录

/**
 获取运动量的详细记录（每五分钟一个数据）

 @param data 运动同步返回数据
 @return 包含<i>FCDataObject</i>对象的数组
 */
+ (NSArray*)getRecordsOfExercise:(NSData*)data;


#pragma mark - 获取睡眠的详细记录

/**
 获取睡眠详细记录（每五分钟一个数据）

 @param data 睡眠同步返回数据
 @return 包含<i>FCDataObject</i>对象的数组
 */
+ (NSArray*)getRecordsOfSleep:(NSData*)data;



#pragma mark - 获取心率详细记录

/**
 获取心率详细记录（每五分钟一个数据）
 
 @param data 心率同步返回数据
 @return 包含<i>FCDataObject</i>对象的数组
 */
+ (NSArray*)getRecordsOfHeartRate:(NSData*)data;



#pragma mark - 获取血氧详细记录


/**
 获取血氧详细记录（每五分钟一个数据）
 
 @param data 血氧同步返回数据
 @return 包含<i>FCDataObject</i>对象的数组
 */
+ (NSArray*)getRecordsOfBloodOxygen:(NSData*)data;


#pragma mark - 获取血压详细记录

/**
 获取血压详细记录（每五分钟一个数据）

 @param data 血压同步数据返回
 @param systolicBP 收缩压参考值
 @param diastolicBP 舒张压参考值
 @return 包含<i>FCDataObject</i>对象的数组
 */
+ (NSArray*)getRecordsOfBloodPressure:(NSData*)data systolicBP:(UInt16)systolicBP diastolicBP:(UInt16)diastolicBP;


#pragma mark - 获取呼吸频率详细记录

/**
 获取呼吸频率详细记录（每五分钟一个数据）

 @param data 呼吸频率同步返回数据
 @return 包含<i>FCDataObject</i>对象的数组
 */
+ (NSArray*)getRecordsOfBreathingRate:(NSData*)data;



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
+ (NSData*)alarmClockDataFromAlarmList:(NSArray<FCAlarmClockObject*>*)array;
@end
