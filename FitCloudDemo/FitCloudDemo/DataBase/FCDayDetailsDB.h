//
//  FCDayDetailsDB.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/6/5.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>


// 主要用于存储每日总数据

@interface FCDayDetailsDB : NSObject

/**
 存储日总数据

 @param dayDetails 日总数据对象
 @param retHandler 存储结果回调
 */
+ (void)storeDayDetails:(id)dayDetails result:(void(^)(BOOL finished))retHandler;


/**
 查询某一天的详细数据

 @param date 查询日期
 @param retHandler 查询结果回调
 */
+ (void)fetchDayDetails:(NSDate*)date result:(void(^)(id dayDetails))retHandler;
@end
