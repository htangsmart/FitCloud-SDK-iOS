//
//  AppDelegate.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/11/1.
//  Copyright © 2016年 马远征. All rights reserved.
//



#import "AppDelegate.h"
#import <YYModel.h>

@interface YYModelObject : NSObject
@property (nonatomic, strong) NSData *data1;
@property (nonatomic, strong) NSData *data2;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, assign) BOOL enabled;
@end

@implementation YYModelObject
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}
@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    YYModelObject *modelObj = [[YYModelObject alloc]init];
    Byte byte[2] = {0}; byte[0] = 1; byte[1] = 2;
    modelObj.data1 = [NSData dataWithBytes:byte length:2];
    Byte byte1[3] = {0}; byte1[0] = 2; byte1[1] = 2;byte1[2] = 2;
    modelObj.data2 = [NSData dataWithBytes:byte1 length:3];
    modelObj.number = @(110);
    modelObj.enabled = YES;
    
    NSLog(@"-model--%@",modelObj.yy_modelDescription);
    
    NSData *data = [modelObj yy_modelToJSONData];
    NSLog(@"-data--%@",data);
    YYModelObject *aModelObj = [YYModelObject yy_modelWithJSON:data];
    NSLog(@"-aModelObj--%@",aModelObj.yy_modelDescription);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{

}


- (void)applicationDidEnterBackground:(UIApplication *)application
{

}


- (void)applicationWillEnterForeground:(UIApplication *)application
{

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{

}


- (void)applicationWillTerminate:(UIApplication *)application
{

}


@end
