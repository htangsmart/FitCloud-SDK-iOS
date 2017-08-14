//
//  HFLocalFirmwareViewController.h
//  HFit
//
//  Created by 远征 马 on 16/8/2.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFLocalFirmwareViewController : UIViewController
@property (nonatomic, assign) BOOL isFlashOTA;
@property (nonatomic, copy) void(^didSelectedFileAtPathBlock)(NSString *filePath, BOOL isFlashOTA);
@end
