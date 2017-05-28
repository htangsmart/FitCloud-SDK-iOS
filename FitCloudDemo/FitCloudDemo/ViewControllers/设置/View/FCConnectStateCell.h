//
//  FCConnectStateCell.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/28.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCConnectStateCell : UITableViewCell
// 蓝牙是否已经连接
@property (nonatomic, assign) BOOL connected;
// 手表是否已经绑定
@property (nonatomic, assign) BOOL hasBeenBound;
@end
