//
//  ScanListViewController.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanListViewController : UIViewController
@property (nonatomic, copy) void(^didCompletionBlock)();
@end
