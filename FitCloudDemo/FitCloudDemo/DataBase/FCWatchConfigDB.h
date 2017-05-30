//
//  FCWatchConfigDB.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FCWatchSettingsObject;
// 用于存储管理手表配置信息
@interface FCWatchConfigDB : NSObject

/**
 存储手表配置信息

 @param configObj 手表配置信息对象
 @param uuidString 蓝牙外设uuid
 @return YES/NO
 */
+ (BOOL)storeWatchConfig:(id)configObj forUUID:(NSString*)uuidString;


/**
 查询手表配置信息对象
 
 @param uuidString 蓝牙外设uuid
 @return 手表config对象
 */
+ (FCWatchSettingsObject*)getWatchConfigFromDBWithUUID:(NSString*)uuidString;
@end
