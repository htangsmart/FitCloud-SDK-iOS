//
//  FCScreenDisplayConfigObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"

/**
 手表屏幕显示配置，此配置用于发送到手表控制手表屏幕显示，屏幕显示设置项需要先根据传感器标志来判断，如果传感器标志功能不存在，则屏幕设置项需要设置为无效
 */
@interface FCScreenDisplayConfigObject : NSObject <NSCopying>
@property (nonatomic, assign) BOOL dateTime;
@property (nonatomic, assign) BOOL stepCount;
@property (nonatomic, assign) BOOL calorie;
@property (nonatomic, assign) BOOL distance;
@property (nonatomic, assign) BOOL sleep;
@property (nonatomic, assign) BOOL heartRate;
@property (nonatomic, assign) BOOL bloodOxygen;
@property (nonatomic, assign) BOOL bloodPressure;
@property (nonatomic, assign) BOOL weatherForecast;
@property (nonatomic, assign) BOOL findPhone;
@property (nonatomic, assign) BOOL displayId;
+ (instancetype)objectWithData:(NSData*)data;
- (NSData*)writeData;
@end
