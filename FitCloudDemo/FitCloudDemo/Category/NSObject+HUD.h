//
//  NSObject+HUD.h
//  HFit
//
//  Created by BillYang on 16/7/4.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Category.h"


@interface NSObject (BaseHUD)
- (void)showHUDWithMessage:(NSString*)message;
- (void)showWarningWithMessage:(NSString*)message;
- (void)showSuccessWithMessage:(NSString *)message;
- (void)showErrorWithMessage:(NSString *)message;

- (void)hideHUDWithSuccess:(NSString*)message;
- (void)hideHUDWithFailure:(NSString*)message;
- (void)hideHUDWithMessage:(NSString*)message;
- (void)hideHUD:(NSString*)message completion:(dispatch_block_t)completion;
- (void)hideHUD;

// 隐藏所有hud
- (void)hideAllHUDs;
@end


#pragma mark - loadingHUD

@interface NSObject (LoadingHUD)
- (MBProgressHUD*)showLoadingHUDWithMessage:(NSString*)message;
- (void)changeLoadingWithMessage:(NSString*)message;
- (void)hideLoadingHUDWithMessage:(NSString*)message;
- (void)hideLoadingHUDWithFailure:(NSString*)message;
- (void)hideLoadingHUDWithSuccess:(NSString*)message;
- (void)hideLoadingHUDWithSuccess:(NSString*)message completion:(dispatch_block_t)completion;
- (void)hideLoadingHUD;
@end


#pragma mark - 进度条HUD

@interface NSObject (ProgressBarHUD)
- (MBProgressHUD*)showProgressHUDWithMessage:(NSString*)message;
- (void)hideProgressHUDWithMessage:(NSString*)message;
- (void)hideProgressHUDWithFailure:(NSString*)message;
- (void)hideProgressHUDWithSuccess:(NSString*)message;
- (void)hideProgressHUD;
@end
