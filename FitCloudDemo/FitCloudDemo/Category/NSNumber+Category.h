//
//  NSNumber+Category.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/31.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Category)
// 英镑转千克
- (NSNumber*)pandToKiloGram;
// 千克转英镑
- (NSNumber*)kiolgramToPand;
// 英寸转厘米
- (NSNumber*)inchToCM;
// 厘米转英寸
- (NSNumber*)cmToInch;
// 千米转英里
- (NSNumber*)kmToMi;
// 英里转KM
- (NSNumber*)miToKM;
@end
