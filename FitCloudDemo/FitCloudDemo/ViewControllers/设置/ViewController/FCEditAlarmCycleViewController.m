//
//  FCEditAlarmCycleViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCEditAlarmCycleViewController.h"
#import "FCAlarmCycleCheckCell.h"
#import <FitCloudKit.h>

@interface FCEditAlarmCycleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCEditAlarmCycleViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
    static NSString *identifier = @"Cell";
    FCAlarmCycleCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"周一";
        cell.checked = self.cycleObj.monday;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"周二";
        cell.checked = self.cycleObj.tuesday;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"周三";
        cell.checked = self.cycleObj.wednesday;
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"周四";
        cell.checked = self.cycleObj.thursday;
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"周五";
        cell.checked = self.cycleObj.firday;
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"周六";
        cell.checked = self.cycleObj.saturday;
    }
    else if (indexPath.row == 6)
    {
        cell.textLabel.text = @"周日";
        cell.checked = self.cycleObj.sunday;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.cycleObj.monday = !self.cycleObj.monday;
    }
    else if (indexPath.row == 1)
    {
        self.cycleObj.tuesday = !self.cycleObj.tuesday;
    }
    else if (indexPath.row == 2)
    {
        self.cycleObj.wednesday = !self.cycleObj.wednesday;
    }
    else if (indexPath.row == 3)
    {
        self.cycleObj.thursday = !self.cycleObj.thursday;
    }
    else if (indexPath.row == 4)
    {
        self.cycleObj.firday = !self.cycleObj.firday;
    }
    else if (indexPath.row == 5)
    {
        self.cycleObj.saturday = !self.cycleObj.saturday;
    }
    else if (indexPath.row == 6)
    {
        self.cycleObj.sunday = !self.cycleObj.sunday;
    }
    //    NSLog(@"--cycleObj--%@",self.cycleObj.logAllProperties;
    [self.tableView reloadData];
    if (_didRefreshWorkModeBlock) {
        _didRefreshWorkModeBlock();
    }
}


@end
