//
//  NSObject+FCObject.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "NSObject+FCObject.h"

@implementation FCSedentaryReminderObject (Category)

- (NSString*)stMinuteString
{
    int hour = (int)floorf(self.stMinute /60);
    int minute = self.stMinute % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

- (NSString*)edMinuteString
{
    int hour = (int)floorf(self.edMinute /60);
    int minute = self.edMinute % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}
@end


@implementation NSObject (FCObject)

@end
