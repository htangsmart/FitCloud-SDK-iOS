//
//  FCVersionDataObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"
#import "FCSensorFlagObject.h"
#import "FCPageDisplayFlagObject.h"


/**
 手表系统版本信息
 */
@interface FCVersionDataObject : NSObject <FCObjectProtocal>

/**
 项目的编号
 */
@property (nonatomic, strong) NSData *fwNumberData;

/**
 硬件号亦为手环传感器或功能标志位，组成的32bit，每个bit代表某一传感器或功能在该项目是否存在，手机APP根据该硬件号判断在手机APP上是否显示该功能和是否同步该项数据，
 
 @see FCSensorFlagObject
 */
@property (nonatomic, strong) NSData *sensorTagData;

/**
 手环页面标号为该项目手环上能显示的所有页面的标志，共32bit，每个bit代表一个页面，手机APP上根据该标号来确定有哪些显示页面可以给用户设置。此处数据暂不使用，可以通过<i>FCSystemSettingObject</i> 的 <i>wsdisplayData</i>获取设置信息  4byte
 
 @see FCScreenDisplayConfigObject
 */
@property (nonatomic, strong) NSData *pageDisplayData;

/**
 手环底层patch的版本号 6byte
 */
@property (nonatomic, strong) NSData *patchData;

/**
 flash文件版本号 4byte
 */
@property (nonatomic, strong) NSData *flashData;

/**
 固件app版本号 4byte
 */
@property (nonatomic, strong) NSData *fwAppData;

/**
 固件版本时间序号 4byte
 */
@property (nonatomic, strong) NSData *timeSeqNumData;


/**
 通过系统版本数据获取传感器标志位对象
 
 @return 传感器标志对象
 */
- (FCSensorFlagObject*)sensorTagObject;

/**
 手环页面显示标志，如果某个属性存在，手表屏幕才能显示某个功能，否则就不显示。<i>FCScreenDisplayConfigObject</i>中的部分属性如果不需要显示，则必须设置为NO,其余属性根据需要动态配置
 
 @return 页面显示标志对象
 */
- (FCPageDisplayFlagObject*)pageDisplayFlagObject;
@end

