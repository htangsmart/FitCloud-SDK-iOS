//
//  SyncHistoryViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "SyncHistoryViewController.h"
#import "NSObject+HUD.h"
#import <FitCloudKit.h>
#import "Macro.h"


@interface SyncHistoryViewController ()

@end

@implementation SyncHistoryViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self syncHistoryData];
}

- (void)syncHistoryData
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"健康实时测试"];
    [[FitCloud shared]fcGetHistoryData:^(FCSyncType syncType) {
        NSLog(@"--syncType--%@",@(syncType));
    } dataHandler:^(FCSyncType syncType, NSData *data) {
        if (syncType == FCSyncTypeExercise) {
            NSArray *array = [FitCloudUtils resolveExerciseDataIntoModelObjects:data];
            NSLog(@"--array--%@",array);
        }
        else if (syncType == FCSyncTypeSleep)
        {
            NSArray *array = [FitCloudUtils resolveSleepDataIntoModelObjects:data];
            NSLog(@"--array--%@",array);
        }
        else if (syncType == FCSyncTypeHeartRate)
        {
            NSArray *array = [FitCloudUtils resolveHeartRateDataIntoModelObjects:data];
            NSLog(@"--array--%@",array);
        }
        else if (syncType == FCSyncTypeBloodOxygen)
        {
        }
        else if (syncType == FCSyncTypeBloodPressure)
        {
        }
        else if (syncType == FCSyncTypeBreathingRate)
        {
            
        }
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步完成"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}



@end
