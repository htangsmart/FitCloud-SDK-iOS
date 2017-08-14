//
//  FitCloudUtils.m
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "FitCloudUtils.h"
#import "FCObject.h"
#import "NSDate+FitCloud.h"
#import "FitCloud.h"
#import <sys/utsname.h>
#import "NSMutableDictionary+FCCategory.h"


@implementation FitCloudUtils


+ (BOOL)is12HourSystem
{
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location!=NSNotFound;
    if (hasAMPM)
    {
        NSLog(@"为12小时制");
    }
    else
    {
        NSLog(@"为24小时制");
    }
    return hasAMPM;
}


+ (NSDictionary*)getBatteryLevelAndChargingState:(NSData *)data
{
    if (!data || data.length < 2) {
        return nil;
    }
    Byte *byte = (Byte*)[data bytes];
    UInt16 batteryPercentage = byte[0];
    UInt16 chargingState = byte[1];
    return @{@"batteryLevel":@(batteryPercentage),@"state":@(chargingState)};
}

#pragma mark - 卡路里计算

+ (CGFloat)caloriesFromSteps:(UInt32)stepCount weight:(UInt32)weight height:(UInt32)height isBoy:(BOOL)isBoy
{
    // 计算距离，单位公里 =（步距（身高（米) * 性别系数）x 步数）/1000
    CGFloat factor = isBoy ? 0.415 : 0.413;
    CGFloat stepSize =  (height * factor)/100;
    CGFloat distance = stepSize * stepCount;
    CGFloat calorie = weight * 0.78 * distance;
    return calorie/1000;
}


#pragma mark - 距离计算

+ (CGFloat)distanceFromSteps:(UInt32)stepCount height:(UInt32)height isBoy:(BOOL)isBoy
{
    // 计算距离，单位公里 =（步距（身高（米) * 性别系数）x 步数）/1000
    CGFloat factor = isBoy ? 0.415 : 0.413;
    CGFloat stepSize =  (height * factor)/100;
    // 返回千米
    CGFloat distance = stepSize * stepCount;
    return distance/1000;
}


#pragma mark - 手机信息

+ (NSNumber*)getPhoneModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"])
        return @(2); //return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"])
        return @(3); //return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"])
        return @(4); // return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] ||
        [platform isEqualToString:@"iPhone3,3"])
        return @(5); // return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"])
        return @(6); //return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"])
        return @(7); //return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"])
        return @(8); //return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"])
        return @(9); //return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"])
        return @(11); //return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"])
        return @(10); //return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"])
        return @(12); //return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"])
        return @(13); //return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"])
        return @(14); //return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"])
        return @(15); //return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"])
        return @(16); //return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])
        return @(55); //return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])
        return @(56); //return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])
        return @(57); //return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])
        return @(58); //return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])
        return @(59); //return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])
        return @(31); //return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] ||
        [platform isEqualToString:@"iPad2,3"] || [platform isEqualToString:@"iPad2,4"])
        return @(32); //return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] ||
        [platform isEqualToString:@"iPad2,7"])
        return @(35); //return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] ||
        [platform isEqualToString:@"iPad3,3"])
        return @(33); //return @"iPad 3";
    
    
    if ([platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] ||
        [platform isEqualToString:@"iPad3,6"])
        return @(34); //return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"] || [platform isEqualToString:@"iPad4,2"] ||
        [platform isEqualToString:@"iPad4,3"])
        return @(36); // return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] ||
        [platform isEqualToString:@"iPad4,6"])
        return @(37); //return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"] || [platform isEqualToString:@"iPad4,8"] ||
        [platform isEqualToString:@"iPad4,9"])
        return @(39); //return @"iPad Mini 3G";
    
    if ([platform isEqualToString:@"iPad5,1"] || [platform isEqualToString:@"iPad5,2"])
        return @(41); //return @"iPad mini 4";
    
    if ([platform isEqualToString:@"iPad5,3"] || [platform isEqualToString:@"iPad5,4"])
        return @(38); //return @"iPad Air2";
    
    return @(0);
}

+ (NSNumber*)getOsVersion
{
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    if ([phoneVersion isEqualToString:@"10.1.1"] || [phoneVersion isEqualToString:@"10.1"] ||
        [phoneVersion isEqualToString:@"10.0.2"] || [phoneVersion isEqualToString:@"10.0"]) {
        return @12;
    }
    else if ([phoneVersion isEqualToString:@"9.3.5"] || [phoneVersion isEqualToString:@"9.3.4"] ||
             [phoneVersion isEqualToString:@"9.3.3"] || [phoneVersion isEqualToString:@"9.3.2"] ||
             [phoneVersion isEqualToString:@"9.3.1"])
    {
        return @11;
    }
    else if ([phoneVersion isEqualToString:@"9.2.1"] || [phoneVersion isEqualToString:@"9.2"])
    {
        return @10;
    }
    else if ([phoneVersion isEqualToString:@"9.1"])
    {
        return @9;
    }
    else if ([phoneVersion isEqualToString:@"9.0.2"] || [phoneVersion isEqualToString:@"9.0.1"] ||
             [phoneVersion isEqualToString:@"9.0"])
    {
        return @8;
    }
    else if ([phoneVersion isEqualToString:@"8.4.1"] || [phoneVersion isEqualToString:@"8.4"])
    {
        return @7;
    }
    else if ([phoneVersion isEqualToString:@"8.3"])
    {
        return @6;
    }
    else if ([phoneVersion isEqualToString:@"8.2"])
    {
        return @5;
    }
    else if ([phoneVersion isEqualToString:@"8.1.3"] || [phoneVersion isEqualToString:@"8.1.2"] || [phoneVersion isEqualToString:@"8.1.1"] || [phoneVersion isEqualToString:@"8.1"])
    {
        return @4;
    }
    else if ([phoneVersion isEqualToString:@"8.0.2"])
    {
        return @3;
    }
    else if ([phoneVersion isEqualToString:@"8.0"])
    {
        return @3;
    }
    return @0;
}



@end
