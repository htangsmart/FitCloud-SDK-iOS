//
//  FCPageDisplayFlagObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"

/*!
 手环页面标号。手环页面标号为该项目手环上能显示的所有页面的标志，共32bit，每个bit代表一个页面，
 手机APP上根据该标号来确定有哪些显示页面可以给用户设置，具体每一位代表哪一个页面请看下面定义
 */
@interface FCPageDisplayFlagObject : NSObject
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
@end
