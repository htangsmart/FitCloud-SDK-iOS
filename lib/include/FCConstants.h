//
//  FCConstants.h
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import <Foundation/Foundation.h>


// This notification is issued when the central manager's status changes
FOUNDATION_EXTERN NSString *const EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY;

// 外设连接成功通知
FOUNDATION_EXTERN NSString *const EVENT_CONNECT_PERIPHERAL_NOTIFY;

// 外设连接失败通知
FOUNDATION_EXTERN NSString *const EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY;

// 外设断开连接通知
FOUNDATION_EXTERN NSString *const EVENT_DISCONNECT_PERIPHERAL_NOTIFY;

// 发现服务特征,接到此通知，你可以进行蓝牙写数据
FOUNDATION_EXTERN NSString *const EVENT_DISCOVER_CHARACTERISTICS_NOTIFY;

// 固件升级成功断开连接通知
FOUNDATION_EXTERN NSString *const EVENT_FIRMWARE_UPDATE_DISCONNECT_PERIPHERAL_NOTIFY;
