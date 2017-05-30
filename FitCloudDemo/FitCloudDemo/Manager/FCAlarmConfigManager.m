//
//  FCAlarmConfigManager.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCAlarmConfigManager.h"
#import <FitCloudKit.h>

@implementation FCAlarmConfigManager
@synthesize listArray = _listArray;


+ (instancetype)manager
{
    static FCAlarmConfigManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    __weak __typeof(self) ws = self;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ws alloc]init];
    });
    return sharedManager;
}

- (void)clearCache
{
    [self.listArray removeAllObjects];
    
}

- (NSInteger)countOfAlarms
{
    return self.listArray.count;
}

- (void)refreshModel:(id)aModel
{
    if (_didUpdateAlarmClockListBlock) {
        _didUpdateAlarmClockListBlock();
    }
}

- (void)addAlarmClockFromArray:(NSArray*)array
{
    if (array && array.count > 0) {
        @synchronized(self) {
            [self.listArray addObjectsFromArray:array];
            if (_didUpdateAlarmClockListBlock) {
                _didUpdateAlarmClockListBlock();
            }
        }
    }
}

- (void)addAlarmClock:(id)aModel
{
    if (aModel && [aModel isKindOfClass:[FCAlarmClockObject class]]) {
        @synchronized(self) {
            [self.listArray addObject:aModel];
            if (_didUpdateAlarmClockListBlock) {
                _didUpdateAlarmClockListBlock();
            }
        }
    }
}

- (void)removeAlarmClock:(id)aModel
{
    if (aModel && [aModel isKindOfClass:[FCAlarmClockObject class]]) {
        @synchronized(self) {
            if ([self.listArray containsObject:aModel])
            {
                [self.listArray removeObject:aModel];
                if (_didUpdateAlarmClockListBlock) {
                    _didUpdateAlarmClockListBlock();
                }
            }
        }
    }
}


// 判断闹钟是否存在
- (BOOL)isExistAlarmClock:(id)aModel
{
    if (aModel && [aModel isKindOfClass:[FCAlarmClockObject class]])
    {
        FCAlarmClockObject *alarmModel = (FCAlarmClockObject*)aModel;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND minute == %@",alarmModel.year,alarmModel.month,alarmModel.day,alarmModel.hour,alarmModel.minute];
        NSArray *filterArray = [self.listArray filteredArrayUsingPredicate:predicate];
        return (filterArray && filterArray.count > 0);
    }
    return NO;
}


// 判断闹钟时间是否存在
- (BOOL)isExistTimeForAlarmClock:(id)aModel
{
    if (aModel && [aModel isKindOfClass:[FCAlarmClockObject class]])
    {
        FCAlarmClockObject *alarmModel = (FCAlarmClockObject*)aModel;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND minute == %@",alarmModel.year,alarmModel.month,alarmModel.day,alarmModel.hour,alarmModel.minute];
        NSArray *filterArray = [self.listArray filteredArrayUsingPredicate:predicate];
        if (filterArray && filterArray.count > 0)
        {
            FCAlarmClockObject *firstModel = [filterArray firstObject];
            if (firstModel.alarmId.integerValue != alarmModel.alarmId.integerValue) {
                return YES;
            }
        }
    }
    return NO;
}



// 重新分配闹钟id
- (void)redistributeAlarmID
{
    [self.listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[FCAlarmClockObject class]]) {
            FCAlarmClockObject *aModel = (FCAlarmClockObject*)obj;
            aModel.alarmId = @(idx);
        }
    }];
}



#pragma mark - Getter

- (NSMutableArray*)listArray
{
    if (_listArray) {
        return _listArray;
    }
    _listArray = [[NSMutableArray alloc]init];
    return _listArray;
}

@end
