//
//  NSNumber+Category.m
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "NSNumber+Category.h"

@implementation NSNumber (Category)
// 英镑转千克
- (NSNumber*)pandToKiloGram
{
    return @((int)(roundf(self.floatValue*0.4535924)));
}
// 千克转英镑
- (NSNumber*)kiolgramToPand
{
    return @((int)(roundf(self.floatValue*2.2046226)));
}

// 英寸转厘米
- (NSNumber*)inchToCM
{
    return @((int)(roundf(self.floatValue*2.54)));
}

// 厘米转英寸
- (NSNumber*)cmToInch
{
    return @((int)(roundf(self.floatValue*0.3937008)));
}

// 千米转英里
- (NSNumber*)kmToMi
{
    return @(self.floatValue*0.6213712);
}

// 英里转KM
- (NSNumber*)miToKM
{
    return @(self.floatValue*1.609344);
}

@end
