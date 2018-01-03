//
//  FCAlarmConfigManager.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCAlarmConfigManager : NSObject
@property (nonatomic, strong, readonly) NSMutableArray *listArray;
@property (nonatomic, copy) void(^didUpdateAlarmClockListBlock)(void);
+ (instancetype)manager;
/*!
 清理缓存的闹钟
 */
- (void)clearCache;


/**
 获取闹钟数量，最多可以设置8个闹钟

 @return 闹钟数量
 */
- (NSInteger)countOfAlarms;


/**
 刷新闹钟模型
 
 @param aModel 闹钟模型
 */
- (void)refreshModel:(id)aModel;

/*!
 从数组添加闹钟
 
 @param array 要添加的闹钟数据
 */
- (void)addAlarmClockFromArray:(NSArray*)array;


/*!
 添加闹钟
 
 @param aModel 要添加的闹钟
 */
- (void)addAlarmClock:(id)aModel;


/**
 删除闹钟
 
 @param aModel 要删除的闹钟
 */
- (void)removeAlarmClock:(id)aModel;

/**
 判断闹钟是否已经存在
 
 @param aModel 闹钟模型
 @return 判断结果
 */
- (BOOL)isExistAlarmClock:(id)aModel;


/**
 判断当前闹钟的时间是否已经被其他闹钟占用
 
 @param aModel 闹钟模型
 @return 判断结果
 */
- (BOOL)isExistTimeForAlarmClock:(id)aModel;

/*!
 重新分配闹钟ID
 */
- (void)redistributeAlarmID;
@end
