//
//  FCNotificationViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCNotificationViewController.h"
#import "FCNotificationCell.h"
#import "FCConfigManager.h"
#import <FitCloudKit.h>
#import "NSObject+HUD.h"
#import "FCWatchConfigDB.h"
#import "FitCloud+Category.h"
#import <NSObject+FBKVOController.h>
#import "FCUIConstants.h"
#import "FCSwitch.h"


@interface FCNotificationViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCNotificationObject *noteObj;
@end

@implementation FCNotificationViewController

#pragma mark - dealloc

- (void)dealloc
{
    [self.KVOController unobserve:[FitCloud shared]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
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
    
    self.tableView.userInteractionEnabled = [[FitCloud shared]isConnected];
    
    __weak __typeof(self) ws = self;
    [self.KVOController observe:[FitCloud shared] keyPath:@"managerState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        FCManagerState state = (FCManagerState)[change[NSKeyValueChangeNewKey]integerValue];
        NSLog(@"--state--[%@]:%@",@([NSThread isMainThread]),@(state));
        st_dispatch_async_main(^{
            if (state == FCManagerStatePoweredOn)
            {
                
            }
            else if (state == FCManagerStatePoweredOff)
            {
                ws.tableView.userInteractionEnabled = NO;
            }
        });
    }];

    
    
    FCNotificationObject *noteObj = [[FCConfigManager manager]notificationObject];
    self.noteObj = noteObj;
    [self.tableView reloadData];
}


- (void)registerNotfication
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralConnected:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralDisConnect:) name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
}


- (void)onReceivedPeripheralConnected:(NSNotification*)note
{
    NSLog(@"--外设连接成功--");
    
    self.tableView.userInteractionEnabled = YES;
}


- (void)onReceivedPeripheralDisConnect:(NSNotification*)note
{
    NSLog(@"--外设断开连接--");
    self.tableView.userInteractionEnabled = NO;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    __weak __typeof(self) ws = self;
    [cell setSwitchValueChangeBlock:^(FCSwitch *aSwicth, NSString *funSwitchName){
        [ws switchValueChanged:aSwicth forFunction:funSwitchName];
    }];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"来电通知";
        cell.mySwitch.on = self.noteObj.incomingCall;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"短信通知";
        cell.mySwitch.on = self.noteObj.smsAlerts;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"QQ消息";
        cell.mySwitch.on = self.noteObj.qqMessage;
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"微信消息";
        cell.mySwitch.on = self.noteObj.wechatMessage;
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"facebook";
        cell.mySwitch.on = self.noteObj.facebook;
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"twitter";
        cell.mySwitch.on = self.noteObj.twitter;
    }
    else if (indexPath.row == 6)
    {
        cell.textLabel.text = @"linkedin";
        cell.mySwitch.on = self.noteObj.linkedin;
    }
    else if (indexPath.row == 7)
    {
        cell.textLabel.text = @"instagram";
        cell.mySwitch.on = self.noteObj.instagram;
    }
    else if (indexPath.row == 8)
    {
        cell.textLabel.text = @"pinterest";
        cell.mySwitch.on = self.noteObj.pinterest;
    }
    else if (indexPath.row == 9)
    {
        cell.textLabel.text = @"whatsapp";
        cell.mySwitch.on = self.noteObj.whatsapp;
    }
    else if (indexPath.row == 10)
    {
        cell.textLabel.text = @"line";
        cell.mySwitch.on = self.noteObj.line;
    }
    else if (indexPath.row == 11)
    {
        cell.textLabel.text = @"facebookMessage";
        cell.mySwitch.on = self.noteObj.facebookMessage;
    }
    else if (indexPath.row == 12)
    {
        cell.textLabel.text = @"其他app通知";
        cell.mySwitch.on = self.noteObj.otherApp;
    }
    else if (indexPath.row == 13)
    {
        // 这个选项可以不用
        cell.textLabel.text = @"显示消息内容";
        cell.mySwitch.on = self.noteObj.messageDisplayEnabled;
    }
    else if (indexPath.row == 14)
    {
        cell.textLabel.text = @"app断开提醒";
        cell.mySwitch.on = self.noteObj.appDisconnectAlerts;
    }
    else if (indexPath.row == 15)
    {
        cell.textLabel.text = @"手表断开提醒";
        cell.mySwitch.on = self.noteObj.watchDisconnectAlerts;
    }
    else if (indexPath.row == 16)
    {
        // 这个选项可以不用
        cell.textLabel.text = @"kakao消息";
        cell.mySwitch.on = self.noteObj.kakaoMessage;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)switchValueChanged:(FCSwitch*)aSwitch forFunction:(NSString*)functionName
{
    if ([functionName isEqualToString:@"来电通知"])
    {
        self.noteObj.incomingCall = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.incomingCall = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"短信通知"])
    {
        self.noteObj.smsAlerts = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.smsAlerts = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"QQ消息"])
    {
        self.noteObj.qqMessage = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.qqMessage = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"微信消息"])
    {
        self.noteObj.wechatMessage = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.wechatMessage = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"facebook"])
    {
        self.noteObj.facebook = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.facebook = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"twitter"])
    {
        self.noteObj.twitter = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.twitter = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"linkedin"])
    {
        self.noteObj.linkedin = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.linkedin = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"instagram"])
    {
        self.noteObj.instagram = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.instagram = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"pinterest"])
    {
        self.noteObj.pinterest = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.pinterest = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"whatsapp"])
    {
        self.noteObj.whatsapp = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.whatsapp = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"line"])
    {
        self.noteObj.line = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.line = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"facebookMessage"])
    {
        self.noteObj.facebookMessage = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.facebookMessage = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"其他app通知"])
    {
        self.noteObj.otherApp = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.otherApp = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"显示消息内容"])
    {
        self.noteObj.messageDisplayEnabled = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.messageDisplayEnabled = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"app断开提醒"])
    {
        self.noteObj.appDisconnectAlerts = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.appDisconnectAlerts = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"手表断开提醒"])
    {
        self.noteObj.watchDisconnectAlerts = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.watchDisconnectAlerts = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
    else if ([functionName isEqualToString:@"心率实时监测"])
    {
        self.noteObj.kakaoMessage = aSwitch.isOn;
        __weak __typeof(self) ws = self;
        [self syncNotificationData:^{
            ws.noteObj.kakaoMessage = !aSwitch.isOn;
            [aSwitch setOn:!aSwitch.isOn animated:YES];
        }];
    }
}

- (void)syncNotificationData:(dispatch_block_t)completion
{
    NSData *data = self.noteObj.writeData;
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetNotificationSettingData:data result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
            
            FCWatchSettingsObject *watchSettingObj = [FCConfigManager manager].watchSetting;
            watchSettingObj.nfSettingData = data;
            NSString *uuid = [[FitCloud shared]bondDeviceUUID];
            BOOL ret = [FCWatchConfigDB storeWatchConfig:watchSettingObj forUUID:uuid];
            if (ret)
            {
                NSLog(@"--更新手表配置--");
            }
        }
        else
        {
            if (completion) {
                completion();
            }
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

@end
