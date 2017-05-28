//
//  FCConnectStateCell.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/28.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCConnectStateCell.h"

@interface FCConnectStateCell ()
@property (nonatomic, strong) UIImageView *stateImageView;
@end

@implementation FCConnectStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    _stateImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_stateImageView];
}

- (void)setHasBeenBound:(BOOL)hasBeenBound
{
    _hasBeenBound = hasBeenBound;
    self.stateImageView.hidden = !_hasBeenBound;
}

- (void)setConnected:(BOOL)connected
{
    _connected = connected;
    if (_connected) {
        _stateImageView.image = [UIImage imageNamed:@"ico_connected"];
    }
    else
    {
        _stateImageView.image = [UIImage imageNamed:@"ico_disconnect"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGRect frame = CGRectMake(width-60, 14.5, 21, 21);
    self.stateImageView.frame = frame;
}

@end
