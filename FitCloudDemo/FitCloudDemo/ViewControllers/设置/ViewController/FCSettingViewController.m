//
//  FCSettingViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSettingViewController.h"
#import "FCConnectStateCell.h"


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
    [self.tableView registerClass:[FCConnectStateCell class] forCellReuseIdentifier:@"StateCell"];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 7;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return 50.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0.01;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FCConnectStateCell *stateCell = [tableView dequeueReusableCellWithIdentifier:@"StateCell" forIndexPath:indexPath];
        stateCell.textLabel.text = @"绑定设备";
        stateCell.detailTextLabel.text = @"未绑定";
        return stateCell;
    }
    
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
