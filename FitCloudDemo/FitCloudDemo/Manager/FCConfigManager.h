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

+ (instancetype)manager;


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
