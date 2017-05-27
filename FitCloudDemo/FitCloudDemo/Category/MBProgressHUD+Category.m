//
//  MBProgressHUD+Category.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "MBProgressHUD+Category.h"

@implementation MBProgressHUD (Category)

- (void)changeHUDWithMessage:(NSString*)message andMode:(MBProgressHUDMode)mode
{
    if (!self) {
        return;
    }
    self.mode = mode;
    self.labelText = message;
    self.labelFont = [UIFont systemFontOfSize:14];
}


- (void)hideHUDWithMessage:(NSString*)message
{
    if (!self) {
        return;
    }
    self.mode = MBProgressHUDModeText;
    self.labelText = message;
    self.labelFont = [UIFont systemFontOfSize:14];
    [self hide:YES afterDelay:1.5];
}

- (void)hideHUDWithSuccess:(NSString*)message
{
    if (!self) {
        return;
    }
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_success"]];
    self.labelText = message;
    self.labelFont = [UIFont systemFontOfSize:14];
    [self hide:YES afterDelay:1.5];
}

- (void)hideHUDWithFailure:(NSString*)message
{
    if (!self) {
        return;
    }
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_error"]];
    self.labelText = message;
    self.labelFont = [UIFont systemFontOfSize:14];
    [self hide:YES afterDelay:1.5];
}

@end
