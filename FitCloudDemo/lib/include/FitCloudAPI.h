//
//  FitCloudAPI.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/9.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitCloudAPI : NSObject
#pragma mark - 固件升级检测与下载

/**
 固件升级检测API接口，此结果返回新固件下载链接和固件信息说明
 {
     "msg": "请求成功",
     "object": {
         "compulsion_tag": "0", // 是否需要强制更新
         "hardwareInfo": "0000000000200000004D002200330000110131170000000000000D0212345678", // 固件版本信息
         "hardwareName": "X40020170518", // 固件名称
         "hardwareUrl": "http://dl.hetangsmart.com:8380/upload/bin/64c30979522841dd9731174b4e18f510.bin", //固件下载链接
         "note": "" // 备注信息
     },
    "status": 1
 }
 注：部分固件可能需要进行两次升级，所以每次升级成功都需要再查询一次新固件信息
 
 @param versionInfoString 固件版本信息字符串
 @param retHandler 请求结果回调
 @return 请求任务
 */
+ (NSURLSessionDataTask*)getNewFirmwareFromServer:(NSString *)versionInfoString result:(void(^)(id responseObject, NSError *error))retHandler;
@end

