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
#import "FCDayDetailsObject.h"
#import "FCDayDetailsDB.h"

@interface FCSyncDataViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) FCSensorFlagObject *sensorFlag;
@property (nonatomic, strong) FCDayDetailsObject *dayDetailsObj;
@end

@implementation FCSyncDataViewController


#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"EVENT_DAY_DETAILS_UPDATE_NOTIFY" object:nil];
}

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
    
    [FCDayDetailsDB fetchDayDetails:[NSDate date] result:^(id dayDetails) {
        if (dayDetails && [dayDetails isKindOfClass:[FCDayDetailsObject class]]) {
            ws.dayDetailsObj = dayDetails;
            [ws.tableView reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedDayDetailsUpdate:) name:@"EVENT_DAY_DETAILS_UPDATE_NOTIFY" object:nil];
}

- (void)onReceivedDayDetailsUpdate:(NSNotification*)note
{
    if (note && note.object) {
        FCDayDetailsObject *dayDetails = (FCDayDetailsObject*)note.object;
        self.dayDetailsObj = dayDetails;
        [self.tableView reloadData];
    }
}

#pragma mark - 同步最新数据

- (void)syncLatestData
{
    [[FitCloudManager manager]pullDownToSyncHistoryData];
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
        else if ([itemName isEqualToString:@"紫外线"])
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
            cell.stepLabel.text = self.dayDetailsObj.stepCount.stringValue;
            cell.calorieLabel.text = @(self.dayDetailsObj.calorie.floatValue/1000).stringValue;
            cell.distanceLabel.text = @(self.dayDetailsObj.distance.floatValue/1000).stringValue;
            return cell;
        }
        else if ([itemName isEqualToString:@"睡眠"])
        {
            FCSleepDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SleepCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_sleep"];
            NSInteger totalTime = self.dayDetailsObj.deepSleep.doubleValue + self.dayDetailsObj.lightSleep.doubleValue;
            cell.totalSleepTimeLabel.text = [NSString stringWithFormat:@"%@时%@分",@((int)(floorf(totalTime/60))),@((int)(ceilf(totalTime%60)))];
            NSInteger deepSleepTime = self.dayDetailsObj.deepSleep.doubleValue;
            cell.deepSleepLabel.text = [NSString stringWithFormat:@"%@时%@分",@((int)(floorf(deepSleepTime/60))),@((int)(ceilf(deepSleepTime%60)))];
            NSInteger lightSleepTime = self.dayDetailsObj.lightSleep.doubleValue;
            cell.lightSleepLabel.text = [NSString stringWithFormat:@"%@时%@分",@((int)(floorf(lightSleepTime/60))),@((int)(ceilf(lightSleepTime%60)))];
            return cell;
        }
        else if ([itemName isEqualToString:@"紫外线"])
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_uv"];
            return cell;
        }
        else if ([itemName isEqualToString:@"心率"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_heart_rate"];
            cell.titleLabel.text = @"实时测量心率";
            cell.valueLabel.text = @"0";
            cell.maxValueLabel.text = @"0";
            cell.minValueLabel.text = @"0";
            return cell;
        }
        else if ([itemName isEqualToString:@"血氧"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_blood_oxygen"];
            cell.titleLabel.text = @"实时测量血氧";
            cell.valueLabel.text = @"0 SpO2";
            cell.maxValueLabel.text = @"0 SpO2";
            cell.minValueLabel.text = @"0 SpO2";
            return cell;
        }
        else if ([itemName isEqualToString:@"血压"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_blood_pressure"];
            cell.titleLabel.text = @"实时测量血压";
            cell.valueLabel.text = @"0/0 mmHg";
            cell.maxValueLabel.text = @"0/0 mmHg";
            cell.minValueLabel.text = @"0/0 mmHg";
            return cell;
        }
        else if ([itemName isEqualToString:@"呼吸频率"])
        {
            FCHealthDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"ico_respiratory _rate"];
            cell.titleLabel.text = @"实时测量呼吸频率";
            cell.valueLabel.text = @"0 次/分";
            cell.maxValueLabel.text = @"0 次/分";
            cell.minValueLabel.text = @"0 次/分";
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
    [self startMeasuringHeartRate];
    
    if (indexPath.row < [self.sensorFlag itemNameArray].count)
    {
        NSString *itemName = self.sensorFlag.itemNameArray[indexPath.row];
        if ([itemName isEqualToString:@"运动"])
        {

        }
        else if ([itemName isEqualToString:@"睡眠"])
        {

        }
        else if ([itemName isEqualToString:@"紫外线"])
        {

        }
        else if ([itemName isEqualToString:@"心率"])
        {
            [self startMeasuringHeartRate];
        }
        else if ([itemName isEqualToString:@"血氧"])
        {

        }
        else if ([itemName isEqualToString:@"血压"])
        {

        }
        else if ([itemName isEqualToString:@"呼吸频率"])
        {

        }
        else if ([itemName isEqualToString:@"心电"])
        {

        }
    }

}


- (void)startMeasuringHeartRate
{
    // 蓝牙连接操作自动处理，确保发送指令前蓝牙处于连接状态
    [[FitCloud shared]fcOpenRealTimeSync:FCRTSyncTypeBloodOxygen dataCallback:^(FCSyncType syncType, NSData *data) {
        NSLog(@"--data--%@",data);
        
        NSNumber *realTimeValue = [FCRTSyncUtils getRTBloodOxygenValue:data];
        NSLog(@"---value--%@",realTimeValue);
        
    } result:^(FCSyncType syncType, FCSyncResponseState state) {
        NSLog(@"--state--%@",@(state));
        if (state == FCSyncResponseStateSuccess)
        {
            NSLog(@"--响应成功--");
        }
        else if (state == FCSyncResponseStateError)
        {
            NSLog(@"--打开实时同步错误--");
        }
        else if (state == FCSyncResponseStateNotConnected)
        {
            NSLog(@"--蓝牙未连接--");
        }
        else if (state == FCSyncResponseStateSynchronizing)
        {
            NSLog(@"---蓝牙正在同步--");
        }
        else if (state == FCSyncResponseStateDisconnect)
        {
            NSLog(@"---蓝牙中途断开连接--");
        }
        else if (state == FCSyncResponseStateRTTimeOut)
        {
            NSLog(@"--响应超时--");
        }
    }];
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
