//
//  FCRTSyncUtils.m
//  FitCloud
//
//  Created by 远征 马 on 2017/8/9.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCRTSyncUtils.h"

@implementation FCRTSyncUtils
+ (NSNumber*)getRTHeartRateValue:(NSData*)data
{
    if (!data || data.length < 7) {
        return nil;
    }
    Byte byte[1] = {0};
    [data getBytes:byte range:NSMakeRange(data.length-5, 1)];
    return @(byte[0]);
}

+ (NSNumber*)getRTBloodOxygenValue:(NSData*)data
{
    if (!data || data.length < 7) {
        return nil;
    }
    Byte byte[1] = {0};
    [data getBytes:byte range:NSMakeRange(data.length-4, 1)];
    return @(byte[0]);
}


+ (NSDictionary*)getRTBloodPressureValue:(NSData*)data
{
    if (!data || data.length < 7) {
        return nil;
    }
    Byte byte[2] = {0};
    [data getBytes:byte range:NSMakeRange(data.length-3, 2)];
    return @{@"sbp":@(byte[1]),@"dbp":@(byte[0])};
}

+ (NSNumber*)getRTBreathingRateValue:(NSData*)data
{
    if (!data || data.length < 7) {
        return nil;
    }
    Byte byte[1] = {0};
    [data getBytes:byte range:NSMakeRange(data.length-1, 1)];
    return @(byte[0]);
}
@end
