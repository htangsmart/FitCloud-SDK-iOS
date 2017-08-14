//
//  OTAEncrypt.m
//  OTAEncrypt
//
//  Created by Tang on 15/8/30.
//
//  OTAClient.m
//  BleHub
//
//  Created by Tang on 15/3/25.
//  Copyright (c) 2015年 Tang. All rights reserved.
//


#import "FCOTAService.h"
#import "DFUDef.h"

#import "FCGlobalDef.h"



#define ATT_MTU 20
#define ATT_MTU_EXTERN 256
#define AES_ENCRYPT


@interface FCOTAService () <CBPeripheralDelegate>

@property (nonatomic, strong) CBCharacteristic  *dfuDataChar;
@property (nonatomic, strong) CBCharacteristic  *dfuControlPointChar;

@property (nonatomic, strong) NSData            *reader;
@property (nonatomic, strong) NSString          *filePath;


@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, strong) NSData     *txData;

@property (nonatomic) IMAGE_HEADER              imageHeader;
@property (nonatomic) DFU_DATA_INFO             dfuDataInfo;
@property (nonatomic) aes_context               ctx;


@property (nonatomic) int mTxFileSize;
@property (nonatomic) UInt8 otaMode;
@property (nonatomic) UInt16 originalFWVersion;
@property (nonatomic) UInt16 newFWVersion;
@property (nonatomic) UInt64 fileSize;
@property (nonatomic) BOOL bOtaing;
@property(weak, nonatomic, nullable) id<CBPeripheralDelegate> deviceOldDelegate;

@end

@implementation FCOTAService

#pragma OTA

+ (id)shareInstance
{
    static FCOTAService *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _filePath = @"";
        _bOtaing = NO;
        _otaMode = 0;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}


- (BOOL)oTAIsTransfering
{
    return _bOtaing;
}


- (void)setServiceDfu:(CBService *)serviceDfu
{
    _serviceDfu = serviceDfu;
    for (CBCharacteristic *c in _serviceDfu.characteristics)
    {
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:AN_DEVICE_DFU_DATA]])
        {
            _dfuDataChar = c;
        }
        else if ([c.UUID isEqual:[CBUUID UUIDWithString:AN_DEVICE_FIRMWARE_UPDATE_CHAR]])
        {
            _dfuControlPointChar = c;
        }
    }
}

 - (void)setDevicePeripheral:(CBPeripheral *)devicePeripheral
{
    _otaMode = 0;
    _devicePeripheral = devicePeripheral;
    _deviceOldDelegate = _devicePeripheral.delegate;
    _devicePeripheral.delegate = self;

#define SERVICE_DFU                     @"00006287-3C17-D293-8E48-14FE2E4DA212"
#define SERVICE_WRISTBAND               @"000001ff-3C17-D293-8E48-14FE2E4DA212"
    
    if (_devicePeripheral.services) {
        
        for (CBService *service in _devicePeripheral.services)
        {
            if([service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_DFU]] || [service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_WRISTBAND]])
            {
                _otaMode++;
            }
            
        }
    }
}

//-(id) initWithPeripheral:(CBPeripheral *) peripheral andService:(CBService *)service andDeleget:(id<OTADelegate>) delegate
//{
//    self = [super init];
//    
//    if (_bOtaing) {
//        self.oTADelegate = delegate;
//        
//       // return [OTAClient shareInstance];
//    }
//    
//    if (self) {
//        if (_bOtaing) {
//            self.oTADelegate = delegate;
//            return self;
//        }
//        _serviceDfu = service;
//        _devicePeripheral = peripheral;
//        _filePath = @"";
//        _oTADelegate = delegate;
//        _bOtaing = NO;
//        _otaMode = 0;
//        #define SERVICE_DFU                     @"00006287-3C17-D293-8E48-14FE2E4DA212"
//        #define SERVICE_WRISTBAND               @"000001ff-3C17-D293-8E48-14FE2E4DA212"
//        if (peripheral.services) {
//            
//            for (CBService *service in peripheral.services)
//            {
//                if([service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_DFU]] || [service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_WRISTBAND]])
//                {
//                    _otaMode++;
//                }
//                
//            }
//        }
//
//        
//        _deviceOldDelegate = _devicePeripheral.delegate;
//
//        _devicePeripheral.delegate = self;
//        
//        for (CBCharacteristic *c in _serviceDfu.characteristics) {
//            
//            if ([c.UUID isEqual:[CBUUID UUIDWithString:AN_DEVICE_DFU_DATA]])
//            {
//                _dfuDataChar = c;
//            }
//            else if ([c.UUID isEqual:[CBUUID UUIDWithString:AN_DEVICE_FIRMWARE_UPDATE_CHAR]])
//            {
//                _dfuControlPointChar = c;
//            }
//        }
//
//    }
//    
//    return self;
//}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
//    NSLog(@"rx <----(%@) %u: %@", characteristic.UUID.UUIDString, characteristic.value.length, characteristic.value);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRISTBAND_CHAR_NOTIFY]])
    {
       //  NSLog(@"otaing  rx wristband <---- %@", characteristic.value);
//        [[WristBandEvent getShareInstance]wbProcessNotifyData:(Byte *)[characteristic.value bytes]  andLength:characteristic.value.length];
        //  [self wbProcessNotifyData:(Byte *)[characteristic.value bytes]  andLength:characteristic.value.length];
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:AN_DEVICE_FIRMWARE_UPDATE_CHAR]])
    {
    //    NSLog(@"ota rx <---- %@", characteristic.value);

        [self oTAProcessControlPointResponse:(Byte *)characteristic.value.bytes];
    }
    else
    {
        NSLog(@"ota error: %@", characteristic.UUID);
    }
}


- (void) oTASetNotifyOfControlPoint:(BOOL) bNotify
{
    if (_dfuControlPointChar)
    {
        [self.devicePeripheral setNotifyValue:bNotify forCharacteristic:_dfuControlPointChar];
    }
    else
    {
        NSLog(@"no char:6487");
    }
    
}



- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}



-(void) oTALoadFWImageFromFile:(NSString *)fileName
{
    _reader = [NSData dataWithContentsOfFile:fileName];
    //获取字节的个数
    [_reader getBytes:&_imageHeader length:sizeof(IMAGE_HEADER)];
    
    NSLog(@"Image Info: \n\toffset(0x%x), \n\tsignature(0x%x), \n\tversion(0x%x), \n\tchecksum(0x%x), \n\tlength(0x%x), \n\tota_flag(0x%x), \n\treserved_8(0x%x)\n",
          _imageHeader.offset, _imageHeader.signature, _imageHeader.version, _imageHeader.checksum, _imageHeader.length, _imageHeader.ota_flag, _imageHeader.reserved_8);
    
   // [_oTADelegate onGetFileVersion:_imageHeader.version andSize:_imageHeader.length*4];
    if (_imageHeader.length*4 > 0)
    {
      //  [self oTAStartDFU];
        NSLog(@"OTA step2: oTAGetTargetImageInfo");
        [self oTAGetTargetImageInfo];
    }
    else
    {
        NSLog(@"file size = 0 ,return");
        return;
    }
    
    _newFWVersion = _imageHeader.version;
    _fileSize = _imageHeader.length*4;
    return;
}



- (void) oTAGetTargetImageInfo
{
    REPORT_RECEIVED_IMAGE_INFO targetImageInfo;
    targetImageInfo.Opcode = OPCODE_DFU_REPORT_RECEIVED_IMAGE_INFO;
    targetImageInfo.nSignature = _imageHeader.signature;
    NSData *data = [[NSData alloc]initWithBytes:&targetImageInfo length:sizeof(REPORT_RECEIVED_IMAGE_INFO)];
    
    [self.devicePeripheral writeValue:data forCharacteristic:_dfuControlPointChar type:CBCharacteristicWriteWithResponse];
}

- (void) oTAStartDFU
{
    if(_dfuDataInfo.CurInfo.ImageUpdateOffset == 0)
    {// offset is zero, need to send 0x01
        DFU_START_DFU startDfu;
        startDfu.Opcode = OPCODE_DFU_START_DFU;
        startDfu.checksum = _imageHeader.checksum;
        startDfu.length = _imageHeader.length;
        startDfu.offset = _imageHeader.offset;
        startDfu.ota_flag = _imageHeader.ota_flag;
        startDfu.signature = _imageHeader.signature;
        startDfu.version =  _imageHeader.version;
        startDfu.reserved_8 = _imageHeader.reserved_8;
        
#ifdef AES_ENCRYPT
        startDfu.ReservedForAes = 0;
        UINT8 *pAesData = (UINT8 *)&startDfu + 1;
        [self aes_encrypt:&_ctx andInput:pAesData andOutput:pAesData];
        
#endif
        
        
        NSData *data = [[NSData alloc]initWithBytes:&startDfu length:sizeof(DFU_START_DFU)];
        [self.devicePeripheral writeValue:data forCharacteristic:_dfuControlPointChar type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        [self oTAPushImageToTarget];
    }
    
}



-(void)oTAPushImageToTarget
{
    RECEIVE_FW_IMAGE ReceiveImg;
    ReceiveImg.Opcode = OPCODE_DFU_RECEIVE_FW_IMAGE;
    ReceiveImg.nSignature = _imageHeader.signature;
    
    if(_dfuDataInfo.CurInfo.ImageUpdateOffset != 0)
    {
        ReceiveImg.nImageUpdateOffset = _dfuDataInfo.CurInfo.ImageUpdateOffset;
    }
    else
    {
        ReceiveImg.nImageUpdateOffset = 12;
    }
    
    if (_otaMode == 2)
    {
        ReceiveImg.nImageUpdateOffset = 0;
    }
    
    NSData *data = [[NSData alloc]initWithBytes:&ReceiveImg length:sizeof(RECEIVE_FW_IMAGE)];
    [self.devicePeripheral writeValue:data forCharacteristic:_dfuControlPointChar type:CBCharacteristicWriteWithResponse];
    
    
    [NSThread sleepForTimeInterval:0.020f];
    // check with remote image info
    UInt8 DataBuf[1024*256] = {0};
    
    [_reader getBytes:DataBuf range:NSMakeRange(sizeof(IMAGE_HEADER), [_reader length]-sizeof(IMAGE_HEADER))];
   
    UINT8 *buf = DataBuf;	// Image Buffer
    int DataLen = _imageHeader.length*4;	// Image Length
    
    if (_otaMode == 2)
    {
        [_reader getBytes:DataBuf range:NSMakeRange(0, [_reader length])];
        DataLen = (int)[_reader length];
    }
    
    int offset = _dfuDataInfo.CurInfo.ImageUpdateOffset == 0 ? 0 : _dfuDataInfo.CurInfo.ImageUpdateOffset-sizeof(IMAGE_HEADER);
    
    
    
    if(_dfuDataInfo.CurInfo.ImageUpdateOffset != 0)
    {
        buf = DataBuf + (_dfuDataInfo.CurInfo.ImageUpdateOffset - 12);
        DataLen = _imageHeader.length*4 - (_dfuDataInfo.CurInfo.ImageUpdateOffset - 12);
    }
    
    if (_otaMode == 1) //internal flash OTA, if file size > 100k, need jump 40k invalid content.
    {
        if (DataLen >= 7168*20-12 && offset <= 5200*20)
        {
            for(int i=5200*20; i<1024*256; i++)
            {
                buf[i] = buf[i+20*1968-12];
            }
            DataLen -= (1968*20-12);
            
            //buf.removeRange(Range(start: 5200*20, end: 5200*20+20*1968-12))
        }
    }
    
    
    buf += offset;
    DataLen -= offset;
   // buf.removeRange(Range(start: 0, end: offset))
    
  //  NSData *data2 = [[NSData alloc]initWithBytes:buf length:DataLen];
    _txData  = [[NSData alloc]initWithBytes:buf length:DataLen];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        if ([_mTimer isValid]) {
//            [_mTimer invalidate];
//            _mTimer = nil;
//        }
//        if (_otaMode == 1) {
//            _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.015
//                                                       target:self
//                                                     selector:@selector(sendData)
//                                                     userInfo:nil
//                                                      repeats:YES];
//        }
//        else if (_otaMode == 2) {
//            _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.015
//                                                       target:self
//                                                     selector:@selector(sendData)
//                                                     userInfo:nil
//                                                      repeats:YES];
//        }
//        else
//        {
//            NSLog(@"error mode = %d", _otaMode);
//        }
//    });
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(txThread) object:nil];
    [thread start];
}

- (void)txThread
{
    if ([_mTimer isValid])
    {
        [_mTimer invalidate];
        _mTimer = nil;
    }
    if (_otaMode == 1)
    {
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.015
                                                   target:self
                                                 selector:@selector(sendData)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    else if (_otaMode == 2)
    {
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.015
                                                   target:self
                                                 selector:@selector(sendData)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    else
    {
        NSLog(@"error mode = %d", _otaMode);
    }
    _bOtaing = true;
    while (_bOtaing)
    {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    }
}

-(void)sendData
{
    NSUInteger DataLen = _txData.length;
    NSUInteger sendUnit = ATT_MTU;
    
    if (_otaMode == 1)
    {
        if (_mTxFileSize+ATT_MTU > DataLen)
        {
            sendUnit = DataLen - _mTxFileSize;
        }
        else
        {
            sendUnit = ATT_MTU;
        }
    }
    else if(_otaMode == 2)
    {
        if (_mTxFileSize+ATT_MTU > DataLen)
        {
            if (_mTxFileSize%256==240)
            {
                if (DataLen-_mTxFileSize>16)
                {
                    sendUnit = 16;
                }
                else
                {
                    sendUnit =  DataLen - _mTxFileSize;
                }
            }
            else
            {
                sendUnit = DataLen - _mTxFileSize;
            }
            
        }
        else
        {
            if (_mTxFileSize%256==240)
            {
                sendUnit = 16;
            }
            else
            {
                sendUnit = ATT_MTU;
            }
        }
    }
    
    UINT8 buf[sendUnit];
    [_txData getBytes:buf range:NSMakeRange(_mTxFileSize, sendUnit)];
    
#ifdef AES_ENCRYPT

    if (sendUnit >= 16)
    {
        [self aes_encrypt:&_ctx andInput:buf  andOutput:buf];
    }
    
#endif

    NSData *data2 = [[NSData alloc]initWithBytes:buf length:sendUnit];
    [self.devicePeripheral writeValue:data2 forCharacteristic:_dfuDataChar type:CBCharacteristicWriteWithoutResponse];
    

    _mTxFileSize += sendUnit;
  //  NSLog(@"已发送 :%d bytes", _mTxFileSize);
    
    if ([_oTADelegate respondsToSelector:@selector(onSendAUnit:andFileSize:)]) {
        [_oTADelegate onSendAUnit:_mTxFileSize andFileSize:DataLen];
    }
    
    
    if (_mTxFileSize >= DataLen)
    {
        if ([_mTimer isValid])
        {
            [_mTimer invalidate];
            _mTimer = nil;
        }
       // _bOtaing = false;
        _mTxFileSize = 0;
        NSLog(@"OTA step5: oTAValidFW");
        [self oTAValidFW];
    }
    
    if (self.devicePeripheral.state != CBPeripheralStateConnected)
    {
        if ([_mTimer isValid])
        {
            [_mTimer invalidate];
            _mTimer = nil;
        }
        _bOtaing = false;
        _mTxFileSize = 0;
        _devicePeripheral.delegate = _deviceOldDelegate;
        if ([_oTADelegate respondsToSelector:@selector(onOTAFinishedWithStatus:)])
        {
            [_oTADelegate onOTAFinishedWithStatus:ERROR_STATE_OPRERATION_FAILED];
        }
    }
  
}

- (void)sendData2
{
    // NSData *data = _mTimer.userInfo;
    NSUInteger DataLen = _txData.length;
    NSUInteger sendUnit = ATT_MTU_EXTERN;
    
    _bOtaing = true;
    
    
    if (_mTxFileSize+ATT_MTU_EXTERN > DataLen)
    {
        sendUnit = DataLen - _mTxFileSize;
    }
    else
    {
        sendUnit = ATT_MTU_EXTERN;
    }
    
    
    UINT8 buf[sendUnit];
    [_txData getBytes:buf range:NSMakeRange(_mTxFileSize, sendUnit)];
    
#ifdef AES_ENCRYPT
    int i=0;
    for (; i<sendUnit/20; i++)
    {
        [self aes_encrypt:&_ctx andInput:buf+i*20  andOutput:buf+i*20];
    }
    if (sendUnit - i*20 >= 16)
    {
        [self aes_encrypt:&_ctx andInput:buf+i*20  andOutput:buf+i*20];
    }
#endif
    
    NSData *data2 = [[NSData alloc]initWithBytes:buf length:sendUnit];
    [self.devicePeripheral writeValue:data2 forCharacteristic:_dfuDataChar type:CBCharacteristicWriteWithoutResponse];
    
    
    _mTxFileSize += sendUnit;
    //  NSLog(@"已发送 :%d bytes", _mTxFileSize);
    
    
    [_oTADelegate onSendAUnit:_mTxFileSize andFileSize:DataLen];
    
    if (_mTxFileSize >= DataLen)
    {
        if ([_mTimer isValid])
        {
            [_mTimer invalidate];
            _mTimer = nil;
        }
        // _bOtaing = false;
        _mTxFileSize = 0;
        NSLog(@"OTA step6: oTAValidFW");
        [self oTAValidFW];
    }
    
    if (self.devicePeripheral.state != CBPeripheralStateConnected)
    {
        if ([_mTimer isValid]) {
            [_mTimer invalidate];
            _mTimer = nil;
        }
        _bOtaing = false;
        _mTxFileSize = 0;
        _devicePeripheral.delegate = _deviceOldDelegate;
        if ([_oTADelegate respondsToSelector:@selector(onOTAFinishedWithStatus:)]) {
            [_oTADelegate onOTAFinishedWithStatus:ERROR_STATE_OPRERATION_FAILED];
        }
    }
    
}

-(void) oTAValidFW

{
    VALIDATE_FW_IMAGE validImage;
    validImage.Opcode = OPCODE_DFU_VALIDATE_FW_IMAGE;
    validImage.nSignature = _imageHeader.signature;
    
    NSData *data = [[NSData alloc]initWithBytes:&validImage length:sizeof(VALIDATE_FW_IMAGE)];
    [self.devicePeripheral writeValue:data forCharacteristic:_dfuControlPointChar type:CBCharacteristicWriteWithResponse];
    
}

-(void) oTAActiveAndReset
{
    
    ACTIVE_IMAGE_RESET activeReset;
    activeReset.Opcode = OPCODE_DFU_ACTIVE_IMAGE_RESET;
    
    NSData *data = [[NSData alloc]initWithBytes:&activeReset length:sizeof(ACTIVE_IMAGE_RESET)];
    
    [self.devicePeripheral writeValue:data forCharacteristic:_dfuControlPointChar type:CBCharacteristicWriteWithResponse];
    
}

-(void) oTAImmediatelyReset
{
    
    RESET_SYSTEM activeReset;
    activeReset.Opcode = OPCODE_DFU_RESET_SYSTEM;
    
    NSData *data = [[NSData alloc]initWithBytes:&activeReset length:sizeof(RESET_SYSTEM)];
    
    [self.devicePeripheral writeValue:data forCharacteristic:_dfuControlPointChar type:CBCharacteristicWriteWithResponse];
    
}



-(void) oTAProcessControlPointResponse:(Byte *)respData
{
    DEF_RESPONSE_HEADER *deh = (DEF_RESPONSE_HEADER *)respData;
    if(OPCODE_DFU_RESPONSE_CODE == deh->Opcode)
    {
        if (OPCODE_DFU_REPORT_RECEIVED_IMAGE_INFO == deh->ReqOpcode)
        {
            REPORT_RECEIVED_IMAGE_INFO_RESPONSE *p = (REPORT_RECEIVED_IMAGE_INFO_RESPONSE *)(respData);
            if (p->RspValue == ERROR_STATE_SUCCESS) {
                
                _dfuDataInfo.CurInfo.OriginalVersion = p->OriginalFWVersion;
                _dfuDataInfo.CurInfo.ImageUpdateOffset = p->nImageUpdateOffset;
             //   [_oTADelegate onReadFwVersion:p->OriginalFWVersion];
                _originalFWVersion = p->OriginalFWVersion;
                
                NSLog(@"OTA step3: oTAStartDFU");
               
                [self oTAStartDFU];
            }
        }
        else if(OPCODE_DFU_START_DFU == deh->ReqOpcode)
        {
            if (!_bOtaing) {
                //todo
                DFU_START_DFU_RESPONSE *p = (DFU_START_DFU_RESPONSE *)(respData);
                if (p->RspValue == ERROR_STATE_SUCCESS) {
                    NSLog(@"OTA step4: oTAPushImageToTarget");
                    [self oTAPushImageToTarget];

                }
            }
            else
            {
                NSLog(@"error, rx 2 OPCODE_DFU_START_DFU");
            }
            
            
        }
        else if (OPCODE_DFU_VALIDATE_FW_IMAGE == deh->ReqOpcode)
        {
            _devicePeripheral.delegate = _deviceOldDelegate;
            VALIDATE_FW_IMAGE_RESPONSE *p = (VALIDATE_FW_IMAGE_RESPONSE *)(respData);
            if (p->RspValue == ERROR_STATE_SUCCESS) {
                //step 6:
                NSLog(@"OTA step6: oTAActiveAndReset");
                [self oTAActiveAndReset];
                [_oTADelegate onOTAFinishedWithStatus:ERROR_STATE_SUCCESS];
                
            }
            else
            {
                NSLog(@"OTA oTAValidFW fail code:%d", p->RspValue);
                [_oTADelegate onOTAFinishedWithStatus:p->RspValue];
            }
            if ([_mTimer isValid]) {
                [_mTimer invalidate];
                _mTimer = nil;
            }
            _bOtaing = false;
            _mTxFileSize = 0;
        }
    }
}

-(BOOL) oTAInit
{
    if (_bOtaing) {
        NSLog(@"Error: OTAing, return");
        return FALSE;
    }
    NSLog(@"OTA step1: Enable Notify");
    _bOtaing = NO;
    [self oTASetNotifyOfControlPoint:YES];
    
#ifdef AES_ENCRYPT
    [self aesInit:3];
#endif
    return true;
}

- (void)oTAClearStatus
{
    _filePath = @"";
    _bOtaing = false;
    _otaMode = 0;
}

-(void)aesInit:(int)mode
{
    UINT8 key[32] = {0};
    int n = mode -1;
    memcpy( key, secret_key, 16 + n * 8);
    [self aes_set_key:&_ctx andKey:key andBits:128+n*64];// aes_set_key( &ctx, key, 128 + n * 64);
}

/* AES key scheduling routine */
//int aes_set_key( aes_context *ctx, uint8_t *key, int nbits )
-(int) aes_set_key:(aes_context *)ctx andKey:(uint8_t *)key andBits:(int)nbits
{
    int i;
    uint32_t *RK, *SK;
    
    uint32_t KT0[256];
    uint32_t KT1[256];
    uint32_t KT2[256];
    uint32_t KT3[256];
    
    switch( nbits )
    {
        case 128: ctx->nr = 10; break;
        case 192: ctx->nr = 12; break;
        case 256: ctx->nr = 14; break;
        default : return( 1 );
    }
    
    RK = ctx->erk;
    
    for( i = 0; i < (nbits >> 5); i++ )
    {
        GET_UINT32( RK[i], key, i * 4 );
    }
    
    /* setup encryption round keys */
    
    switch( nbits )
    {
        case 128:
            
            for( i = 0; i < 10; i++, RK += 4 )
            {
                RK[4]  = RK[0] ^ RCON[i] ^
                ( FSb[ (uint8_t) ( RK[3] >> 16 ) ] << 24 ) ^
                ( FSb[ (uint8_t) ( RK[3] >>  8 ) ] << 16 ) ^
                ( FSb[ (uint8_t) ( RK[3]       ) ] <<  8 ) ^
                ( FSb[ (uint8_t) ( RK[3] >> 24 ) ]       );
                
                RK[5]  = RK[1] ^ RK[4];
                RK[6]  = RK[2] ^ RK[5];
                RK[7]  = RK[3] ^ RK[6];
            }
            break;
            
        case 192:
            
            for( i = 0; i < 8; i++, RK += 6 )
            {
                RK[6]  = RK[0] ^ RCON[i] ^
                ( FSb[ (uint8_t) ( RK[5] >> 16 ) ] << 24 ) ^
                ( FSb[ (uint8_t) ( RK[5] >>  8 ) ] << 16 ) ^
                ( FSb[ (uint8_t) ( RK[5]       ) ] <<  8 ) ^
                ( FSb[ (uint8_t) ( RK[5] >> 24 ) ]       );
                
                RK[7]  = RK[1] ^ RK[6];
                RK[8]  = RK[2] ^ RK[7];
                RK[9]  = RK[3] ^ RK[8];
                RK[10] = RK[4] ^ RK[9];
                RK[11] = RK[5] ^ RK[10];
            }
            break;
            
        case 256:
            
            for( i = 0; i < 7; i++, RK += 8 )
            {
                RK[8]  = RK[0] ^ RCON[i] ^
                ( FSb[ (uint8_t) ( RK[7] >> 16 ) ] << 24 ) ^
                ( FSb[ (uint8_t) ( RK[7] >>  8 ) ] << 16 ) ^
                ( FSb[ (uint8_t) ( RK[7]       ) ] <<  8 ) ^
                ( FSb[ (uint8_t) ( RK[7] >> 24 ) ]       );
                
                RK[9]  = RK[1] ^ RK[8];
                RK[10] = RK[2] ^ RK[9];
                RK[11] = RK[3] ^ RK[10];
                
                RK[12] = RK[4] ^
                ( FSb[ (uint8_t) ( RK[11] >> 24 ) ] << 24 ) ^
                ( FSb[ (uint8_t) ( RK[11] >> 16 ) ] << 16 ) ^
                ( FSb[ (uint8_t) ( RK[11] >>  8 ) ] <<  8 ) ^
                ( FSb[ (uint8_t) ( RK[11]       ) ]       );
                
                RK[13] = RK[5] ^ RK[12];
                RK[14] = RK[6] ^ RK[13];
                RK[15] = RK[7] ^ RK[14];
            }
            break;
    }
    
    /* setup decryption round keys */
    
    
    for( i = 0; i < 256; i++ )
    {
        KT0[i] = RT0[ FSb[i] ];
        KT1[i] = RT1[ FSb[i] ];
        KT2[i] = RT2[ FSb[i] ];
        KT3[i] = RT3[ FSb[i] ];
    }
    
    
    
    SK = ctx->drk;
    
    *SK++ = *RK++;
    *SK++ = *RK++;
    *SK++ = *RK++;
    *SK++ = *RK++;
    
    for( i = 1; i < ctx->nr; i++ )
    {
        RK -= 8;
        
        *SK++ = KT0[ (uint8_t) ( *RK >> 24 ) ] ^
        KT1[ (uint8_t) ( *RK >> 16 ) ] ^
        KT2[ (uint8_t) ( *RK >>  8 ) ] ^
        KT3[ (uint8_t) ( *RK       ) ]; RK++;
        
        *SK++ = KT0[ (uint8_t) ( *RK >> 24 ) ] ^
        KT1[ (uint8_t) ( *RK >> 16 ) ] ^
        KT2[ (uint8_t) ( *RK >>  8 ) ] ^
        KT3[ (uint8_t) ( *RK       ) ]; RK++;
        
        *SK++ = KT0[ (uint8_t) ( *RK >> 24 ) ] ^
        KT1[ (uint8_t) ( *RK >> 16 ) ] ^
        KT2[ (uint8_t) ( *RK >>  8 ) ] ^
        KT3[ (uint8_t) ( *RK       ) ]; RK++;
        
        *SK++ = KT0[ (uint8_t) ( *RK >> 24 ) ] ^
        KT1[ (uint8_t) ( *RK >> 16 ) ] ^
        KT2[ (uint8_t) ( *RK >>  8 ) ] ^
        KT3[ (uint8_t) ( *RK       ) ]; RK++;
    }
    
    RK -= 8;
    
    *SK++ = *RK++;
    *SK++ = *RK++;
    *SK++ = *RK++;
    *SK++ = *RK++;
    
    return( 0 );
}

/* AES 128-bit block encryption routine */
//void aes_encrypt( aes_context *ctx, uint8_t input[16], uint8_t output[16] )
-(void) aes_encrypt:(aes_context *)ctx andInput:(uint8_t *)input andOutput:(uint8_t *)output
{
    uint32_t *RK, X0, X1, X2, X3, Y0, Y1, Y2, Y3;
    
    RK = ctx->erk;
    
    GET_UINT32( X0, input,  0 ); X0 ^= RK[0];
    GET_UINT32( X1, input,  4 ); X1 ^= RK[1];
    GET_UINT32( X2, input,  8 ); X2 ^= RK[2];
    GET_UINT32( X3, input, 12 ); X3 ^= RK[3];
    
#define AES_FROUND(X0,X1,X2,X3,Y0,Y1,Y2,Y3)     \
{                                               \
RK += 4;                                    \
\
X0 = RK[0] ^ FT0[ (uint8_t) ( Y0 >> 24 ) ] ^  \
FT1[ (uint8_t) ( Y1 >> 16 ) ] ^  \
FT2[ (uint8_t) ( Y2 >>  8 ) ] ^  \
FT3[ (uint8_t) ( Y3       ) ];   \
\
X1 = RK[1] ^ FT0[ (uint8_t) ( Y1 >> 24 ) ] ^  \
FT1[ (uint8_t) ( Y2 >> 16 ) ] ^  \
FT2[ (uint8_t) ( Y3 >>  8 ) ] ^  \
FT3[ (uint8_t) ( Y0       ) ];   \
\
X2 = RK[2] ^ FT0[ (uint8_t) ( Y2 >> 24 ) ] ^  \
FT1[ (uint8_t) ( Y3 >> 16 ) ] ^  \
FT2[ (uint8_t) ( Y0 >>  8 ) ] ^  \
FT3[ (uint8_t) ( Y1       ) ];   \
\
X3 = RK[3] ^ FT0[ (uint8_t) ( Y3 >> 24 ) ] ^  \
FT1[ (uint8_t) ( Y0 >> 16 ) ] ^  \
FT2[ (uint8_t) ( Y1 >>  8 ) ] ^  \
FT3[ (uint8_t) ( Y2       ) ];   \
}
    
    AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 1 */
    AES_FROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 2 */
    AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 3 */
    AES_FROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 4 */
    AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 5 */
    AES_FROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 6 */
    AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 7 */
    AES_FROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 8 */
    AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 9 */
    
    if( ctx->nr > 10 )
    {
        AES_FROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );   /* round 10 */
        AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );   /* round 11 */
    }
    
    if( ctx->nr > 12 )
    {
        AES_FROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );   /* round 12 */
        AES_FROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );   /* round 13 */
    }
    
    /* last round */
    
    RK += 4;
    
    X0 = RK[0] ^ ( FSb[ (uint8_t) ( Y0 >> 24 ) ] << 24 ) ^
    ( FSb[ (uint8_t) ( Y1 >> 16 ) ] << 16 ) ^
    ( FSb[ (uint8_t) ( Y2 >>  8 ) ] <<  8 ) ^
    ( FSb[ (uint8_t) ( Y3       ) ]       );
    
    X1 = RK[1] ^ ( FSb[ (uint8_t) ( Y1 >> 24 ) ] << 24 ) ^
    ( FSb[ (uint8_t) ( Y2 >> 16 ) ] << 16 ) ^
    ( FSb[ (uint8_t) ( Y3 >>  8 ) ] <<  8 ) ^
    ( FSb[ (uint8_t) ( Y0       ) ]       );
    
    X2 = RK[2] ^ ( FSb[ (uint8_t) ( Y2 >> 24 ) ] << 24 ) ^
    ( FSb[ (uint8_t) ( Y3 >> 16 ) ] << 16 ) ^
    ( FSb[ (uint8_t) ( Y0 >>  8 ) ] <<  8 ) ^
    ( FSb[ (uint8_t) ( Y1       ) ]       );
    
    X3 = RK[3] ^ ( FSb[ (uint8_t) ( Y3 >> 24 ) ] << 24 ) ^
    ( FSb[ (uint8_t) ( Y0 >> 16 ) ] << 16 ) ^
    ( FSb[ (uint8_t) ( Y1 >>  8 ) ] <<  8 ) ^
    ( FSb[ (uint8_t) ( Y2       ) ]       );
    
    PUT_UINT32( X0, output,  0 );
    PUT_UINT32( X1, output,  4 );
    PUT_UINT32( X2, output,  8 );
    PUT_UINT32( X3, output, 12 );
}

/* AES 128-bit block decryption routine */
//void aes_decrypt( aes_context *ctx, uint8_t input[16], uint8_t output[16] )
-(void) aes_decrypt:(aes_context *)ctx andInput:(uint8_t *)input andOutput:(uint8_t *)output
{
    uint32_t *RK, X0, X1, X2, X3, Y0, Y1, Y2, Y3;
    
    RK = ctx->drk;
    
    GET_UINT32( X0, input,  0 ); X0 ^= RK[0];
    GET_UINT32( X1, input,  4 ); X1 ^= RK[1];
    GET_UINT32( X2, input,  8 ); X2 ^= RK[2];
    GET_UINT32( X3, input, 12 ); X3 ^= RK[3];
    
#define AES_RROUND(X0,X1,X2,X3,Y0,Y1,Y2,Y3)     \
{                                               \
RK += 4;                                    \
\
X0 = RK[0] ^ RT0[ (uint8_t) ( Y0 >> 24 ) ] ^  \
RT1[ (uint8_t) ( Y3 >> 16 ) ] ^  \
RT2[ (uint8_t) ( Y2 >>  8 ) ] ^  \
RT3[ (uint8_t) ( Y1       ) ];   \
\
X1 = RK[1] ^ RT0[ (uint8_t) ( Y1 >> 24 ) ] ^  \
RT1[ (uint8_t) ( Y0 >> 16 ) ] ^  \
RT2[ (uint8_t) ( Y3 >>  8 ) ] ^  \
RT3[ (uint8_t) ( Y2       ) ];   \
\
X2 = RK[2] ^ RT0[ (uint8_t) ( Y2 >> 24 ) ] ^  \
RT1[ (uint8_t) ( Y1 >> 16 ) ] ^  \
RT2[ (uint8_t) ( Y0 >>  8 ) ] ^  \
RT3[ (uint8_t) ( Y3       ) ];   \
\
X3 = RK[3] ^ RT0[ (uint8_t) ( Y3 >> 24 ) ] ^  \
RT1[ (uint8_t) ( Y2 >> 16 ) ] ^  \
RT2[ (uint8_t) ( Y1 >>  8 ) ] ^  \
RT3[ (uint8_t) ( Y0       ) ];   \
}
    
    AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 1 */
    AES_RROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 2 */
    AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 3 */
    AES_RROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 4 */
    AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 5 */
    AES_RROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 6 */
    AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 7 */
    AES_RROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );       /* round 8 */
    AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );       /* round 9 */
    
    if( ctx->nr > 10 )
    {
        AES_RROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );   /* round 10 */
        AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );   /* round 11 */
    }
    
    if( ctx->nr > 12 )
    {
        AES_RROUND( X0, X1, X2, X3, Y0, Y1, Y2, Y3 );   /* round 12 */
        AES_RROUND( Y0, Y1, Y2, Y3, X0, X1, X2, X3 );   /* round 13 */
    }
    
    /* last round */
    
    RK += 4;
    
    X0 = RK[0] ^ ( RSb[ (uint8_t) ( Y0 >> 24 ) ] << 24 ) ^
    ( RSb[ (uint8_t) ( Y3 >> 16 ) ] << 16 ) ^
    ( RSb[ (uint8_t) ( Y2 >>  8 ) ] <<  8 ) ^
    ( RSb[ (uint8_t) ( Y1       ) ]       );
    
    X1 = RK[1] ^ ( RSb[ (uint8_t) ( Y1 >> 24 ) ] << 24 ) ^
    ( RSb[ (uint8_t) ( Y0 >> 16 ) ] << 16 ) ^
    ( RSb[ (uint8_t) ( Y3 >>  8 ) ] <<  8 ) ^
    ( RSb[ (uint8_t) ( Y2       ) ]       );
    
    X2 = RK[2] ^ ( RSb[ (uint8_t) ( Y2 >> 24 ) ] << 24 ) ^
    ( RSb[ (uint8_t) ( Y1 >> 16 ) ] << 16 ) ^
    ( RSb[ (uint8_t) ( Y0 >>  8 ) ] <<  8 ) ^
    ( RSb[ (uint8_t) ( Y3       ) ]       );
    
    X3 = RK[3] ^ ( RSb[ (uint8_t) ( Y3 >> 24 ) ] << 24 ) ^
    ( RSb[ (uint8_t) ( Y2 >> 16 ) ] << 16 ) ^
    ( RSb[ (uint8_t) ( Y1 >>  8 ) ] <<  8 ) ^
    ( RSb[ (uint8_t) ( Y0       ) ]       );
    
    PUT_UINT32( X0, output,  0 );
    PUT_UINT32( X1, output,  4 );
    PUT_UINT32( X2, output,  8 );
    PUT_UINT32( X3, output, 12 );
}

@end


