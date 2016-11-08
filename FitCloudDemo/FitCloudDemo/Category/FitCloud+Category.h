//
//  FitCloud+Category.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <FitCloudKit.h>

@interface FitCloud (Category)
// 存储绑定数据
- (BOOL)storeBondDevice;

// 移除绑定数据
- (BOOL)removeBondDevice;

// 绑定的设备uuid
- (NSString*)bondDeviceUUID;

// 绑定的设备名称
- (NSString*)bondDeviceName;

// 判断设备是否绑定
- (BOOL)deviceIsBond;

// 蓝牙名称和状态
- (NSString*)deviceNameAndState;
@end
