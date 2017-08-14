//
//  HFLocalFirmwareViewController.m
//  HFit
//
//  Created by 远征 马 on 16/8/2.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "HFLocalFirmwareViewController.h"

@interface HFLocalFirmwareViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listArray;

@end

@implementation HFLocalFirmwareViewController

#pragma mark - 按钮交互

- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    self.listArray = files;
    [self.tableView reloadData];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row < self.listArray.count) {
        cell.textLabel.text = self.listArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.listArray.count)
    {
        NSString *fileName = self.listArray[indexPath.row];
        NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [patchs objectAtIndex:0];
        NSString *filePath = [documentsDirectory  stringByAppendingPathComponent:fileName];
        if (_didSelectedFileAtPathBlock) {
            _didSelectedFileAtPathBlock(filePath, self.isFlashOTA);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
