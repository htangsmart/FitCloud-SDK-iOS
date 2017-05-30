//
//  FCNotificationCell.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCNotificationCell.h"

@implementation FCNotificationCell
@synthesize mySwitch = _mySwitch;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self setUp];
}

- (void)setUp
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _mySwitch = [[UISwitch alloc]init];
    [_mySwitch addTarget:self action:@selector(mySwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _mySwitch;
}

- (void)setSwitchValueChangeBlock:(void (^)(UISwitch *, NSString *))switchValueChangeBlock
{
    if (!_switchValueChangeBlock) {
        _switchValueChangeBlock = switchValueChangeBlock;
    }
}

- (void)mySwitchValueChanged:(UISwitch*)aSwitch
{
    if (_switchValueChangeBlock) {
        _switchValueChangeBlock(aSwitch, self.textLabel.text);
    }
}
@end
