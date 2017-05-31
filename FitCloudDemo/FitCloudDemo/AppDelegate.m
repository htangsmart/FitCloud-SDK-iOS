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
