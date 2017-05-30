//
//  FCSettingViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSettingViewController.h"
#import "FCConnectStateCell.h"
#import "FitCloud+Category.h"
#import "FCUIConstants.h"
#import <FitCloudKit.h>
#import <NSObject+FBKVOController.h>

@interface FCSettingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCSettingViewController

#pragma mark - dealloc

- (void)dealloc
{
    [self.KVOController unobserve:[FitCloud shared]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DEVICE_BOUND_RESULT_NOTIFY object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[FCConnectStateCell class] forCellReuseIdentifier:@"StateCell"];
    [self registerNotfication];
    
    // 观察蓝牙状态并更新对应的UI
    __weak __typeof(self) ws = self;
    [self.KVOController observe:[FitCloud shared] keyPath:@"managerState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        FCManagerState state = (FCManagerState)[change[NSKeyValueChangeNewKey]integerValue];
        NSLog(@"--state--%@",@(state));
        st_dispatch_async_main(^{
            [ws.tableView reloadData];
        });
    }];
}


#pragma mark - 通知

- (void)registerNotfication
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedBoundResult:) name:EVENT_DEVICE_BOUND_RESULT_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralConnected:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralFailConnect:) name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralDisConnect:) name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
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


- (void)onReceivedBoundResult:(NSNotification*)note
{
    [self.tableView reloadData];
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
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60;
    }
    return 50.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    return 0.01;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FCConnectStateCell *stateCell = [tableView dequeueReusableCellWithIdentifier:@"StateCell" forIndexPath:indexPath];
        BOOL isBound = [[FitCloud shared]deviceIsBond];
        stateCell.hasBeenBound = isBound;
        if (isBound)
        {
            stateCell.textLabel.text = [[FitCloud shared]bondDeviceName];
            stateCell.connected = [FitCloud shared].isConnected;
            stateCell.detailTextLabel.text = @" ";
        }
        else
        {
            stateCell.textLabel.text = @"绑定设备";
            stateCell.detailTextLabel.text = @"未绑定";
        }
        return stateCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_profile"];
        cell.textLabel.text = @"用户资料";
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_note"];
        cell.textLabel.text = @"通知开关";
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_unit"];
        cell.textLabel.text = @"惯用单位";
    }
    else if (indexPath.row == 3)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_alarm"];
        cell.textLabel.text = @"闹钟配置";
    }
    else if (indexPath.row == 4)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_upgrade"];
        cell.textLabel.text = @"固件升级";
    }
    else if (indexPath.row == 5)
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_other"];
        cell.textLabel.text = @"其他设置";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        BOOL ret = [[FitCloud shared]deviceIsBond];
        if (!ret)
        {
            [self performSegueWithIdentifier:@"绑定设备" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"设备信息" sender:self];
        }
    }
    else
    {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"用户资料" sender:self];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"通知开关" sender:self];
        }
        else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"惯用单位" sender:self];
        }
        else if (indexPath.row == 3)
        {
            [self performSegueWithIdentifier:@"闹钟配置" sender:self];
        }
        else if (indexPath.row == 4)
        {
            [self performSegueWithIdentifier:@"固件升级" sender:self];
        }
        else if (indexPath.row == 5)
        {
            [self performSegueWithIdentifier:@"其他设置" sender:self];
        }
    }
}

@end
