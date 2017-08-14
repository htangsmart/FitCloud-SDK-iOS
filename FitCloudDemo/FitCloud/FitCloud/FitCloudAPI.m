//
//  FitCloudAPI.m
//  FitCloud
//
//  Created by 远征 马 on 2017/8/9.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FitCloudAPI.h"

@implementation FitCloudAPI
#pragma mark - 固件升级检查

+ (NSURLSessionDataTask*)getNewFirmwareFromServer:(NSString *)versionInfoString result:(void(^)(id responseObject, NSError *error))retHandler
{
    if (!versionInfoString)
    {
        NSError *error = [NSError errorWithDomain:@"ParamsError"
                                             code:-1999
                                         userInfo:@{NSLocalizedDescriptionKey:@"传入空的参数"}];
        if (retHandler) retHandler(nil,error);
        return nil;
    }
    //创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://dl.hetangsmart.com:8380/open/updateVersionNew.action"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
    request.timeoutInterval = 30;
    
    NSString *postBody = [NSString stringWithFormat:@"os=ios&hardwareInfo=%@",versionInfoString];
    request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    //创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && !error)
        {
            NSError *aError;
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&aError];
            if (retHandler) {
                retHandler(object,aError);
            }
        }
        else
        {
            if (retHandler) {
                retHandler(nil,error);
            }
        }
    }];
    [task resume];
    return task;
}
@end
