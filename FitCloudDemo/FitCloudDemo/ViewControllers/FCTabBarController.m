//
//  FCTabBarController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCTabBarController.h"

@interface FCTabBarController ()

@end

@implementation FCTabBarController


#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureBarButtonItems];
}



- (void)configureBarButtonItems
{
    UIStoryboard *sportsBoard = [UIStoryboard storyboardWithName:@"运动" bundle:nil];
    UIViewController *sportsViewController = [sportsBoard instantiateInitialViewController];
    UIStoryboard *sleepBoard = [UIStoryboard storyboardWithName:@"睡眠" bundle:nil];
    UIViewController *sleepViewController = [sleepBoard instantiateInitialViewController];
    UIStoryboard *healthBoard = [UIStoryboard storyboardWithName:@"健康" bundle:nil];
    UIViewController *healthViewController = [healthBoard instantiateInitialViewController];
    UIStoryboard *settingBoard = [UIStoryboard storyboardWithName:@"设置" bundle:nil];
    UIViewController *settingViewController = [settingBoard instantiateInitialViewController];


    NSArray *viewControllers = @[sportsViewController, sleepViewController, healthViewController, settingViewController];
    [self setViewControllers:viewControllers];
}

@end
