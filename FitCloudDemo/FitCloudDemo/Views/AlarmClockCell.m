//
//  AlarmClockCell.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "AlarmClockCell.h"

@implementation AlarmClockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryView = self.acSwitch;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UISwitch*)acSwitch
{
    if (_acSwitch) {
        return _acSwitch;
    }
    _acSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    return _acSwitch;
}

@end
