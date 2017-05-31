//
//  FCNotificationCell.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCSwitch;
@interface FCNotificationCell : UITableViewCell
@property (nonatomic, strong, readonly) FCSwitch *mySwitch;
@property (nonatomic, copy) void (^switchValueChangeBlock)(FCSwitch *aSwitch, NSString *funSwitchName);
@end
