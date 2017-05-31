//
//  FCOtherViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCOtherViewController.h"
#import "NSObject+HUD.h"
#import <FitCloudKit.h>
#import "FCUserConfig.h"
#import "FCUserConfigDB.h"
#import "FCWatchConfigDB.h"
#import "FCConfigManager.h"
#import "FCWatchConfigDB.h"
#import "FCWatchSettingsObject+Category.h"
#import "FitCloud+Category.h"
#import "NSObject+FCObject.h"

@interface FCOtherViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISwitch *drinkRemindSwitch;
@property (nonatomic, strong) UISwitch *sedentaryReminderSwitch;
@property (nonatomic, strong) UISwitch *restTimeNotDisturbSwitch;
@property (nonatomic, strong) FCSedentaryReminderObject *srObj;
@end

@implementation FCOtherViewController

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
    
    FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
    self.drinkRemindSwitch.on = watchSettingObj.drinkRemindEnabled;
    self.srObj = [[FCConfigManager manager]sedentaryReminderObject];
    self.sedentaryReminderSwitch.on = self.srObj.isOn;
    self.restTimeNotDisturbSwitch.on = self.srObj.restTimeNotDisturbEnabled;
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrinkRemind" forIndexPath:indexPath];
        cell.textLabel.text = @"喝水提醒";
        cell.accessoryView = self.drinkRemindSwitch;
        return cell;
    }
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"久坐提醒";
        cell.detailTextLabel.text = @"持续1小时未活动，手表将振动提醒";
        cell.accessoryView = self.sedentaryReminderSwitch;
        return cell;
    }
    else if (indexPath.row == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"   午休免打扰";
        cell.detailTextLabel.text = @"    午休12:00-14:00不提醒";
        cell.accessoryView = self.restTimeNotDisturbSwitch;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
        if (indexPath.row == 1)
        {
            cell.textLabel.text = @"   开始时间";
            cell.detailTextLabel.text = self.srObj.stMinuteString;
        }
        else
        {
            cell.textLabel.text = @"   结束时间";
            cell.detailTextLabel.text = self.srObj.edMinuteString;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - valueChanged

- (void)drinkRemindSwitchValueChanged:(UISwitch*)aSwitch
{
    __weak __typeof(self)ws = self;
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetDrinkRemindEnable:aSwitch.isOn result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
            
            
            FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
            Byte byte[1] = {0}; byte[0] = aSwitch.isOn;
            watchSettingObj.drinkReminderData = [NSData dataWithBytes:byte length:1];
            
            NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
            BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
            if (ret) {
                NSLog(@"--更新喝水提醒--");
            }
        }
        else
        {
            [aSwitch setOn:!aSwitch.isOn animated:YES];
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];

}

- (void)sedentaryReminderSwitchValueChanged:(UISwitch*)aSwitch
{
    
}

- (void)restTimeNotDisturbSwitchValueChanged:(UISwitch*)aSwitch
{
    // 久坐提醒未打开或者不包括午休时间，则不允许修改
    if (!self.sedentaryReminderSwitch.isOn || !self.srObj.isAtRestTime)
    {
        [aSwitch setOn:!aSwitch.isOn animated:YES];
         NSLog(@"---不能设置午休免打扰---");
        return;
    }
    
   
    
    __weak __typeof(self)ws = self;
    [self showLoadingHUDWithMessage:@"正在同步"];
    self.srObj.restTimeNotDisturbEnabled = aSwitch.isOn;
    NSData *data = self.srObj.writeData;
    [[FitCloud shared]fcSetSedentaryRemindersData:data result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
            
            FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
            watchSettingObj.sedentaryReminderData = data;
            
            NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
            BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
            if (ret) {
                NSLog(@"--更新久坐提醒--");
            }
        }
        else
        {
            [aSwitch setOn:!aSwitch.isOn animated:YES];
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - Getter

- (UISwitch*)drinkRemindSwitch
{
    if (_drinkRemindSwitch) {
        return _drinkRemindSwitch;
    }
    _drinkRemindSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_drinkRemindSwitch addTarget:self action:@selector(drinkRemindSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _drinkRemindSwitch;
}

- (UISwitch*)sedentaryReminderSwitch
{
    if (_sedentaryReminderSwitch) {
        return _sedentaryReminderSwitch;
    }
    _sedentaryReminderSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_sedentaryReminderSwitch addTarget:self action:@selector(sedentaryReminderSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _sedentaryReminderSwitch;
}

- (UISwitch*)restTimeNotDisturbSwitch
{
    if (_restTimeNotDisturbSwitch) {
        return _restTimeNotDisturbSwitch;
    }
    _restTimeNotDisturbSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_restTimeNotDisturbSwitch addTarget:self action:@selector(restTimeNotDisturbSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _restTimeNotDisturbSwitch;
}
@end
