//
//  NSMutableDictionary+FCCategory.h
//  FitCloud
//
//  Created by myz on 2017/4/1.
//  Copyright © 2017年 myz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (FCCategory)
- (void)fcSetValueIfNotNil:(id)value forKey:(NSString *)key;
- (void)fcSetNotNilNumber:(id)value forKey:(NSString *)key;
- (void)fcSetNotNilDict:(id)value forKey:(NSString *)key;
- (void)fcSetNotNilString:(id)value forKey:(NSString *)key;
- (void)fcSetNotNilData:(id)value forKey:(NSString *)key;
@end
