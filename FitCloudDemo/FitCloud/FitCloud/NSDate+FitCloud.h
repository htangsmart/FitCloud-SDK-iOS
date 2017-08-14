//
//  NSDate+FitCloud.h
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FitCloud)
- (NSInteger)fcYear;
- (NSInteger)fcMonth;
- (NSInteger)fcDay;
- (NSInteger)fcHour;
- (NSInteger)fcMinute;
- (NSInteger)fcSecond;

- (BOOL)fcIsLaterThan:(NSDate *)date;
- (BOOL)fcIsEarlierThan:(NSDate *)date;

- (NSDate *)fcDateByAddingDays:(NSInteger)days;
+ (NSDate *)fcDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)fcDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
@end
