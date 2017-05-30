//
//  FCNewAlarmViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCNewAlarmViewController.h"
#import <FitCloudKit.h>
#import "FCAlarmClockCycleObject+Category.h"
#import "FCEditAlarmCycleViewController.h"
#import "FCAlarmConfigManager.h"
#import <DateTools.h>
#import "NSObject+HUD.h"
#import "FCUIConstants.h"


@interface FCNewAlarmViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) FCAlarmClockCycleObject *cycleObj;
@property (nonatomic, strong) FCAlarmClockObject *alarmObj;
@end

@implementation FCNewAlarmViewController

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮交互

- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickToSave:(id)sender
{
    NSInteger count = [[FCAlarmConfigManager manager]countOfAlarms];
    if (count >= 8) {
        return;
    }
    
    NSDate *date = self.datePicker.date;
    NSDate *currentDate = [NSDate date];
    self.alarmObj.hour = @(date.hour);
    self.alarmObj.minute = @(date.minute);
    self.alarmObj.year = @(currentDate.year-2000);
    self.alarmObj.month = @(currentDate.month);
    self.alarmObj.cycle = self.cycleObj.cycleValue;
    
    NSInteger alarmMinutes = self.alarmObj.hour.integerValue * 60 + self.alarmObj.minute.integerValue;
    NSInteger minutes = currentDate.hour*60 + currentDate.minute;
    if (alarmMinutes <= minutes && self.alarmObj.cycle.integerValue == 0)
    {
        self.alarmObj.day = @(currentDate.day+1);
    }
    else
    {
        self.alarmObj.day = @(currentDate.day);
    }
    
    self.alarmObj.isOn = YES;
    // 同步的时候需要刷新id号
    //    self.alarmModel.idNo = arc4random()/7;
    BOOL isExist = [[FCAlarmConfigManager manager]isExistAlarmClock:self.alarmObj];
    if (isExist) {
        [self showWarningWithMessage:@"闹钟已存在"];
    }
    else
    {
        [[FCAlarmConfigManager manager]addAlarmClock:self.alarmObj];
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_ALARM_REALTIME_SYNC_NOTIFY object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @"闹钟周期";
    cell.detailTextLabel.text = self.cycleObj.cycleDescription;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"闹钟周期" sender:self];
}

#pragma mark -  UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"闹钟周期"]) {
        FCEditAlarmCycleViewController *cycleVC = segue.destinationViewController;
        cycleVC.cycleObj = self.cycleObj;
        __weak __typeof(self) ws = self;
        [cycleVC setDidRefreshWorkModeBlock:^{
            [ws.tableView reloadData];
        }];
    }
}



#pragma mark - Getter

- (FCAlarmClockCycleObject*)cycleObj
{
    if (_cycleObj) {
        return _cycleObj;
    }
    _cycleObj = [[FCAlarmClockCycleObject alloc]init];
    return _cycleObj;
}

- (FCAlarmClockObject*)alarmObj
{
    if (_alarmObj) {
        return _alarmObj;
    }
    _alarmObj = [[FCAlarmClockObject alloc]init];
    return _alarmObj;
}

@end
