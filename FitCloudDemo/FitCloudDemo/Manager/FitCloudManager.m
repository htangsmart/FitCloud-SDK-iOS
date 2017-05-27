//
//  FitCloudManager.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/11/23.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "FitCloudManager.h"
#import <FitCloudKit.h>


@implementation FitCloudManager

+ (instancetype)manager
{
    static FitCloudManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FitCloudManager alloc]init];
    });
    return instance;
}

- (void)startService
{
    [self registerNotification];
    
}

#pragma mark - notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(centralManagerDidChangeState:) name:EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didConnectPeripheral:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFailConnectPeripheral:) name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDisconnectPeripheral:) name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
}

- (void)centralManagerDidChangeState:(NSNotification*)notification
{
    
}

- (void)didConnectPeripheral:(NSNotification*)notification
{
    
}

- (void)didFailConnectPeripheral:(NSNotification*)notification
{
    
}

- (void)didDisconnectPeripheral:(NSNotification*)notification
{
    
}

- (void)didDiscoverCharacteristics:(NSNotification*)notification
{
    
}


#pragma mark - 绑定或者登录


@end
