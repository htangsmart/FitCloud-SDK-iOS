//
//  FCOtherViewController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/27.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCOtherViewController.h"

@interface FCOtherViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISwitch *drinkRemindSwitch;
@end

@implementation FCOtherViewController

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 4;
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
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrinkRemind" forIndexPath:indexPath];
        cell.textLabel.text = @"喝水提醒";
        cell.accessoryView = self.drinkRemindSwitch;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - valueChanged

- (void)drinkRemindSwitchValueChanged:(UISwitch*)aSwitch
{
    
}

#pragma mark - Getter

- (UISwitch*)drinkRemindSwitch
{
    if (_drinkRemindSwitch) {
        return _drinkRemindSwitch;
    }
    _drinkRemindSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_drinkRemindSwitch addTarget:self action:@selector(drinkRemindSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _drinkRemindSwitch;
}
@end
