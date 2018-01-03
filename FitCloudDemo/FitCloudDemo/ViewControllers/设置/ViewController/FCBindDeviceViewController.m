//
//  FCBindDeviceViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCBindDeviceViewController.h"
#import <NSObject+FBKVOController.h>
#import <FitCloudKit.h>
#import "NSObject+HUD.h"
#import "FitCloud+Category.h"
#import "FCUIConstants.h"
#import "FCConfigManager.h"
#import "FCUserConfigDB.h"
#import "FCUserConfig.h"


@interface FCBindDeviceViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *peripehralsArray;
@end

@implementation FCBindDeviceViewController

#pragma mark - dealloc

- (void)dealloc
{
    [self.KVOController unobserve:[FitCloud shared]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
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
    [self registerNotfication];
    [self scanForPeripherals];
    
    __weak __typeof(self) ws = self;
    [self.KVOController observe:[FitCloud shared] keyPath:@"managerState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        FCManagerState state = (FCManagerState)[change[NSKeyValueChangeNewKey]integerValue];
        NSLog(@"--state--[%@]:%@",@([NSThread isMainThread]),@(state));
        st_dispatch_async_main(^{
            if (state == FCManagerStatePoweredOn)
            {
                [ws scanForPeripherals];
            }
            else if (state == FCManagerStatePoweredOff)
            {
                [[FitCloud shared]stopScanning];
            }
        });
    }];
}

#pragma mark - notification

- (void)registerNotfication
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralConnected:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralFailConnect:) name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralDisConnect:) name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralDiscoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
}


- (void)onReceivedPeripheralConnected:(NSNotification*)note
{
    NSLog(@"--外设连接成功--");
    [self.tableView reloadData];
}

- (void)onReceivedPeripheralFailConnect:(NSNotification*)note
{
 
    NSLog(@"--外设连接失败--");
    [self.tableView reloadData];
}

- (void)onReceivedPeripheralDisConnect:(NSNotification*)note
{
    NSLog(@"--外设断开连接--");
    [self.tableView reloadData]; 
}


- (void)onReceivedPeripheralDiscoverCharacteristics:(NSNotification*)note
{
    NSLog(@"--外设发现服务特征值--");
    // 部分数据配置需要从本地读取
    __weak __typeof(self) ws = self;
    
    FCUserConfig *userConfig = [FCUserConfigDB getUserFromDB];
    
    FCWatchConfig *watchConfig = [[FCWatchConfig alloc]init];
    watchConfig.guestId = 100;
    watchConfig.phoneModel = [[FitCloudUtils getPhoneModel]unsignedIntValue];
    watchConfig.osVersion = [[FitCloudUtils getOsVersion]unsignedIntValue];
    watchConfig.age = userConfig.age;
    watchConfig.sex = userConfig.sex;
    watchConfig.weight = userConfig.weight;
    watchConfig.height = userConfig.height;
    watchConfig.systolicBP = userConfig.systolicBP;
    watchConfig.diastolicBP = userConfig.diastolicBP;
    watchConfig.isLeftHandWearEnabled = userConfig.isLeftHandWearEnabled;
    
    FCFeaturesObject *feature = [[FCConfigManager manager]featuresObject];
    // 时间显示制式，可以跟随手机时间制式显示
    feature.twelveHoursSystem = [FitCloudUtils is12HourSystem];
    // 单位，根据需要选择
    feature.isImperialUnits = userConfig.isImperialUnits;
    
    watchConfig.featuresData = feature.writeData;
    
    [self showLoadingHUDWithMessage:@"正在绑定设备"];
    [[FitCloud shared]bindDevice:watchConfig result:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            NSLog(@"--绑定成功返回手表配置--");
            // 存储被绑定设备的uuid,下次自动扫描登录
            BOOL ret = [[FitCloud shared]storeBondDevice];
            if (ret)
            {
                [ws hideLoadingHUDWithSuccess:@"绑定成功"];
                // 发送通知更新UI
                [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_DEVICE_BOUND_RESULT_NOTIFY object:nil];
                
                // 手表配置数据解析和存储
                [[FCConfigManager manager]updateConfigWithWatchSettingData:data];
                
                [ws.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                // 如果uuid存储失败，最好做绑定失败处理
                [ws hideLoadingHUDWithSuccess:@"uuid存储失败"];
            }
        }
        else
        {
            NSLog(@"--绑定失败--");
            [ws hideLoadingHUDWithSuccess:@"绑定失败"];
            [[FitCloud shared]disconnect];
            // 绑定失败重新扫描外设，此处根据UI需求配置
            [ws scanForPeripherals];
        }
    }];
}

#pragma mark - 扫描外设

- (void)scanForPeripherals
{
    FCManagerState state = [FitCloud shared].managerState;
    if (state != FCManagerStatePoweredOn) {
        NSLog(@"---蓝牙未打开--");
        return;
    }
    
    __weak __typeof(self) ws = self;
    [[FitCloud shared]scanForPeripherals:nil result:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) {
        NSLog(@"--retArray--%@",retArray);
        @synchronized (ws) {
            [ws.peripehralsArray removeAllObjects];
            [ws.peripehralsArray addObjectsFromArray:retArray];
            [ws.tableView reloadData];
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
    return self.peripehralsArray.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row < self.peripehralsArray.count) {
        CBPeripheral *aPeripheal = self.peripehralsArray[indexPath.row];
        cell.textLabel.text = aPeripheal.name;
        cell.detailTextLabel.text = (aPeripheal.state == CBPeripheralStateConnected ? @"已连接":@"未连接");
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.peripehralsArray.count)
    {
        CBPeripheral *aPeripheal = self.peripehralsArray[indexPath.row];
        // 连接外设
        [[FitCloud shared]connectPeripheral:aPeripheal];
    }
}

#pragma mark - Getter

- (NSMutableArray*)peripehralsArray
{
    if (_peripehralsArray)
    {
        return _peripehralsArray;
    }
    _peripehralsArray = [[NSMutableArray alloc]init];
    return _peripehralsArray;
}
@end
