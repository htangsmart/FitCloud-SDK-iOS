//
//  FCDBEngine.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCDBEngine.h"

@implementation FCDBEngine
+ (instancetype)engine
{
    static FCDBEngine *sharedManager = nil;
    static dispatch_once_t onceToken;
    __weak __typeof(self) ws = self;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ws alloc]init];
    });
    return sharedManager;
}

// 如果app做了多账号切换，请加载对应账号id的数据库，这里默认使用id为100的数据库
- (NSString*)databaseWithGuestId:(NSString*)guestId
{
    if (!guestId) {
        return nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dbPathDir = [[paths[0] stringByAppendingPathComponent:@"FitCloudDB"]stringByAppendingPathComponent:guestId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:dbPathDir isDirectory:&isDir])
    {
        if (isDir)
        {
            return [dbPathDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",guestId]];
        }
        return nil;
    }
    else
    {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:dbPathDir withIntermediateDirectories:YES attributes:nil error:&error])
        {
            if (!error)
            {
                return  [dbPathDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",guestId]];
            }
        }
    }
    return nil;
}

- (FMDatabase*)dataBase
{
    if (_dataBase) {
        return _dataBase;
    }
    NSString *dbPath = [self databaseWithGuestId:@(100).stringValue];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    return _dataBase;
}

- (FMDatabaseQueue*)dataBaseQueue
{
    if (_dataBaseQueue) {
        return _dataBaseQueue;
    }
    NSString *dbPath = [self databaseWithGuestId:@(100).stringValue];
    _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    return _dataBaseQueue;
}

- (BOOL)openDB
{
    if (self.dataBase && self.dataBase.open) {
        return YES;
    }
    return NO;
}

- (BOOL)closeDB
{
    if (self.dataBase) {
        return [self.dataBase close];
    }
    return NO;
}
@end
