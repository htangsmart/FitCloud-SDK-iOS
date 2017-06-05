//
//  FCDayDetailsDB.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/6/5.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCDayDetailsDB.h"
#import "FCDayDetailsObject.h"
#import "FCDBEngine.h"


@implementation FCDayDetailsDB
+ (void)storeDayDetails:(id)dayDetails result:(void(^)(BOOL finished))retHandler
{
    if (!dayDetails || ![dayDetails isKindOfClass:[FCDayDetailsObject class]]) {
        NSLog(@"--configObj不可用--");
        if (retHandler) {
            retHandler(NO);
        }
        return;
    }
    FCDBEngine *dbEngine = [FCDBEngine engine];
    if (![dbEngine openDB]) {
        NSLog(@"--db打开错误--");
        if (retHandler) {
            retHandler(NO);
        }
        return;
    }

    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS DayDetails (timeStamp REAL, stepCount, calorie, distance, deepSleep, lightSleep, avgHeartRate)";
    if (![dbEngine.dataBase executeUpdate:createSQL]) {
        NSLog(@"--创建db失败--");
        if (retHandler) {
            retHandler(NO);
        }
        return;
    }
    
    
    
}

+ (void)fetchDayDetails:(NSDate*)date result:(void(^)(id dayDetails))retHandler
{
    
}
@end
