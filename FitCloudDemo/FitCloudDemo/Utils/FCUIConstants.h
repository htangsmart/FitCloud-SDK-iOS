//
//  FCUIConstants.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2017/5/30.
//  Copyright © 2017年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>


// 设备绑定结果通知
FOUNDATION_EXTERN NSString *const EVENT_DEVICE_BOUND_RESULT_NOTIFY;

FOUNDATION_EXTERN NSString *const EVENT_ALARM_REALTIME_SYNC_NOTIFY;

static inline void st_dispatch_async_main(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


@interface FCUIConstants : NSObject

@end
