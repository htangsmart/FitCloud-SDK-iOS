//
//  FitCloudUtils.h
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FitCloudBlock.h"


/*!
 * @class FitCloudUtils
 * @discussion 数据处理转换类
 */
@interface FitCloudUtils : NSObject

#pragma mark - 实时同步数据

/*!
 @discussion 获取实时心率
 @param data 实时测试数据包
 @return 实时心率
 */
+ (NSNumber*)getRealTimeHeartRateFromData:(NSData*)data;


/*!
 @discussion 获取实时血氧
 @param data 实时测试数据包
 @return 实时血氧
 */
+ (NSNumber*)getRealTimeBloodOxygenFromData:(NSData*)data;


/*!
 @discussion 获取实时血压
 @param data 实时测试数据包
 @return 实时血压 @ {@"sbp":value,@"dbp":value}
 */
+ (NSDictionary*)getRealTimeBloodPressureFromData:(NSData*)data;


/*!
 @discussion 获取实时呼吸频率
 @param data 实时测试数据包
 @return 实时呼吸频率
 */
+ (NSNumber*)getRealTimeBreathingRateFromData:(NSData*)data;


#pragma mark - 日总数据记录

/*!
 @discussion 获取多项总数据记录，包括总步数、总距离、总卡路里、深睡眠时长、浅睡眠时长、平均心率
 返回结果：{
             "stepCount": 0, // 步数,单位 步
             "distance": 0, // 距离，单位 m
             "calorie": 0, // 卡路里， 单位 cal
             "deepSleep": 0, // 深睡眠， 单位 min
             "lightSleep": 0,// 浅睡眠， 单位 min
             "avgHeartRate": 0, // 评价心率， 单位 次/分
         }
 @param data 手表返回的日总数据
 @return 返回日总数据详细记录
 */
+ (NSDictionary*)getDetailsOfCurrentDayFromData:(NSData*)data;



#pragma mark - 获取七天睡眠总数据

/*!
 @discussion 获取日总睡眠时长，手表返回七天或者少于7天的睡眠时长数据
 @param data 睡眠总数据
 @return 七日睡眠记录
 */
+ (NSArray*)getSleepTotalDataOfSevenDaysFromData:(NSData*)data;



#pragma mark - 手环设置

/*!
 @discussion 获取系统设置，系统设置数据包括消息通知开关配置、手环显示配置、手环功能开关配置、手环软硬件版本信息、健康定时检测开关、久坐提醒配置、默认血压、喝水提醒开关
 @param data 系统设置源数据
 @return 系统设置详细数据,value为<code>NSData</code>类型
 */
+ (NSDictionary*)getWatchSettingsFromData:(NSData*)data;




#pragma mark - 软硬件版本信息

/*!
 @discussion 获取软硬件版本信息详细数据
 @param data 软硬件版本信息数据
 @return {@“fwNumberData”:data,
             @"sensorTagData":data,
             @"pageDisplayData":data,
             @"patchData":data,
             @"flashData":data,
             @"fwAppData":data,
             @"timeSeqNumData":data
        }
 */
+ (NSDictionary*)getVersionDetailsDataFromData:(NSData*)data;




/*!
 @discussion 获取软硬件版本信息详细字符串
 @param data 软硬件版本信息数据
 @return {@“fwNumberData”:string,
             @"sensorTagData":string,
             @"pageDisplayData":string,
             @"patchData":string,
             @"flashData":string,
             @"fwAppData":string,
             @"timeSeqNumData":string
        }
 */
+ (NSDictionary*)getVersionDetailsStringFromData:(NSData *)data;




#pragma mark - 默认血压

/*!
 @discussion 获取默认血压
 @param data 血压数据
 @see <code>FCWatchSettingsObject</code>
 @seealso <i>defaultBloodPressureData</i>
 @return {@link {@"systolicBP":120,@"diastolicBP":80} }
 */
+ (NSDictionary*)getDefaultBloodPressureFromData:(NSData*)data;



#pragma mark - 卡路里计算

/*!
 @discussion 计算卡路里消耗(千卡)
 @param stepCount 步数 步
 @param weight 体重 kg
 @param height 身高 cm
 @param isBoy 男女
 @return 卡路里
 */
+ (CGFloat)caloriesFromSteps:(UInt32)stepCount weight:(UInt32)weight height:(UInt32)height isBoy:(BOOL)isBoy;



#pragma mark - 计算距离

/*!
 @discussion 计算运动距离 km
 @param stepCount 步数
 @param height 身高 cm
 @param isBoy 男女
 @return 运动距离
 */
+ (CGFloat)distanceFromSteps:(UInt32)stepCount height:(UInt32)height isBoy:(BOOL)isBoy;



#pragma mark - 获取运动量记录

/*!
 @discussion 获取运动量详细记录， 每隔5分钟一个数据
 @param data 运动量数据包
 @return 一组<code>FCDataObject</code>对象记录
 */
+ (NSArray*)getExerciseDetailsFromData:(NSData*)data;



#pragma mark - 获取睡眠记录

/*!
 @discussion 获取睡眠详细记录， 每隔5分钟一个数据
 @param data 睡眠数据包
 @return 一组包含<code>FCDataObject</code>对象的记录
 */
+ (NSArray*)getSleepDetailsFromData:(NSData*)data;



#pragma mark - 获取心率详细记录

/*!
 @discussion 获取心率详细记录， 每隔5分钟一个数据
 @param data 心率数据包
 @return 一组包含<code>FCDataObject</code>对象的记录
 */
+ (NSArray*)getHeartRateDetailsFromData:(NSData*)data;



#pragma mark - 获取血氧详细记录

/*!
 @discussion 获取血氧详细记录， 每隔5分钟一个数据
 @param data 血氧数据包
 @return 一组包含<code>FCDataObject</code>对象的记录
 */
+ (NSArray*)getBloodOxygenDetailsFromData:(NSData*)data;



#pragma mark - 获取呼吸频率详细记录

/*!
 @discussion 获取呼吸频率详细记录， 每隔5分钟一个数据
 @param data 呼吸频率数据包
 @return 一组包含<code>FCDataObject</code>对象的记录
 */
+ (NSArray*)getBreathingRateDetailsFromData:(NSData*)data;



#pragma mark - 获取血压详细记录

/*!
 @discussion 获取血压详细记录， 每隔5分钟一个数据
 @param data 血氧数据包
 @param systolicBP 收缩压默认数据
 @param diastolicBP 舒张压默认数据
 @return 一组包含<code>FCDataObject</code>对象的记录
 */
- (NSArray*)getBloodPressureDetailsFromData:(NSData*)data systolicBP:(UInt16)systolicBP diastolicBP:(UInt16)diastolicBP;



#pragma mark - 闹钟信息

/*!
 @discussion 获取手表闹钟，最多可以设置8个无重复的闹钟

 @param data 闹钟数据
 @return 一组<code>FCAlarmObject</code>对象
 */
+ (NSArray*)getAlarmClocksFromData:(NSData*)data;


/*!
 @discussion 将一组闹钟对象序列化为二进制闹钟数据，用于蓝牙同步
 @param array 包含<code>FCAlarmObject</code>对象的闹钟数组
 @return 闹钟数据
 */
+ (NSData*)getAlarmClockDataFromObjects:(NSArray*)array;



#pragma mark - 手机信息

/*!
 @discussion 手机的型号，用于登录和绑定设备时手表识别不同型号的机型
 @return 手机机型对应的数值
 */
+ (NSNumber*)getPhoneModel;


/*!
 @discussion 手机操作系统型号，用于手表区分不同的系统
 @return 操作系统对应的数值
 */
+ (NSNumber*)getOsVersion;

@end

