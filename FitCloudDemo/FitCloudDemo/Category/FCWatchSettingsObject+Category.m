//
//  FCWatchSettingsObject+Category.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCWatchSettingsObject+Category.h"
#import <YYModel.h>


@implementation FCWatchSettingsObject (Category)

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nfSettingData forKey:@"nfSettingData"];
    [aCoder encodeObject:self.wsdisplayData forKey:@"wsdisplayData"];
    [aCoder encodeObject:self.featuresData forKey:@"featuresData"];
    [aCoder encodeObject:self.versionData forKey:@"versionData"];
    [aCoder encodeObject:self.healthMonitoringData forKey:@"healthMonitoringData"];
    [aCoder encodeObject:self.sedentaryReminderData forKey:@"sedentaryReminderData"];
    [aCoder encodeObject:self.defaultBloodPressureData forKey:@"defaultBloodPressureData"];
    [aCoder encodeObject:self.drinkReminderData forKey:@"drinkReminderData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.nfSettingData = [aDecoder decodeObjectForKey:@"nfSettingData"];
        self.wsdisplayData = [aDecoder decodeObjectForKey:@"wsdisplayData"];
        self.featuresData = [aDecoder decodeObjectForKey:@"featuresData"];
        self.versionData = [aDecoder decodeObjectForKey:@"versionData"];
        self.healthMonitoringData = [aDecoder decodeObjectForKey:@"healthMonitoringData"];
        self.sedentaryReminderData = [aDecoder decodeObjectForKey:@"sedentaryReminderData"];
        self.defaultBloodPressureData = [aDecoder decodeObjectForKey:@"defaultBloodPressureData"];
        self.drinkReminderData = [aDecoder decodeObjectForKey:@"drinkReminderData"];
    }
    return self;
}

@end
