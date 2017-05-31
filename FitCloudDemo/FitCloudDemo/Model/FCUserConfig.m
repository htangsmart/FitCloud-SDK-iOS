//
//  FCUserConfig.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCUserConfig.h"

@implementation FCUserConfig
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt32:self.age forKey:@"age"];
    [aCoder encodeInt32:self.sex forKey:@"sex"];
    [aCoder encodeInt32:self.weight forKey:@"weight"];
    [aCoder encodeInt32:self.height forKey:@"height"];
    [aCoder encodeInt32:self.systolicBP forKey:@"systolicBP"];
    [aCoder encodeInt32:self.diastolicBP forKey:@"diastolicBP"];
    [aCoder encodeBool:self.isLeftHandWearEnabled forKey:@"isLeftHandWearEnabled"];
    [aCoder encodeBool:self.isImperialUnits forKey:@"isImperialUnits"];
    [aCoder encodeBool:self.drinkRemindEnabled forKey:@"drinkRemindEnabled"];
    [aCoder encodeObject:self.longSitRemindData forKey:@"longSitRemindData"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.age = [aDecoder decodeInt32ForKey:@"age"];
        self.sex = [aDecoder decodeInt32ForKey:@"sex"];
        self.weight = [aDecoder decodeInt32ForKey:@"weight"];
        self.height = [aDecoder decodeInt32ForKey:@"height"];
        self.systolicBP = [aDecoder decodeInt32ForKey:@"systolicBP"];
        self.diastolicBP = [aDecoder decodeInt32ForKey:@"diastolicBP"];
        self.isLeftHandWearEnabled = [aDecoder decodeBoolForKey:@"isLeftHandWearEnabled"];
        self.isImperialUnits = [aDecoder decodeBoolForKey:@"isImperialUnits"];
        self.drinkRemindEnabled = [aDecoder decodeBoolForKey:@"drinkRemindEnabled"];
        self.longSitRemindData = [aDecoder decodeObjectForKey:@"longSitRemindData"];
    }
    return self;
}
@end
