//
//  FCWeather.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 天气状态，你需要把自己获取的天气转换成以下状态同步到手表，手表才能显示正确的天气状态
 */
typedef NS_ENUM(NSInteger, FCWeatherState)
{
    /*! 未知天气*/
    FCWeatherStateUnknown = 0xFF,
    /*! 晴天*/
    FCWeatherStateSunnyDay = 0x01,
    /*! 多云*/
    FCWeatherStateCloudy = 0x02,
    /*! 阴天*/
    FCWeatherStateOvercast = 0x03,
    /*! 阵雨*/
    FCWeatherStateShower = 0x04,
    /*! 雷阵雨、雷阵雨伴有冰雹*/
    FCWeatherStateThunderyShower = 0x05,
    /*! 小雨*/
    FCWeatherStateDrizzle = 0x06,
    /*! 中雨、大雨、暴雨*/
    FCWeatherStateHeavyRain = 0x07,
    /*! 雨夹雪、冻雨*/
    FCWeatherStateSleet = 0x08,
    /*! 小雪*/
    FCWeatherStateLightSnow = 0x09,
    /*! 大雪、暴雪*/
    FCWeatherStateHeavySnow = 0x0a,
    /*! 沙尘暴、浮尘*/
    FCWeatherStateSandstorm = 0x0b,
    /*! 雾、雾霾*/
    FCWeatherStateFogOrHaze = 0x0c,
};


/**
 温度对象，包含城市和天气状态，以及最高、最低和当前温度
 */
@interface FCWeather : NSObject
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

- (NSData*)writeData;
@end
