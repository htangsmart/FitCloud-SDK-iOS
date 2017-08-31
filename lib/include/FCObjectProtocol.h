//
//  FCObjectProtocol.h
//  FitCloud
//
//  Created by 远征 马 on 2017/8/29.
//  Copyright © 2017年 马远征. All rights reserved.
//

#ifndef FCObjectProtocol_h
#define FCObjectProtocol_h

/**
 数据模型协议
 */
@protocol FCObjectProtocal <NSObject>

@optional
+ (instancetype)objectWithData:(NSData*)data;
+ (instancetype)objectWithValue:(NSNumber*)value;

/**
 经过协议编码的蓝牙数据
 
 @return <i>NSData</i>类型的二进制数据
 */
- (NSData*)writeData;
@end


#endif /* FCObjectProtocol_h */
