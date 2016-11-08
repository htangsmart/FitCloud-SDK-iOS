//
//  FitCloudBlock.h
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//


@class NSString;


#ifndef FitCloudBlock_h
#define FitCloudBlock_h

/**
 *  手环系统配置信息回调
 *
 *  @param notificationData    消息通知开关 4byte
 *  @param screenDisplayData  手环显示配置 2byte
 *  @param functionalSwitchData 功能开关配置 2byte
 *  @param hsVersionData  软硬件版本信息配置 32byte
 *  @param healthHistorymonitorData  健康实时监测配置 5byte
 *  @param longSitData  久坐提醒配置 5byte
 *  @param bloodPressureData       默认血压配置 2byte
 *  @param drinkWaterReminderData    喝水提醒配置 1byte
 */
typedef void (^FCSystemSettingDataBlock)(NSData *notificationData, NSData *screenDisplayData,NSData *functionalSwitchData,NSData *hsVersionData,NSData *healthHistorymonitorData,NSData *longSitData,NSData *bloodPressureData,NSData *drinkWaterReminderData);

/*!
 *  @discussion  手环软硬件版本信息字符串回调
 *
 *  @param projNum       项目号
 *  @param hardware      硬件号
 *  @param sdkVersion    sdk版本号
 *  @param patchVerson   软件patch版本号
 *  @param falshVersion  flash版本号
 *  @param appVersion    固件app版本号
 *  @param serialNum     序号
 */
typedef void (^FCHardwareAndSoftwareVersionStringBlock)(NSString *projNum,NSString *hardware,NSString *sdkVersion,NSString *patchVerson,NSString *falshVersion,NSString *appVersion,NSString *serialNum);


/**
 *  @discussion 手环软硬件版本信息回调
 *
 *  @param projData     项目号 6byte
 *  @param hardwareData 硬件号 4byte
 *  @param sdkData      sdk版本号 4byte
 *  @param patchData    软件patch版本号 6byte
 *  @param flashData    flash版本号 4byte
 *  @param fwAppData    固件app版本号 4byte
 *  @param seqData      序号 4byte
 */
typedef void (^FCHardwareAndSoftwareVersionDataBlock)(NSData *projData,NSData *hardwareData,NSData *sdkData,NSData *patchData,NSData *flashData,NSData *fwAppData,NSData *seqData);

#endif /* FitCloudBlock_h */
