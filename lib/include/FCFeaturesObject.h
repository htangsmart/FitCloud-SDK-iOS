//
//  FCFeaturesObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"

/**
 手表功能开关设置对象
 */
@interface FCFeaturesObject : NSObject <FCObjectProtocal>

/**
 翻动手腕时点亮手表屏幕
 */
@property (nonatomic, assign) BOOL flipWristToLightScreen;

/**
 加强测量，心率等测量不出来时，手环会开启加强光反射
 */
@property (nonatomic, assign) BOOL enhanceMeasurementEnabled;

/**
 12小时时间制式，如果为NO，则使用24小时时间制式
 */
@property (nonatomic, assign) BOOL twelveHoursSystem;


/**
 距离和重量单位，0 为公制单位  1 英制单位
 */
@property (nonatomic, assign) BOOL isImperialUnits;
@end

