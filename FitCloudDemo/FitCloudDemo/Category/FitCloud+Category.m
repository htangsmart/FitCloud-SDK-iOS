//
//  FitCloud+Category.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "FitCloud+Category.h"

@implementation FitCloud (Category)

- (BOOL)storeBondDevice
{
    if (!self.servicePeripheral) {
        return NO;
    }
    NSString *uuidString = self.servicePeripheral.identifier.UUIDString;
    NSString *deviceName = self.servicePeripheral.name;
    NSNumber *guestId = @(100); // 使用默认用户id,开发人员可以根据自己服务器账号id配置
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (uuidString && deviceName && guestId)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:uuidString forKey:@"BondDevice"];
        [params setObject:deviceName forKey:uuidString];
        [standardUserDefaults setObject:params forKey:guestId.stringValue];
        return [standardUserDefaults synchronize];
    }
    return NO;
}


// 移除绑定数据
- (BOOL)removeBondDevice
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *guestId = @(100);
    if (!guestId)
    {
        return NO;
    }
    NSMutableDictionary *params = [standardUserDefaults objectForKey:guestId.stringValue];
    if (params) {
        [standardUserDefaults removeObjectForKey:guestId.stringValue];
    }
    return  [standardUserDefaults synchronize];
}

- (NSString*)bondDeviceUUID
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *guestId = @(100);
    if (!guestId)
    {
        return nil;
    }
    NSMutableDictionary *params = [standardUserDefaults objectForKey:guestId.stringValue];
    if (params && params[@"BondDevice"]) {
        return params[@"BondDevice"];
    }
    return nil;
}

- (NSString*)bondDeviceName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *guestId = @(100);
    if (!guestId) {
        return nil;
    }
    NSMutableDictionary *params = [standardUserDefaults objectForKey:guestId.stringValue];
    if (params && params[@"BondDevice"]) {
        NSString *uuid =  params[@"BondDevice"];
        if (uuid) {
            return params[uuid];
        }
    }
    return nil;
}

- (BOOL)deviceIsBond
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *guestId = @(100);
    if (!guestId) {
        return NO;
    }
    NSMutableDictionary *params = [standardUserDefaults objectForKey:guestId.stringValue];
    if (params && params[@"BondDevice"]) {
        return YES;
    }
    return NO;
}


// 蓝牙名称和状态
- (NSString*)deviceNameAndState
{
    NSString *deviceName = [self bondDeviceName];
    if (deviceName)
    {
        if (self.servicePeripheral && self.servicePeripheral.state == CBPeripheralStateConnected) {
            return [NSString stringWithFormat:@"已连接 %@",deviceName];
        }
        else
        {
            return [NSString stringWithFormat:@"未连接 %@",deviceName];
        }
    }
    return @"未绑定";
}

@end
