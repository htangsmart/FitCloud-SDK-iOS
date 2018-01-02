//
//  FCRunObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/9/25.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/**
 (1) APP通过此配置来控制手表跑步模式和跑步状态
 (2) 手表启动跑步指令，会将此配置发送给APP
 */
@interface FCRunConfig : NSObject
/**
 跑步状态 0 结束,1 开始,2 暂停,3 恢复
 */
@property (nonatomic, assign) UInt8 runState;
// 跑步模式
@property (nonatomic, assign) UInt8 runMode;

/**
 跑步的id号码
 */
@property (nonatomic, assign) UInt32 runId;
@property (nonatomic, assign) UInt32 extraBytes;

+ (instancetype)runConfigWithData:(NSData*)data;
- (NSData*)writeData;
@end



/**
 （1）当手表发起或者结果跑步时，需要回复次数据给手表响应跑步结果
 （2）如果是App发送指令给手表，将会收到此响应结果
 */
@interface FCRunStateCode : NSObject
@property (nonatomic, assign) UInt8 runMode;
@property (nonatomic, assign) UInt8 runState;
@property (nonatomic, assign) UInt8 responseCode;
/**
 错误码
 0x01: 其他失败原因
 0x02: 对端正在进行其他运动
 0x03: 蓝牙未连接
 0x04 设置模式参数错误失败
 0x05 GPS 启动搜索失败
 */
@property (nonatomic, assign) UInt8 errorCode;
@property (nonatomic, assign) UInt16 extraBytes;

+ (instancetype)runStateCodeWithData:(NSData*)data;
- (NSData*)writeData;
@end



/**
 跑步状态，通过发送获取跑步状态指令获取手表的跑步状态
 */
@interface FCRunMode : NSObject
@property (nonatomic, assign) UInt8 runMode;
@property (nonatomic, assign) UInt8 runState;
@property (nonatomic, assign) UInt32 runId;
+ (instancetype)runModeWithData:(NSData*)data;
@end




/**
 跑步总数据，app配合手表跑步时需要定时获取一次手表的跑步
 */
@interface FCRunTotalData : NSObject
@property (nonatomic, assign) UInt8 runMode;
@property (nonatomic, assign) UInt8 runState;
@property (nonatomic, assign) UInt32 runTime; // 时长(秒)
@property (nonatomic, assign) UInt32 distance; // 距离(cm)
@property (nonatomic, assign) UInt32 steps;
@property (nonatomic, assign) UInt32 calorie; // 卡路里(小卡)
@property (nonatomic, assign) UInt32 pace; // 配速(s/km)
@property (nonatomic, assign) UInt32 runId; // 跑步Id
@property (nonatomic, assign) UInt32 avgPace; // 跑步过程的平均配速
+ (instancetype)runTotalDataWithData:(NSData*)data;
@end



@interface FCRunSummary : NSObject
@property (nonatomic, assign) UInt32 date;
@property (nonatomic, assign) NSInteger runType;
// 秒
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger stepCount;
// 米
@property (nonatomic, assign) NSInteger distance;
// 卡
@property (nonatomic, assign) NSInteger calorie;
// 分/公里
@property (nonatomic, assign) NSInteger avgPace;
@end

