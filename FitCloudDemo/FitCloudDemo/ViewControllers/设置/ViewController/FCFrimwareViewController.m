//
//  FCFrimwareViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCFrimwareViewController.h"
#import "HFLocalFirmwareViewController.h"
#import "Macro.h"
#import <FitCloudKit.h>
#import "NSObject+HUD.h"


@interface FCFrimwareViewController ()

@end

@implementation FCFrimwareViewController


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

- (IBAction)clickToUpgrade:(id)sender
{
    [self performSegueWithIdentifier:@"本地固件升级" sender:self];
}

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"本地固件升级"])
    {
        WS(ws);
        HFLocalFirmwareViewController *localFW = segue.destinationViewController;
        [localFW setDidSelectedFileAtPathBlock:^(NSString *filePath, BOOL isFlashOTA) {
            NSLog(@"--filePath--%@",filePath);
            if ([filePath containsString:@".bin"])
            {
                
                MBProgressHUD *hud = [ws showProgressHUDWithMessage:@"正在升级"];
                [[FitCloud shared]fcUpdateFirmwareWithPath:filePath progress:^(CGFloat progress) {
                    hud.progress = progress;
                } result:^(FCSyncType syncType, FCSyncResponseState state) {
                    if (state == FCSyncResponseStateSuccess)
                    {
                        NSLog(@"---升级完成---");
                        [ws hideProgressHUDWithSuccess:@"升级成功"];
                        
                    }
                    else
                    {
                        [ws hideProgressHUDWithFailure:@"升级失败"];
                    }
                }];
            }
        }];
    }
}

@end
