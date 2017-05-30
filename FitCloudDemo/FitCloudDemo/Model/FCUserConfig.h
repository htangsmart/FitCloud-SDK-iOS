//
//  FCUserConfig.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用于存储用户资料
@interface FCUserConfig : NSObject
@property (nonatomic, assign) UInt32 age;
@property (nonatomic, assign) UInt32 sex;
@property (nonatomic, assign) UInt32 weight;
@property (nonatomic, assign) UInt32 height;
// 血压参考值
@property (nonatomic, assign) UInt16 systolicBP;
@property (nonatomic, assign) UInt16 diastolicBP;
// 佩戴方式
@property (nonatomic, assign) BOOL isLeftHandWearEnabled;
// 单位 0 为公制单位  1 英制单位
@property (nonatomic, assign) BOOL isImperialUnits;
@end
