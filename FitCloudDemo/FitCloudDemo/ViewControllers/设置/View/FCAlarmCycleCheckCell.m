//
//  FCAlarmCycleCheckCell.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCAlarmCycleCheckCell.h"


@interface FCAlarmCycleCheckCell ()
@property (nonatomic, strong) UIImageView *checkImageView;
@end


@implementation FCAlarmCycleCheckCell
@synthesize checked = _checked;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _checkImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_check"]];
    self.accessoryView = _checkImageView;
}

- (BOOL)isChecked
{
    return _checked;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    self.checkImageView.hidden = !_checked;
}


@end
