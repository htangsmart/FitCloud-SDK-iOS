//
//  NSMutableDictionary+FCCategory.m
//  FitCloud
//
//  Created by myz on 2017/4/1.
//  Copyright © 2017年 myz. All rights reserved.
//

#import "NSMutableDictionary+FCCategory.h"

@implementation NSMutableDictionary (FCCategory)
- (void)fcSetValueIfNotNil:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
}
- (void)fcSetNotNilNumber:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:@[] forKey:key];
    }
}

- (void)fcSetNotNilDict:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:@{} forKey:key];
    }
}

- (void)fcSetNotNilString:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:@"" forKey:key];
    }
}

- (void)fcSetNotNilData:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:[NSData data] forKey:key];
    }
}
@end
