//
//  DailyAlarmClockController.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import "DailyAlarmClockController.h"
#import "Macro.h"
#import <FitCloud.h>
#import "NSObject+HUD.h"
#import "FCObject.h"
#import "FCDataHandler.h"
#import "FCAlarmModel+Category.h"
#import "AlarmClockCell.h"


@interface DailyAlarmClockController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation DailyAlarmClockController

#pragma mark - dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮点击

- (IBAction)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToAddNewClock:(id)sender
{
    [self.listArray removeAllObjects];
    
    FCAlarmCycleModel *cycleModel = [[FCAlarmCycleModel alloc]init];
    cycleModel.monday = YES;
    FCAlarmModel *aModel = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(0);
    [self.listArray addObject:aModel];
    
    FCAlarmCycleModel *cycleModel2 = [[FCAlarmCycleModel alloc]init];
    cycleModel.tuesday = YES;
    FCAlarmModel *aModel2 = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel2.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(1);
    [self.listArray addObject:aModel2];
    
    FCAlarmCycleModel *cycleModel3 = [[FCAlarmCycleModel alloc]init];
    cycleModel.wednesday = YES;
    FCAlarmModel *aModel3 = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel3.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(2);
    [self.listArray addObject:aModel3];
    
    FCAlarmCycleModel *cycleModel4 = [[FCAlarmCycleModel alloc]init];
    cycleModel.thursday = YES;
    FCAlarmModel *aModel4 = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel4.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(3);
    [self.listArray addObject:aModel4];
    
    FCAlarmCycleModel *cycleModel5 = [[FCAlarmCycleModel alloc]init];
    cycleModel.firday = YES;
    FCAlarmModel *aModel5 = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel5.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(4);
    [self.listArray addObject:aModel5];
    
    FCAlarmCycleModel *cycleModel6 = [[FCAlarmCycleModel alloc]init];
    cycleModel.saturday = YES;
    FCAlarmModel *aModel6 = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel6.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(5);
    [self.listArray addObject:aModel6];
    
    FCAlarmCycleModel *cycleModel7 = [[FCAlarmCycleModel alloc]init];
    cycleModel.sunday = YES;
    FCAlarmModel *aModel7 = [[FCAlarmModel alloc]init];
    aModel.cycle = cycleModel7.cycleValue;
    aModel.isOn = YES;
    aModel.year = @(16);
    aModel.month = @(10);
    aModel.day = @(31);
    aModel.hour = @(20);
    aModel.minute = @(30);
    aModel.alarmId = @(6);
    [self.listArray addObject:aModel7];
    [self.tableView reloadData];
    
    NSData *alarmData = [FCDataHandler convertModelsToAlarmData:self.listArray];
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcSetAlarmData:alarmData retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        NSLog(@"--state--%@",@(state));
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
}
#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self syncAlarmClockData];
}

- (void)syncAlarmClockData
{
    WS(ws);
    [self showLoadingHUDWithMessage:@"正在同步"];
    [[FitCloud shared]fcGetAlarmList:^(FCSyncType syncType, NSData *data) {
        NSLog(@"--data--%@",data);
        NSArray *modelsArray = [FCDataHandler convertAlarmDataToModels:data];
        [modelsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj isKindOfClass:[FCAlarmModel class]]) {
                FCAlarmModel *aModel = (FCAlarmModel*)obj;
                FCAlarmCycleModel *cycleModel = [FCAlarmCycleModel modelWithCycle:aModel.cycle];
                aModel.cycleModel = cycleModel;
            }
        }];
        [ws.listArray addObjectsFromArray:modelsArray];
        [ws.tableView reloadData];
    } retHandler:^(FCSyncType syncType, FCSyncResponseState state) {
        NSLog(@"--state--%@",@(state));
        if (state == FCSyncResponseStateSuccess) {
            [ws hideLoadingHUDWithSuccess:@"同步成功"];
        }
        else
        {
            [ws hideLoadingHUDWithFailure:@"同步失败"];
        }
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    AlarmClockCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row < self.listArray.count) {
        FCAlarmModel *aModel = self.listArray[indexPath.row];
        cell.textLabel.text = aModel.workTime;
        cell.detailTextLabel.text = aModel.cycleModel.cycleDescription;
        cell.acSwitch.on = aModel.isOn;
    }
    return cell;
}


#pragma mark - Getter

- (NSMutableArray*)listArray
{
    if (_listArray) {
        return _listArray;
    }
    _listArray = [[NSMutableArray alloc]init];
    return _listArray;
}

@end
