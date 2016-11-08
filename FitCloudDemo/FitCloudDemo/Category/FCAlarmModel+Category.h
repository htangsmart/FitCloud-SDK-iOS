//
//  FCAlarmModel+Category.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#import <FitCloudKit.h>

@interface FCAlarmCycleModel (Category)
- (NSString*)cycleDescription;
@end

@interface FCAlarmModel (Category)
@property (nonatomic, strong) FCAlarmCycleModel *cycleModel;
@end
