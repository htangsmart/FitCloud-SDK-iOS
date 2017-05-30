//
//  HFPickerView.m
//  HFit
//
//  Created by 远征 马 on 16/8/23.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "HFPickerView.h"
#import <DateTools.h>

@interface HFPickerView() <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation HFPickerView

+ (instancetype)pickerView
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"HFPickerView" owner:self options:nil];
    HFPickerView *view =  (HFPickerView*)(xibArray[0]);
    view.frame = [UIScreen mainScreen].bounds;
    return view;

}

- (IBAction)clickToCancel:(id)sender
{
    [self removeFromSuperview];
}


- (IBAction)clickToDone:(id)sender
{
    if (self.pickerStyle == HFPickerStyleBirthDate)
    {
        NSInteger year = [self.pickerView selectedRowInComponent:0];
        NSInteger month = [self.pickerView selectedRowInComponent:1];
        NSString *birthDate = [NSString stringWithFormat:@"%@.%02ld",@(year+1910),(long)(month+1)];
        if (_didCompletionPickDateBlock) {
            _didCompletionPickDateBlock(birthDate);
        }
        [self removeFromSuperview];
        return;
    }
    NSInteger value = [self.pickerView selectedRowInComponent:0];
    NSUInteger location = self.pickRange.location;
    if (_didCompletionPickBlock) {
        _didCompletionPickBlock(@(location+value));
    }
    [self removeFromSuperview];
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    self.displayView.layer.cornerRadius = 4.0;
    self.displayView.layer.masksToBounds = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTitle:@"确定" forState:UIControlStateHighlighted];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setValue:(NSUInteger)value
{
    _value = value;
    if (_pickerStyle == HFPickerStyleEHeight) {
        NSInteger row = (value-30) > 0 ?(value-30):0;
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    else if (_pickerStyle == HFPickerStyleMHeight)
    {
        NSInteger row = (value-130) > 0 ?(value-130):0;
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    else if (_pickerStyle == HFPickerStyleEWeight)
    {
        NSInteger row = (value-60) > 0 ?(value-60):0;
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    else if (_pickerStyle == HFPickerStyleMWeight)
    {
        NSInteger row = (value-30) > 0 ?(value-30):0;
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    else if (_pickerStyle == HFPickerStyleSBP)
    {
        NSInteger row = (value-80) > 0 ?(value-80):0;
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    else if (_pickerStyle == HFPickerStyleDBP)
    {
        NSInteger row = (value-40) > 0 ?(value-40):0;
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    
}


- (void)setBirthDate:(NSString *)birthDate
{
    _birthDate = birthDate;
    if (self.pickerStyle != HFPickerStyleBirthDate)
    {
        return;
    }
    
    if (birthDate.length >= 4) {
        NSString *yearString = [birthDate substringWithRange:NSMakeRange(0, 4)];
        [self.pickerView selectRow:yearString.integerValue - 1910 inComponent:0 animated:NO];
    }
    if (birthDate.length >= 7) {
        NSString *monthString = [birthDate substringWithRange:NSMakeRange(5, 2)];
        [self.pickerView selectRow:monthString.integerValue-1 inComponent:1 animated:NO];
    }
    
}

- (void)setPickerStyle:(HFPickerStyle)pickerStyle
{
    _pickerStyle = pickerStyle;
    if (_pickerStyle == HFPickerStyleEHeight) {
        self.title = @"身高 in";
        self.pickRange = NSMakeRange(30, 70);
    }
    else if (_pickerStyle == HFPickerStyleMHeight)
    {
        self.title = @"身高 cm";
        self.pickRange = NSMakeRange(130, 120);
    }
    else if (_pickerStyle == HFPickerStyleEWeight) {
        self.title = @"体重 lb";
        self.pickRange = NSMakeRange(60, 380);
    }
    else if (_pickerStyle == HFPickerStyleMWeight)
    {
        self.title = @"体重 kg";
        self.pickRange = NSMakeRange(30, 170);
    }
    else if (_pickerStyle == HFPickerStyleSBP)
    {
        self.title = @"收缩压";
        self.pickRange = NSMakeRange(80, 120);
    }
    else if (_pickerStyle == HFPickerStyleDBP)
    {
        self.title = @"舒张压";
        self.pickRange = NSMakeRange(40, 80);
    }
    else if (_pickerStyle == HFPickerStyleBirthDate)
    {
        self.title = @"出生年月";
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HFPickerStyleBirthDate) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerStyle == HFPickerStyleBirthDate) {
        if (component == 0) {
            
            NSInteger curYear = [NSDate date].year;
            return curYear - 1910 + 1;
        }
        if (component == 1) {
            return 12;
        }
    }
    return self.pickRange.length+1;
}

#pragma mark - UIPickViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HFPickerStyleBirthDate) {
        if (component == 0) {
            
            return @(1910 + row).stringValue;
        }
        if (component == 1) {
            return @(row+1).stringValue;
        }
    }
    NSUInteger location = self.pickRange.location;
    return @(row+location).stringValue;
}


- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HFPickerStyleBirthDate)
    {
        if (component == 0) {
            
            NSString *string = @(1910 + row).stringValue;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
            return attrString;
        }
        if (component == 1) {
            NSString *string = @(row+1).stringValue;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
            return attrString;
        }
    }
    NSUInteger location = self.pickRange.location;
    NSString *string = @(row + location).stringValue;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
    return attrString;
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
