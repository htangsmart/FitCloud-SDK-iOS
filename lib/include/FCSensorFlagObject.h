//
//  FCSensorFlagObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"


/**
 传感器标志。硬件号亦为手环传感器或功能标志位，组成的32bit，每个bit代表某一传感器或功能在该项目是否存在，手机APP根据该硬件号判断在手机APP上是否显示该功能和是否同步该项数据，详细请看下面定义
 */
@interface FCSensorFlagObject : NSObject <NSCopying>
@property (nonatomic, assign) BOOL heartRate;
@property (nonatomic, assign) BOOL ultraviolet;
@property (nonatomic, assign) BOOL weather;
@property (nonatomic, assign) BOOL bloodOxygen;
@property (nonatomic, assign) BOOL bloodPressure;
@property (nonatomic, assign) BOOL breathingRate;

/**
 心率加强监测，对于一些测不出心率的特殊人群，开启加强检测有助于心率测量
 */
@property (nonatomic, assign) BOOL enhanceMeasurement;

/**
 七天历史睡眠总数据,如果有此标志位，可以同步七天睡眠总数据
 */
@property (nonatomic, assign) BOOL sleepHistoryOfSevenDays;

/**
 心电功能标志
 */
@property (nonatomic, assign) BOOL ECG;

/**
 判断手表是否支持flashOTA升级
 */
@property (nonatomic, assign) BOOL flashOTA;

/**
 ANCS语言支持标识，此标志的固件可以把app系统语言发送到手表，手表ancs消息通知会显示对应的语言
 */
@property (nonatomic, assign) BOOL ancsLanguage;

/**
 喝水提醒和翻腕亮屏标志位
 */
@property (nonatomic, assign) BOOL drinkRemindAndFWTLS;

/**
 运动模式标志
 */
@property (nonatomic, assign) BOOL runingEnable;

/**
 日语字库
 */
@property (nonatomic, assign) BOOL ancsJapanese;

/**
 温度单位设置标志
 */
@property (nonatomic, assign) BOOL temperatureUnit;
+ (instancetype)objectWithData:(NSData*)data;
@end

