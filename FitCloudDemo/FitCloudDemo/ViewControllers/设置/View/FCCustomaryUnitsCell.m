//
//  FCCustomaryUnitsCell.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCCustomaryUnitsCell.h"

@implementation FCCustomaryUnitsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textLabel.font = [UIFont systemFontOfSize:16];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (!_checked) {
        self.textLabel.textColor = [UIColor colorWithRed:0.063 green:0.063 blue:0.063 alpha:1.0];
    }
    else
    {
        self.textLabel.textColor = [UIColor colorWithRed:0.992 green:0.718 blue:0.486 alpha:1.0];
    }
}


@end
