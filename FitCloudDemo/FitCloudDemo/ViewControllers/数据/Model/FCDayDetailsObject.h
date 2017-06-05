//
//  FCDayDetailsObject.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/6/5.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCDayDetailsObject : NSObject
@property (nonatomic, strong) NSNumber *timeStamp;
@property (nonatomic, strong) NSNumber *stepCount;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *calorie;
@property (nonatomic, strong) NSNumber *deepSleep;
@property (nonatomic, strong) NSNumber *lightSleep;
@property (nonatomic, strong) NSNumber *avgHeartRate;
@end
