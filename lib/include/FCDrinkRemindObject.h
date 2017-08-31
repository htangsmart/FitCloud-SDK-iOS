//
//  FCDrinkRemindObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"

// 喝水提醒配置
@interface FCDrinkRemindObject : NSObject <FCObjectProtocal>

@property (nonatomic, assign) BOOL isOn;
// 时间间隔 分钟
@property (nonatomic, assign) NSUInteger timeInteval;
// 开始时间 （从0开始的分钟数）
@property (nonatomic, assign) NSUInteger stMinute;
// 结束时间 （从0开始的分钟数）
@property (nonatomic, assign) NSUInteger edMinute;
@end
