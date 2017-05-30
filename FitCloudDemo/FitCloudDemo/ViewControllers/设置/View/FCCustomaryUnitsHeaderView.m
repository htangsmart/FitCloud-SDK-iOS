//
//  FCCustomaryUnitsHeaderView.m
//  HFit
//
//  Created by BillYang on 16/6/24.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "FCCustomaryUnitsHeaderView.h"

@implementation FCCustomaryUnitsHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:0.439 green:0.439 blue:0.439 alpha:1.0];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    _titleLabel.frame = (CGRect){10, height-25, width-20,20};
}
@end
