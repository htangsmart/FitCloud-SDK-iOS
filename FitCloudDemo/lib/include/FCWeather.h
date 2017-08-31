//
//  FCWeather.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"
#import "FCDefine.h"


@interface FCWeather : NSObject <FCObjectProtocal>
/**
 当前温度
 */
@property (nonatomic, assign) NSInteger temperature;

/**
 最高温度
 */
@property (nonatomic, assign) NSInteger maxTemperature;


/**
 最低温度
 */
@property (nonatomic, assign) NSInteger minTemperature;

/**
 天气状况，从服务器获取天气状态后，你需要转换为枚举值对应的天气
 */
@property (nonatomic, assign) FCWeatherState weatherState;

/**
 当前天气所在城市
 */
@property (nonatomic, strong) NSString *city;
@end
