//
//  FCUserConfigDB.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCUserConfigDB.h"
#import "FCDBEngine.h"
#import "FCUserConfig.h"
#import <YYModel.h>


@implementation FCUserConfigDB
+ (BOOL)storeUser:(id)aUser
{
    if (!aUser || ![aUser isKindOfClass:[FCUserConfig class]])
    {
        return NO;
    }
    
    FCDBEngine *dbEngine = [FCDBEngine engine];
    if (![dbEngine openDB]) {
        NSLog(@"--打开数据库错误--");
        return NO;
    }
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS User (jsonData BLOB)";
    if (![dbEngine.dataBase executeUpdate:createSQL]) {
        NSLog(@"--db创建失败--");
        return NO;
    }
    BOOL ret = NO;
    FCUserConfig *userConfig = (FCUserConfig*)aUser;
    NSData *jsonData = [userConfig yy_modelToJSONData];
    FMResultSet *rs = [dbEngine.dataBase executeQuery:@"SELECT * FROM User"];
    if (rs && [rs next])
    {
        ret = [dbEngine.dataBase executeUpdate:@"UPDATE User SET jsonData = ?",jsonData];
    }
    else
    {
        ret = [dbEngine.dataBase executeUpdate:@"INSERT INTO User VALUES (?)",jsonData];
    }
    [rs close];
    [dbEngine closeDB];
    return ret;
}


+ (FCUserConfig*)getUserFromDB
{
    FCDBEngine *dbEngine = [FCDBEngine engine];
    if (![dbEngine openDB])
    {
        NSLog(@"--打开数据库错误--");
        return nil;
    }
    
    if (![dbEngine.dataBase tableExists:@"User"])
    {
        NSLog(@"---表User不存在---");
        return nil;
    }
    FCUserConfig *userConfig = nil;
    FMResultSet *rs = [dbEngine.dataBase executeQuery:@"SELECT * FROM User"];
    if (rs && [rs next])
    {
        NSData *jsonData = [rs dataForColumnIndex:0];
        userConfig = [FCUserConfig yy_modelWithJSON:jsonData];
    }
    else
    {
        userConfig = [[FCUserConfig alloc]init];
        userConfig.age = 27;
        userConfig.sex = 0;
        userConfig.weight = 60;
        userConfig.height = 165;
        userConfig.systolicBP = 125;
        userConfig.diastolicBP = 80;
        userConfig.isLeftHandWearEnabled = YES;
        userConfig.isImperialUnits = NO;
    }
    [rs close];
    [dbEngine closeDB];
    return userConfig;
}
@end
