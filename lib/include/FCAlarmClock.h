//
//  FCAlarmClock.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"


#pragma mark - FCAlarmClockCycleObject

/**
 闹钟周期, 如果周一到周日无设置，则表示闹钟当日有效
 */
@interface FCAlarmClockCycleObject : NSObject
@property (nonatomic, assign) BOOL monday;
@property (nonatomic, assign) BOOL tuesday;
@property (nonatomic, assign) BOOL wednesday;
@property (nonatomic, assign) BOOL thursday;
@property (nonatomic, assign) BOOL firday;
@property (nonatomic, assign) BOOL saturday;
@property (nonatomic, assign) BOOL sunday;

/**
 通过闹钟周期<i>cycleValue</i>初始化<i>FCCycleOfAlarmClockObject</i>对象
 
 @param cycleValue 闹钟周期数值
 @return <i>FCCycleOfAlarmClockObject</i> 实例对象
 */
+ (instancetype)cycleWithValue:(NSNumber*)cycleValue;

/**
 获取闹钟周期数值（7 bits），从低位到高位表示周一到周日；如果所有字节为0，则表示闹钟当日有效.
 
 @return 闹钟周期数值
 */
- (NSNumber*)cycleValue;
@end




#pragma mark - FCAlarmClockObject

/**
 闹钟对象
 */
@interface FCAlarmClockObject : NSObject <FCObjectProtocal>
@property (nonatomic, strong) NSNumber *alarmId;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *hour;
@property (nonatomic, strong) NSNumber *minute;
@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, strong) NSNumber *cycle;
@property (nonatomic, strong) FCAlarmClockCycleObject *cycleObject;

/**
 响铃时间
 
 @return 响铃时间字符串 格式："HH: mm"
 */
- (NSString*)ringTime;
@end

