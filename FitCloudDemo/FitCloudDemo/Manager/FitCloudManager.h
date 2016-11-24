//
//  FitCloudManager.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/11/23.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitCloudManager : NSObject
+ (instancetype)manager;

/**
 Initializes the SDK service
 */
- (void)startService;
@end
