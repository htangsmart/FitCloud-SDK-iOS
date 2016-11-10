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

// This notification is issued when the peripheral is connected successfully
FOUNDATION_EXTERN NSString *const EVENT_CONNECT_PERIPHERAL_NOTIFY;

// This notification is issued when a peripheral connection fails
FOUNDATION_EXTERN NSString *const EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY;

// This notification is issued by a peripheral disconnect
FOUNDATION_EXTERN NSString *const EVENT_DISCONNECT_PERIPHERAL_NOTIFY;

// Discover the service characteristic value of the peripheral,After receiving this notice, you can write value.
FOUNDATION_EXTERN NSString *const EVENT_DISCOVER_CHARACTERISTICS_NOTIFY;

// This notification is issued when the firmware upgrade is successful or disconnected
FOUNDATION_EXTERN NSString *const EVENT_FIRMWARE_UPDATE_DISCONNECT_PERIPHERAL_NOTIFY;
