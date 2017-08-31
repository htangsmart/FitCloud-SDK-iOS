//
//  FCFlipWristToLightUpScreenObject.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCObjectProtocol.h"

@interface FCFlipWristToLightUpScreenObject : NSObject <FCObjectProtocal>
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) NSUInteger stMinute;
@property (nonatomic, assign) NSUInteger edMinute;
@end
