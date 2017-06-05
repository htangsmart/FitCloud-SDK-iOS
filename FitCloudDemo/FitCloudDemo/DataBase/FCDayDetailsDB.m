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
#import <YYModel.h>
#import <DateTools.h>


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
    

    __block BOOL ret = NO;
    FCDBEngine *dbEngine = [FCDBEngine engine];
    [dbEngine.dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        //    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS DayDetails (timeStamp REAL, stepCount, calorie, distance, deepSleep, lightSleep, avgHeartRate)";
        NSString *createSQL = @"CREATE TABLE IF NOT EXISTS DayDetails (timeStamp REAL, jsonData BLOB)";
        if ([dbEngine.dataBase executeUpdate:createSQL]) {
            NSLog(@"--创建db失败--");
            
            FCDayDetailsObject *dayDetailsObj = (FCDayDetailsObject*)dayDetails;
            NSData *data = [dayDetailsObj yy_modelToJSONData];
            FMResultSet *rs = [db executeQuery:@"SELECT  * FROM DayDetails WHERE timeStamp = ?", dayDetailsObj.timeStamp];
            if (rs && [rs next]) {
                NSString *updateSQL = @"UPDATE DayDetails SET jsonData = ? WHERE timeStamp = ?";
                ret = [db executeUpdate:updateSQL,data,dayDetailsObj.timeStamp];
            }
            else
            {
                NSString *insertSQL = @"INSERT INTO DayDetails VALUES (?,?)";
                ret = [db executeUpdate:insertSQL,dayDetailsObj.timeStamp,data];
            }
        };
    }];
    
    if (retHandler) {
        retHandler(ret);
    }
}

+ (void)fetchDayDetails:(NSDate*)date result:(void(^)(id dayDetails))retHandler
{
    if (!date) {
        return;
    }
    
    __block FCDayDetailsObject *dayDetailsObj = nil;
    FCDBEngine *dbEngine = [FCDBEngine engine];
    [dbEngine.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db tableExists:@"DayDetails"]) {
            NSDate *zeroDate = [NSDate dateWithYear:date.year month:date.month day:date.day];
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM DayDetails WHERE timeStamp = ?",@(zeroDate.timeIntervalSince1970)];
            if (rs && [rs next]) {
                NSData *jsonData = [rs dataForColumnIndex:1];
                dayDetailsObj = [FCDayDetailsObject yy_modelWithJSON:jsonData];
            }
        }
    }];
    
    if (retHandler) {
        retHandler(dayDetailsObj);
    }

}
@end
