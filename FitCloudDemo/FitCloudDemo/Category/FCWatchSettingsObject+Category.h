//
//  FCWatchSettingsObject+Category.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import "FitCloudKit.h"

@interface FCWatchSettingsObject (Category) <NSCoding>
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
