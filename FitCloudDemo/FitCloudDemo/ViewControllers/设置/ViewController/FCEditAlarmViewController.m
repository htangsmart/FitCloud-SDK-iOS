//
//  FCEditAlarmViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCEditAlarmViewController.h"
#import <FitCloudKit.h>
#import "FCAlarmConfigManager.h"
#import <DateTools.h>
#import "FCUIConstants.h"
#import "FCEditAlarmCycleViewController.h"
#import "FCAlarmClockCycleObject+Category.h"


@interface FCEditAlarmViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation FCEditAlarmViewController

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
    NSDate *date = self.datePicker.date;
    NSDate *currentDate = [NSDate date];
    self.alarmObj.hour = @(date.hour);
    self.alarmObj.minute = @(date.minute);
    self.alarmObj.year = @(currentDate.year-2000);
    self.alarmObj.month = @(currentDate.month);
    self.alarmObj.day = @(currentDate.day);
    self.alarmObj.cycle = self.alarmObj.cycleObject.cycleValue;
    self.alarmObj.isOn = YES;
    [[FCAlarmConfigManager manager]refreshModel:self.alarmObj];
    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_ALARM_REALTIME_SYNC_NOTIFY object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.alarmObj) {
        NSDate *date = [NSDate dateWithYear:self.alarmObj.year.intValue
                                      month:self.alarmObj.month.intValue
                                        day:self.alarmObj.day.intValue
                                       hour:self.alarmObj.hour.intValue
                                     minute:self.alarmObj.minute.intValue
                                     second:0];
        [self.datePicker setDate:date animated:YES];
        [self.tableView reloadData];
    }

}


#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.textLabel.text = @"闹钟周期";
        cell.detailTextLabel.text = self.alarmObj.cycleObject.cycleDescription;
        return cell;
    }
    else
    {
        static NSString *deleteIdentifier = @"DeleteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deleteIdentifier];
        cell.textLabel.text = @"删除闹钟";
        cell.textLabel.textColor = [UIColor colorWithRed:0.925 green:0.259 blue:0.286 alpha:1.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"闹钟周期" sender:self];
    }
    else
    {
        [[FCAlarmConfigManager manager]removeAlarmClock:self.alarmObj];
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_ALARM_REALTIME_SYNC_NOTIFY object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -  UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"闹钟周期"])
    {
        FCEditAlarmCycleViewController *cycleVC = segue.destinationViewController;
        cycleVC.cycleObj = self.alarmObj.cycleObject;
        __weak __typeof(self) ws = self;
        [cycleVC setDidRefreshWorkModeBlock:^{
            [ws.tableView reloadData];
        }];
    }
}



@end
