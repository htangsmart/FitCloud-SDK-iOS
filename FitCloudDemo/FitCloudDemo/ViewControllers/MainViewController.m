//
//  MainViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "MainViewController.h"
#import "ScanListViewController.h"
#import "Macro.h"
#import "FitCloud+Category.h"
#import "NSObject+HUD.h"
#import <FitCloudKit.h>

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *powerAndChargeState;
@property (nonatomic, strong) NSString *wearingStyle;
@property (nonatomic, assign) BOOL leftHand;
@property (nonatomic, strong) UISwitch *drinkRemindSwitch;
@end

@implementation MainViewController

#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮交互

- (IBAction)clickToUnBondDevice:(id)sender
{
    BOOL ret = [[FitCloud shared]removeBondDevice];
    if (ret)
    {
        CBPeripheral *aPeripheral = [FitCloud shared].servicePeripheral;
        [[FitCloud shared]disconnectPeripheral:aPeripheral];
    }
}

#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotification];
    [self scanAndConnectTheDevice];
    self.powerAndChargeState = @"未获取";
    self.wearingStyle = @"左手佩戴";
    self.leftHand = YES;
}

- (void)scanAndConnectTheDevice
{
    NSString *bondDeviceUUID = [[FitCloud shared]bondDeviceUUID];
    if (!bondDeviceUUID) {
        return;
    }
    [[FitCloud shared]scanningPeripheralWithUUID:bondDeviceUUID retHandler:^(CBPeripheral *aPeripheral) {
        [[FitCloud shared]connectPeripheral:aPeripheral];
    }];
}

#pragma mark - 通知

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(discoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(centralManagerStateChanged:) name:EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disconnectPeripheral:) name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
}

- (void)disconnectPeripheral:(NSNotification*)notification
{
    if (notification && notification.object)
    {
        CBPeripheral *aPeripheral = (CBPeripheral*)(notification.object);
        if (aPeripheral && [aPeripheral.name.uppercaseString containsString:@"H"])
        {
            if (![[FitCloud shared]deviceIsBond])
            {
                NSLog(@"---设备未绑定---");
                return;
            }
            NSLog(@"--重新连接--");
            [[FitCloud shared]connectPeripheral:aPeripheral];
        }
    }
}

- (void)centralManagerStateChanged:(NSNotification*)notification
{
    if (notification && notification.userInfo)
    {
        NSNumber *stateNumber = notification.userInfo[@"state"];
        CBCentralManagerState state = stateNumber.integerValue;
        if (state == CBCentralManagerStatePoweredOn)
        {
            [self scanAndConnectTheDevice];
        }
    }
}

- (void)discoverCharacteristics:(NSNotification*)notification
{
    [self.tableView reloadData];
    if (![[FitCloud shared]deviceIsBond])
    {
        NSLog(@"---设备未绑定---");
        return;
    }
    // 登录设备
    [[FitCloud shared]loginDevice:^(FCAuthDataHandler authDataHandler) {
        if (authDataHandler) {
            authDataHandler(100,0x01,0x02,0x01);
        }
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (syncType == FCSyncTypeLoginToSyncTime) {
            NSLog(@"--同步完成--");
        }
        else
        {
            NSLog(@"--登录失败---");
        }
    }];
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"设备";
        cell.detailTextLabel.text = [[FitCloud shared]deviceNameAndState];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"电量和充电信息";
        cell.detailTextLabel.text = self.powerAndChargeState;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"查找手环";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"手环显示设置";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"翻腕亮屏";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"佩戴方式";
        cell.detailTextLabel.text = self.wearingStyle;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 6)
    {
        cell.textLabel.text = @"通知配置";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 7)
    {
        cell.textLabel.text = @"日常闹钟";
        cell.detailTextLabel.text = @"进入详情获取或新增闹钟";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 8)
    {
        cell.textLabel.text = @"喝水提醒";
        cell.accessoryView = self.drinkRemindSwitch;
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 9)
    {
        cell.textLabel.text = @"久坐提醒设置";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 10)
    {
        cell.textLabel.text = @"健康历史记录设置";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 11)
    {
        cell.textLabel.text = @"默认血压";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 12)
    {
        cell.textLabel.text = @"用户资料";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 13)
    {
        cell.textLabel.text = @"健康实时测试";
        cell.detailTextLabel.text = @"进入详情测试";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 14)
    {
        cell.textLabel.text = @"历史数据同步";
        cell.detailTextLabel.text = @"进入详情获取";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 15)
    {
        cell.textLabel.text = @"固件升级";
        cell.detailTextLabel.text = @"  ";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (![[FitCloud shared]deviceIsBond]) {
            [self performSegueWithIdentifier:@"设备列表" sender:self];
        }
        return;
    }
    if ([FitCloud shared].servicePeripheral.state != CBPeripheralStateConnected)
    {
        [self showWarningWithMessage:@"蓝牙未连接"];
        return;
    }
    if (indexPath.row == 1)
    {
        [self getPowerAndChangeState];
    }
    else if (indexPath.row == 2)
    {
        [self startfindWatch];
    }
    else if (indexPath.row == 3)
    {
        [self setTheScreenDisplayOfTheWatch];
    }
    else if (indexPath.row == 4)
    {
        [self theScreenLightsUpInTurningTheWrist];
    }
    else if (indexPath.row == 5)
    {
        [self updateWearingStyle];
    }
    else if (indexPath.row == 6)
    {
        [self updateNotificationSettings];
    }
    else if (indexPath.row == 7)
    {
        [self performSegueWithIdentifier:@"日常闹钟" sender:self];
    }
    else if (indexPath.row == 9)
    {
        [self updateLongSitSettings];
    }
    else if (indexPath.row == 10)
    {
        [self updateHealthHistoryRecordSettings];
    }
    else if (indexPath.row == 11)
    {
        [self updateDefaultBloodPressure];
    }
    else if (indexPath.row == 12)
    {
        [self updateUserProfile];
    }
    else if (indexPath.row == 13)
    {
        [self performSegueWithIdentifier:@"健康实时测试" sender:self];
    }
    else if (indexPath.row == 14)
    {
        [self performSegueWithIdentifier:@"历史数据同步" sender:self];
    }
}


#pragma mark - 获取电量和充电信息
- (void)getPowerAndChangeState
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在获取电量信息"];
    [[FitCloud shared]fcGetBatteryPowerAndChargingState:^(UInt8 powerValue, UInt8 chargingState) {
        if (chargingState == 1) {
            ws.powerAndChargeState = [NSString stringWithFormat:@"正在充电 剩余电量:%@%%",@(powerValue)];
        }
        else
        {
            ws.powerAndChargeState = [NSString stringWithFormat:@"未充电 剩余电量:%@%%",@(powerValue)];
        }
        [ws.tableView reloadData];
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 查找手环

- (void)startfindWatch
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在查找手表"];
    [[FitCloud shared]fcFindWristband:^(FCSyncType syncType, FCSyncResponseState state) {
        NSLog(@"--state--%@",@(state));
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 手环显示设置

- (void)setTheScreenDisplayOfTheWatch
{
    FCDisplayModel *aModel = [[FCDisplayModel alloc]init];
    aModel.dateTime = YES;
    aModel.stepCount = YES;
    aModel.calorie = YES;
    aModel.sleep = YES;
    aModel.heartRate = YES;
    aModel.distance = YES;
    aModel.bloodOxygen = YES;
    aModel.bloodPressure = YES;
    aModel.findPhone = YES;
    aModel.displayId = YES;
    NSData *displayData = [aModel displayData];
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetDisplayData:displayData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 翻腕亮屏
- (void)theScreenLightsUpInTurningTheWrist
{
    FCFunctionSwitchModel *aModel = [[FCFunctionSwitchModel alloc]init];
    aModel.twLightScreen = YES;
    NSData *functionSwitchData = [aModel functionSwitchData];
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetFunctionSwitchData:functionSwitchData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}
#pragma mark - 穿戴方式
- (void)updateWearingStyle
{
    BOOL wearingStyle = !self.leftHand;
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetLeftHandWearEnable:wearingStyle retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            ws.leftHand = !ws.leftHand;
            ws.wearingStyle = ws.leftHand ? @"左手佩戴" :@"右手佩戴";
            [ws.tableView reloadData];
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 通知设置

- (void)updateNotificationSettings
{
    FCNotificationModel *aModel = [[FCNotificationModel alloc]init];
    aModel.shortMessage = YES;
    aModel.phoneCall = YES;
    aModel.weChat = YES;
    aModel.QQ = YES;
    aModel.facebook = YES;
    aModel.instagram = YES;
    NSData *nfSettingsData = [aModel nfSettingData];
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetNotificationSettingData:nfSettingsData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 喝水提醒

- (void)drinkremindSwitchValueChanged:(UISwitch*)sender
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetDrinkRemindEnable:sender.isOn retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark -久坐提醒设置
- (void)updateLongSitSettings
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    FCLongSitModel *aModel = [[FCLongSitModel alloc]init];
    aModel.isOn = YES;
    aModel.stMinute = 480; // 08:00
    aModel.edMinute = 1200; // 20:00
    if (aModel.isLunchDNDEnable) {
        aModel.isLunchBreakFree = YES;
    }
    NSData *longSitData = [aModel longSitData];
    [[FitCloud shared]fcSetLongSitData:longSitData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 健康历史记录设置
- (void)updateHealthHistoryRecordSettings
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    FCHealthMonitoringModel *aModel = [[FCHealthMonitoringModel alloc]init];
    aModel.isOn = YES;
    aModel.stMinute = 480; // 08:00
    aModel.edMinute = 1200; // 20:00
    NSData *data = [aModel healthMonitoringData];
    [[FitCloud shared]fcSetHealthMonitorData:data retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 喝水提醒

- (void)updateDefaultBloodPressure
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetBloodPressure:100 dbp:85 retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}


#pragma mark - 更新用户资料

- (void)updateUserProfile
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetUserProfile:1 age:29 height:183*2 weight:65*2 retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"设备列表"]) {
        ScanListViewController *scanListVC = segue.destinationViewController;
        WS(ws);
        [scanListVC setDidCompletionBlock:^{
            [ws.tableView reloadData];
        }];
    }
}

#pragma mark - 
- (UISwitch*)drinkRemindSwitch
{
    if (_drinkRemindSwitch) {
        return _drinkRemindSwitch;
    }
    _drinkRemindSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_drinkRemindSwitch addTarget:self action:@selector(drinkremindSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _drinkRemindSwitch;
}

@end
