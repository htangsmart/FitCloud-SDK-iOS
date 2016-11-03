//
//  RealTimeTestViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "RealTimeTestViewController.h"
#import "Macro.h"
#import "FitCloud.h"
#import "NSObject+HUD.h"


@interface RealTimeTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *realtimeTestButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, assign) FCRTSyncType rtSyncType;
@end

@implementation RealTimeTestViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToOpenOrCloseRTTest:(UIButton*)sender
{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"打开健康实时测试"]) {
        
        WS(ws);
        [[FitCloud shared]fcOpenRealTimeSync:self.rtSyncType dataHandler:^(FCSyncType syncType, NSData *data) {
            if (ws.rtSyncType == FCRTSyncTypeHeartRate) {
                Byte byte[1] = {0};
                [data getBytes:byte range:NSMakeRange(data.length-5, 1)];
                NSNumber *value = @(byte[0]);
                ws.resultLabel.text = [NSString stringWithFormat:@"实时心率%@",value];
            }
            else if (ws.rtSyncType == FCRTSyncTypeBloodOxygen)
            {
                Byte byte[1] = {0};
                [data getBytes:byte range:NSMakeRange(data.length-4, 1)];
                
                NSInteger value = byte[0];
                ws.resultLabel.text = [NSString stringWithFormat:@"实时血压%@",@(value)];
            }
            else if (ws.rtSyncType == FCRTSyncTypeBloodPressure)
            {
                Byte byte[2] = {0};
                [data getBytes:byte range:NSMakeRange(data.length-3, 2)];
                
                NSInteger lbpValue = byte[0];
                NSInteger hbpValue = byte[1];
                ws.resultLabel.text = [NSString stringWithFormat:@"实时血压 低压%@ 高压%@",@(lbpValue),@(hbpValue)];
            }
            else if (ws.rtSyncType == FCRTSyncTypeBreathingRate)
            {
                Byte byte[1] = {0};
                [data getBytes:byte range:NSMakeRange(data.length-1, 1)];
                NSNumber *value = @(byte[0]);
                ws.resultLabel.text = [NSString stringWithFormat:@"实时呼吸频率%@",value];
            }
        } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
            if (state == FCSyncResponseStateSuccess) {
                [sender setTitle:@"关闭健康实时测试" forState:UIControlStateNormal];
            }
            else if (state == FCSyncResponseStateRTTimeOut)
            {
                [sender setTitle:@"打开健康实时测试" forState:UIControlStateNormal];
            }
            else
            {
                [ws showErrorWithMessage:@"打开实时同步超时"];
            }
        }];
    }
    else
    {
        
        WS(ws);
        [[FitCloud shared]fcCloseRealTimeSync:^(FCSyncType syncType, FCSyncResponseState state) {
            if (state == FCSyncResponseStateSuccess) {
                [sender setTitle:@"打开健康实时测试" forState:UIControlStateNormal];
            }
            else
            {
                [ws showErrorWithMessage:@"关闭实时同步超时"];
            }
        }];
    }
}


- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.rtSyncType = FCRTSyncTypeHeartRate;
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        self.rtSyncType = FCRTSyncTypeBloodOxygen;
    }
    else if (sender.selectedSegmentIndex == 2)
    {
        self.rtSyncType = FCRTSyncTypeBloodPressure;
    }
    else if (sender.selectedSegmentIndex == 3)
    {
        self.rtSyncType = FCRTSyncTypeBreathingRate;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rtSyncType = FCRTSyncTypeHeartRate;
    self.resultLabel.text = @"测试结果";
}




@end
