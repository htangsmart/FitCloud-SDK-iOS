//
//  NSObject+FCObject.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FitCloudKit.h>

@interface FCSedentaryReminderObject (Category)
- (NSString*)stMinuteString;
- (NSString*)edMinuteString;
@end

@interface FCHealthMonitoringObject (Category)
- (NSString*)stMinuteString;
- (NSString*)edMinuteString;
@end


@interface FCSensorFlagObject (Category)
- (NSUInteger)countOfItems;
- (NSArray*)itemNameArray;
@end

@interface NSObject (FCObject)

@end
