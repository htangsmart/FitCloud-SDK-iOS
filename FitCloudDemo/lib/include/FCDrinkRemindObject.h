//
//  FCDrinkRemindObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 喝水提醒配置
 */
@interface FCDrinkRemindObject : NSObject

@property (nonatomic, assign) BOOL isOn;
// 时间间隔 分钟
@property (nonatomic, assign) NSUInteger timeInteval;
// 开始时间 （从0开始的分钟数）
@property (nonatomic, assign) NSUInteger stMinute;
// 结束时间 （从0开始的分钟数）
@property (nonatomic, assign) NSUInteger edMinute;

/**
 初始化方法

 @param data 配置数据，如果为nil则使用默认配置初始化
 @return 初始化对象
 */
+ (instancetype)objectWithData:(NSData*)data;
- (NSData*)writeData;
@end
