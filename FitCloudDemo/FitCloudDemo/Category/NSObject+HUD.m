//
//  NSObject+HUD.m
//  HFit
//
//  Created by BillYang on 16/7/4.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "NSObject+HUD.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBProgressHUDTAG)
{
    MBProgressHUDTagUnknown = 0,
    MBProgressHUDTagBase = 1 << 2,
    MBProgressHUDTagLoading = 1 << 3,
    MBProgressHUDTagProgressBar = 1 << 4,
};

@implementation NSObject (BaseHUD)

- (UIWindow*)window
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows && windows.count > 0) {
        return windows[0];
    }
    return nil;
}

- (MBProgressHUD*)hudWithTag:(MBProgressHUDTAG)hugTag
{
    UIWindow *window = [self window];
    if (!window) {
        return nil;
    }
    NSArray *hudArray = [MBProgressHUD allHUDsForView:window];
    for (MBProgressHUD *aHUD in hudArray) {
        if (aHUD.tag == hugTag) {
            return aHUD;
        }
    }
    return nil;
}


- (void)showHUDWithMessage:(NSString*)message
{
    UIWindow *window = [self window];
    if (!window) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.tag = MBProgressHUDTagBase;
    [hud hide:YES afterDelay:1.5];
}

- (void)showWarningWithMessage:(NSString*)message
{
    UIWindow *window = [self window];
    if (!window) {
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_warning"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.tag = MBProgressHUDTagBase;
    [hud hide:YES afterDelay:1.5];
}

- (void)showSuccessWithMessage:(NSString *)message
{
    UIWindow *window = [self window];
    if (!window) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_success"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.tag = MBProgressHUDTagBase;
    [hud hide:YES afterDelay:1.5];
}

- (void)showErrorWithMessage:(NSString *)message
{
    UIWindow *window = [self window];
    if (!window) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_error"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.tag = MBProgressHUDTagBase;
    [hud hide:YES afterDelay:1.5];
}

- (void)hideHUDWithSuccess:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagBase];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_success"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}


- (void)hideHUDWithFailure:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagBase];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_error"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}


- (void)hideHUDWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagBase];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}


- (void)hideHUD
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagBase];
    if (!hud) {
        return;
    }
    [hud hide:YES];
}

- (void)hideHUD:(NSString*)message completion:(dispatch_block_t)completion
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagBase];
    if (!hud) {
        if (completion) {
            completion();
        }
        return;
    }
    if (!message) {
        [hud hide:YES];
        if (completion) {
            completion();
        }
        return;
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud hide:YES afterDelay:1.5];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}


- (void)hideAllHUDs
{
    UIWindow *window = [self window];
    if (!window) {
        return ;
    }
    [MBProgressHUD hideAllHUDsForView:window animated:NO];
}
@end

#pragma mark - loadingHUD


@implementation NSObject (LoadingHUD)

- (MBProgressHUD*)showLoadingHUDWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (hud) {
        hud.labelFont = [UIFont systemFontOfSize:14];
        hud.labelText = message;
        hud.tag = MBProgressHUDTagLoading;
        hud.mode = MBProgressHUDModeIndeterminate;
        return hud;
    }
    UIWindow *window = [self window];
    if (!window) {
        return nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.labelText = message;
    hud.tag = MBProgressHUDTagLoading;
    return hud;
}

- (void)changeLoadingWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (hud) {
        hud.labelFont = [UIFont systemFontOfSize:14];
        hud.labelText = message;
        hud.tag = MBProgressHUDTagLoading;
    }
}

- (void)hideLoadingHUDWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}

- (void)hideLoadingHUDWithFailure:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_error"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}

- (void)hideLoadingHUDWithSuccess:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_success"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}

- (void)hideLoadingHUDWithSuccess:(NSString*)message completion:(dispatch_block_t)completion
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (!hud) {
        if (completion) {
            completion();
        }
        return;
    }
    if (!message)
    {
        [hud hide:YES];
        if (completion) {
            completion();
        }
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_success"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}


- (void)hideLoadingHUD
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagLoading];
    if (!hud) {
        return;
    }
    [hud hide:YES];
}
@end


#pragma mark - 进度条HUD

@implementation NSObject (ProgressBarHUD)

- (MBProgressHUD*)showProgressHUDWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagProgressBar];
    if (hud)
    {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelFont = [UIFont systemFontOfSize:14];
        hud.labelText = message;
        hud.tag = MBProgressHUDTagProgressBar;
        return hud;
    }
    UIWindow *window = [self window];
    if (!window) {
        return nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.labelText = message;
    hud.tag = MBProgressHUDTagProgressBar;
    return hud;
}

- (void)hideProgressHUDWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagProgressBar];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}

- (void)hideProgressHUDWithFailure:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagProgressBar];
    if (!hud) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_error"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}


- (void)hideProgressHUDWithSuccess:(NSString*)message
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagProgressBar];
    if (!hud)
    {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_success"]];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud hide:YES afterDelay:1.5];
}


- (void)hideProgressHUD
{
    MBProgressHUD *hud = [self hudWithTag:MBProgressHUDTagProgressBar];
    if (!hud) {
        return;
    }
    [hud hide:YES];
}
@end
