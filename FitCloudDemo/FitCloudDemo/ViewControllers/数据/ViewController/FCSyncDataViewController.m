//
//  FCSyncDataViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSyncDataViewController.h"
#import "FitCloudManager.h"
#import "FCConfigManager.h"
#import <FitCloudKit.h>
#import "NSObject+FCObject.h"
#import <NSObject+FBKVOController.h>
#import "FCSportsDisplayCell.h"
#import "FCSleepDisplayCell.h"
#import "FCHealthDisplayCell.h"

@interface FCSyncDataViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) FCSensorFlagObject *sensorFlag;
@end

@implementation FCSyncDataViewController


#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView addSubview:self.refreshControl];
    
    // 开始蓝牙服务
    [[FitCloudManager manager]startService];
    
    FCSensorFlagObject *sensorFlag = [[FCConfigManager manager]sensorFlagObject];
    self.sensorFlag = sensorFlag;
    [self.tableView reloadData];
    
    __weak __typeof(self) ws = self;
    [self.KVOController observe:[FCConfigManager manager] keyPath:@"sensorFlagUpdate" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [ws.tableView reloadData];
    }];
}

#pragma mark - 同步最新数据

- (void)syncLatestData
{
    [self.refreshControl endRefreshing];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sensorFlag countOfItems];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.sensorFlag itemNameArray].count)
    {
        NSString *itemName = self.sensorFlag.itemNameArray[indexPath.row];
        if ([itemName isEqualToString:@"运动"])
        {
            return 100.0;
        }
        else if ([itemName isEqualToString:@"心电"])
        {
            return 50.0;
        }
        return 110.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.sensorFlag itemNameArray].count)
    {
        NSString *itemName = self.sensorFlag.itemNameArray[indexPath.row];
        if ([itemName isEqualToString:@"运动"])
        {
            FCSportsDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_runing"];
            return cell;
        }
        else if ([itemName isEqualToString:@"睡眠"])
        {
            FCSleepDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SleepCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_sleep"];
            return cell;
        }
        else if ([itemName isEqualToString:@"紫外线"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_sleep"];
            return cell;
        }
        else if ([itemName isEqualToString:@"心率"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_heart_rate"];
            return cell;
        }
        else if ([itemName isEqualToString:@"血氧"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_blood_oxygen"];
            return cell;
        }
        else if ([itemName isEqualToString:@"血压"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_blood_pressure"];
            return cell;
        }
        else if ([itemName isEqualToString:@"呼吸频率"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_blood_pressure"];
            return cell;
        }
        else if ([itemName isEqualToString:@"心电"])
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_ecg"];
            cell.textLabel.text = @"心电";
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getter

- (UIRefreshControl*)refreshControl
{
    if (_refreshControl) {
        return _refreshControl;
    }
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.tintColor = [UIColor colorWithRed:0.847 green:0.118 blue:0.024 alpha:1.0];
    [_refreshControl addTarget:self action:@selector(syncLatestData) forControlEvents:UIControlEventValueChanged];
    return _refreshControl;
}

@end
