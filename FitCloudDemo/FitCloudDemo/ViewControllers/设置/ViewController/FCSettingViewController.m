//
//  FCSettingViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSettingViewController.h"

@interface FCSettingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCSettingViewController

#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_profile"];
        cell.textLabel.text = @"用户资料";
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_note"];
        cell.textLabel.text = @"通知开关";
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_unit"];
        cell.textLabel.text = @"惯用单位";
    }
    else if (indexPath.row == 3)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_alarm"];
        cell.textLabel.text = @"闹钟配置";
    }
    else if (indexPath.row == 4)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_upgrade"];
        cell.textLabel.text = @"固件升级";
    }
    else if (indexPath.row == 5)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_other"];
        cell.textLabel.text = @"其他设置";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
