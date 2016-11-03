//
//  FCConstants.h
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import <Foundation/Foundation.h>


// 蓝牙更新状态通知
FOUNDATION_EXTERN NSString *const EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY;

// 外设成功连接通知
FOUNDATION_EXTERN NSString *const EVENT_CONNECT_PERIPHERAL_NOTIFY;

// 连接外设失败通知
FOUNDATION_EXTERN NSString *const EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY;

// 外设断开连接通知
FOUNDATION_EXTERN NSString *const EVENT_DISCONNECT_PERIPHERAL_NOTIFY;

// 发现外设服务特征值通知
FOUNDATION_EXTERN NSString *const EVENT_DISCOVER_CHARACTERISTICS_NOTIFY;
