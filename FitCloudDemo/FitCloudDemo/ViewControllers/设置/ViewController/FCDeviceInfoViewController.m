//
//  FCDeviceInfoViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCDeviceInfoViewController.h"
#import "FCSwitch.h"
#import "FCUserConfig.h"
#import "FCUserConfigDB.h"
#import "FCWatchConfigDB.h"
#import "FCConfigManager.h"
#import "FitCloud+Category.h"
#import "HFDatePickerView.h"
#import "NSObject+FCObject.h"
#import "FCWatchSettingsObject+Category.h"
#import <FitCloudKit.h>
#import "NSObject+HUD.h"
#import "HFRadioAlertView.h"


@interface FCDeviceInfoViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *batteryLevel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCSwitch *hmSwitch;
@property (nonatomic, strong) FCSwitch *fwSwitch;
@property (nonatomic, strong) FCHealthMonitoringObject *hmObj;
@property (nonatomic, strong) FCUserConfig *userConfig;
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
    
    FCHealthMonitoringObject *hmObject = [[FCConfigManager manager]healthMonitoringObject];
    self.hmObj = hmObject;
    self.hmSwitch.on = hmObject.isOn;
    
    FCFeaturesObject *features = [[FCConfigManager manager]featuresObject];
    self.fwSwitch.on = features.flipWristToLightScreen;
    
    self.userConfig = [FCUserConfigDB getUserFromDB];
    [self.tableView reloadData];

    
    self.batteryLevel.text = @(0).stringValue;
    self.statusLabel.text = @"剩余电量";
    [self getBatteryLevelAndChargingState];
}

#pragma mark - 获取电磁电量

- (void)getBatteryLevelAndChargingState
{
    __weak __typeof(self) ws = self;
    [[FitCloud shared]fcGetBatteryLevelAndState:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            NSDictionary *params = [FitCloudUtils getBatteryLevelAndChargingState:data];
            if (params) {
                int chargingState = [params[@"state"]intValue];
                int batteryLevel = [params[@"batteryLevel"]intValue];
                ws.batteryLevel.text = @(batteryLevel).stringValue;
                if (chargingState == 0x00)
                {
                    ws.statusLabel.text = @"剩余电量";
                }
                else
                {
                    ws.statusLabel.text = @"正在充电";
                }
            }
        }
        else
        {
            ws.batteryLevel.text = @(0).stringValue;
            ws.statusLabel.text = @"剩余电量";
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
    return 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell" forIndexPath:indexPath];
        cell.textLabel.text = @"设备名称";
        cell.detailTextLabel.text = [[FitCloud shared]bondDeviceName];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindWatchCell" forIndexPath:indexPath];
        cell.textLabel.text = @"查找手环";
        return cell;
    }
    else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DisplayCell" forIndexPath:indexPath];
        cell.textLabel.text = @"手环显示设置";
        cell.detailTextLabel.text = @"设置是否在手环上显示";
        return cell;
    }
    else if (indexPath.row == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WearStyleCell" forIndexPath:indexPath];
        cell.textLabel.text = @"佩戴方式";
        cell.detailTextLabel.text = self.userConfig.isLeftHandWearEnabled ? @"左手":@"右手";
        return cell;
    }
    else if (indexPath.row == 4 || indexPath.row == 5)
    {
        if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"翻腕亮屏";
            cell.detailTextLabel.text = @"翻手腕查看手环信息";
            cell.accessoryView = self.fwSwitch;
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"健康定时监测";
            cell.detailTextLabel.text = @"开启时定时自动检测，生成历史记录";
            cell.accessoryView = self.hmSwitch;
            return cell;
        }
    }
    else
    {
         if (indexPath.row == 6)
         {
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
             cell.textLabel.text = @"    开始时间";
             cell.detailTextLabel.text = self.hmObj.stMinuteString;
             return cell;
         }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"    结束时间";
            cell.detailTextLabel.text = self.hmObj.edMinuteString;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        // 查找手环
        [self findTheWatch];
    }
    else if (indexPath.row == 2)
    {
        // 手环显示设置
        [self updateDisplaySetting];
    }
    else if (indexPath.row == 3)
    {
        // 佩戴方式
        [self updateWearSttyle];
    }
    else if (indexPath.row == 6)
    {
        [self changeHealthMonitorSTMinute];
    }
    else if (indexPath.row == 7)
    {
        [self changeHealthMonitorEDMinute];
    }
}

#pragma mark - 查找手表

- (void)findTheWatch
{
    __weak __typeof(self)ws = self;
    [self showLoadingHUDWithMessage:@"正在发送查找指令"];
    [[FitCloud shared]fcFindTheWatch:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"已发送查找指令"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"发送指令失败"];
        }
    }];
}

#pragma mark - 修改手表佩戴方式

- (void)updateWearSttyle
{
    __weak __typeof(self)ws = self;
    HFRadioAlertView *wearingStylesView = [HFRadioAlertView alertViewWithTitle:@"佩戴方式" andItems:@[@"左手",@"右手"]];
    wearingStylesView.checkItem = (ws.userConfig.isLeftHandWearEnabled ? @"左手":@"右手");
    [wearingStylesView setDidTouchBlock:^(NSString *item) {
        BOOL lefthand = [item isEqualToString:@"左手"];
        
        [ws showLoadingHUDWithMessage:@"正在同步"];
        
        [[FitCloud shared]fcSetLeftHandWearEnable:lefthand result:^(FCSyncType syncType, FCSyncResponseState state) {
            if ( state == FCSyncResponseStateSuccess) {
                [ws hideLoadingHUDWithSuccess:@"同步完成"];
                
                ws.userConfig.isLeftHandWearEnabled = lefthand;
                [ws.tableView reloadData];
                
                BOOL ret = [FCUserConfigDB storeUser:ws.userConfig];
                if (ret) {
                    NSLog(@"--更新佩戴方式--");
                }
                
            }
            else
            {
                [ws hideLoadingHUDWithFailure:@"同步失败"];
            }
        }];
    }];
    [wearingStylesView show];
}

#pragma mark - 更新屏幕显示设置

- (void)updateDisplaySetting
{
    __weak __typeof(self)ws = self;
    HFRadioAlertView *displayView = [HFRadioAlertView wristbandDisplayWithData:nil];
    [displayView setDidUpdateDisplayBlock:^(NSData *data) {
        [ws showLoadingHUDWithMessage:@"正在同步"];
        [[FitCloud shared]fcSetWatchScreenDisplayData:data result:^(FCSyncType syncType, FCSyncResponseState state) {
            if (state == FCSyncResponseStateSuccess)
            {
                [ws hideLoadingHUDWithSuccess:@"同步完成"];
                
                FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
                watchSettingObj.wsdisplayData = data;
                
                NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
                BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
                if (ret) {
                    NSLog(@"--更新久坐提醒--");
                }
            }
            else
            {
                [ws hideLoadingHUDWithFailure:@"同步失败"];
            }
        }];
    }];
    [displayView show];
}

#pragma mark - 修改健康定时监测时间

- (void)changeHealthMonitorSTMinute
{
    if (!self.hmSwitch.isOn) {
        [self showWarningWithMessage:@"健康定时监测开关未打开"];
        return;
    }
    __weak __typeof(self)ws = self;
    HFDatePickerView *pickerView = [HFDatePickerView pickerView];
    pickerView.title = @"开始时间";
    [pickerView setDidCompletePickBlock:^(NSInteger minutes) {
        ws.hmObj.stMinute = minutes;
        [ws.tableView reloadData];
        
        if (ws.hmObj.stMinute < ws.hmObj.edMinute)
        {
            [ws showLoadingHUDWithMessage:@"正在同步"];
            NSData *writeData = [self.hmObj writeData];
            [[FitCloud shared]fcSetHealthMonitoringData:writeData result:^(FCSyncType syncType, FCSyncResponseState state) {
                if (state == FCSyncResponseStateSuccess)
                {
                    [ws hideLoadingHUDWithSuccess:@"同步完成"];
                    
                    FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
                    watchSettingObj.healthMonitoringData = writeData;
                    
                    NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
                    BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
                    if (ret) {
                        NSLog(@"--更新久坐提醒--");
                    }
                }
                else
                {
                    [ws hideLoadingHUDWithFailure:@"同步失败"];
                }
            }];
        }
        else
        {
            [ws showErrorWithMessage:@"开始时间必须小于结束时间"];
        }
    }];
    [pickerView show];
}


- (void)changeHealthMonitorEDMinute
{
    if (!self.hmSwitch.isOn) {
        [self showWarningWithMessage:@"健康定时监测开关未打开"];
        return;
    }
    __weak __typeof(self)ws = self;
    // 设置结束时间
    HFDatePickerView *pickerView = [HFDatePickerView pickerView];
    pickerView.title = @"结束时间";
    [pickerView setDidCompletePickBlock:^(NSInteger minutes) {
        if (minutes > ws.hmObj.stMinute)
        {
            ws.hmObj.edMinute = minutes;
            [ws.tableView reloadData];
            
            [ws showLoadingHUDWithMessage:@"正在同步"];
            NSData *writeData = [self.hmObj writeData];
            
            [[FitCloud shared]fcSetHealthMonitoringData:writeData result:^(FCSyncType syncType, FCSyncResponseState state) {
                if (state == FCSyncResponseStateSuccess)
                {
                    [ws hideLoadingHUDWithSuccess:@"同步完成"];
                    FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
                    watchSettingObj.healthMonitoringData = writeData;
                    
                    NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
                    BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
                    if (ret) {
                        NSLog(@"--更新健康定时监测--");
                    }
                }
                else
                {
                    [ws hideLoadingHUDWithFailure:@"同步失败"];
                }
            }];
        }
        else
        {
            [ws showErrorWithMessage:@"结束时间必须大于开始时间"];
        }
    }];
    [pickerView show];
}

#pragma mark - UISwitch Value Changed

- (void)flipWristSwitchValueChanged:(UISwitch*)sender
{
    FCUserConfig *userConfig = [FCUserConfigDB getUserFromDB];
    FCFeaturesObject *features = [[FCConfigManager manager]featuresObject];
    features.flipWristToLightScreen = sender.isOn;
    features.isImperialUnits = userConfig.isImperialUnits;
    features.twelveHoursSystem = [FitCloudUtils is12HourSystem];
    
    __weak __typeof(self) ws = self;
    NSData *data = [features writeData];
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetFeaturesData:data result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
            FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
            watchSettingObj.featuresData = data;
            
            NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
            BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
            if (ret) {
                NSLog(@"--更新健康定时监测--");
            }

        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
            sender.on = !sender.isOn;
        }
    }];
}

- (void)healthMonitorSwitchValueChanged:(UISwitch*)sender
{
    __weak __typeof(self) ws = self;
    self.hmObj.isOn = sender.isOn;
    NSData *writeData = [self.hmObj writeData];
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetHealthMonitoringData:writeData result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];

            FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
            watchSettingObj.healthMonitoringData = writeData;
            
            NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
            BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
            if (ret) {
                NSLog(@"--更新健康定时监测--");
            }
        }
        else
        {
            sender.on = !sender.isOn;
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }

    }];
}

#pragma mark - Getter

- (FCSwitch*)fwSwitch
{
    if (_fwSwitch) {
        return _fwSwitch;
    }
    _fwSwitch = [[FCSwitch alloc]initWithFrame:CGRectZero];
    [_fwSwitch addTarget:self action:@selector(flipWristSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _fwSwitch;
}

- (FCSwitch*)hmSwitch
{
    if (_hmSwitch) {
        return _hmSwitch;
    }
    _hmSwitch = [[FCSwitch alloc]initWithFrame:CGRectZero];
    [_hmSwitch addTarget:self action:@selector(healthMonitorSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _hmSwitch;
}
@end
