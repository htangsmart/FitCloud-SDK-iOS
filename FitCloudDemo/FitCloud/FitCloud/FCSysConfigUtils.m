//
//  FCSysConfigUtils.m
//  FitCloud
//
//  Created by 远征 马 on 2017/8/6.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSysConfigUtils.h"
#import "NSMutableDictionary+FCCategory.h"


@implementation FCSysConfigUtils

#pragma mark - 获取手表系统设置

+ (NSDictionary*)getWatchSettingsFromSysConfig:(NSData*)data
{
    if (!data || data.length < 53) {
        return nil;
    }
    Byte *byte = (Byte*)[data bytes];
    NSData *nfSetting = [NSData dataWithBytes:&byte[0] length:4];
    NSData *displayData = [NSData dataWithBytes:&byte[4] length:2];
    NSData *fcSwitchData = [NSData dataWithBytes:&byte[6] length:2];
    NSData *versionData = [NSData dataWithBytes:&byte[8] length:32];
    NSData *hMonitorData = [NSData dataWithBytes:&byte[40] length:5];
    NSData *sedentaryReminderData = [NSData dataWithBytes:&byte[45] length:5];
    NSData *bpData = [NSData dataWithBytes:&byte[50] length:2];
    NSData *drinkData = [NSData dataWithBytes:&byte[52] length:1];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params fcSetNotNilData:nfSetting forKey:@"notification"];
    [params fcSetNotNilData:displayData forKey:@"screenDisplay"];
    [params fcSetNotNilData:fcSwitchData forKey:@"functionSwitch"];
    [params fcSetNotNilData:versionData forKey:@"version"];
    [params fcSetNotNilData:hMonitorData forKey:@"healthMonitoring"];
    [params fcSetNotNilData:sedentaryReminderData forKey:@"sedentaryReminder"];
    [params fcSetNotNilData:bpData forKey:@"defaultBloodPressure"];
    [params fcSetNotNilData:drinkData forKey:@"drinkReminder"];
    return [NSDictionary dictionaryWithDictionary:params];
}

+ (FCNotificationObject*)getNotificationFromSysConfig:(NSData*)data
{
    if (!data || data.length < 53)
    {
        return [FCNotificationObject objectWithData:nil];
    }
    
    NSData *subData = [data subdataWithRange:NSMakeRange(0, 4)];
    return [FCNotificationObject objectWithData:subData];
}



+ (FCFeaturesObject*)getFeaturesFromSysConfig:(NSData*)data
{
    if (!data || data.length < 53) {
        return [FCFeaturesObject objectWithData:nil];
    }
    
    NSData *subData = [data subdataWithRange:NSMakeRange(6, 2)];
    return [FCFeaturesObject objectWithData:subData];
}


+ (FCSensorFlagObject*)getSensorFlagFromSysConfig:(NSData*)data
{
    if (!data || data.length < 53) {
        return [FCSensorFlagObject objectWithData:nil];
    }
    
    NSData *subData = [data subdataWithRange:NSMakeRange(14, 4)];
    return [FCSensorFlagObject objectWithData:subData];
}


+ (FCPageDisplayFlagObject*)getPageDisplayFromSysConfig:(NSData*)data
{
    if (!data || data.length < 53) {
        return [FCPageDisplayFlagObject objectWithData:nil];
    }
    
    NSData *subData = [data subdataWithRange:NSMakeRange(18, 4)];
    return [FCPageDisplayFlagObject objectWithData:subData];
}


+  (FCSedentaryReminderObject*)getSedentaryReminderFromSysConfg:(NSData*)data
{
    if (!data || data.length < 53) {
        return [FCSedentaryReminderObject objectWithData:nil];
    }
    
    NSData *subData = [data subdataWithRange:NSMakeRange(45, 5)];
    return [FCSedentaryReminderObject objectWithData:subData];
}

#pragma mark - 获取默认血压

+ (NSDictionary*)getDefaultBloodPressureFromSysConfig:(NSData*)data
{
    if (data && data.length >= 2)
    {
        Byte byte[2] = {0};
        [data getBytes:byte range:NSMakeRange(0, 2)];
        return @{@"systolicBP":@(byte[1]),@"diastolicBP":@(byte[0])};
    }
    return @{@"systolicBP":@(125),@"diastolicBP":@(80)};
}

#pragma mark - 固件信息

+ (NSString*)getFirmwareVersionNumFromSysConfig:(NSData*)data
{
    NSString *versionString = [self getFirmwareVersionInfoStringFromSysConfig:data];
    return [self getFirmwareVersionNumFromVersionString:versionString];
}

+ (NSString*)getFirmwareVersionNumFromVersionString:(NSString*)versionString
{
    if (!versionString || versionString.length < 64) {
        return nil;
    }
    
    NSString *prjNOString = [versionString substringWithRange:NSMakeRange(0, 12)];
    NSUInteger location = 0;
    while (location < prjNOString.length) {
        NSString *subString = [prjNOString substringWithRange:NSMakeRange(location, 1)];
        if ([subString isEqualToString:@"0"]) {
            location += 1;
        }
        else
        {
            break;
        }
    }
    if (location < prjNOString.length) {
        prjNOString = [prjNOString substringFromIndex:location];
    }
    else
    {
        prjNOString = @"";
    }
    
    NSString *patchString = [versionString substringWithRange:NSMakeRange(36, 4)];
    NSString *appVersionString = [versionString substringWithRange:NSMakeRange(48, 8)];
    location = 0;
    while (location < appVersionString.length)
    {
        NSString *subString = [appVersionString substringWithRange:NSMakeRange(location, 1)];
        if ([subString isEqualToString:@"0"]) {
            location += 1;
        }
        else
        {
            break;
        }
    }
    
    if (location < appVersionString.length) {
        appVersionString = [appVersionString substringFromIndex:location];
    }
    else
    {
        appVersionString = @"";
    }
    return [NSString stringWithFormat:@"%@.%@.%@",prjNOString,patchString,appVersionString];
}


+ (NSString*)getFirmwareVersionInfoStringFromSysConfig:(NSData*)data
{
    if (!data || data.length < 53) {
        return nil;
    }
    Byte *byte = (Byte*)[data bytes];
    NSData *versionData = [NSData dataWithBytes:&byte[8] length:32];
    NSString *versionDes = [versionData.description stringByReplacingOccurrencesOfString:@"<" withString:@""];
    versionDes = [versionDes stringByReplacingOccurrencesOfString:@">" withString:@""];
    versionDes = [versionDes stringByReplacingOccurrencesOfString:@" " withString:@""];
    return versionDes;
}

+ (NSString*)bytesStringWithData:(NSData*)data
{
    if (!data) {
        return nil;
    }
    NSString *description = data.description;
    description = [description stringByReplacingOccurrencesOfString:@" " withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@">" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"<" withString:@""];
    return description;
}

+ (NSDictionary*)getFirmwareVersionDetailedDataFromVersionData:(NSData*)data
{
    if (data && data.length >= 32)
    {
        Byte *vsByte = (Byte*)[data bytes];
        NSData *fwNumberData = [NSData dataWithBytes:&vsByte[0] length:6];
        NSData *sensorTagData = [NSData dataWithBytes:&vsByte[6] length:4];
        NSData *pageDisplayData = [NSData dataWithBytes:&vsByte[10] length:4];
        NSData *patchData = [NSData dataWithBytes:&vsByte[14] length:6];
        NSData *flashData = [NSData dataWithBytes:&vsByte[20] length:4];
        NSData *fwAppData = [NSData dataWithBytes:&vsByte[24] length:4];
        NSData *timeSeqNumData = [NSData dataWithBytes:&vsByte[28] length:4];
        
        NSString *fwNumber = [self bytesStringWithData:fwNumberData];
        NSString *sensorTag = [self bytesStringWithData:sensorTagData];
        NSString *pageDisplay = [self bytesStringWithData:pageDisplayData];
        NSString *patch = [self bytesStringWithData:patchData];
        NSString *flash = [self bytesStringWithData:flashData];
        NSString *fwApp = [self bytesStringWithData:fwAppData];
        NSString *timeSeqNum = [self bytesStringWithData:timeSeqNumData];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params fcSetNotNilString:fwNumber forKey:@"fwNumber"];
        [params fcSetNotNilString:sensorTag forKey:@"sensorTag"];
        [params fcSetNotNilString:pageDisplay forKey:@"pageDisplay"];
        [params fcSetNotNilString:patch forKey:@"patch"];
        [params fcSetNotNilString:flash forKey:@"flash"];
        [params fcSetNotNilString:fwApp forKey:@"fwApp"];
        [params fcSetNotNilString:timeSeqNum forKey:@"timeSeqNum"];
        return [NSDictionary dictionaryWithDictionary:params];
    }
    return nil;
}



+ (NSDictionary*)getFirmwareVersionDetailedStringFromVersionData:(NSData*)data
{
    if (data && data.length >= 32)
    {
        Byte *vsByte = (Byte*)[data bytes];
        NSData *fwNumberData = [NSData dataWithBytes:&vsByte[0] length:6];
        NSData *sensorTagData = [NSData dataWithBytes:&vsByte[6] length:4];
        NSData *pageDisplayData = [NSData dataWithBytes:&vsByte[10] length:4];
        NSData *patchData = [NSData dataWithBytes:&vsByte[14] length:6];
        NSData *flashData = [NSData dataWithBytes:&vsByte[20] length:4];
        NSData *fwAppData = [NSData dataWithBytes:&vsByte[24] length:4];
        NSData *timeSeqNumData = [NSData dataWithBytes:&vsByte[28] length:4];
        
        NSString *fwNumber = [self bytesStringWithData:fwNumberData];
        NSString *sensorTag = [self bytesStringWithData:sensorTagData];
        NSString *pageDisplay = [self bytesStringWithData:pageDisplayData];
        NSString *patch = [self bytesStringWithData:patchData];
        NSString *flash = [self bytesStringWithData:flashData];
        NSString *fwApp = [self bytesStringWithData:fwAppData];
        NSString *timeSeqNum = [self bytesStringWithData:timeSeqNumData];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params fcSetNotNilString:fwNumber forKey:@"fwNumber"];
        [params fcSetNotNilString:sensorTag forKey:@"sensorTag"];
        [params fcSetNotNilString:pageDisplay forKey:@"pageDisplay"];
        [params fcSetNotNilString:patch forKey:@"patch"];
        [params fcSetNotNilString:flash forKey:@"flash"];
        [params fcSetNotNilString:fwApp forKey:@"fwApp"];
        [params fcSetNotNilString:timeSeqNum forKey:@"timeSeqNum"];
        return [NSDictionary dictionaryWithDictionary:params];
    }
    return nil;
}


#pragma mark - 闹钟

+ (NSArray*)getAlarmClockListFromData:(NSData*)data
{
    if (!data) {
        return nil;
    }
    
    Byte *l2Packet = (Byte*)[data bytes];
    UInt16 payloadLen = ( l2Packet[1]&1 << 8) + l2Packet[2];
    int alarmCount = MIN(payloadLen / 5, 8);
    if (alarmCount == 0)
    {
        return nil;
    }
    Byte *hdr = l2Packet + 3;
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i< alarmCount; i++)
    {
        FCAlarmClockObject *aModel = [[FCAlarmClockObject alloc]init];
        aModel.year =  @( (hdr[i*5+0] & 0xfc) >> 2 );
        aModel.month = @(((hdr[i*5+0] & 0x3) << 2) + ((hdr[i*5+1] & 0xc0) >> 6));
        aModel.day = @((hdr[i*5+1] & 0x3f) >> 1);
        aModel.hour = @(((hdr[i*5+1] & 0x1) << 4) + ((hdr[i*5+2] & 0xf0) >> 4));
        aModel.minute = @(((hdr[i*5+2] & 0x0f) << 2 ) + (( hdr[i*5+3] & 0xc0 ) >> 6));
        aModel.alarmId = @((hdr[i*5+3] & 0x38) >> 3);
        aModel.cycle = @(hdr[i*5+4] & 0x7f);
        aModel.isOn = ((hdr[i*5+3] & 0x07) << 3) +  (hdr[i*5+4] & 0x80);
        [tmpArray addObject:aModel];
    }
    return [NSArray arrayWithArray:tmpArray];
}

+ (NSData*)getAlarmClockConfigDataFromArray:(NSArray*)array
{
    if (!array || array.count <= 0) {
        return nil;
    }
    NSMutableData *data = [NSMutableData data];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[FCAlarmClockObject class]])
        {
            FCAlarmClockObject *aModel = (FCAlarmClockObject*)obj;
            NSData *writeData = [aModel writeData];
            if (writeData)
            {
                [data appendData:writeData];
            }
        }
    }];
    return data;
}
@end
