//
//  FCDataHandler.h
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCDefine.h"


/*!
 * @class FCDataHandler
 * @discussion This class is mainly used for data processing,Such as data segmentation, data analysis, model conversion and so on
 */

@interface FCDataHandler : NSObject

#pragma mark - 系统设置数据解析

/*!
 * @brief Split system settings data
 * @param data       System setting Data
 * @param retHandler Processing result callback block
 * @warning If the parameter is <i>nil</i>, no data is returned
 */
+ (void)divideSystemSettingData:(NSData*)data retHandler:(FCSysSettingDataHandler)retHandler;

/*!
 * @brief Split the hardware and software version data
 * @param versionData Hardware and software version data
 * @param retHandler Processing result callback block
 * @warning If the parameter is null, no data is returned
 */
+ (void)divideVersionData:(NSData*)versionData retHandler:(FCVersionDataHandler)retHandler;

/*!
 * @brief Parse the hardware and software version data
 * @param versionData Hardware and software version data
 * @param retHandler Processing result callback block
 * @warning If the parameter is null, no data is returned
 */
+ (void)parseVersionData:(NSData *)versionData retHandler:(FCVersionStringHandler)retHandler;


#pragma mark - 闹钟转换

/*!
 * @brief  Parse the alarm clock data
 * @param alarmData alarm clock data
 * @return a list of <code>FCAlarmObject</code> objects
 */
+ (NSArray*)convertAlarmDataToModels:(NSData*)alarmData;

/*!
 * @brief Converts a list of alarm objects to NSData
 * @param array a list of <code>FCAlarmModel</code> objects
 * @return Alarm data of NSData type
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSData*)convertModelsToAlarmData:(NSArray*)array;

#pragma mark - 运动数据解析

/*!
 * @brief Convert sports data to an array containing dictionary objects,Each record contains five minutes of data
 * @param data The sports data to be converted
 * @return a list of <code>NSDictionary</code> objects
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)convertSportsDataToDictionarys:(NSData*)data;

/*!
 * @brief Convert sports data to an array containing the model objects,Each record contains five minutes of data
 * @param data The sports data to be converted
 * @return a list of <code>FCExerciseModel</code> objects
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)convertSportsDataToModels:(NSData*)data;

/*!
 * @brief Convert sleep data to an array containing dictionary objects,Each record contains five minutes of data
 * @param data The sleep data to be converted
 * @return a list of <code>NSDictionary</code> objects
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)convertSleepDataToDictionarys:(NSData*)data;

/*!
 * @brief Convert sleep data to an array containing the model objects,Each record contains five minutes of data
 * @param data The sleep data to be converted
 * @return a list of <code>FCSleepModel</code> objects
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)convertSleepDataToModels:(NSData*)data;

/*!
 * @brief Convert heart rate data to an array containing dictionary objects,Each record contains five minutes of data
 * @param data The heart rate data to be converted
 * @return a list of <code>NSDictionary</code> objects
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)convertHeartRateDataToDictionarys:(NSData*)data;

/*!
 * @brief Convert heart rate data to an array containing the model objects,Each record contains five minutes of data
 * @param data The heart rate data to be converted
 * @return a list of <code>FCHealthModel</code> objects
 * @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)convertHeartRateDataToModels:(NSData*)data;
@end
