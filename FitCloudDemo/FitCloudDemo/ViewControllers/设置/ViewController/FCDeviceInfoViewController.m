//
//  FCDeviceInfoViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCDeviceInfoViewController.h"

@interface FCDeviceInfoViewController ()

@end

@implementation FCDeviceInfoViewController

#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - 按钮交互

- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
