//
//  HFDatePickerView.m
//  HFit
//
//  Created by 远征 马 on 16/8/21.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "HFDatePickerView.h"
#import <DateTools.h>

@interface HFDatePickerView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation HFDatePickerView
+ (instancetype)pickerView
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"HFDatePickerView" owner:self options:nil];
    HFDatePickerView *picker = (HFDatePickerView*)(xibArray[0]);
    picker.frame = [UIScreen mainScreen].bounds;
    return picker;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    self.datePicker.datePickerMode = _datePickerMode;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 4.0;
    self.bgView.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTitle:@"确定" forState:UIControlStateHighlighted];
}

- (IBAction)clickToCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)clickToDone:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSInteger hour = date.hour;
    NSInteger minute = date.minute;
    NSInteger minutes = hour*60 + minute;
    if (_didCompletePickBlock) {
        _didCompletePickBlock(minutes);
    }
    if (_didCompletePickerDateBlock) {
        _didCompletePickerDateBlock(date);
    }
    [self removeFromSuperview];
}

- (void)show
{
    if (self.superview)
    {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window addSubview:self];
}
@end
