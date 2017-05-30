//
//  FCDailyAlarmCell.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCDailyAlarmCell.h"

@implementation FCDailyAlarmCell

@synthesize stSwitch = _stSwitch;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont boldSystemFontOfSize:18];
    _timeLabel.textColor = [UIColor colorWithRed:0.176 green:0.180 blue:0.184 alpha:1.0];
    [self.contentView addSubview:_timeLabel];
    
    _weekLabel = [[UILabel alloc]init];
    _weekLabel.font = [UIFont systemFontOfSize:15];
    _weekLabel.textColor = [UIColor colorWithRed:0.667 green:0.671 blue:0.678 alpha:1.0];
    [self.contentView addSubview:_weekLabel];
    
    _stSwitch = [[UISwitch alloc]init];
    _stSwitch.onTintColor = [UIColor colorWithRed:0.898 green:0.702 blue:0.545 alpha:1.0];
    [_stSwitch addTarget:self action:@selector(swicthValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _stSwitch;
}

- (void)swicthValueChanged:(UISwitch*)sender
{
    if (_didChangedSwicthValueBlock) {
        _didChangedSwicthValueBlock(self);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.bounds);
    CGSize tlSize = [_timeLabel sizeThatFits:CGSizeZero];
    _timeLabel.frame = (CGRect){20,height*0.5 - tlSize.height,tlSize.width,tlSize.height};
    CGSize wlSize = [_weekLabel sizeThatFits:CGSizeZero];
    _weekLabel.frame = (CGRect){20,height*0.5+5 ,wlSize.width, wlSize.height};
}

@end
