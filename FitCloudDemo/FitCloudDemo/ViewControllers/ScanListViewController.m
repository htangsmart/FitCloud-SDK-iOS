//
//  ScanListViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "ScanListViewController.h"
#import "Macro.h"
#import "NSObject+HUD.h"
#import <FitCloudKit.h>
#import "FitCloud+Category.h"


@interface ScanListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation ScanListViewController

#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮交互

- (IBAction)clickToBack:(id)sender
{
    [[FitCloud shared]stopScanning];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotification];
    [self scanningDevice];
}

#pragma mark - 注册通知

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(centralManagerStateChanged:) name:EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didConnectPeripherals:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(discoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
}

- (void)discoverCharacteristics:(NSNotification*)notification
{
    WS(ws);
    [self changeLoadingWithMessage:@"正在绑定设备"];
    [[FitCloud shared]bondDevice:^(FCAuthDataHandler authDataHandler, FCUserDataHandler userDataHandler, FCWearStyleHandler wearStyleHandler) {
        if (authDataHandler) {
            authDataHandler(100,0x01,0x02,0x01);
        }
        if (userDataHandler) {
            userDataHandler(1,29,63*2,183*2);
        }
        if (wearStyleHandler) {
            wearStyleHandler(1);
        }
    } dataHandler:^(FCSyncType syncType, NSData *data) {
        NSLog(@"--data---%@",data);
        if (data)
        {
            //
            [FitCloudUtils resolveSystemSettingsData:data withCallbackBlock:^(NSData *notificationData, NSData *screenDisplayData, NSData *functionalSwitchData, NSData *hsVersionData, NSData *healthHistorymonitorData, NSData *longSitData, NSData *bloodPressureData, NSData *drinkWaterReminderData) {
                
                
                [FitCloudUtils resolveHardwareAndSoftwareVersionData:hsVersionData withCallbackBlock:^(NSData *projData, NSData *hardwareData, NSData *sdkData, NSData *patchData, NSData *flashData, NSData *fwAppData, NSData *seqData) {
                    
                }];
                
                [FitCloudUtils resolveHardwareAndSoftwareVersionDataToString:hsVersionData withCallbackBlock:^(NSString *projNum, NSString *hardware, NSString *sdkVersion, NSString *patchVerson, NSString *falshVersion, NSString *appVersion, NSString *serialNum) {
                    
                }];
            }];
        }
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state)
    {
        if (state == FCSyncResponseStateSuccess)
        {
            NSLog(@"--绑定成功--");
            [ws hideLoadingHUDWithSuccess:@"绑定成功"];
            BOOL ret = [[FitCloud shared]storeBondDevice];
            if (ret) {
                if (_didCompletionBlock) {
                    _didCompletionBlock();
                }
                [ws.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
            }
        }
        else
        {
            [ws hideLoadingHUDWithSuccess:@"绑定失败"];
        }
    }];
}

- (void)centralManagerStateChanged:(NSNotification*)notification
{
    if (notification && notification.userInfo)
    {
        NSNumber *stateNumber = notification.userInfo[@"state"];
        CBCentralManagerState state = stateNumber.integerValue;
        if (state == CBCentralManagerStatePoweredOn)
        {
            NSLog(@"--扫描设备--");
            [self scanningDevice];
        }
    }
}


- (void)didConnectPeripherals:(NSNotification*)notification
{
    [self.tableView reloadData];
}

#pragma mark - 扫描设备

- (void)scanningDevice
{
    WS(ws);
    [[FitCloud shared]scanningPeripherals:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) {
        NSLog(@"--扫描外设--%@",aPeripheral);
        [ws.listArray removeAllObjects];
        [ws.listArray addObjectsFromArray:retArray];
        [ws.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row < self.listArray.count) {
        CBPeripheral *aPeripheral = self.listArray[indexPath.row];
        cell.textLabel.text = aPeripheral.name;
        if (aPeripheral.state == CBPeripheralStateConnected) {
            cell.detailTextLabel.text = @"已连接";
        }
        else if (aPeripheral.state == CBPeripheralStateConnecting)
        {
            cell.detailTextLabel.text = @"正在连接";
        }
        else
        {
            cell.detailTextLabel.text = @"未连接";
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.listArray.count)
    {
        CBPeripheral *aPeripheral = self.listArray[indexPath.row];
        [self showLoadingHUDWithMessage:@"正在连接设备"];
        [[FitCloud shared]connectPeripheral:aPeripheral];
    }
}

#pragma mark -
- (NSMutableArray*)listArray
{
    if (_listArray) {
        return _listArray;
    }
    _listArray = [[NSMutableArray alloc]init];
    return _listArray;
}
@end
