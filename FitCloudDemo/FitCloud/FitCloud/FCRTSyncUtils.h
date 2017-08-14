//
//  FCRTSyncUtils.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/9.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 实时同步结果解析类,提供心率、血氧、血压、呼吸频率等实时同步数据解析接口
 */
@interface FCRTSyncUtils : NSObject

/**
 解析心率实时同步结果

 @param data 实时同步数据
 @return 实时心率
 */
+ (NSNumber*)getRTHeartRateValue:(NSData*)data;

/**
 解析血氧实时同步结果

 @param data 实时同步数据
 @return 实时血氧
 */
+ (NSNumber*)getRTBloodOxygenValue:(NSData*)data;

/**
 获取血压实时同步结果

 @param data 实时同步数据
 @return 实时血压  @ {@"sbp":value,@"dbp":value}
 */
+ (NSDictionary*)getRTBloodPressureValue:(NSData*)data;

/**
 获取实时呼吸频率
 
 @param data 实时同步数据
 @return 实时呼吸频率
 */
+ (NSNumber*)getRTBreathingRateValue:(NSData*)data;


@end
