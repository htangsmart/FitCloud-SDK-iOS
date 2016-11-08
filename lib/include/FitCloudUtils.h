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
 * @discussion This class is mainly used for data analysis, type conversion and so on
 */
@interface FitCloudUtils : NSObject

/*!
 The system setting data is divided into detailed setting data

 @param data system setting data
 @param block The resulting callback block
 @return if data is <i>nil</i>,return <i>NO</i>
 */
+ (BOOL)resolveSystemSettingsData:(NSData*)data withCallbackBlock:(FCSystemSettingDataBlock)block;


/*!
 Divide the hardware and software version information data into detailed data

 @param data hardware and software version information data
 @param block The resulting callback block
 @return if data is <i>nil</i>,return <i>NO</i>
 */
+ (BOOL)resolveHardwareAndSoftwareVersionDataToString:(NSData*)data withCallbackBlock:(FCHardwareAndSoftwareVersionStringBlock)block;


/*!
 Divide the hardware and software version information data into detailed data and parse the detailed data into strings

 @param data hardware and software version information data
 @param block The resulting callback block
 @return if data is <i>nil</i>,return <i>NO</i>
 */
+ (BOOL)resolveHardwareAndSoftwareVersionData:(NSData*)data withCallbackBlock:(FCHardwareAndSoftwareVersionDataBlock)block;


/*!
 Convert sports data to an array containing dictionary objects,Each record contains five minutes of data

 @param data The sports data to be converted
 @return a list of <code>NSDictionary</code> objects
 @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)resolveExerciseDataIntoDictionaryObjects:(NSData*)data;


/*!
 Convert sports data to an array containing dictionary objects,Each record contains five minutes of data
 
 @param data The sports data to be converted
 @return a list of <code>FCExerciseModel</code> objects
 @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)resolveExerciseDataIntoModelObjects:(NSData*)data;


/*!
 Convert sleep data to an array containing dictionary objects,Each record contains five minutes of data
 
 @param data The sleep data to be converted
 @return a list of <code>NSDictionary</code> objects
 @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)resolveSleepDataIntoDictionaryObjects:(NSData*)data;


/*!
 Convert sleep data to an array containing the model objects,Each record contains five minutes of data
 
 @param data The sleep data to be converted
 @return a list of <code>FCSleepModel</code> objects
 @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)resolveSleepDataIntoModelObjects:(NSData*)data;


/*!
 Convert heart rate data to an array containing dictionary objects,Each record contains five minutes of data
 
 @param data The heart rate data to be converted
 @return a list of <code>NSDictionary</code> objects
 @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)resolveHeartRateDataIntoDictionaryObjects:(NSData*)data;


/*!
 Convert heart rate data to an array containing the model objects,Each record contains five minutes of data
 
 @param data The heart rate data to be converted
 @return a list of <code>FCHealthModel</code> objects
 @warning If the parameter is <i>nil</i>, returns <i>nil</i>
 */
+ (NSArray*)resolveHeartRateDataIntoModelObjects:(NSData*)data;
@end

/*!
 * @category NSData
 * @discussion NSData class method extension
 */
@interface NSData (Utils)

/*!
 Converts system settings data to a data model with detailed attributes

 @return The object to be converted
 @warning if self is <i>nil</i>, return <i>nil</i>
 */
- (id)objectFromSystemSettingsData;


/*!
 Converts system settings data to a dictonary with detailed data
 
 @return The object to be converted
 @warning if self is <i>nil</i>, return <i>nil</i>
 */
- (NSDictionary*)dictionaryFromSystemSettingsData;


/*!
 Converts hardware and software version information data to a dictionary with detailed data

 @return The object to be converted
 @warning if self is <i>nil</i>, return <i>nil</i>
 */
- (NSDictionary*)dictionaryFromSoftwareAndHardwareVersionData;
@end


/*!
 * @category NSArray
 * @discussion NSArray class method extension
 */
@interface NSArray (Utils)

/*!
 Convert alarm clock data to alarm clock models

 @param data The alarm clock data to be converted
 @return a list of <code>FCAlarmObject</code> objects, if data is <i>nil</i>,return nil.
 */
+ (NSArray*)arrayWithAlarmClockConfigurationData:(NSData*)data;


/*!
 Combines a set of alarm clock models into alarm clock data

 @return Alarm clock data according to Bluetooth protocol standard
 */
+ (NSData*)alarmClockConfigurationData;
@end
