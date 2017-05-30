//
//  FCWatchConfigDB.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCWatchConfigDB.h"
#import "FCDBEngine.h"
#import <FitCloudKit.h>
#import <YYModel.h>

@implementation FCWatchConfigDB
+ (BOOL)storeWatchConfig:(id)configObj forUUID:(NSString *)uuidString
{
    if (!uuidString) {
        NSLog(@"--不可用的uuid--");
        return NO;
    }
    if (!configObj || ![configObj isKindOfClass:[FCWatchSettingsObject class]]) {
        NSLog(@"--configObj不可用--");
        return NO;
    }
    FCDBEngine *dbEngine = [FCDBEngine engine];
    if (![dbEngine openDB]) {
        NSLog(@"--db打开错误--");
        return NO;
    }
    
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS WatchSetting(uuid TEXT NOT NULL, jsonData BLOB)";
    if (![dbEngine.dataBase executeUpdate:createSQL]) {
        NSLog(@"--db创建失败--");
        return NO;
    }
    FCWatchSettingsObject *watchSettingObj = (FCWatchSettingsObject*)configObj;
    NSData *watchSettingData = [watchSettingObj yy_modelToJSONData];
    
    BOOL ret = NO;
    NSString *fetchSQL = @"SELECT * FROM WatchSetting WHERE uuid = ?";
    FMResultSet *rs = [dbEngine.dataBase executeQuery:fetchSQL,uuidString];
    if (rs && [rs next]) {
        NSString *updateSQL = @"UPDATE WatchSetting SET jsonData = ? WHERE uuid = ?";
        ret = [dbEngine.dataBase executeUpdate:updateSQL,watchSettingData, uuidString];
    }
    else
    {
        NSString *insertSQL = @"INSERT INTO WatchSetting VALUES(?,?)";
        ret = [dbEngine.dataBase executeUpdate:insertSQL,uuidString,watchSettingData];
    }
    [rs close];
    [dbEngine closeDB];
    return ret;
}


+ (FCWatchSettingsObject*)getWatchConfigFromDBWithUUID:(NSString *)uuidString
{
    if (!uuidString) {
        NSLog(@"--uuid不存在--");
        return nil;
    }
    FCDBEngine *dbEngine = [FCDBEngine engine];
    if (![dbEngine openDB]) {
        NSLog(@"--db打开错误--");
        return nil;
    }
    
    if (![dbEngine.dataBase tableExists:@"WatchSetting"]) {
        NSLog(@"--表WatchSetting不存在--");
        return nil;
    }
    FCWatchSettingsObject *watchSettingObj = nil;
    FMResultSet *rs = [dbEngine.dataBase executeQuery:@"SELECT * FROM WatchSetting WHERE uuid = ?",uuidString];
    if (rs && [rs next]) {
        NSData *jsonData = [rs dataForColumnIndex:1];
        watchSettingObj = [FCWatchSettingsObject yy_modelWithJSON:jsonData];
    }
    [rs close];
    [dbEngine closeDB];
    return watchSettingObj;
}
@end
