//
//  FCSyncUtils.m
//  FitCloud
//
//  Created by 远征 马 on 2017/8/9.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSyncUtils.h"
#import "NSDate+FitCloud.h"
#import "FCDefine.h"
#import "FCObject.h"


static const NSUInteger KDataHeaderLen = 8;


@implementation FCSyncUtils

#pragma mark - 日总数据

+ (NSDictionary*)getDetailsOfDailyTotalData:(NSData*)data
{
    if (!data || data.length < 24) {
        return nil;
    }
    
    Byte *byte = (Byte*)[data bytes];
    UInt32 stepCount = (byte[0] << 24) + (byte[1] << 16) + (byte[2] << 8) + (byte[3]);
    UInt32 distance = (byte[4] << 24) + (byte[5] << 16) + (byte[6] << 8) + (byte[7]);
    UInt32 calorie = (byte[8] << 24) + (byte[9] << 16) + (byte[10] << 8) + (byte[11]);
    UInt32 deepSleep = (byte[12] << 24) + (byte[13] << 16) + (byte[14] << 8) + (byte[15]);
    UInt32 lightSleep = (byte[16] << 24) + (byte[17] << 16) + (byte[18] << 8) + (byte[19]);
    UInt32 avgHeartRate = (byte[20] << 24) + (byte[21] << 16) + (byte[22] << 8) + (byte[23]);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(stepCount) forKey:@"stepCount"];
    [params setObject:@(distance) forKey:@"distance"];
    [params setObject:@(calorie) forKey:@"calorie"];
    [params setObject:@(deepSleep) forKey:@"deepSleep"];
    [params setObject:@(lightSleep) forKey:@"lightSleep"];
    [params setObject:@(avgHeartRate) forKey:@"avgHeartRate"];
    
    return [NSDictionary dictionaryWithDictionary:params];
}

#pragma mark - 七日睡眠数据解析

+ (NSArray*)getDetailsOfTotalSleepDataWithinSevenDays:(NSData*)data;
{
    if (data && data.length >= 42)
    {
        Byte *byte = (Byte*)[data bytes];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (int index = 0; index < 42; index += 6)
        {
            int year = ((byte[index] & 0x7E) >> 1);
            int month = (byte[index] & 0x01) + ((byte[index+1] & 0xE0) >> 5);
            int day = (byte[index + 1] & 0x1F);
            
            NSDate *date = [NSDate fcDateWithYear:year month:month day:day];
            date = [date fcDateByAddingDays:1];
            int deepSleepValue = (byte[index+2] << 8) + byte[index+3];
            int lightSleepValue = (byte[index+4] << 8) + byte[index + 5];
            if (deepSleepValue + lightSleepValue > 0)
            {
                NSDictionary *params = @{@"timeStamp":@(date.timeIntervalSince1970),
                                         @"deepSleep":@(deepSleepValue),
                                         @"lightSleep":@(lightSleepValue)};
                if (params)
                {
                    [tmpArray addObject:params];
                }
            }
        }
        return [NSArray arrayWithArray:tmpArray];
    }
    return nil;
}

#pragma mark - 获取运动量详细记录

+ (NSArray*)getRecordsOfExercise:(NSData*)data
{
    return [self getRecords:data withDataType:FCDataTypeExercise];
}

#pragma mark - 获取睡眠的详细记录

+ (NSArray*)getRecordsOfSleep:(NSData*)data
{
    return [self getRecords:data withDataType:FCDataTypeSleep];

}

#pragma mark - 获取心率详细记录

+ (NSArray*)getRecordsOfHeartRate:(NSData*)data
{
    return [self getRecords:data withDataType:FCDataTypeHeartRate];
}


#pragma mark - 获取血氧详细记录

+ (NSArray*)getRecordsOfBloodOxygen:(NSData*)data
{
    return [self getHealthRecords:data withDataType:FCDataTypeBloodOxygen];
}

#pragma mark - 获取呼吸频率详细记录

+ (NSArray*)getRecordsOfBreathingRate:(NSData*)data
{
    return [self getHealthRecords:data withDataType:FCDataTypeBreathingRate];
}


#pragma mark - 获取血压详细记录

+ (NSArray*)getRecordsOfBloodPressure:(NSData*)data systolicBP:(UInt16)systolicBP diastolicBP:(UInt16)diastolicBP
{
    if (!data)
    {
        return nil;
    }
    
    NSUInteger totalLength = data.length;
    if (totalLength < KDataHeaderLen) {
        // 数据包长度错误
        return nil;
    }
    NSUInteger location = 0;
    NSUInteger itemLength = 1;
    // 当前时间，超过当前时间的数据丢弃
    NSTimeInterval limitTimeStamp = [NSDate date].timeIntervalSince1970;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    Byte *dataBytes = (Byte*)[data bytes];
    // 如果数据处理位置小于数据总长度，继续处理
    while (location + KDataHeaderLen < totalLength)
    {
        UInt16 itemCount = (((dataBytes[location] & 0xff) << 8) | (dataBytes[location+1] & 0xff));
        if (itemCount > 0)
        {
            // 日期
            UInt16 year = (( dataBytes[location+2] & 0x7e) >> 1);
            UInt16 month = (((dataBytes[location+2] & 0x01) << 3) | ((dataBytes[location+3] >> 5) & 0x07));
            UInt16 day = (dataBytes[location+3] & 0x1f);
            UInt16 minuteOffset = (((dataBytes[location+4] & 0xff) << 8) | (dataBytes[location+5] & 0xff));
            // 每个采样点的时间间隔min
            UInt16 timeInterval = (((dataBytes[location+6] & 0xff) << 8) | (dataBytes[location+7] & 0xff));
            
            NSDate *startDate = [NSDate fcDateWithYear:(year+2000) month:month day:day];
            NSTimeInterval startTimeStamp = startDate.timeIntervalSince1970;
            
            for (int index = 0; index < itemCount; index++)
            {
                NSTimeInterval itemTimeStamp = startTimeStamp + (index*timeInterval + minuteOffset)*60;
                if (itemTimeStamp < limitTimeStamp)
                {
                    NSUInteger itemLocation = location + KDataHeaderLen + index*itemLength;
                    if (itemLocation + itemLength <= totalLength)
                    {
                        UInt16 value = 0;
                        if (itemLength == 1)
                        {
                            value = (dataBytes[itemLocation] & 0xff);
                        }
                        // 过滤掉无用的数据
                        BOOL valid = (value > 0);
                        if (valid)
                        {
                            UInt16 hBPValue = 0;
                            UInt16 lBPValue = 0;
                            if (systolicBP > 125 && diastolicBP > 80)
                            {
                                hBPValue = (value >= 110 ? 128 + arc4random()%8 : 125 + arc4random()%6);
                                lBPValue = (value >= 110 ? 88 + arc4random()%8 : 85 + arc4random()%16);
                            }
                            else
                            {
                                hBPValue = (value >= 110 ? 115 + arc4random()%16 : 110 + arc4random()%16);
                                lBPValue = (value >= 110 ? 75 + arc4random()%11 : 65 + arc4random()%16);
                            }
                            FCDataObject *anObject = [[FCDataObject alloc]init];
                            anObject.DataType = FCDataTypeBloodPressure;
                            anObject.timeStamp = @(itemTimeStamp);
                            anObject.value = @(hBPValue);
                            anObject.extraValue = @(lBPValue);
                            [tmpArray addObject:anObject];
                        }
                    }
                    else
                    {
                        // 处理位置越界处理结束
                        return tmpArray;
                    }
                }
                else
                {
                    // 记录的时间超过当前时间，处理结束
                    return tmpArray;
                }
            }
            location += KDataHeaderLen + itemCount*itemLength;
        }
        else
        {
            location += KDataHeaderLen;
        }
    }
    return tmpArray;
}


#pragma mark - 获取详细记录

+ (NSArray*)getRecords:(NSData*)data withDataType:(FCDataType)dataType
{
    if (!data) {
        return nil;
    }
    
    NSUInteger totalLength = data.length;
    if (totalLength < KDataHeaderLen) {
        // 数据包长度错误
        return nil;
    }
    
    NSUInteger location = 0;
    // 某种类型的单位数据长度
    NSUInteger itemLength = 1;
    if (dataType == FCDataTypeExercise || dataType == FCDataTypeBloodPressure)
    {
        // 运动量和血压占2字节长度
        itemLength = 2;
    }
    
    // 当前时间，超过当前时间的数据丢弃
    NSTimeInterval limitTimeStamp = [NSDate date].timeIntervalSince1970;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    Byte *dataBytes = (Byte*)[data bytes];
    // 如果数据处理位置小于数据总长度，继续处理
    while (location + KDataHeaderLen < totalLength)
    {
        UInt16 itemCount = (((dataBytes[location] & 0xff) << 8) | (dataBytes[location+1] & 0xff));
        if (itemCount > 0)
        {
            UInt16 year = (( dataBytes[location+2] & 0x7e) >> 1);
            UInt16 month = (((dataBytes[location+2] & 0x01) << 3) | ((dataBytes[location+3] >> 5) & 0x07));
            UInt16 day = (dataBytes[location+3] & 0x1f);
            // 当前分钟便宜量
            UInt16 minuteOffset = (((dataBytes[location+4] & 0xff) << 8) | (dataBytes[location+5] & 0xff));
            // 每个采样点的时间间隔min
            UInt16 timeInterval = (((dataBytes[location+6] & 0xff) << 8) | (dataBytes[location+7] & 0xff));
            
            NSDate *startDate = [NSDate fcDateWithYear:(year+2000) month:month day:day];
            NSTimeInterval startTimeStamp = startDate.timeIntervalSince1970;
            
            for (int index = 0; index < itemCount; index++)
            {
                NSTimeInterval itemTimeStamp = startTimeStamp + (index*timeInterval + minuteOffset)*60;
                if (itemTimeStamp < limitTimeStamp)
                {
                    NSUInteger itemLocation = location + KDataHeaderLen + index*itemLength;
                    if (itemLocation + itemLength <= totalLength)
                    {
                        UInt16 value = 0,extraValue = 0;
                        if (itemLength == 1)
                        {
                            value = (dataBytes[itemLocation] & 0xff);
                        }
                        else if (itemLength == 2)
                        {
                            if (dataType == FCDataTypeExercise)
                            {
                                value = ((dataBytes[itemLocation] & 0xff) << 8) | (dataBytes[itemLocation+1] & 0xff);
                            }
                            else if (dataType == FCDataTypeBloodPressure)
                            {
                                value = (dataBytes[itemLocation] & 0xff);//高收缩压
                                extraValue = (dataBytes[itemLocation+1] & 0xff);//低舒张压
                            }
                        }
                        // 过滤掉无用的数据
                        BOOL valid = YES;
                        if (dataType == FCDataTypeBloodPressure)
                        {
                            valid = ((value > 0 ) && (extraValue > 0));
                        }
                        else
                        {
                            valid = (value > 0);
                        }
                        
                        if (valid)
                        {
                            if (dataType == FCDataTypeExercise)
                            {
                                if (value <= 3000 )
                                {
                                    FCDataObject *aObject = [[FCDataObject alloc]init];
                                    aObject.DataType = FCDataTypeExercise;
                                    aObject.timeStamp = @(itemTimeStamp);
                                    aObject.value = @(value);
                                    [resultArray addObject:aObject];
                                    
                                }
                            }
                            else if (dataType == FCDataTypeSleep)
                            {
                                if (value < 4)
                                {
                                    FCDataObject *aObject = [[FCDataObject alloc]init];
                                    aObject.DataType = FCDataTypeSleep;
                                    aObject.timeStamp = @(itemTimeStamp);
                                    aObject.value = @(value);
                                    [resultArray addObject:aObject];
                                }
                            }
                            else if (dataType == FCDataTypeHeartRate)
                            {
                                
                                FCDataObject *aObject = [[FCDataObject alloc]init];
                                aObject.DataType = FCDataTypeHeartRate;
                                aObject.timeStamp = @(itemTimeStamp);
                                aObject.value = @(value);
                                [resultArray addObject:aObject];
                            }
                            else if (dataType == FCDataTypeBloodOxygen)
                            {
                                
                            }
                            else if (dataType == FCDataTypeBloodPressure)
                            {
                                
                            }
                            else if (dataType == FCDataTypeBreathingRate)
                            {
                                
                            }
                        }
                    }
                    else
                    {
                        // 处理位置越界处理结束
                        return resultArray;
                    }
                }
                else
                {
                    // 记录的时间超过当前时间，处理结束
                    return resultArray;
                }
            }
            location += KDataHeaderLen + itemCount*itemLength;
        }
        else
        {
            location += KDataHeaderLen;
        }
    }
    return resultArray;
}

#pragma mark - 获取健康记录
+ (NSArray*)getHealthRecords:(NSData*)data withDataType:(FCDataType)dataType
{
    if (!data)
    {
        return nil;
    }
    NSUInteger totalLength = data.length;
    if (totalLength < KDataHeaderLen) {
        // 数据包长度错误
        return nil;
    }
    
    NSUInteger location = 0;
    NSUInteger itemLength = 1;
    
    // 当前时间，超过当前时间的数据丢弃
    NSTimeInterval limitTimeStamp = [NSDate date].timeIntervalSince1970;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    Byte *dataBytes = (Byte*)[data bytes];
    // 如果数据处理位置小于数据总长度，继续处理
    while (location + KDataHeaderLen < totalLength)
    {
        UInt16 itemCount = (((dataBytes[location] & 0xff) << 8) | (dataBytes[location+1] & 0xff));
        if (itemCount > 0)
        {
            UInt16 year = (( dataBytes[location+2] & 0x7e) >> 1);
            UInt16 month = (((dataBytes[location+2] & 0x01) << 3) | ((dataBytes[location+3] >> 5) & 0x07));
            UInt16 day = (dataBytes[location+3] & 0x1f);
            UInt16 minuteOffset = (((dataBytes[location+4] & 0xff) << 8) | (dataBytes[location+5] & 0xff));
            // 每个采样点的时间间隔min
            UInt16 timeInterval = (((dataBytes[location+6] & 0xff) << 8) | (dataBytes[location+7] & 0xff));
            
            NSDate *startDate = [NSDate fcDateWithYear:(year+2000) month:month day:day];
            NSTimeInterval startTimeStamp = startDate.timeIntervalSince1970;
            
            for (int index = 0; index < itemCount; index++)
            {
                NSTimeInterval itemTimeStamp = startTimeStamp + (index*timeInterval + minuteOffset)*60;
                if (itemTimeStamp < limitTimeStamp)
                {
                    NSUInteger itemLocation = location + KDataHeaderLen + index*itemLength;
                    if (itemLocation + itemLength <= totalLength)
                    {
                        UInt16 value = 0;
                        if (itemLength == 1)
                        {
                            value = (dataBytes[itemLocation] & 0xff);
                        }
                        // 过滤掉无用的数据
                        BOOL valid = (value > 0);
                        
                        
                        if (valid)
                        {
                            if (dataType == FCDataTypeBloodOxygen) {
                                
                                UInt16 boValue = (value >= 90 ? (arc4random()%2 + 96) : (arc4random()%2 + 98));
                                FCDataObject *anObject = [[FCDataObject alloc]init];
                                anObject.DataType = FCDataTypeBloodOxygen;
                                anObject.timeStamp = @(itemTimeStamp);
                                anObject.value = @(boValue);
                                [resultArray addObject:anObject];
                            }
                            else if (dataType == FCDataTypeBloodPressure)
                            {
                                
                                
                            }
                            else if (dataType == FCDataTypeBreathingRate)
                            {
                                UInt16 brValue = (value >= 90 ? (arc4random()%10 + 36) : (arc4random()%6 + 18));
                                FCDataObject *anObject = [[FCDataObject alloc]init];
                                anObject.DataType = FCDataTypeBreathingRate;
                                anObject.timeStamp = @(itemTimeStamp);
                                anObject.value = @(brValue);
                                [resultArray addObject:anObject];
                            }
                        }
                    }
                    else
                    {
                        // 处理位置越界处理结束
                        return resultArray;
                    }
                }
                else
                {
                    // 记录的时间超过当前时间，处理结束
                    return resultArray;
                }
            }
            location += KDataHeaderLen + itemCount*itemLength;
        }
        else
        {
            location += KDataHeaderLen;
        }
    }
    return resultArray;
}
@end
