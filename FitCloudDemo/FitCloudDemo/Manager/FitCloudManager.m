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
#import "FCUserConfigDB.h"
#import "FCUserConfig.h"
#import "FCConfigManager.h"
#import "FCDayDetailsObject.h"
#import <DateTools.h>
#import "FCDayDetailsDB.h"


static inline void st_dispatch_async_main(dispatch_block_t block) {
    
    if ([NSThread isMainThread]) {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface FitCloudManager()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) dispatch_queue_t asyncQueue;
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
    _asyncQueue = dispatch_queue_create([[[NSDate date]description]UTF8String], NULL);
    
    // 如果蓝牙已经绑定，自动扫描连接
    [self scanForPeripheralWithSavedUUID];
    
    __weak __typeof(self) ws = self;
    [self.KVOController observe:[FitCloud shared] keyPath:@"managerState" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        FCManagerState state = (FCManagerState)[change[NSKeyValueChangeNewKey]integerValue];
        if (state == FCManagerStatePoweredOn)
        {
            // 蓝牙power on，扫描连接指定外设
            NSLog(@"---扫描蓝牙设备---");
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
    FCUserConfig *userConfig = [FCUserConfigDB getUserFromDB];
    
    FCWatchConfig *watchConfig = [[FCWatchConfig alloc]init];
    watchConfig.guestId = 100;
    watchConfig.phoneModel = [[FitCloudUtils getPhoneModel]unsignedIntValue];
    watchConfig.osVersion = [[FitCloudUtils getOsVersion]unsignedIntValue];
    
    // 如果需要同步手机制式或者单位等到手机需要配置此项
    FCFeaturesObject *feature = [[FCConfigManager manager]featuresObject];
    // 时间显示制式，可以跟随手机时间制式显示
    feature.twelveHoursSystem = [FitCloudUtils is12HourSystem];
    // 单位，根据需要选择
    feature.isImperialUnits = userConfig.isImperialUnits;
    watchConfig.featuresData = feature.writeData;
    
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在登录"];
    [[FitCloud shared]loginDevice:watchConfig result:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
        if (syncType == FCSyncTypeLoginDevice)
        {
            if (state == FCSyncResponseStateError)
            {
                // 登陆失败
                [ws hideLoadingHUDWithFailure:@"登录失败,请重新绑定"];
                
                BOOL ret = [[FitCloud shared]removeBondDevice];
                if (ret)
                {
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
                // 登录指令超时则断开重连重新登录
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
            // 登陆成功，将执行其他操作，
            // data 为手表系统配置，你需要把此数据存储到数据库
            NSLog(@"--登录成功---");
            [ws hideLoadingHUDWithSuccess:@"登录成功"];
            
            // 如果你需要自己定义登录浏览，可以不使用此组合接口，直接使用分步的接口操作
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
    if (!ret)
    {
        NSLog(@"--蓝牙未绑定--");
        [self showWarningWithMessage:@"设备未绑定"];
        return;
    }
    
    ret = [[FitCloud shared]isConnected];
    if (!ret)
    {
        NSLog(@"--蓝牙未连接--");
        [self showWarningWithMessage:@"蓝牙未连接"];
        // 扫描连接以及绑定的蓝牙
        [self scanForPeripheralWithSavedUUID];
        return;
    }

    [self syncHistoryData];
}

#pragma mark - 历史数据同步与解析

- (void)syncHistoryData
{
    
    __weak __typeof(self) ws = self;
    
    FCUserConfig *userConfig = [FCUserConfigDB getUserFromDB];
    FCFeaturesObject *feature = [[FCConfigManager manager]featuresObject];
    // 时间显示制式，可以跟随手机时间制式显示
    feature.twelveHoursSystem = [FitCloudUtils is12HourSystem];
    // 单位，根据需要选择
    feature.isImperialUnits = userConfig.isImperialUnits;
    
    FCWatchConfig *watchConfig = [[FCWatchConfig alloc]init];
    watchConfig.featuresData =  feature.writeData;
    
    [ws hideAllHUDs];
    [ws showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcGetHistoryData:watchConfig stepCallback:^(NSInteger syncType) {
        FCSyncType dataSyncType = (FCSyncType)syncType;
        NSLog(@"---同步步骤--%@",@(dataSyncType));
    } dataCallback:^(FCSyncType syncType, NSData *data) {
        // 部分类型的数据是否同步跟随传感器标志变化，如传感器标志存在心率，则才会有心率数据返回
        dispatch_async(_asyncQueue, ^{
            if (syncType == FCSyncTypeGetDayTotalData)
            {
                // 日总数据
                [ws didReceivedTotalData:data];
            }
            else if (syncType == FCSyncTypeGetExerciseData)
            {
                // 运动量
                [ws didReceivedExerciseData:data];
            }
            else if (syncType == FCSyncTypeGetSleepData)
            {
                // 睡眠
                [ws didReceivedSleepData:data];
            }
            else if (syncType == FCSyncTypeGetHeartRateData)
            {
                // 心率
                [ws didReceivedHeartRateData:data];
            }
            else if (syncType == FCSyncTypeGetBloodOxygenData)
            {
                // 血氧
                [ws didReceivedBloodOxygenData:data];
            }
            else if (syncType == FCSyncTypeGetBloodPressureData)
            {
                // 血压
                [ws didReceivedBloodPressureData:data];
            }
            else if (syncType == FCSyncTypeGetBreathingRateData)
            {
                // 呼吸频率
                [ws didReceivedBreathingRateData:data];
            }
            else if (syncType == FCSyncTypeGetUltravioletData)
            {
                // 紫外线，暂无
            }
            else if (syncType == FCSyncTypeGetSevenDaysSleepData)
            {
                // 7日睡眠
                NSArray *servenDaySleepArray = [FCSyncUtils getSevenDaysSleepTotalData:data];
                NSLog(@"---servenDaysArray--%@",servenDaySleepArray);
            }
        });
    } result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
        }
        else if (state == FCSyncResponseStateTimeOut)
        {
            [ws hideLoadingHUDWithFailure:@"同步超时"];
        }
        else if (state == FCSyncResponseStateSynchronizing)
        {
            NSLog(@"--正在同步[%@]--",@([FitCloud shared].syncType));
        }
        else if (state == FCSyncResponseStateNotConnected)
        {
            [ws hideAllHUDs];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - 运动量

- (void)didReceivedTotalData:(NSData*)data
{
    if (!data) {
        return;
    }
    NSDictionary *params = [FCSyncUtils getDaySummary:data];
    NSLog(@"--params--%@",params);
    
    // 如果需要对每日步数进行累加，请自行累加处理，每次手环重新绑定都会从0开始重新计算
    // 存储日总数据
    FCDayDetailsObject *dayDetails = [[FCDayDetailsObject alloc]init];
    dayDetails.stepCount = params[@"stepCount"];
    dayDetails.distance = params[@"distance"];
    dayDetails.calorie = params[@"calorie"];
    dayDetails.deepSleep = params[@"deepSleep"];
    dayDetails.lightSleep = params[@"lightSleep"];
    dayDetails.avgHeartRate = params[@"avgHeartRate"];
    
    NSDate *currentDate = [NSDate date];
    dayDetails.timeStamp = @([[NSDate dateWithYear:currentDate.year month:currentDate.month day:currentDate.day]timeIntervalSince1970]);
    
    [FCDayDetailsDB storeDayDetails:dayDetails result:^(BOOL finished) {
        if (finished) {
            NSLog(@"---存储日总数据---");
        }
    }];
    // 通知刷新UI
    st_dispatch_async_main(^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"EVENT_DAY_DETAILS_UPDATE_NOTIFY" object:dayDetails];
    });
}


#pragma mark - 运动量
- (void)didReceivedExerciseData:(NSData*)data
{
    if (!data) {
        return;
    }
    // 获取运动详细记录 （每五分钟一个记录）
    
    NSArray *detailsArray = [FCSyncUtils getRecordsOfExercise:data];
    NSLog(@"--运动量-【%@】-%@",data,detailsArray);
    // 存储详细记录，如果有需要，可以对记录按天统计求和
    
    // 服务器需要保持记录的可以将详细记录上传给服务器
}


#pragma mark - 睡眠
- (void)didReceivedSleepData:(NSData*)data
{
    if (!data) {
        return;
    }
    // 获取运动详细记录 （每五分钟一个记录）
    NSArray *detailsArray = [FCSyncUtils getRecordsOfSleep:data];
    NSLog(@"--睡眠-【%@】-%@",data,detailsArray);
    // 存储详细记录，如果有需要，可以对记录按天统计求和
    
    // 服务器需要保持记录的可以将详细记录上传给服务器
}

#pragma mark - 心率
- (void)didReceivedHeartRateData:(NSData*)data
{
    if (!data) {
        return;
    }
    // 获取运动详细记录 （每五分钟一个记录）
    NSArray *detailsArray = [FCSyncUtils getRecordsOfHeartRate:data];
    NSLog(@"--心率-【%@】-%@",data,detailsArray);
    // 存储详细记录，如果有需要，可以对记录按天统计平均值
    
    // 服务器需要保持记录的可以将详细记录上传给服务器
}

#pragma mark - 血氧
- (void)didReceivedBloodOxygenData:(NSData*)data
{
    if (!data) {
        return;
    }
    // 获取运动详细记录 （每五分钟一个记录）
    NSArray *detailsArray = [FCSyncUtils getRecordsOfBloodOxygen:data];
    NSLog(@"--血氧-【%@】-%@",data,detailsArray);
    // 存储详细记录，如果有需要，可以对记录按天统计平均值
    
    // 服务器需要保持记录的可以将详细记录上传给服务器
}

#pragma mark - 血压
- (void)didReceivedBloodPressureData:(NSData*)data
{
    if (!data) {
        return;
    }
    FCUserConfig *userConfig = [FCUserConfigDB getUserFromDB];
    
    // 获取运动详细记录 （每五分钟一个记录）
    NSArray *detailsArray = [FCSyncUtils getRecordsOfBloodPressure:data systolicBP:userConfig.systolicBP diastolicBP:userConfig.diastolicBP];
    NSLog(@"--血压-【%@】-%@",data,detailsArray);
    // 存储详细记录，如果有需要，可以对记录按天统计平均值
    
    // 服务器需要保持记录的可以将详细记录上传给服务器
}

#pragma mark - 呼吸频率
- (void)didReceivedBreathingRateData:(NSData*)data
{
    if (!data) {
        return;
    }
    
    // 获取运动详细记录 （每五分钟一个记录）
    NSArray *detailsArray = [FCSyncUtils getRecordsOfBreathingRate:data];
    NSLog(@"--呼吸频率-【%@】-%@",data,detailsArray);
    // 存储详细记录，如果有需要，可以对记录按天统计平均值
    
    // 服务器需要保持记录的可以将详细记录上传给服务器
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
