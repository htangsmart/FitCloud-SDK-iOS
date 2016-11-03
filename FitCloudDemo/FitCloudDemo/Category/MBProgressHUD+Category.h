//
//  MBProgressHUD+Category.h
//  HFit
//
//  Created by 远征 马 on 16/7/25.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Category)

- (void)changeHUDWithMessage:(NSString*)message andMode:(MBProgressHUDMode)mode;


- (void)hideHUDWithMessage:(NSString*)message;
- (void)hideHUDWithSuccess:(NSString*)message;
- (void)hideHUDWithFailure:(NSString*)message;

@end
