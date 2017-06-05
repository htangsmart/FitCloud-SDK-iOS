//
//  FCSleepDisplayCell.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/6/5.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCSleepDisplayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalSleepTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deepSleepLabel;
@property (weak, nonatomic) IBOutlet UILabel *lightSleepLabel;

@end
