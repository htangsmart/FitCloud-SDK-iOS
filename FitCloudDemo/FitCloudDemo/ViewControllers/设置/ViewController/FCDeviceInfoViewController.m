//
//  FCDeviceInfoViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCDeviceInfoViewController.h"

@interface FCDeviceInfoViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *batteryLevel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation FCDeviceInfoViewController

#pragma mark - dealloc

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
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell" forIndexPath:indexPath];
        
        cell.textLabel.text = @"设备名称";
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindWatchCell" forIndexPath:indexPath];
        cell.textLabel.text = @"查找手环";
        return cell;
    }
    else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DisplayCell" forIndexPath:indexPath];
        cell.textLabel.text = @"手环显示设置";
        cell.detailTextLabel.text = @"设置是否在手环上显示";
        return cell;
    }
    else if (indexPath.row == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WearStyleCell" forIndexPath:indexPath];
        cell.textLabel.text = @"佩戴方式";
        return cell;
    }
    else if (indexPath.row == 4 || indexPath.row == 5)
    {
        if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.textLabel.text = @"翻腕亮屏";
            cell.detailTextLabel.text = @"翻手腕查看手环信息";
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.textLabel.text = @"健康定时监测";
            cell.detailTextLabel.text = @"开启时定时自动检测，生成历史记录";
            return cell;
        }
    }
    else
    {
         if (indexPath.row == 6)
         {
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
             cell.textLabel.text = @"开始时间";
             return cell;
         }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"结束时间";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
