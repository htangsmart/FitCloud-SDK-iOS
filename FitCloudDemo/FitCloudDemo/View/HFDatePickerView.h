//
//  HFDatePickerView.h
//  HFit
//
//  Created by 远征 马 on 16/8/21.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFDatePickerView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic,   copy) void(^didCompletePickBlock)(NSInteger minutes);
@property (nonatomic,   copy) void(^didCompletePickerDateBlock)(NSDate *date);
+ (instancetype)pickerView;
- (void)show;
@end
