//
//  FCAlarmConfigViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCAlarmConfigViewController.h"
#import <FitCloudKit.h>
#import "FCConfigManager.h"
#import "FitCloud+Category.h"
#import "NSObject+HUD.h"
#import "FCAlarmConfigManager.h"
#import "FCDailyAlarmCell.h"
#import "FCAlarmClockCycleObject+Category.h"
#import "FCUIConstants.h"
#import "FCEditAlarmViewController.h"

@interface FCAlarmConfigViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCAlarmConfigViewController


#pragma mark - dealloc

- (void)dealloc
{
    [[FCAlarmConfigManager manager]clearCache];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_ALARM_REALTIME_SYNC_NOTIFY object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮交互

- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToSave:(id)sender
{
    NSUInteger count = [FCAlarmConfigManager manager].countOfAlarms;
    if (count <= 0) {
        return;
    }
    // 重新排序id号
    [[FCAlarmConfigManager manager]redistributeAlarmID];
    
    
    NSData *alarmConfigData = [FCSysConfigUtils getAlarmClockConfigDataFromArray:[FCAlarmConfigManager manager].listArray];
    if (!alarmConfigData) {
        return;
    }
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetAlarmData:alarmConfigData result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

- (IBAction)clickToAddNewAlarm:(id)sender
{
    [self performSegueWithIdentifier:@"新增闹钟" sender:self];
}


#pragma mark - lifeStyle


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotification];
    
    __weak __typeof(self) ws = self;
    [[FCAlarmConfigManager manager]setDidUpdateAlarmClockListBlock:^{
        [ws.tableView reloadData];
    }];
    
    [self syncAlarmListFromWatch];
}


- (void)registerNotification
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedAlarmUpdate) name:EVENT_ALARM_REALTIME_SYNC_NOTIFY object:nil];
}

- (void)onReceivedAlarmUpdate
{
    [self clickToSave:nil];
}

#pragma mark - 同步闹钟

- (void)syncAlarmListFromWatch
{
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcGetAlarmList:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            NSArray *alarmListArray = [FCSysConfigUtils getAlarmClockListFromData:data];
            NSLog(@"--闹钟列表--%@",alarmListArray);
            [[FCAlarmConfigManager manager]addAlarmClockFromArray:alarmListArray];
            
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}




#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FCAlarmConfigManager manager].listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCDailyAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    __weak __typeof(self) ws = self;
    [cell setDidChangedSwicthValueBlock:^(FCDailyAlarmCell *aCell) {
        [ws openOrCloseAlarmWithCell:aCell];
    }];
    if (indexPath.row < [FCAlarmConfigManager manager].listArray.count) {
        FCAlarmClockObject *aModel = [FCAlarmConfigManager manager].listArray[indexPath.row];
        cell.timeLabel.text = aModel.ringTime;
        cell.weekLabel.text = aModel.cycleObject.cycleDescription;
        cell.stSwitch.on = aModel.isOn;
    }

    return cell;
}

- (void)openOrCloseAlarmWithCell:(FCDailyAlarmCell*)aCell
{
    if (!aCell) {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:aCell];
    if (indexPath.row < [FCAlarmConfigManager manager].listArray.count) {
        FCAlarmClockObject *aModel = [FCAlarmConfigManager manager].listArray[indexPath.row];
        aModel.isOn = aCell.stSwitch.isOn;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [FCAlarmConfigManager manager].listArray.count) {
        FCAlarmClockObject *aModel = [FCAlarmConfigManager manager].listArray[indexPath.row];
        [self performSegueWithIdentifier:@"编辑闹钟" sender:aModel];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"编辑闹钟"]) {
        FCEditAlarmViewController *editAlarm = segue.destinationViewController;
        editAlarm.alarmObj = sender;
    }
}

@end
