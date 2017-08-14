//
//  OTAEncrypt.h
//  OTAEncrypt
//
//  Created by Tang on 15/8/30.
//  Copyright (c) 2015年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <coreBluetooth/CoreBluetooth.h>


@protocol OTADelegate<NSObject>
-(void)onOTAFinishedWithStatus:(UInt8)status;
//-(void)onReadFwVersion:(UInt16)version;
//-(void)onGetFileVersion:(UInt16)version andSize:(UInt64) fileSize;
-(void)onSendAUnit:(UInt64)totalSendSize andFileSize:(UInt64)fileSize;
@end



@interface FCOTAService : NSObject

+ (id)shareInstance;

- (void)oTALoadFWImageFromFile:(NSString *)fileName;
- (void)oTAProcessControlPointResponse:(Byte *)respData;
- (BOOL)oTAInit;
- (BOOL)oTAIsTransfering;
- (void)oTAClearStatus;
- (void)oTAImmediatelyReset;

@property (nonatomic, strong) CBPeripheral      *devicePeripheral;
@property (nonatomic, strong) CBService         *serviceDfu;
@property (nonatomic, weak) id<OTADelegate>    oTADelegate;
@end
