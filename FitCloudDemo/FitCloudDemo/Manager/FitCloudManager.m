//
//  FitCloudManager.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/11/23.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "FitCloudManager.h"
#import <FitCloudKit.h>
#import "FitCloud+Category.h"
#import <NSObject+FBKVOController.h>
#import "NSObject+HUD.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface FitCloudManager()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation FitCloudManager

+ (instancetype)manager
{
    static FitCloudManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FitCloudManager alloc]init];
    });
    return instance;
}

- (void)startService
{
    [self registerNotification];
    
    // 如果蓝牙已经绑定，自动扫描连接
    [self scanForPeripheralWithSavedUUID];
    
    __weak __typeof(self) ws = self;
    [self.KVOController observe:[FitCloud shared] keyPath:@"managerState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        FCManagerState state = (FCManagerState)[change[NSKeyValueChangeNewKey]integerValue];
        if (state == FCManagerStatePoweredOn)
        {
            // 蓝牙power on，扫描连接指定外设
            [ws scanForPeripheralWithSavedUUID];
        }
        else if (state == FCManagerStatePoweredOff)
        {
            NSLog(@"---蓝牙断开连接---");
        }
    }];
    
    // 监听查找手机指令，并作出对应的响应，UI根据需求定制
    [[FitCloud shared]fcSetListenFindPhoneCMDFromWatch:^{
        [ws playMusicAndVibrateToReplyFoundThePhone];
    }];

}

#pragma mark - 查找手机响应

void systemAudioCallback()
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playMusicAndVibrateToReplyFoundThePhone
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state != UIApplicationStateActive)
    {
        UILocalNotification *localNotify = [[UILocalNotification alloc]init];
        localNotify.fireDate = [NSDate date];
        localNotify.timeZone = [NSTimeZone defaultTimeZone];
        localNotify.alertBody = @"找到手机";
        localNotify.soundName = @"29.mp3";
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotify];
        
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    if (self.audioPlayer == nil || self.audioPlayer.playing) {
        return;
    }
    // 播放音乐和震动
    [self.audioPlayer play];
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    __weak __typeof(self) ws = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"找到手机" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        // 停止播放音乐和震动
        if (ws.audioPlayer) {
            [ws.audioPlayer stop];
        }
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
        
        
        // 发送回复给手表
        [[FitCloud shared]fcFindThePhoneReply:^(FCSyncType syncType, FCSyncResponseState state) {
            if (state == FCSyncResponseStateSuccess) {
                NSLog(@"--查找手机回复成功--");
            }
        }];
    } ]];
    UIViewController *rootViewController = [UIApplication sharedApplication].windows[0].rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -  扫描连接

- (void)scanForPeripheralWithSavedUUID
{
    BOOL ret = [[FitCloud shared]isConnected];
    if (ret) {
        NSLog(@"--外设已连接--");
    }
    NSString *boundUUIDString = [[FitCloud shared]bondDeviceUUID];
    if (boundUUIDString)
    {
        // 扫描连接外设
        [[FitCloud shared]scanForPeripherals:boundUUIDString result:^(NSArray<CBPeripheral *> *retArray, CBPeripheral *aPeripheral) {
            // 扫描连接外设
            [[FitCloud shared]connectPeripheral:aPeripheral];
        }];
    }
}

#pragma mark - notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralConnected:) name:EVENT_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralFailConnect:) name:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralDisConnect:) name:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedPeripheralDiscoverCharacteristics:) name:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)onReceivedPeripheralConnected:(NSNotification*)note
{
    NSLog(@"--外设连接成功--");
}

- (void)onReceivedPeripheralFailConnect:(NSNotification*)note
{
    
    NSLog(@"--外设连接失败--");
}

- (void)onReceivedPeripheralDisConnect:(NSNotification*)note
{
    NSLog(@"--外设断开连接--");
    [self hideAllHUDs];
    [self showWarningWithMessage:@"蓝牙断开连接"];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound (1023);//声音
    
    // 自动断开进行重新连接处理
    NSString *boundDeviceUUID = [[FitCloud shared]bondDeviceUUID];
    if (boundDeviceUUID)
    {
        if (note && note.object && [note.object isKindOfClass:[CBPeripheral class]] && !self.autoConnectDisabled)
        {
            CBPeripheral *aPeripheral = (CBPeripheral*)(note.object);
            if (boundDeviceUUID && [aPeripheral.identifier.UUIDString isEqualToString:boundDeviceUUID])
            {
                NSLog(@"--断开重连--");
                [[FitCloud shared]connectPeripheral:aPeripheral];
            }
        }
    }
}


- (void)onReceivedPeripheralDiscoverCharacteristics:(NSNotification*)note
{
    BOOL ret = [[FitCloud shared]deviceIsBond];
    if (ret)
    {
        // 开始登陆设备
        [self loginDevice];
    }
    else
    {
        NSLog(@"--设备未绑定--");
    }
}

#pragma mark - 登录设备
- (void)loginDevice
{
    FCUserObject *user = [[FCUserObject alloc]init];
    user.guestId = 100;
    user.phoneModel = [[FitCloudUtils getPhoneModel]unsignedIntValue];
    user.osVersion = [[FitCloudUtils getOsVersion]unsignedIntValue];
    
    // 如果需要同步手机制式或者单位等到手机需要配置此项
//    FCFeaturesObject *feature = [[FCFeaturesObject alloc]init];
//    feature.flipWristToLightScreen = YES;
//    feature.enhanceSurveyEnabled = YES;
//    // 时间显示制式，可以跟随手机时间制式显示
//    feature.twelveHoursSystem = YES;
//    // 单位，根据需要选择
//    feature.isImperialUnits = NO;
//    user.featuresData = feature.writeData;
    
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在登陆"];
    [[FitCloud shared]loginWithUser:user stepCallback:^(NSInteger syncType) {
        NSLog(@"--登陆流程回调--%@",@(syncType));
        
    } result:^(FCSyncType syncType, FCLoginSyncType loginSyncType, FCSyncResponseState state) {
        if (loginSyncType == FCLoginSyncTypeLogin) {
            if (state == FCSyncResponseStateError)
            {
                // 登陆失败
                [ws hideLoadingHUDWithFailure:@"登陆失败,请重新绑定"];
                BOOL ret = [[FitCloud shared]removeBondDevice];
                if (ret) {
                    // 断开当前蓝牙外设的连接
                    ret = [[FitCloud shared]disconnect];
                    if(ret)
                    {
                        NSLog(@"蓝牙断开连接");
                    }
                }

            }
            else if (state == FCSyncResponseStateTimeOut)
            {
                [ws hideLoadingHUD];
                BOOL ret = [[FitCloud shared]disconnect];
                if(ret)
                {
                    NSLog(@"蓝牙断开连接后重连登录");
                }
            }
            else
            {
                [ws hideLoadingHUDWithFailure:@"登录失败"];
            }
            
        }
        else
        {
            // 登陆成功，这里可以做自定义操作，比如同步天气或者同步数据，等等操作
            NSLog(@"--登录成功---");
            [ws hideLoadingHUDWithSuccess:@"登录成功"];
        }
    }];
}

#pragma mark - 应用程序前后台切换

- (void)applicationDidBecomeActiveNotification
{
    NSLog(@"---程序进入前台---");
    BOOL ret = [[FitCloud shared]deviceIsBond];
    if (!ret) {
        NSLog(@"--蓝牙未绑定--");
        return;
    }
    
    ret = [[FitCloud shared]isConnected];
    if (!ret) {
        NSLog(@"--蓝牙未连接--");
        [self scanForPeripheralWithSavedUUID];
        return;
    }
    // 同步手表历史数据
    [self syncHistoryData];
}

#pragma mark - 下拉刷新同步数据

- (void)pullDownToSyncHistoryData
{
    BOOL ret = [[FitCloud shared]deviceIsBond];
    if (!ret) {
        NSLog(@"--蓝牙未绑定--");
        [self showWarningWithMessage:@"设备未绑定"];
        return;
    }
    
    ret = [[FitCloud shared]isConnected];
    if (!ret) {
        NSLog(@"--蓝牙未连接--");
        [self showWarningWithMessage:@"蓝牙未连接"];
        [self scanForPeripheralWithSavedUUID];
        return;
    }

    [self syncHistoryData];
}

#pragma mark - 历史数据同步与解析

- (void)syncHistoryData
{
    
}



#pragma mark - Getter

- (AVAudioPlayer*)audioPlayer
{
    if (_audioPlayer) {
        return _audioPlayer;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"29" ofType:@"mp3"];
    NSURL* fileURL = [NSURL fileURLWithPath:path];
    if (!fileURL) {
        return nil;
    }
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [_audioPlayer prepareToPlay];
    _audioPlayer.numberOfLoops = -1;
    return _audioPlayer;
}

@end
