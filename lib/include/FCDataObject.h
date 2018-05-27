//
//  FCDataObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCDefine.h"


/**
 手表同步数据模型
 */
@interface FCDataObject : NSObject

/**
 数据类型，用于区分不同的数据，详细见<i>FCDataType</i>
 */
@property (nonatomic, assign) FCDataType DataType;

/**
 自1970开始的时间戳
 */
@property (nonatomic, strong) NSNumber *timeStamp;

/**
 运动和健康数据，dataType为一下类型时分别对应一下数据
 <i>FCDataTypeExercise</i>：value为运动的步数；
 <i>FCDataTypeSleep</i>：value为睡眠状态（1：深睡眠 2：浅睡眠 3：清醒）；
 <i>FCDataTypeHeartRate</i>：value为平均心率；
 <i>FCDataTypeBloodOxygen</i>：value为血氧数值；
 <i>FCDataTypeBloodPressure</i>：value为收缩压，extravalue为舒张压；
 <i>FCDataTypeBreathingRate</i>：value为呼吸频率
 */
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSNumber *extraValue;


// 下面两个属性在FCDataTypeExercise类型时有效
@property (nonatomic, strong) NSNumber *calorie; // 千卡
@property (nonatomic, strong) NSNumber *distance; // 公里
@end

