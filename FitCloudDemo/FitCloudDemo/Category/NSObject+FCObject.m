//
//  NSObject+FCObject.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "NSObject+FCObject.h"

@implementation FCSedentaryReminderObject (Category)

- (NSString*)stMinuteString
{
    int hour = (int)floorf(self.stMinute /60);
    int minute = self.stMinute % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

- (NSString*)edMinuteString
{
    int hour = (int)floorf(self.edMinute /60);
    int minute = self.edMinute % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}
@end

@implementation FCHealthMonitoringObject (Category)

- (NSString*)stMinuteString
{
    int hour = (int)floorf(self.stMinute /60);
    int minute = self.stMinute % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

- (NSString*)edMinuteString
{
    int hour = (int)floorf(self.edMinute /60);
    int minute = self.edMinute % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}
@end


@implementation FCSensorFlagObject (Category)

- (NSUInteger)countOfItems
{
    NSUInteger count = 2;
    if (self.heartRate)
    {
        count += 1;
    }
    if (self.ultraviolet)
    {
        count += 1;
    }
    
    if (self.bloodOxygen) {
        count += 1;
    }
    
    if (self.bloodPressure) {
        count += 1;
    }
    
    if (self.breathingRate) {
        count += 1;
    }
    
    if (self.ECG) {
        count += 1;
    }
    
    return count;
}

- (NSArray*)itemNameArray
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    [tmpArray addObject:@"运动"];
    [tmpArray addObject:@"睡眠"];
    if (self.heartRate)
    {
        [tmpArray addObject:@"心率"];
    }
    if (self.ultraviolet)
    {
        [tmpArray addObject:@"紫外线"];
    }
    
    if (self.bloodOxygen) {
        [tmpArray addObject:@"血氧"];
    }
    
    if (self.bloodPressure) {
        [tmpArray addObject:@"血压"];
    }
    
    if (self.breathingRate) {
        [tmpArray addObject:@"呼吸频率"];
    }
    
    if (self.ECG) {
        [tmpArray addObject:@"心电"];
    }
    return [NSArray arrayWithArray:tmpArray];
}

@end

@implementation NSObject (FCObject)

@end
