//
//  FitCloudUtils.h
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 数据处理使用工具
 */
@interface FitCloudUtils : NSObject

#pragma mark - 时间制式
/*!
 判断手机是否是12小时制
 
 @return YES/NO
 */
+ (BOOL)is12HourSystem;



#pragma mark - 电量和充电状态
/**
 获取电池电量和充电状态

 @param data 电量和充电状态数据
 @return {@"batteryLevel":10,@"state":1}
 */
+ (NSDictionary*)getBatteryLevelAndChargingState:(NSData*)data;



#pragma mark - 卡路里计算

/**
 计算卡路里消耗(千卡)

 @param stepCount 步数 步
 @param weight 体重 kg
 @param height 身高 cm
 @param isBoy 男女
 @return 卡路里
 */
+ (CGFloat)caloriesFromSteps:(UInt32)stepCount weight:(UInt32)weight height:(UInt32)height isBoy:(BOOL)isBoy;



#pragma mark - 计算距离

/**
 计算运动距离 km

 @param stepCount 步数
 @param height 身高 cm
 @param isBoy 男女
 @return 运动距离
 */
+ (CGFloat)distanceFromSteps:(UInt32)stepCount height:(UInt32)height isBoy:(BOOL)isBoy;




#pragma mark - 手机信息

/**
 手机的型号，用于登录和绑定设备时手表识别不同型号的机型

 @return 手机机型对应的数值
 */
+ (NSNumber*)getPhoneModel;




#pragma mark - 获取操作系统版本号
/**
 手机操作系统型号，用于手表区分不同的系统

 @return 操作系统对应的数值
 */
+ (NSNumber*)getOsVersion;



@end

