//
//  FCUserConfigDB.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FCUserConfig;
@interface FCUserConfigDB : NSObject

/**
 存储用户资料

 @param aUser 用户资料对象
 @return YES/NO
 */
+ (BOOL)storeUser:(id)aUser;


/**
 获取用户资料

 @return 用户资料对象
 */
+ (FCUserConfig*)getUserFromDB;
@end
