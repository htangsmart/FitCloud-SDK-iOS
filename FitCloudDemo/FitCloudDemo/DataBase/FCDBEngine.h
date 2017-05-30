//
//  FCDBEngine.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface FCDBEngine : NSObject
@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;
+ (instancetype)engine;
- (BOOL)openDB;
- (BOOL)closeDB;
@end
