//
//  HFPickerView.h
//  HFit
//
//  Created by 远征 马 on 16/8/23.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HFPickerStyle)
{
    HFPickerStyleNone,
    HFPickerStyleBirthDate,
    HFPickerStyleMHeight,
    HFPickerStyleEHeight,
    HFPickerStyleMWeight,
    HFPickerStyleEWeight,
    HFPickerStyleSBP,
    HFPickerStyleDBP,
};

@interface HFPickerView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) HFPickerStyle pickerStyle;
@property (nonatomic, assign) NSRange pickRange;
@property (nonatomic, assign) NSUInteger value;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic,   copy) void(^didCompletionPickBlock)(NSNumber *pickValue);
@property (nonatomic,   copy) void(^didCompletionPickDateBlock)(NSString *birthDate);
+ (instancetype)pickerView;
- (void)show;
@end
