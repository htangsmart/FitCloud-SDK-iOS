//
//  HFRadioAlertView.m
//  HFit
//
//  Created by 远征 马 on 16/8/21.
//  Copyright © 2016年 BillYang. All rights reserved.
//

#import "HFRadioAlertView.h"
#import <FitCloudKit.h>
#import "FitCloud+Category.h"
#import <FitCloudKit.h>
#import "FCConfigManager.h"



typedef NS_ENUM(NSInteger, HFRadioType)
{
    HFRadioTypeNone,
    HFRadioTypeSingle,
    HFRadioTypeMultiple,
};

@interface HFRadioCell : UITableViewCell
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) UIImageView *checkImageView;

@end

@implementation HFRadioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    _checkImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_uncheck"]];
    self.accessoryView = _checkImageView;
}


- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (_checked) {
        _checkImageView.image = [UIImage imageNamed:@"ico_check"];
    }
    else
    {
        _checkImageView.image = [UIImage imageNamed:@"ico_uncheck"];
    }
}
@end



@interface HFRadioAlertView () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, assign) BOOL isMultipleChoice;

@property (nonatomic, assign) HFRadioType radioType;
@property (nonatomic, strong) NSArray *listArray;


//@property (nonatomic, strong) FCDisplayModel *displayModel;
//@property (nonatomic, strong) FCHardwareNumModel *hwModel;

@end

@implementation HFRadioAlertView

+ (instancetype)alertViewWithTitle:(NSString*)title andItems:(NSArray*)items
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"HFRadioAlertView" owner:self options:nil];
    HFRadioAlertView *view =  (HFRadioAlertView*)(xibArray[0]);
    view.frame = [UIScreen mainScreen].bounds;
    view.isMultipleChoice = NO;
    view.itemsArray = items;
    view.title = title;
    view.radioType = HFRadioTypeSingle;
    return view;
}


+ (instancetype)wristbandDisplayWithData:(NSData*)data
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"HFRadioAlertView" owner:self options:nil];
    HFRadioAlertView *view =  (HFRadioAlertView*)(xibArray[0]);
    view.frame = [UIScreen mainScreen].bounds;
    view.isMultipleChoice = YES;
    view.title = @"选择以下信息在手环上显示";
    view.radioType = HFRadioTypeMultiple;
//    view.displayModel = [FCDisplayModel modelWithData:data];
    view.heightConstraint.constant = 360;
    return view;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.displayView.layer.masksToBounds = YES;
    self.displayView.layer.cornerRadius = 8.0;
    [self.tableView registerClass:[HFRadioCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTitle:@"确定" forState:UIControlStateHighlighted];
    
//    self.hwModel = [HFDBEngine getHardwareAndSoftwareVersionInfo];
//    FCPageDisplayTagObject *object = [HFDBEngine pageDisplayObject];
//    self.listArray = [object displayItems];
//    [self.tableView reloadData];
}

- (void)show
{
    if (self.superview)
    {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window addSubview:self];
}

- (IBAction)clickToCancel:(id)sender
{
    [self removeFromSuperview];
}


- (IBAction)clickToDone:(id)sender
{
    if (self.radioType == HFRadioTypeMultiple) {
//        self.displayModel.displayId = YES;
//        NSData *displayData = [self.displayModel displayData];
        if (_didUpdateDisplayBlock) {
//            _didUpdateDisplayBlock(displayData);
        }
    }
    else
    {
        if (_didTouchBlock) {
            _didTouchBlock(self.checkItem);
        }
    }
    [self removeFromSuperview];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.radioType == HFRadioTypeSingle)
    {
        return self.itemsArray.count;
    }
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    HFRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.userInteractionEnabled = YES;
    if (self.radioType == HFRadioTypeMultiple)
    {
        if (indexPath.row < self.listArray.count)
        {
            NSString *displayString = self.listArray[indexPath.row];
            cell.textLabel.text = displayString;
            if ([displayString isEqualToString:@"时间和日期"])
            {
                cell.checked = YES;
                cell.userInteractionEnabled = NO;
            }
//            else if ([displayString isEqualToString:@"步数"])
//            {
////                cell.checked = self.displayModel.stepCount;
//            }
//            else if ([displayString isEqualToString:@"距离"])
//            {
//                cell.checked = self.displayModel.distance;
//            }
//            else if ([displayString isEqualToString:@"卡路里"])
//            {
//                cell.checked = self.displayModel.calorie;
//            }
//            else if ([displayString isEqualToString:@"睡眠"])
//            {
//                cell.checked = self.displayModel.sleep;
//            }
//            else if ([displayString isEqualToString:@"心率"])
//            {
//                cell.checked = self.displayModel.heartRate;
//            }
//            else if ([displayString isEqualToString:@"血氧"])
//            {
//                cell.checked = self.displayModel.bloodOxygen;
//            }
//            else if ([displayString isEqualToString:@"血压"])
//            {
//                cell.checked = self.displayModel.bloodPressure;
//            }
//            else if ([displayString isEqualToString:@"天气预报"])
//            {
//                cell.checked = self.displayModel.weatherForecast;
//            }
//            else if ([displayString isEqualToString:@"查找手机"])
//            {
//                cell.checked = self.displayModel.findPhone;
//            }
//            else if ([displayString isEqualToString:@"ID"])
//            {
//                cell.checked = YES;//self.displayModel.displayId;
//            }
        }
    }
    else
    {
        cell.checked = NO;
        if (indexPath.row < self.itemsArray.count)
        {
            NSString *item = self.itemsArray[indexPath.row];
            cell.textLabel.text = item;
            if (self.checkItem && [self.checkItem isEqualToString:item]) {
                cell.checked = YES;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.radioType == HFRadioTypeSingle)
    {
        if (indexPath.row < self.itemsArray.count) {
            NSString *item = self.itemsArray[indexPath.row];
            self.checkItem = item;
            [self.tableView reloadData];
        }
    }
    else
    {
        if (indexPath.row < self.listArray.count)
        {
//            NSString *displayString = self.listArray[indexPath.row];
//            if ([displayString isEqualToString:@"时间和日期"]) {
//                self.displayModel.dateTime = YES;
//            }
//            else if ([displayString isEqualToString:@"步数"])
//            {
//                self.displayModel.stepCount = !self.displayModel.stepCount;
//            }
//            else if ([displayString isEqualToString:@"距离"])
//            {
//                self.displayModel.distance = !self.displayModel.distance;
//            }
//            else if ([displayString isEqualToString:@"卡路里"])
//            {
//                self.displayModel.calorie = !self.displayModel.calorie;
//            }
//            else if ([displayString isEqualToString:@"睡眠"])
//            {
//                self.displayModel.sleep = !self.displayModel.sleep;
//            }
//            else if ([displayString isEqualToString:@"心率"])
//            {
//                self.displayModel.heartRate = !self.displayModel.heartRate;
//            }
//            else if ([displayString isEqualToString:@"血氧"])
//            {
//                self.displayModel.bloodOxygen = !self.displayModel.bloodOxygen;
//            }
//            else if ([displayString isEqualToString:@"血压"])
//            {
//                self.displayModel.bloodPressure = !self.displayModel.bloodPressure;
//            }
//            else if ([displayString isEqualToString:@"天气预报"])
//            {
//                self.displayModel.weatherForecast = !self.displayModel.weatherForecast;
//            }
//            else if ([displayString isEqualToString:@"查找手机"])
//            {
//                self.displayModel.findPhone = !self.displayModel.findPhone;
//            }
            
            //else if ([displayString isEqualToString:@"ID"])
            //{
              //  self.displayModel.displayId = !self.displayModel.displayId;
            //}
        }
        [self.tableView reloadData];
    }
}

@end
