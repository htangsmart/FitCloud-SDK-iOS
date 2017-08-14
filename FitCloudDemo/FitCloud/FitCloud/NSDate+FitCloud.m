//
//  NSDate+FitCloud.m
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "NSDate+FitCloud.h"

static const unsigned int fcAllCalendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;

static NSString *fcDefaultCalendarIdentifier = nil;
static NSCalendar *fcImplicitCalendar = nil;


@implementation NSDate (FitCloud)
+ (void)load {
    [self setDefaultCalendarIdentifier:NSCalendarIdentifierGregorian];
}

- (NSInteger)fcYear
{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:fcAllCalendarUnitFlags fromDate:self];
    return [dateComponents year];
}

- (NSInteger)fcMonth
{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:fcAllCalendarUnitFlags fromDate:self];
    return [dateComponents month];
}

- (NSInteger)fcDay
{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:fcAllCalendarUnitFlags fromDate:self];
    return [dateComponents day];
}

- (NSInteger)fcHour{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:fcAllCalendarUnitFlags fromDate:self];
    return [dateComponents hour];
}

/**
 *  Returns the minute of the receiver. (0-59)
 *
 *  @return NSInteger
 */
- (NSInteger)fcMinute{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:fcAllCalendarUnitFlags fromDate:self];
    return [dateComponents minute];
}

/**
 *  Returns the second of the receiver. (0-59)
 *
 *  @return NSInteger
 */
- (NSInteger)fcSecond{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:fcAllCalendarUnitFlags fromDate:self];
    return [dateComponents second];
}

- (NSDate *)fcDateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [[self class] implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

-(BOOL)fcIsLaterThan:(NSDate *)date{
    if (self.timeIntervalSince1970 > date.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}

-(BOOL)fcIsEarlierThan:(NSDate *)date{
    if (self.timeIntervalSince1970 < date.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}

#pragma mark - Date Creating
+ (NSDate *)fcDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    return [self fcDateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)fcDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSDate *nsDate = nil;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year   = year;
    components.month  = month;
    components.day    = day;
    components.hour   = hour;
    components.minute = minute;
    components.second = second;
    
    nsDate = [[[self class] implicitCalendar] dateFromComponents:components];
    return nsDate;
}



/**
 *  Retrieves the default calendar identifier used for all non-calendar-specified operations
 *
 *  @return NSString - NSCalendarIdentifier
 */
+(NSString *)defaultCalendarIdentifier {
    return fcDefaultCalendarIdentifier;
}

/**
 *  Sets the default calendar identifier used for all non-calendar-specified operations
 *
 *  @param identifier NSString - NSCalendarIdentifier
 */
+ (void)setDefaultCalendarIdentifier:(NSString *)identifier
{
    fcDefaultCalendarIdentifier = [identifier copy];
    fcImplicitCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:fcDefaultCalendarIdentifier ?: NSCalendarIdentifierGregorian];
}

/**
 *  Retrieves a default NSCalendar instance, based on the value of defaultCalendarSetting
 *
 *  @return NSCalendar The current implicit calendar
 */
+ (NSCalendar *)implicitCalendar {
    return fcImplicitCalendar;
}

@end
