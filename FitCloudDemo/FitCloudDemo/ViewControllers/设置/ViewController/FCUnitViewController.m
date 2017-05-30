//
//  FCUnitViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCUnitViewController.h"
#import "FCCustomaryUnitsHeaderView.h"
#import "FCCustomaryUnitsCell.h"
#import "FCUserConfig.h"
#import "FCUserConfigDB.h"
#import "FCWatchConfigDB.h"
#import <FitCloudKit.h>
#import "NSObject+HUD.h"
#import "FCConfigManager.h"
#import "FitCloud+Category.h"


@interface FCUnitViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCUserConfig *userConfig;
@end

@implementation FCUnitViewController

#pragma mark - dealloc

- (void)dealloc
{
    
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


#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[FCCustomaryUnitsHeaderView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    
    FCUserConfig *aUserConfig = [FCUserConfigDB getUserFromDB];
    self.userConfig = aUserConfig;
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerIdentifier = @"HeaderView";
    FCCustomaryUnitsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    headerView.textLabel.text = (section == 0 ? @"设置长度单位" : @"设置重量单位");
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    FCCustomaryUnitsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"公制 (米、公里)";
            cell.checked = !self.userConfig.isImperialUnits;
        }
        else
        {
            cell.textLabel.text = @"英制 (英尺、英里)";
            cell.checked = self.userConfig.isImperialUnits;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"公制 (公斤、千克)";
            cell.checked = !self.userConfig.isImperialUnits;;
        }
        else
        {
            cell.textLabel.text = @"英制 (磅)";
            cell.checked = self.userConfig.isImperialUnits;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL ret = [[FitCloud shared]isConnected];
    if (!ret) {
        [self showWarningWithMessage:@"蓝牙未连接"];
        return;
    }
    
    FCFeaturesObject *featureObj = [[FCConfigManager manager]featuresObject];
    featureObj.twelveHoursSystem = [FitCloudUtils is12HourSystem];
    featureObj.isImperialUnits = (indexPath.row == 1);
    
    NSData *data = [featureObj writeData];
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在同步单位"];
    [[FitCloud shared]fcSetFeaturesData:data result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
            
            BOOL ret = [FCUserConfigDB storeUser:ws.userConfig];
            if (ret) {
                NSLog(@"---更新User--");
                ws.userConfig.isImperialUnits = (indexPath.row == 1);
                [ws.tableView reloadData];
            }
            
            FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
            watchSettingObj.featuresData = data;
            NSString *uuidString = [[FitCloud shared]bondDeviceUUID];
            ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuidString];
            if (ret) {
                NSLog(@"--更新手表配置--");
            }
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

@end
