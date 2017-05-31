//
//  FCSwitch.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FCSwitch.h"


@interface FCSwitch ()
@property (nonatomic, assign) BOOL previousValue;
@end

@implementation FCSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _previousValue = self.isOn;
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    _previousValue = self.isOn;
    self.exclusiveTouch = YES;
}


- (void)setOn:(BOOL)on animated:(BOOL)animated{
    
    [super setOn:on animated:animated];
    _previousValue = on;
}


-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if(_previousValue != self.isOn){
        for (id targetForEvent in [self allTargets]) {
            for (id actionForEvent in [self actionsForTarget:targetForEvent forControlEvent:UIControlEventValueChanged]) {
                [super sendAction:NSSelectorFromString(actionForEvent) to:targetForEvent forEvent:event];
            }
        }
        _previousValue = self.isOn;
    }
}

@end
