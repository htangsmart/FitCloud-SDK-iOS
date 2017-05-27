//
//  MBProgressHUD+Category.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Category)
- (void)changeHUDWithMessage:(NSString*)message andMode:(MBProgressHUDMode)mode;
- (void)hideHUDWithMessage:(NSString*)message;
- (void)hideHUDWithSuccess:(NSString*)message;
- (void)hideHUDWithFailure:(NSString*)message;
@end
