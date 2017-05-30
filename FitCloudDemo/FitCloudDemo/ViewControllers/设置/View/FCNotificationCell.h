//
//  FCNotificationCell.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCNotificationCell : UITableViewCell
@property (nonatomic, strong, readonly) UISwitch *mySwitch;
@property (nonatomic, copy) void (^switchValueChangeBlock)(UISwitch *aSwitch, NSString *funSwitchName);
@end
