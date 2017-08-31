//
//  FCNotificationObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"


/**
 手表通知开关对象
 */
@interface FCNotificationObject : NSObject <FCObjectProtocal>

/**
 手机来电通知，有新来电时手表会震动提醒
 */
@property (nonatomic, assign) BOOL incomingCall;

/**
 短信通知，有新短信时手表会提醒
 */
@property (nonatomic, assign) BOOL smsAlerts;
@property (nonatomic, assign) BOOL qqMessage;
@property (nonatomic, assign) BOOL wechatMessage;
@property (nonatomic, assign) BOOL facebook;
@property (nonatomic, assign) BOOL twitter;
@property (nonatomic, assign) BOOL linkedin;
@property (nonatomic, assign) BOOL instagram;
@property (nonatomic, assign) BOOL pinterest;
@property (nonatomic, assign) BOOL whatsapp;
@property (nonatomic, assign) BOOL line;
@property (nonatomic, assign) BOOL facebookMessage;

/**
 打开此项，其他app来消息时，手表会及时通知用户
 */
@property (nonatomic, assign) BOOL otherApp;

/**
 消息内容是否在手表屏幕上显示，打开此项短消息内容会即时显示在手表屏幕上
 */
@property (nonatomic, assign) BOOL messageDisplayEnabled;

/**
 蓝牙断开提醒，当手表和手机断开连接，手机app会及时提醒用户,此处需要用户自己去做app提醒
 */
@property (nonatomic, assign) BOOL appDisconnectAlerts;

/**
 手表断开提醒，当手表和手机断开连接，手表会震动提醒
 */
@property (nonatomic, assign) BOOL watchDisconnectAlerts;

/**
 kakao消息通知
 */
@property (nonatomic, assign) BOOL kakaoMessage;
@end

