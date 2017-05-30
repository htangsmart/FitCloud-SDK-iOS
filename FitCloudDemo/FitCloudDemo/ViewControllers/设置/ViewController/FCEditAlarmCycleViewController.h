//
//  FCEditAlarmCycleViewController.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCAlarmClockCycleObject;
@interface FCEditAlarmCycleViewController : UIViewController
@property (nonatomic, strong) FCAlarmClockCycleObject *cycleObj;
@property (nonatomic, copy) void(^didRefreshWorkModeBlock)();
@end
