//
//  FCProfileViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCProfileViewController.h"
#import "HFRadioAlertView.h"
#import "FCConfigManager.h"
#import "FitCloud+Category.h"
#import <FitCloudKit.h>
#import "FCUserConfigDB.h"
#import "FCUserConfig.h"
#import "FCWatchConfigDB.h"
#import "NSNumber+Category.h"
#import "HFPickerView.h"
#import <DateTools.h>
#import "NSObject+HUD.h"
#import <YYModel.h>

@interface FCProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCUserConfig *userConfig;
@end

@implementation FCProfileViewController

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


- (IBAction)clickToSave:(id)sender
{
    if (!self.userConfig) {
        return;
    }
    
    BOOL ret = [FCUserConfigDB storeUser:self.userConfig];
    if (!ret) {
        [self showErrorWithMessage:@"保存失败"];
    }
    
    FCUserObject *userObject = [[FCUserObject alloc]init];
    userObject.age = self.userConfig.age;
    userObject.sex = self.userConfig.sex;
    userObject.weight = self.userConfig.weight;
    userObject.height = self.userConfig.height;
    userObject.systolicBP = self.userConfig.systolicBP;
    userObject.diastolicBP = self.userConfig.diastolicBP;
    
    __weak __typeof(self) ws = self;
    [self showLoadingHUDWithMessage:@"正在同步资料"];
    [[FitCloud shared]fcSetUserProfile:userObject result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess) {
            
            [ws changeLoadingWithMessage:@"正在同步默认血压"];
            [[FitCloud shared]fcSetBloodPressure:userObject.systolicBP dbp:userObject.diastolicBP result:^(FCSyncType syncType, FCSyncResponseState state) {
                if (state == FCSyncResponseStateSuccess)
                {
                    [ws hideLoadingHUDWithSuccess:@"同步成功"];
                }
                else
                {
                    [ws hideLoadingHUDWithFailure:@"同步失败"];
                }
            }];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    FCUserConfig *aUserConfig = [FCUserConfigDB getUserFromDB];
    self.userConfig = aUserConfig;
    NSLog(@"--aUserConfig---%@",aUserConfig.yy_modelDescription);
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"出身年月";
        cell.detailTextLabel.text = @(self.userConfig.age).stringValue;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = (self.userConfig.sex ? @"男" : @"女");
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"身高";
        if (!self.userConfig.isImperialUnits) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ cm",@(self.userConfig.height)];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ in",[@(self.userConfig.height) cmToInch]];
        }
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"体重";
        if (!self.userConfig.isImperialUnits) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kg",@(self.userConfig.weight)];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ lb",[@(self.userConfig.weight) kiolgramToPand]];
        }
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"收缩压";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ mmHg",@(self.userConfig.systolicBP)];
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"舒张压";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ mmHg",@(self.userConfig.diastolicBP)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        __weak __typeof(self) ws = self;
        HFPickerView *pickerView = [HFPickerView pickerView];
        pickerView.pickerStyle = HFPickerStyleBirthDate;
        pickerView.birthDate = @(NSDate.date.year - self.userConfig.age).stringValue;
        [pickerView setDidCompletionPickDateBlock:^(NSString *birthDate) {
            NSLog(@"--birthDate---%@",birthDate);
            NSInteger birthDateYear = [birthDate substringToIndex:4].integerValue;
            NSLog(@"--birthDateYear---%@",@(birthDateYear));
            ws.userConfig.age = (UInt32)([NSDate date].year - birthDateYear) ;
            [ws.tableView reloadData];
        }];
        [pickerView show];
    }
    else if (indexPath.row == 1)
    {
        __weak __typeof(self) ws = self;
        HFRadioAlertView *sexRaidoView = [HFRadioAlertView alertViewWithTitle:@"性别" andItems:@[@"男",@"女"]];
        sexRaidoView.checkItem = (self.userConfig.sex ? @"男":@"女");
        [sexRaidoView setDidTouchBlock:^(NSString *item) {
            BOOL isWomen = [item isEqualToString:@"女"];
            ws.userConfig.sex = isWomen ? 0 : 1;
            [ws.tableView reloadData];
        }];
        [sexRaidoView show];
    }
    else if (indexPath.row == 2)
    {
        __weak __typeof(self) ws = self;
        HFPickerView *pickerView = [HFPickerView pickerView];
        pickerView.pickerStyle = self.userConfig.isImperialUnits ?  HFPickerStyleEHeight : HFPickerStyleMHeight;
        pickerView.value = self.userConfig.height;
        [pickerView setDidCompletionPickBlock:^(NSNumber *pickValue) {
            if (pickerView.pickerStyle == HFPickerStyleEHeight) {
                ws.userConfig.height = (UInt32)[pickValue inchToCM].unsignedIntegerValue;
            }
            else
            {
                ws.userConfig.height = pickValue.unsignedIntValue;
            }
            [ws.tableView reloadData];
        }];
        [pickerView show];
    }
    else if (indexPath.row == 3)
    {
        __weak __typeof(self) ws = self;
        HFPickerView *pickerView = [HFPickerView pickerView];
        pickerView.pickerStyle = self.userConfig.isImperialUnits ? HFPickerStyleEWeight : HFPickerStyleMWeight;
        pickerView.value = self.userConfig.weight;
        [pickerView setDidCompletionPickBlock:^(NSNumber *pickValue) {
            NSLog(@"--pickValue---%@",pickValue);
            if (pickerView.pickerStyle == HFPickerStyleEWeight) {
                ws.userConfig.weight = (UInt32)[pickValue pandToKiloGram].unsignedIntegerValue;
            }
            else
            {
                ws.userConfig.weight = pickValue.unsignedIntValue;
            }
            [ws.tableView reloadData];
        }];
        [pickerView show];
    }
    else if (indexPath.row == 4)
    {
        __weak __typeof(self) ws = self;
        HFPickerView *pickerView = [HFPickerView pickerView];
        pickerView.pickerStyle = HFPickerStyleSBP;
        pickerView.value = self.userConfig.systolicBP;
        [pickerView setDidCompletionPickBlock:^(NSNumber *pickValue) {
            ws.userConfig.systolicBP = pickValue.unsignedIntValue;
            [ws.tableView reloadData];
        }];
        [pickerView show];

    }
    else if (indexPath.row == 5)
    {
        __weak __typeof(self) ws = self;
        HFPickerView *pickerView = [HFPickerView pickerView];
        pickerView.pickerStyle = HFPickerStyleDBP;
        pickerView.value = self.userConfig.diastolicBP;
        [pickerView setDidCompletionPickBlock:^(NSNumber *pickValue) {
            ws.userConfig.diastolicBP = pickValue.unsignedIntValue;
            [ws.tableView reloadData];
        }];
        [pickerView show];
    }

}
@end
