//
//  FCAlarmClockCycleObject+Category.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCAlarmClockCycleObject+Category.h"

@implementation FCAlarmClockCycleObject (Category)
- (NSString*)cycleDescription
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    if (self.monday)
    {
        [tmpArray addObject:@"周一"];
    }
    if (self.tuesday)
    {
        [tmpArray addObject:@"周二"];
    }
    if (self.wednesday)
    {
        [tmpArray addObject:@"周三"];
    }
    if (self.thursday)
    {
        [tmpArray addObject:@"周四"];
    }
    if (self.firday)
    {
        [tmpArray addObject:@"周五"];
    }
    if (self.saturday)
    {
        [tmpArray addObject:@"周六"];
    }
    if (self.sunday)
    {
        [tmpArray addObject:@"周日"];
    }
    
    if (tmpArray.count == 0)
    {
        return @"暂无";
    }
    
    if (tmpArray.count >= 7)
    {
        return @"每天";
    }
    NSString *cycle = [tmpArray componentsJoinedByString:@"、"];
    return cycle;
}

@end
