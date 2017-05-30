//
//  FitCloudManager.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/11/23.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitCloudManager : NSObject
// 断开后是否需要回连标志，如果有账号切换，登录成功或者注销后需要对此赋值
@property (nonatomic, assign) BOOL autoConnectDisabled;
+ (instancetype)manager;

/**
 Initializes the SDK service
 */
- (void)startService;


/**
 下拉刷新同步数据
 */
- (void)pullDownToSyncHistoryData;
@end
