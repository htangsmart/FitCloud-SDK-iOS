//
//  HFRadioAlertView.h
//  HFit
//
//  Created by 远征 马 on 16/8/21.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HFRadioAlertView : UIView
@property (nonatomic, strong) NSString *checkItem;
@property (nonatomic, copy) void(^didTouchBlock)(NSString *item);
@property (nonatomic, copy) void(^didUpdateDisplayBlock)(NSData *data);

+ (instancetype)alertViewWithTitle:(NSString*)title andItems:(NSArray*)items;
+ (instancetype)wristbandDisplayWithData:(NSData*)data;
- (void)show;
@end
