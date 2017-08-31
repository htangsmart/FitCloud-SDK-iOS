//
//  FCWatchConfig.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"

/**
 手表配置信息，主要用于登录、绑定、数据同步等更细手表配置
 */


@interface FCWatchConfig : NSObject <FCObjectProtocal>
/**
 用户id，由自己服务器为每个用户分配。登录、绑定都需要此参数
 */
@property (nonatomic, assign) UInt64 guestId;

/**
 手机型号,如iphone6、iphone6s,通过<i>FitCloudUtils</i>可以获取到。登录、绑定都需要此参数
 */
@property (nonatomic, assign) UInt8 phoneModel;

/**
 系统版本,通过<i>FitCloudUtils</i>可以获取到。登录、绑定都需要此参数
 */
@property (nonatomic, assign) UInt8 osVersion;

/**
 用户年龄，默认1990出生。 绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 age;

/**
 性别，默认为女性 0。 绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 sex;

/**
 用户体重，默认60kg。绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 weight;

/**
 用户身高，女性默认 165cm, 男性默认 175cm。 绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt32 height;

/**
 收缩压参考值，默认125。绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt16 systolicBP;

/**
 舒张压参考值，默认80。绑定手表或者同步用户资料需要此参数
 */
@property (nonatomic, assign) UInt16 diastolicBP;

/**
 佩戴方式，左右佩戴？右手佩戴。 绑定手表需要此参数
 */
@property (nonatomic, assign) BOOL isLeftHandWearEnabled;

/**
 手表功能开关数据，详细参数见 <i>FCFeaturesObject</i> ,手表绑定、登录或者同步历史数据时如果对此参数赋值，会将手表时间制式、单位等同步到手表，如果为nil则不同步此配置
 */
@property (nonatomic, strong) NSData  *featuresData;

/**
 登录或者绑定手表时蓝牙需要写入的数据
 */
- (NSData*)loginOrBindData;

/**
 同步用户资料时蓝牙需要写入的数据
 */
- (NSData*)userProfileData;
@end
