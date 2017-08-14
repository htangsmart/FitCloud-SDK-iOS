//
//  FitCloud.m
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//

#import "FitCloud.h"
#import "FCProtocol.h"
#import <objc/message.h>
#import "FCOTAService.h"
#import "FCConstants.h"
#import "NSDate+FitCloud.h"
#import "FCObject.h"


#define WS(ws) __weak __typeof(self)ws = self;
#define SS(ss) __strong __typeof(ws)ss = ws;

#ifdef DEBUG
#   define DEBUG_STR(...) NSLog(__VA_ARGS__);
#   define DEBUG_METHOD(format, ...) NSLog(format, ##__VA_ARGS__);
#else
#   define DEBUG_STR(...)
#   define DEBUG_METHOD(format, ...)
#endif

/* CRC16 Table*/
UInt16 fc_crc16_table[256] =
{
    0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
    0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
    0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
    0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
    0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
    0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
    0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
    0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
    0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
    0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
    0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
    0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
    0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
    0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
    0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
    0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
    0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
    0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
    0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
    0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
    0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
    0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
    0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
    0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
    0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
    0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
    0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
    0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
    0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
    0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
    0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
    0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
};

// 分包发送
static const NSUInteger KPackageNum = 20;

// 服务特征值
static NSString *KServiceUUID = @"000001ff-3c17-d293-8e48-14fe2e4da212";
static NSString *KReadCharacteristicUUID =  @"0000ff03-0000-1000-8000-00805f9b34fb";
static NSString *KWriteCharacteristicUUID = @"0000ff02-0000-1000-8000-00805f9b34fb";
// 固件升级服务与特征
static NSString *KFWServiceUUID = @"00006287-3C17-D293-8E48-14FE2E4DA212";
static NSString *KFWReadCharacteristicUUID =  @"00006487-3C17-D293-8E48-14FE2E4DA212";
static NSString *KFWWriteCharacteristicUUID = @"00006387-3C17-D293-8E48-14FE2E4DA212";


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



@interface FitCloud () <CBCentralManagerDelegate, CBPeripheralDelegate, OTADelegate>

@property (nonatomic, strong) CBCharacteristic *wirteCharacteristic;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;

@property (nonatomic, strong) NSMutableArray *peripheralsArray;

@property (nonatomic, assign) UInt32 sensorFlag;

@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSMutableData *historyData;
@property (nonatomic, assign) UInt64 historyDataLength;
@property (nonatomic, assign) UInt16 nextRxDataBytes;

// 定时器
@property (nonatomic, strong) NSTimer *syncTimeoutTimer;
@property (nonatomic, strong) NSTimer *realtimeSyncTimeoutTimer;
@property (nonatomic, strong) NSTimer *scanningTimer;
@property (nonatomic, strong) NSTimer *firmwareUpgradeTimer;


@property (nonatomic, assign) UInt16 txSequenceId, rxSequenceID;
@property (nonatomic, assign) UInt16 alarmDataSeqId;
@property (nonatomic, assign) UInt16 displaySeqId;
@property (nonatomic, assign) UInt16 funcSwitchSeqId;
@property (nonatomic, assign) UInt16 notificationSeqId;
@property (nonatomic, assign) UInt16 longSitSeqId;
@property (nonatomic, assign) UInt16 healthMonitorSeqId;
@property (nonatomic, assign) UInt16 drinkRemindSeqId;
@property (nonatomic, assign) UInt16 wearingStyleSeqId;
@property (nonatomic, assign) UInt16 cameraStateSeqId;
@property (nonatomic, assign) UInt16 bloodPressureSeqId;
@property (nonatomic, assign) UInt16 weatherSeqId;
@property (nonatomic, assign) UInt16 userProfileSeqId;
@property (nonatomic, assign) UInt16 openRealtimeSyncSeqId, closeRealtimeSyncSeqId;
@property (nonatomic, assign) UInt16 findThePhoneReplySeqId;
@property (nonatomic, assign) UInt16 findTheWatchSeqId;
@property (nonatomic, assign) UInt16 updateWatchTimeSeqId;
@property (nonatomic, assign) UInt16 ancsLanguageSeqId;


@property (nonatomic, strong) NSString *scanUUIDString;

// 查找手机、拍照控制
@property (nonatomic,   copy) dispatch_block_t findTheMobileBlock;
@property (nonatomic,   copy) dispatch_block_t takePicturesBlock;


@property (nonatomic, strong) NSString *otaPeripheralName;
@property (nonatomic, assign) BOOL cycleScanPeripheral;

// ota升级
@property (nonatomic, strong) NSString *otaFilePath;
@property (nonatomic,   copy) FCOTAService *otaService;

@property (nonatomic, strong) FCPeripheralsHandler peripheralsHandler;
@property (nonatomic,   copy) FCProgressHandler progressHandler;
@property (nonatomic,   copy) FCSyncResultHandler syncResultHandler;
@property (nonatomic,   copy) FCSyncDataResultHandler syncDataResultHandler;
@property (nonatomic,   copy) FCSyncDataHandler  syncDataHandler;

@property (nonatomic, strong) NSObject *scanLockObject;

@end

@implementation FitCloud

@synthesize syncType = _syncType;
@synthesize synchronizing = _synchronizing;
@synthesize centralManager = _centralManager;
@synthesize servicePeripheral = _servicePeripheral;
@synthesize managerState = _managerState;


+ (NSString*)SDKVersion
{
    return @"2.1.2";
}


+ (instancetype)shared
{
    static dispatch_once_t pred;
    static FitCloud *sharedinstance = nil;
    dispatch_once(&pred, ^{
        sharedinstance = [[self alloc] init];
    });
    return sharedinstance;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _txSequenceId = 1;
        _scanLockObject = [[NSObject alloc]init];
        
        // 读取本地默认传感器数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *flag = [userDefaults objectForKey:@"fc.SensorFlag"];
        if (flag) {
            _sensorFlag = flag.unsignedIntValue;
        }
        
        _managerState = (FCManagerState)self.centralManager.state;
        _otaService = [FCOTAService shareInstance];
    }
    return self;
}

- (void)setServicePeripheral:(CBPeripheral *)servicePeripheral
{
    if (servicePeripheral != _servicePeripheral)
    {
        _servicePeripheral = servicePeripheral;
    }
}

- (void)setManagerState:(FCManagerState)managerState
{
    if (managerState != _managerState)
    {
        _managerState = managerState;
        [self didChangeValueForKey:@"managerState"];
    }
}


#pragma mark - 传感器标志

- (BOOL)isSyncEnable:(FCSensorFlagType)type
{
    if ((_sensorFlag & type)) {
        return YES;
    }
    return NO;
}

#pragma mark - 设备状态

- (BOOL)isConnected:(CBPeripheral*)peripheral
{
    if (peripheral && peripheral.state == CBPeripheralStateConnected)
    {
        return YES;
    }
    return NO;
}


- (BOOL)isConnected
{
    return [self isConnected:self.servicePeripheral];
}


- (BOOL)isSynchronizing
{
    _synchronizing = !(_syncType == FCSyncTypeUnknown || _syncType == FCSyncTypeEnd);
    return _synchronizing;
}


#pragma mark - 扫描外设

- (void)stopScanning
{
    [self.centralManager stopScan];
    st_dispatch_async_main(^{
        if (_scanningTimer)
        {
            [_scanningTimer invalidate];
            _scanningTimer = nil;
        }
    });
}

- (void)scanForPeripherals:(NSString*)uuidString result:(FCPeripheralsHandler)retHandler
{
    @synchronized (_scanLockObject)
    {
        [self.peripheralsArray removeAllObjects];
    }
    self.scanUUIDString = uuidString;
    self.peripheralsHandler = retHandler;
    [self stopScanning];
    if (self.scanUUIDString)
    {
        NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
        [self.centralManager scanForPeripheralsWithServices:@[] options:options];
        
        // 扫描系统连接的外设
        _scanningTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(retrieveConnectedPeripherals) userInfo:nil repeats:YES];
        [_scanningTimer fire];
    }
    else
    {
        // 扫描非系统连接外设
        NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
        [self.centralManager scanForPeripheralsWithServices:@[] options:options];
        
        _scanningTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(retrieveConnectedPeripherals) userInfo:nil repeats:YES];
        [_scanningTimer fire];
    }
}

// 恢复系统连接的外设
- (void)retrieveConnectedPeripherals
{
    @synchronized (_scanLockObject)
    {
        NSArray *services = @[[CBUUID UUIDWithString:KServiceUUID]];
        NSArray<CBPeripheral*> *array = [self.centralManager retrieveConnectedPeripheralsWithServices:services];
        for (CBPeripheral *peripheral in array)
        {
            DEBUG_METHOD(@"-系统连接外设--%@",peripheral);
            if ([peripheral.name.uppercaseString containsString:@"H"])
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier.UUIDString == %@",peripheral.identifier.UUIDString];
                NSArray *filterArray = [self.peripheralsArray filteredArrayUsingPredicate:predicate];
                if (!filterArray || filterArray.count <= 0)
                {
                    [self.peripheralsArray addObject:peripheral];
                    if (self.peripheralsHandler) {
                        self.peripheralsHandler(self.peripheralsArray, peripheral);
                    }
                }
                else
                {
                    CBPeripheral *aPeripheral = [filterArray firstObject];
                    NSInteger index = [self.peripheralsArray indexOfObject:aPeripheral];
                    if (index < self.peripheralsArray.count)
                    {
                        [self.peripheralsArray replaceObjectAtIndex:index withObject:peripheral];
                    }
                    if (self.peripheralsHandler) {
                        self.peripheralsHandler(self.peripheralsArray, peripheral);
                    }
                }
            }
        }// for
    }//@synchronized
}

// 恢复特定uuid的外设
- (void)retrievePeripheralsWithIdentifier
{
    @synchronized (_scanLockObject)
    {
        NSArray *identifiers = @[[[NSUUID alloc]initWithUUIDString:self.scanUUIDString]];
        NSArray<CBPeripheral*> *array = [self.centralManager retrievePeripheralsWithIdentifiers:identifiers];
        for (CBPeripheral *peripheral in array)
        {
            DEBUG_METHOD(@"-retrieve-peripheral--%@",peripheral);
            if ( self.scanUUIDString && [self.scanUUIDString isEqualToString:peripheral.identifier.UUIDString])
            {
                [self.peripheralsArray removeAllObjects];
                [self.peripheralsArray addObject:peripheral];
                if (self.peripheralsHandler) {
                    self.peripheralsHandler(self.peripheralsArray, peripheral);
                }
                return;
            }
        }
    }
}

#pragma mark - 连接或者断开外设

- (BOOL)connectPeripheral:(CBPeripheral*)peripheral
{
    if (!peripheral)
    {
        return NO;
    }
    [self stopScanning];
    self.servicePeripheral = peripheral;
    NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(YES)};
    [self.centralManager connectPeripheral:peripheral options:options];
    return YES;
}

- (BOOL)disconnectPeripheral:(CBPeripheral*)peripheral
{
    if (peripheral)
    {
        [self.centralManager cancelPeripheralConnection:peripheral];
        return YES;
    }
    return NO;
}

- (BOOL)disconnect
{
    return [self disconnectPeripheral:self.servicePeripheral];
}


#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.managerState = (FCManagerState)central.state;
    st_dispatch_async_main(^{
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_CENTRALMANAGER_UPDATE_STATE_NOTIFY object:nil userInfo:@{@"state":@(central.state)}];
    });
    
    //蓝牙设备砖塔更新回调
    if (central.state == FCManagerStateUnknown)
    {
        DEBUG_METHOD(@"初始的时候是未知的 (刚刚创建的时候)");
    }
    else if (central.state == FCManagerStateResetting)
    {
        DEBUG_METHOD(@"蓝牙设备重置状态");
        [self cancelAllTimers];
        [self endSyncWithResponseState:FCSyncResponseStateResetting];
    }
    else if (central.state == FCManagerStateUnsupported)
    {
        DEBUG_METHOD(@"设备部支持的状态");
    }
    else if (central.state == FCManagerStateUnauthorized)
    {
        DEBUG_METHOD(@"设备未授权状态");
    }
    else if (central.state == FCManagerStatePoweredOff)
    {
        DEBUG_METHOD(@"设备关闭状态");
        [self stopScanning];
        [self cancelAllTimers];
        [self endSyncWithResponseState:FCSyncResponseStatePowerOff];
        
    }
    else if (central.state == FCManagerStatePoweredOn)
    {
        NSLog(@"蓝牙设备可以使用");
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    if (peripheral && [peripheral.name.uppercaseString containsString:@"H"])
    {
        if (_syncType == FCSyncTypeFirmwareUpgrade)
        {
            if ([peripheral.name isEqualToString:self.otaPeripheralName])
            {
                _cycleScanPeripheral = NO;
                [self connectPeripheral:peripheral];
            }
            return;
        }
        
        if (self.scanUUIDString)
        {
            if ([self.scanUUIDString isEqualToString:peripheral.identifier.UUIDString])
            {
                @synchronized (_scanLockObject) {
                    
                    [self.peripheralsArray removeAllObjects];
                    [self.peripheralsArray addObject:peripheral];
                    
                    WS(ws);
                    st_dispatch_async_main(^{
                        if (ws.peripheralsHandler)
                        {
                            ws.peripheralsHandler(ws.peripheralsArray, peripheral);
                        }
                    });
                }
            }
        }
        else
        {
            @synchronized (_scanLockObject)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier.UUIDString == %@",peripheral.identifier.UUIDString];
                NSArray *filterArray = [self.peripheralsArray filteredArrayUsingPredicate:predicate];
                if (!filterArray || filterArray.count <= 0)
                {
                    [self.peripheralsArray addObject:peripheral];
                    WS(ws);
                    st_dispatch_async_main(^{
                        if (_peripheralsHandler) {
                            _peripheralsHandler(ws.peripheralsArray, peripheral);
                        }
                    });
                }
                else
                {
                    CBPeripheral *aPeripheral = [filterArray firstObject];
                    NSInteger index = [self.peripheralsArray indexOfObject:aPeripheral];
                    if (index < self.peripheralsArray.count) {
                        [self.peripheralsArray replaceObjectAtIndex:index withObject:peripheral];
                    }
                    
                    WS(ws);
                    st_dispatch_async_main(^{
                        if (_peripheralsHandler) {
                            _peripheralsHandler(ws.peripheralsArray, peripheral);
                        }
                    });
                }
            }//@synchronized
        }
    }
    
    // 内部OTA升级扫描
    if ((peripheral && [peripheral.name.uppercaseString containsString:@"BEETGT"]) ||
        (advertisementData && [advertisementData[@"kCBAdvDataLocalName"] isEqualToString:@"BeeTgt"]))
    {
        DEBUG_METHOD(@"---固件升级peripheral--%@[%@]",peripheral.name,advertisementData);
        // 连接升级外设
        [self connectPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(nonnull CBPeripheral *)peripheral
{
    DEBUG_METHOD(@"--外设成功连接--%@",peripheral);
    if (peripheral && [peripheral.name.uppercaseString containsString:@"H"])
    {
        [self cancelAllTimers];
        self.servicePeripheral = peripheral;
        [peripheral setDelegate:self];
        [peripheral discoverServices:nil];
        
        st_dispatch_async_main(^{
            [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_CONNECT_PERIPHERAL_NOTIFY object:peripheral];
        });
    }
    else
    {
        self.servicePeripheral = peripheral;
        [peripheral setDelegate:self];
        [peripheral discoverServices:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DEBUG_METHOD(@"--连接外设失败--%@:%@",peripheral,error);
    self.servicePeripheral = nil;
    if (peripheral && [peripheral.name.uppercaseString containsString:@"H"])
    {
        // 外部OTA升级连接失败
        if (_syncType == FCSyncTypeFirmwareUpgrade) {
            st_dispatch_async_main(^{
                if (_firmwareUpgradeTimer) {
                    [_firmwareUpgradeTimer invalidate];_firmwareUpgradeTimer = nil;
                }
                if (_syncResultHandler) {
                    _syncResultHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateError);
                }
            });
        }
        else
        {
            [self cancelScheduledTimer];
            st_dispatch_async_main(^{
                [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_FAIL_CONNECT_PERIPHERAL_NOTIFY object:peripheral];
            });
        }
    }
    else
    {
        // 内部OTA升级断开连接
        if (_syncType == FCSyncTypeEnd)
        {
            NSLog(@"--升级完成断开连接--");
            return;
        }
        
        // 固件升级过程中断开连接
        _syncType = FCSyncTypeEnd;
        st_dispatch_async_main(^{
            if (_firmwareUpgradeTimer) {
                [_firmwareUpgradeTimer invalidate];_firmwareUpgradeTimer = nil;
            }
            if (_syncResultHandler) {
                _syncResultHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateError);
            }
        });
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DEBUG_METHOD(@"-----外设断开连接------%@:%@",peripheral,error);
    [self.peripheralsArray removeAllObjects];
    self.servicePeripheral = nil;
    if (peripheral && [peripheral.name.uppercaseString containsString:@"H"])
    {
        if (_syncType == FCSyncTypeFirmwareUpgrade)
        {
            // 如果ota在升级过程中断开连接
            if ([_otaService oTAIsTransfering])
            {
                DEBUG_METHOD(@"--OTA升级异常断开--");
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateError);
                    }
                });
                return;
            }
            
            // 进入固件升级模式断开连接扫描升级外设
            if ([self isSyncEnable:FCSensorFlagTypeFlashOTA])
            {
                DEBUG_METHOD(@"--FLASH OTA升级扫描外设--");
                
                [self stopScanning];
                NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
                [self.centralManager scanForPeripheralsWithServices:@[] options:options];
                
                _cycleScanPeripheral = YES;
                while (_cycleScanPeripheral)
                {
                    NSArray *services = @[[CBUUID UUIDWithString:KFWServiceUUID],[CBUUID UUIDWithString:KServiceUUID]];
                    NSArray<CBPeripheral*> *array = [self.centralManager retrieveConnectedPeripheralsWithServices:services];
                    for (CBPeripheral *peripheral in array)
                    {
                        DEBUG_METHOD(@"-系统连接外设--%@:%@",self.otaPeripheralName ,peripheral);
                        if ([peripheral.name isEqualToString:self.otaPeripheralName])
                        {
                            DEBUG_METHOD(@"--连接外设--%@",peripheral);
                            [self connectPeripheral:peripheral];
                            _cycleScanPeripheral = NO;
                        }
                    }
                }
            }
            else
            {
                DEBUG_METHOD(@"--OTA升级扫描外设--");
                [self stopScanning];
                NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
                [self.centralManager scanForPeripheralsWithServices:@[] options:options];
            }
        }
        else
        {
            
            [self cancelScheduledTimer];
            st_dispatch_async_main(^{
                [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_DISCONNECT_PERIPHERAL_NOTIFY object:peripheral];
            });
            [self endSyncWithResponseState:FCSyncResponseStateDisconnect];
            st_dispatch_async_main(^{
                if (_realtimeSyncTimeoutTimer)
                {
                    [_realtimeSyncTimeoutTimer invalidate];
                    _realtimeSyncTimeoutTimer = nil;
                }
            });
        }
    }
    else
    {
        // 固件升级完成断开连接
        if (_syncType == FCSyncTypeEnd)
        {
            st_dispatch_async_main(^{
                [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_FIRMWARE_UPDATE_DISCONNECT_PERIPHERAL_NOTIFY
                                                                   object:nil userInfo:@{@"UpgradeResult":@(YES)}];
            });
            return;
        }
        
        // ota升级中途断开连接
        st_dispatch_async_main(^{
            if (_firmwareUpgradeTimer)
            {
                [_firmwareUpgradeTimer invalidate]; _firmwareUpgradeTimer = nil;
            }
            if (_syncResultHandler)
            {
                _syncResultHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateError);
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_FIRMWARE_UPDATE_DISCONNECT_PERIPHERAL_NOTIFY
                                                               object:nil userInfo:@{@"UpgradeResult":@(NO)}];
        });
        _syncType = FCSyncTypeEnd;
    }
    
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(nullable NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        [self disconnectPeripheral:aPeripheral];
        return;
    }
    DEBUG_METHOD(@"---发现服务: %@", aPeripheral.services);
    
    for (CBService *service in aPeripheral.services)
    {
        DEBUG_METHOD(@"---Service found with UUID: %@", service.characteristics);
        if (_syncType == FCSyncTypeFirmwareUpgrade)
        {
            // 固件升级服务
            if ([service.UUID isEqual:[CBUUID UUIDWithString:KFWServiceUUID]])
            {
                
                DEBUG_METHOD(@"--发现固件升级服务--")
//                NSArray *characteristicUUIDs = @[[CBUUID UUIDWithString:KFWReadCharacteristicUUID],
//                                                 [CBUUID UUIDWithString:KFWWriteCharacteristicUUID]];
                [_servicePeripheral discoverCharacteristics:nil forService:service];
                break;
            }
        }
        else
        {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:KServiceUUID]])
            {
                NSArray *characteristicUUIDs = @[[CBUUID UUIDWithString:KReadCharacteristicUUID],
                                                 [CBUUID UUIDWithString:KWriteCharacteristicUUID]];
                [_servicePeripheral discoverCharacteristics:characteristicUUIDs forService:service];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering characteristic: %@", [error localizedDescription]);
        [self disconnectPeripheral:peripheral];
        return;
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:KFWServiceUUID]])
    {
        DEBUG_METHOD(@"--开始固件升级--")
        if (_syncType == FCSyncTypeFirmwareUpgrade)
        {
            if (![_otaService oTAIsTransfering])
            {
                [self cancelFirmwareUpgradeTimeoutTimer];
                [_otaService oTAClearStatus];
                _otaService.devicePeripheral = peripheral;
                _otaService.serviceDfu = service;
                _otaService.oTADelegate = self;
                [_otaService oTAInit];
                [_otaService oTALoadFWImageFromFile:self.otaFilePath];
            }
            return;
        }
    }
    
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:KServiceUUID]])
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            DEBUG_METHOD(@"----didDiscoverCharacteristicsForService---%@",characteristic.UUID);
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KReadCharacteristicUUID]])
            {
                self.readCharacteristic = characteristic;
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                DEBUG_METHOD(@"----readCharacteristic---%@",characteristic.UUID);
            }
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KWriteCharacteristicUUID]])
            {
                self.wirteCharacteristic = characteristic;
                DEBUG_METHOD(@"----wirteCharacteristic---%@",characteristic.UUID.UUIDString);
                [NSThread sleepForTimeInterval:1];
                
                st_dispatch_async_main(^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_DISCOVER_CHARACTERISTICS_NOTIFY object:nil];
                });
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        DEBUG_METHOD(@"Error didUpdateValueForCharacteristic: %@",error.localizedDescription);
        return;
    }
    
    DEBUG_METHOD(@"--value--%@",characteristic.value);
    NSData *valueData = characteristic.value;
    NSUInteger length = valueData.length;
    if (_nextRxDataBytes == 0)
    {
        if (length < L1_HEADER_SIZE)
        {
            NSLog(@"--CHECK L1 HEADER FAIL--");
            _nextRxDataBytes = 0;
            return;
        }
        L1_HEADER *l1Hdr = (L1_HEADER*)[valueData bytes];
        if (CFByteOrderGetCurrent() == CFByteOrderLittleEndian)
        {
            l1Hdr->seqID = CFSwapInt16BigToHost(l1Hdr->seqID);
            l1Hdr->crc16 = CFSwapInt16BigToHost(l1Hdr->crc16);
            l1Hdr->payloaddLength = CFSwapInt16BigToHost(l1Hdr->payloaddLength);
            
            UInt8 protocolVersion = ((UInt8 *)l1Hdr)[L1_HEADER_PROTOCOL_VERSION_POS];
            l1Hdr->errFlag = (protocolVersion >> 5) & 0x1;
            l1Hdr->ackFlag = (protocolVersion >> 4) & 0x1;
            l1Hdr->version = protocolVersion & 0xf;
        }
        
        if (l1Hdr->magicByte != L1_HEADER_MAGIC)
        {
            NSLog(@"--CHECK MAGIC FAIL--");
            _nextRxDataBytes = 0;
            return ;
        }
        UInt16 l1PayloadLen = l1Hdr->payloaddLength;
        _nextRxDataBytes = l1PayloadLen + L1_HEADER_SIZE - length;
        if (_nextRxDataBytes > 0)
        {
            [self.receiveData appendData:valueData];
        }
        
        if (l1Hdr->errFlag == 0 && l1Hdr->ackFlag == 1) //ack packet
        {
            if (l1Hdr->seqID == _txSequenceId)
            {
                DEBUG_METHOD(@"--%d--%d",_txSequenceId,l1Hdr->seqID);
                _txSequenceId ++;
                if (_alarmDataSeqId == l1Hdr->seqID ||
                    _displaySeqId == l1Hdr->seqID ||
                    _updateWatchTimeSeqId == l1Hdr->seqID ||
                    _funcSwitchSeqId == l1Hdr->seqID ||
                    _ancsLanguageSeqId == l1Hdr->seqID ||
                    _notificationSeqId == l1Hdr->seqID ||
                    _longSitSeqId == l1Hdr->seqID ||
                    _healthMonitorSeqId == l1Hdr->seqID ||
                    _drinkRemindSeqId == l1Hdr->seqID ||
                    _wearingStyleSeqId == l1Hdr->seqID ||
                    _cameraStateSeqId == l1Hdr->seqID ||
                    _bloodPressureSeqId == l1Hdr->seqID ||
                    _weatherSeqId == l1Hdr->seqID ||
                    _userProfileSeqId == l1Hdr->seqID ||
                    _findTheWatchSeqId == l1Hdr->seqID ||
                    _findThePhoneReplySeqId == l1Hdr->seqID)
                {
                    [self cancelScheduledTimer];
                    
                    FCSyncType tmpSyncType = _syncType;
                    [self logSycnCallBack:tmpSyncType];
                    
                    _syncType = FCSyncTypeEnd;
                    st_dispatch_async_main(^{
                        if (_syncResultHandler) {
                            _syncResultHandler(tmpSyncType,FCSyncResponseStateSuccess);
                        }
                    });
                }
                else if (_closeRealtimeSyncSeqId == l1Hdr->seqID)
                {
                    DEBUG_METHOD(@"--关闭心率实时同步--");
                    [self cancelScheduledTimer];
                    _syncType = FCSyncTypeEnd;
                    st_dispatch_async_main(^{
                        if (_realtimeSyncTimeoutTimer) {
                            [_realtimeSyncTimeoutTimer invalidate];
                            _realtimeSyncTimeoutTimer = nil;
                        }
                        if (_syncResultHandler) {
                            _syncResultHandler(FCSyncTypeCloseRealtimeSync,FCSyncResponseStateSuccess);
                        }
                    });
                }
                else if (_openRealtimeSyncSeqId == l1Hdr->seqID)
                {
                    DEBUG_METHOD(@"--打开健康实时同步--");
                    [self cancelScheduledTimer];
                    
                    WS(ws);
                    // 健康实时同步2分钟超时
                    st_dispatch_async_main(^{
                        if (_realtimeSyncTimeoutTimer) {
                            [_realtimeSyncTimeoutTimer invalidate];
                            _realtimeSyncTimeoutTimer = nil;
                        }
                        _realtimeSyncTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:ws selector:@selector(realtimeSyncTimeOut) userInfo:nil repeats:NO];
                        if (_syncResultHandler)
                        {
                            _syncResultHandler(FCSyncTypeOpenRealtimeSync,FCSyncResponseStateSuccess);
                        }
                    });
                }
                NSLog(@"ACK PACKET");
                return;
            }
            else
            {
                NSLog(@"sequance id:%d != %d is incorrect", l1Hdr->seqID, _txSequenceId);
                return ;
            }
        }
        else if (l1Hdr->errFlag == 1 && l1Hdr->ackFlag == 1) //ERR ack packet
        {
            NSLog(@"ERROR PACKET");
            [self wbSendErrorACKData];
            return;
        }
        else if (l1Hdr->errFlag == 0 && l1Hdr->ackFlag == 0) //DATA Packet
        {
            _rxSequenceID = l1Hdr->seqID;
            NSLog(@"DATA PACKET");
            return;
        }
        else
        {
            NSLog(@"Unknown PACKET");
            return ;
        }
    }
    else
    {
        [self.receiveData appendData:valueData];
        _nextRxDataBytes -= length;
        if (_nextRxDataBytes > 0)
        {
            return;
        }
        else
        {
            _nextRxDataBytes = 0;
            DEBUG_METHOD(@"--接收的数据--%@",self.receiveData);
        }
    }
    
    int len = (int)(self.receiveData.length - L1_HEADER_SIZE);
    Byte *l2Packet = (Byte*)malloc(len);
    [self.receiveData getBytes:l2Packet range:NSMakeRange(L1_HEADER_SIZE, len)];
    L2_HEADER *l2h = (L2_HEADER *)l2Packet;
    switch ( l2h -> cmdID )
    {
        case CMD_UPDATE:
        {
            NSLog(@"UPDATE CMD");
            [self wbRxParseUpdateData:l2Packet+L2_HEADER_SIZE andLength:len-L2_HEADER_SIZE];
        }
            break;
            
        case CMD_SETTING:
            NSLog(@"SETTING CMD");
            [self wbRxParseSettingData:l2Packet+L2_HEADER_SIZE andLength:len-L2_HEADER_SIZE];
            break;
            
        case CMD_BOND_REG:
            NSLog(@"BOND CMD");
            [self wbRxParseBondData:l2Packet+L2_HEADER_SIZE andLength:len-L2_HEADER_SIZE];
            break;
            
        case CMD_NOTIFY:
            NSLog(@"NOTIFY CMD");
            [self wbRxParseDefaultData:l2Packet+L2_HEADER_SIZE andLength:len];
            break;
            
        case CMD_SPORTS:
            NSLog(@"SPORTS CMD");
            [self wbRxParseSportsData:l2Packet+L2_HEADER_SIZE andLength:len-L2_HEADER_SIZE];
            break;
            
        case CMD_FACTORY:
            NSLog(@"FACTORY CMD");
            [self wbRxParseDefaultData:l2Packet+L2_HEADER_SIZE andLength:len];
            break;
            
        case CMD_CTRL:
            NSLog(@"CTRL CMD");
            [self wbRxParseDefaultData:l2Packet+L2_HEADER_SIZE andLength:len-L2_HEADER_SIZE];
            break;
            
        case CMD_DUMP:
            NSLog(@"DUMP CMD");
            [self wbRxParseDefaultData:l2Packet+L2_HEADER_SIZE andLength:len];
            break;
            
        case CMD_FLASH:
            NSLog(@"FLASH CMD");
            [self wbRxParseDefaultData:l2Packet+L2_HEADER_SIZE andLength:len];
            break;
            
        case CMD_LOG:
        {
            NSLog(@"LOG CMD");
            [self wbRxParseDefaultData:l2Packet+L2_HEADER_SIZE andLength:len];
        }
            break;
            
        default:
            break;
    }
    [self.receiveData resetBytesInRange:NSMakeRange(0, self.receiveData.length)];
    [self.receiveData setLength:0];
    free(l2Packet);
}



#pragma mark - 错误回调

- (BOOL)isSyncEnabled:(FCSyncType)syncType result:(FCSyncResultHandler)retHandler
{
    if (![self isConnected])
    {
        DEBUG_METHOD(@"--蓝牙未连接--");
        if (retHandler) {
            retHandler(syncType,FCSyncResponseStateNotConnected);
        }
        return YES;
    }
    
    if (self.isSynchronizing)
    {
        DEBUG_METHOD(@"--蓝牙正在同步--");
        if (retHandler) {
            retHandler(syncType,FCSyncResponseStateSynchronizing);
        }
        return YES;
    }
    return NO;
}

- (BOOL)isSyncEnabled:(FCSyncType)syncType resultData:(FCSyncDataResultHandler)retHandler
{
    if (![self isConnected])
    {
        DEBUG_METHOD(@"--蓝牙未连接--");
        if (retHandler) {
            retHandler(nil ,syncType,FCSyncResponseStateNotConnected);
        }
        return YES;
    }
    
    if (self.isSynchronizing)
    {
        DEBUG_METHOD(@"--蓝牙正在同步--");
        if (retHandler) {
            retHandler(nil, syncType,FCSyncResponseStateSynchronizing);
        }
        return YES;
    }
    return NO;
}


#pragma mark - 蓝牙指令

- (void)fcLoginDevice:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    if (!data) {
        DEBUG_METHOD(@"--参数错误--");
        if (retHandler) {
            retHandler(FCSyncTypeLoginDevice, FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeLoginDevice result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncType = FCSyncTypeLoginDevice;
    _syncResultHandler = retHandler;
    
    NSData *payload = [self wbDataWithSequenceId:_txSequenceId command:CMD_BOND_REG key:KEY_LOGIN_REQ l2Payload:data];
    [self sendPacketDataWithResponse:payload];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

- (void)fcBindDevice:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    if (!data) {
        DEBUG_METHOD(@"--参数错误--");
        if (retHandler) {
            retHandler(FCSyncTypeBindDevice, FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeBindDevice result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncType = FCSyncTypeBindDevice;
    _syncResultHandler = retHandler;

    NSData *payload = [self wbDataWithSequenceId:_txSequenceId command:CMD_BOND_REG key:KEY_BOND_REQ l2Payload:data];
    [self sendPacketDataWithResponse:payload];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

- (void)fcUnBindDevice:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeUnBindDevice result:retHandler];
    if (!ret) {
        return;
    }

    _syncType = FCSyncTypeUnBindDevice;
    _syncResultHandler = retHandler;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_BOND_REG key:KEY_UNBOND_REQ l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 查找手表
- (void)fcFindTheWatch:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeFindTheWatch result:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeFindTheWatch;
    _findTheWatchSeqId = _txSequenceId;
    _syncResultHandler = retHandler;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_FIND_WRISTBAND l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


// 找到手机回复
- (void)fcFindThePhoneReply:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeFoundPhoneReplay result:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeFoundPhoneReplay;
    _syncResultHandler = retHandler;
    _findThePhoneReplySeqId = _txSequenceId;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:0x2b l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}



- (void)fcUpdateWatchTime:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeUpdateWatchTime result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncType = FCSyncTypeUpdateWatchTime;
    _syncResultHandler = retHandler;
    _updateWatchTimeSeqId = _txSequenceId;
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    [self fcSetTimerWithYear:components.year-2000
                    andMonth:components.month
                      andDay:components.day
                     andHour:components.hour
                   andMinute:components.minute
                   andSecond:components.second];
}

// 设置手表穿戴方式
- (void)fcSetLeftHandWearEnable:(BOOL)bEnabled result:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetWearingStyle result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncResultHandler = retHandler;
    _wearingStyleSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetWearingStyle;
    
    Byte byte = bEnabled ? 0x01 : 0x02;
    NSData *payload = [NSData dataWithBytes:&byte length:1];
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_WEARING_STYLE l2Payload:payload];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 设置手表功能开关
- (void)fcSetFeaturesData:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    DEBUG_METHOD(@"--data--%@",data);
    if (!data) {
        if (retHandler) {
            retHandler(FCSyncTypeSetFeatures,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetFeatures result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncResultHandler = retHandler;
    _funcSwitchSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetFeatures;
    
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_FUNCTION_SWITCH_DATA l2Payload:data];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


- (void)fcSetAlarmData:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    DEBUG_METHOD(@"--data--%@",data);
    if (!data)
    {
        if (retHandler)
        {
            retHandler(FCSyncTypeSetAlarmData,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetAlarmData result:retHandler];
    if (!ret) {
        return;
    }
    
    
    _syncResultHandler = retHandler;
    _alarmDataSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetAlarmData;
    
    
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_ALARM_DATA l2Payload:data];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


- (void)fcGetAlarmList:(FCSyncDataResultHandler)retHandler;
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetAlarmList resultData:retHandler];
    if (!ret) {
        return;
    }
    
    _syncDataResultHandler = retHandler;
    _syncType = FCSyncTypeGetAlarmList;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_GET_ALARM_LIST_REQ l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 设置用户基本资料
- (void)fcSetUserProfile:(FCUserObject*)aUser result:(FCSyncResultHandler)retHandler
{
    if (!aUser) {
        if (retHandler) {
            retHandler(FCSyncTypeSetUserProfile,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetUserProfile result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncType = FCSyncTypeSetUserProfile;
    _userProfileSeqId = _txSequenceId;
    _syncResultHandler = retHandler;
    
    NSData *payload = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_USER_PROIFLE l2Payload:aUser.writeDataForUserProfile];
    [self sendPacketDataWithResponse:payload];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 设置默认血压
- (void)fcSetBloodPressure:(UInt16)sbp dbp:(UInt16)dbp result:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetDefaultBloodPressure result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncResultHandler = retHandler;
    _bloodPressureSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetDefaultBloodPressure;
    
    Byte byte[2] = {0};
    byte[0] = dbp;
    byte[1] = sbp;
    NSData *payload = [NSData dataWithBytes:&byte length:2];
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_DEFAULT_BLOOD_PRESSURE l2Payload:payload];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


// 获取手表系统设置
- (void)fcGetWatchConfig:(FCSyncDataResultHandler)retHandler;
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetWatchConfig resultData:retHandler];
    if (!ret) {
        return;
    }

    _syncDataResultHandler = retHandler;
    _syncType = FCSyncTypeGetWatchConfig;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_ALL_SETTING_RSP l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 获取mac地址
- (void)fcGetMacAddress:(FCSyncDataResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetMacAddress resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetMacAddress;
    _syncDataResultHandler = retHandler;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:0x2c l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 获取电池充电状态和电量
- (void)fcGetBatteryLevelAndState:(FCSyncDataResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetBatteryLevelAndState resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncDataResultHandler = retHandler;
    _syncType = FCSyncTypeGetBatteryLevelAndState;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_POWER_AND_CHARGING_REQ l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 设置手表显示数据
- (void)fcSetWatchScreenDisplayData:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    if (!data)
    {
        if (retHandler)
        {
            retHandler(FCSyncTypeSetScreenDisplay,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetScreenDisplay result:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncResultHandler = retHandler;
    _displaySeqId = _txSequenceId;
    _syncType = FCSyncTypeSetScreenDisplay;
    
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_DISPLAY_DATA l2Payload:data];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


// 设置手表消息通知开关
- (void)fcSetNotificationSettingData:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    DEBUG_METHOD(@"--data--%@",data);
    if (!data) {
        if (retHandler) {
            retHandler(FCSyncTypeSetNotification,FCSyncResponseStateParameterError);
        }
        return;
    }
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetNotification result:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncResultHandler = retHandler;
    _notificationSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetNotification;
    
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_NOTIFICATION_DATA l2Payload:data];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 设置久坐提醒信息
- (void)fcSetSedentaryRemindersData:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    if (!data) {
        if (retHandler) {
            retHandler(FCSyncTypeSetSedentaryReminder,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetSedentaryReminder result:retHandler];
    if (!ret)
    {
        return;
    }
    
    
    _syncResultHandler = retHandler;
    _longSitSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetSedentaryReminder;
    
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_LONGSIT_DATA l2Payload:data];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

// 设置健康实时监测数据
- (void)fcSetHealthMonitoringData:(NSData*)data result:(FCSyncResultHandler)retHandler
{
    if (!data) {
        if (retHandler) {
            retHandler(FCSyncTypeSetHealthMonitoring,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetHealthMonitoring result:retHandler];
    if (!ret)
    {
        return;
    }

    _syncResultHandler = retHandler;
    _healthMonitorSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetHealthMonitoring;
    
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_HEALTH_MONITOR_DATA l2Payload:data];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


// 设置喝水提醒数据
- (void)fcSetDrinkRemindEnable:(BOOL)bEnabled result:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetDrinkReminder result:retHandler];
    if (!ret)
    {
        return;
    }
    _syncResultHandler = retHandler;
    _drinkRemindSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetDrinkReminder;
    
    Byte byte = bEnabled ? 0x01 : 0x00;
    NSData *payload = [NSData dataWithBytes:&byte length:1];
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_SET_DRINK_REMIND_DATA l2Payload:payload];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


// 设置app相机前后台状态，用于手表拍照控制
- (void)fcSetCameraState:(BOOL)bInForeground result:(FCSyncResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeSetCameraState result:retHandler];
    if (!ret)
    {
        return;
    }
    _syncResultHandler = retHandler;
    _cameraStateSeqId = _txSequenceId;
    _syncType = FCSyncTypeSetCameraState;
    
    
    Byte byte = bInForeground ? 0x00 : 0x01;
    NSData *payload = [NSData dataWithBytes:&byte length:1];
    NSData *sendData = [self wbDataWithSequenceId:_txSequenceId command:CMD_CTRL key:0x11 l2Payload:payload];
    [self sendPacketDataWithResponse:sendData];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


// 设置天气
- (void)fcSetWeather:(FCWeather*)weather result:(FCSyncResultHandler)retHandler
{
    if (!weather) {
        if (retHandler) {
            retHandler(FCSyncTypeUpdateWeather,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeUpdateWeather result:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeUpdateWeather;
    _weatherSeqId = _txSequenceId;
    _syncResultHandler = retHandler;
    
    NSData *writeData = [weather writeData];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:0x29 l2Payload:writeData];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
    
}


- (void)fcGetFirmwareVersion:(FCSyncDataResultHandler)retHandler
{
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetFirmwareVersion resultData:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeGetFirmwareVersion;
    _syncDataResultHandler = retHandler;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:0x11 l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

- (void)fcSetANCSLanguage:(FCSyncResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步ANCS语言--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeANCS];
    if (!ret)
    {
        if (retHandler)
        {
            retHandler(FCSyncTypeSetANCSLanguage, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }

    ret = [self isSyncEnabled:FCSyncTypeSetANCSLanguage result:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeSetANCSLanguage;
    _syncResultHandler = retHandler;
    _ancsLanguageSeqId = _txSequenceId;
    
    Byte byte[4] = {0};
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage containsString:@"zh-"])
    {
        if ([currentLanguage containsString:@"zh-Hant"])
        {
            byte[0] = 0x02;
        }
        else
        {
            byte[0] = 0x01;
        }
    }
    else if ([currentLanguage containsString:@"yue-"])
    {
        byte[0] = 0x02;
    }
    else if ([currentLanguage containsString:@"en-"])
    {
        byte[0] = 0x03;
    }
    else if ([currentLanguage containsString:@"de-"])
    {
        byte[0] = 0x04;
    }
    else if ([currentLanguage containsString:@"es-"])
    {
        byte[0] = 0x06;
    }
    else if ([currentLanguage containsString:@"ja-"])
    {
        byte[0] = 0xff;
    }
    else if ([currentLanguage containsString:@"ko-"])
    {
        byte[0] = 0xff;
    }
    else if ([currentLanguage containsString:@"fr-"])
    {
        byte[0] = 0x08;
    }
    else if ([currentLanguage containsString:@"pt-"])
    {
        byte[0] = 0x07;
    }
    else if ([currentLanguage containsString:@"ru-"])
    {
        byte[0] = 0x05;
    }
    else if ([currentLanguage containsString:@"ar-"])
    {
        byte[0] = 0xff;
    }
    else
    {
        byte[0] = 0xff;
    }
    
    NSData *payload = [NSData dataWithBytes:byte length:4];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:0x32 l2Payload:payload];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}


#pragma mark - 手表登录、绑定或解绑操作

- (void)loginWithUser:(FCUserObject *)aUser stepCallback:(FCStepCallbackHandler)stepCallback result:(FCSyncResultHandler)retHandler
{
    if (!aUser) {
        DEBUG_METHOD(@"--参数错误--");
        if (retHandler) {
            retHandler(FCSyncTypeLoginDevice,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    WS(ws);
    if (stepCallback) {
        stepCallback(FCSyncTypeLoginDevice);
    }
    [self fcLoginDevice:aUser.writeDataForLoginOrBind result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            // 同步系统时间
            if (stepCallback) {
                stepCallback(FCSyncTypeUpdateWatchTime);
            }
            [ws fcUpdateWatchTime:^(FCSyncType syncType, FCSyncResponseState state) {
                if (state == FCSyncResponseStateSuccess)
                {
                    // ANCS设置
                    if (stepCallback) {
                        stepCallback(FCSyncTypeSetANCSLanguage);
                    }
                    [ws fcSetANCSLanguage:^(FCSyncType syncType, FCSyncResponseState state) {
                        if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                        {
                            // 功能开关设置
                            if (stepCallback) {
                                stepCallback(FCSyncTypeSetFeatures);
                            }
                            [ws fcSetFeaturesData:aUser.featuresData result:^(FCSyncType syncType, FCSyncResponseState state) {
                                if (retHandler) {
                                    retHandler(syncType, state);
                                }
                            }];// 功能开关设置
                        }
                        else
                        {
                            if (retHandler) {
                                retHandler(syncType, state);
                            }
                        }
                    }];//ANCS设置
                }
                else
                {
                    if (retHandler) {
                        retHandler(syncType, state);
                    }
                }
            }];// 同步系统时间
            
        }
        else
        {
            if (retHandler) {
                retHandler(syncType,state);
            }
        }
    }];
}

- (void)bindWithUser:(FCUserObject*)aUser stepCallback:(FCStepCallbackHandler)stepCallback result:(FCSyncDataResultHandler)retHandler
{
    if (!aUser) {
        DEBUG_METHOD(@"--参数错误--");
        if (retHandler) {
            retHandler(nil, FCSyncTypeBindDevice,FCSyncResponseStateParameterError);
        }
        return;
    }
    WS(ws);
    if (stepCallback) {
        stepCallback(FCSyncTypeBindDevice);
    }
    [self fcBindDevice:aUser.writeDataForLoginOrBind result:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            // 系统时间设置
            if (stepCallback) {
                stepCallback(FCSyncTypeUpdateWatchTime);
            }
            [ws fcUpdateWatchTime:^(FCSyncType syncType, FCSyncResponseState state) {
                if (state == FCSyncResponseStateSuccess )
                {
                    // 功能开关设置
                    if (stepCallback) {
                        stepCallback(FCSyncTypeSetFeatures);
                    }
                    [ws fcSetFeaturesData:aUser.featuresData result:^(FCSyncType syncType, FCSyncResponseState state) {
                        if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateParameterError)
                        {
                            // ANCS设置
                            if (stepCallback) {
                                stepCallback(FCSyncTypeSetANCSLanguage);
                            }
                            [ws fcSetANCSLanguage:^(FCSyncType syncType, FCSyncResponseState state) {
                                if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                                {
                                    // 用户资料设置
                                    if (stepCallback) {
                                        stepCallback(FCSyncTypeSetUserProfile);
                                    }
                                    [ws fcSetUserProfile:aUser result:^(FCSyncType syncType, FCSyncResponseState state) {
                                        if (state == FCSyncResponseStateSuccess)
                                        {
                                            // 默认血压设置
                                            if (stepCallback) {
                                                stepCallback(FCSyncTypeSetDefaultBloodPressure);
                                            }
                                            [ws fcSetBloodPressure:aUser.systolicBP dbp:aUser.diastolicBP result:^(FCSyncType syncType, FCSyncResponseState state) {
                                                if (state == FCSyncResponseStateSuccess)
                                                {
                                                    // 佩戴方式设置
                                                    if (stepCallback) {
                                                        stepCallback(FCSyncTypeSetWearingStyle);
                                                    }
                                                    [ws fcSetLeftHandWearEnable:aUser.isLeftHandWearEnabled result:^(FCSyncType syncType, FCSyncResponseState state) {
                                                        if (state == FCSyncResponseStateSuccess)
                                                        {
                                                            // 获取手表设置
                                                            if (stepCallback) {
                                                                stepCallback(FCSyncTypeGetWatchConfig);
                                                            }
                                                            [ws fcGetWatchConfig:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                                if (retHandler) {
                                                                    retHandler(data,syncType, state);
                                                                }
                                                            }];// 获取手表设置
                                                        }
                                                        else
                                                        {
                                                            if (retHandler) {
                                                                retHandler(nil, syncType, state);
                                                            }
                                                        }
                                                    }];// 佩戴方式
                                                }
                                                else
                                                {
                                                    if (retHandler) {
                                                        retHandler(nil, syncType, state);
                                                    }
                                                }
                                            }];// 默认血压设置
                                        }
                                        else
                                        {
                                            if (retHandler) {
                                                retHandler(nil, syncType, state);
                                            }
                                        }
                                    }]; // 用户资料设置
                                }
                                else
                                {
                                    if (retHandler) {
                                        retHandler(nil, syncType, state);
                                    }
                                }
                            }];// ANCS设置
                        }
                        else
                        {
                            if (retHandler) {
                                retHandler(nil, syncType, state);
                            }
                        }
                    }];// 功能开关设置
                }
                else
                {
                    if (retHandler) {
                        retHandler(nil, syncType,state);
                    }
                }
            }];// 系统时间设置
        }
        else
        {
            if (retHandler) {
                retHandler(nil, syncType, state);
            }
        }
    }];
}

#pragma mark - 时间同步

- (void)fcSetTimerWithYear:(NSInteger)year
                  andMonth:(NSInteger)month
                    andDay:(NSInteger)day
                   andHour:(NSInteger)hour
                 andMinute:(NSInteger)minute
                 andSecond:(NSInteger)second
{
    
    UInt32 time = (UInt32)((year << 26) + (month << 22) + (day << 17) + (hour << 12) + (minute << 6) + second);
    DEBUG_METHOD(@"set time: %@-%@-%@, %@:%@:%@ 0x%@", @(year), @(month), @(day), @(hour), @(minute), @(second), @(time));
    // 如果是小端模式，则交换为大端模式
    if (CFByteOrderGetCurrent() == CFByteOrderLittleEndian)
    {
        time = CFSwapInt32HostToBig(time);
    }
    NSData *value = [NSData dataWithBytes:&time length:sizeof(time)];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SETTING key:KEY_SETTING_TIMER l2Payload:value];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

- (void)systemTimeUpdate
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    [self fcSetTimerWithYear:components.year-2000
                    andMonth:components.month
                      andDay:components.day
                     andHour:components.hour
                   andMinute:components.minute
                   andSecond:components.second];
}



#pragma mark - 监听

- (void)fcSetListenTakePicturesCMDFromWatch:(dispatch_block_t)aBlock
{
    self.takePicturesBlock = aBlock;
}


- (void)fcSetListenFindPhoneCMDFromWatch:(dispatch_block_t)aBlock
{
    self.findTheMobileBlock = aBlock;
}


#pragma mark - 健康实时同步

- (void)fcOpenRealTimeSync:(FCRTSyncType)syncType dataCallback:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler
{
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeOpenRealtimeSync result:retHandler];
    if (!ret)
    {
        return;
    }

    _syncDataHandler = dataCallback;
    _syncResultHandler = retHandler;
    _openRealtimeSyncSeqId = _txSequenceId;
    _syncType = FCSyncTypeOpenRealtimeSync;
    
    UInt16 syncValue = 0;
    syncValue += ((syncType == FCRTSyncTypeHeartRate) ? 1 : 0);
    syncValue += ((syncType == FCRTSyncTypeBloodOxygen) ? (1 << 1) : 0);
    syncValue += ((syncType == FCRTSyncTypeBloodPressure) ? (1 << 2) : 0);
    syncValue += ((syncType == FCRTSyncTypeBreathingRate) ? (1 << 3) : 0);
    
    Byte byte[4] = {0};
    byte[0] = (syncValue >> 8);
    byte[1] = (syncValue & 0xFF);
    byte[2] = 5;
    byte[3] = 2;
    NSData *payload = [NSData dataWithBytes:byte length:4];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:0x06 l2Payload:payload];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}


- (void)fcCloseRealTimeSync:(FCSyncResultHandler)retHandler
{
    if (![self isConnected])
    {
        DEBUG_METHOD(@"--蓝牙未连接--");
        if (retHandler) {
            retHandler(FCSyncTypeCloseRealtimeSync,FCSyncResponseStateNotConnected);
        }
        return;
    }
    
    if (_syncType != FCSyncTypeOpenRealtimeSync && self.isSynchronizing)
    {
        DEBUG_METHOD(@"--蓝牙正在同步--");
        if (retHandler) {
            retHandler(FCSyncTypeCloseRealtimeSync,FCSyncResponseStateSynchronizing);
        }
        return;
    }

    _syncResultHandler = retHandler;
    _syncType = FCSyncTypeCloseRealtimeSync;
    _closeRealtimeSyncSeqId = _txSequenceId;
    
    Byte byte[4] = {0};
    byte[0] = 0;
    byte[1] = 0;
    byte[2] = 1;
    byte[3] = 2;
    NSData *payload = [NSData dataWithBytes:byte length:4];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:0x06 l2Payload:payload];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(closeRealTimeSyncTimeout)];
}

- (void)closeRealTimeSyncTimeout
{
    // 实时同步关闭失败，则恢复实时同步状态
    _syncType = FCSyncTypeOpenRealtimeSync;
}

- (void)realtimeSyncTimeOut
{
    DEBUG_METHOD(@"--健康实时同步超时---");
    _syncType = FCSyncTypeEnd;
    st_dispatch_async_main(^{
        if (_syncResultHandler) {
            _syncResultHandler(FCSyncTypeOpenRealtimeSync,FCSyncResponseStateRTTimeOut);
        }
    });
}


#pragma mark - 固件与升级

- (void)fcUpdateFirmwareWithPath:(NSString *)filePath progress:(FCProgressHandler)progressHandler result:(FCSyncResultHandler)retHandler
{
    if (!filePath)
    {
        if (retHandler)
        {
            retHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateParameterError);
        }
        return;
    }
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeFirmwareUpgrade result:retHandler];
    if (!ret) {
        return;
    }
    
    _syncType = FCSyncTypeFirmwareUpgrade;
    _otaFilePath = filePath;
    _progressHandler = progressHandler;
    _syncResultHandler = retHandler;
    
    // 开始进入固件升级模式
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_UPDATE key:0x1 l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:10 andSelector:@selector(syncTimeOut)];
}

- (void)firmwareUpgradeTimeout
{
    [self stopScanning];
    _syncType = FCSyncTypeEnd;
    st_dispatch_async_main(^{
        if (_syncResultHandler) {
            _syncResultHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateError);
        }
    });
    [self disconnectPeripheral:self.servicePeripheral];
}

- (void)cancelFirmwareUpgradeTimeoutTimer
{
    st_dispatch_async_main(^{
        if (_firmwareUpgradeTimer) {
            [_firmwareUpgradeTimer invalidate]; _firmwareUpgradeTimer = nil;
        }
    });
}

#pragma mark - 运动数据同步

// 同步某一类型的运动数据
- (void)wbSyncDataWithKey:(Byte)key;
{
    NSData *payload = [NSData dataWithBytes:&key length:sizeof(key)];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:0x01 l2Payload:payload];
    [self sendPacketDataWithResponse:data];
}


- (void)fcGetDailyTotalData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"---同步日总数据--");
    
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetDayTotalData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeGetDayTotalData;
    _syncDataResultHandler = retHandler;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:0x21 l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}

- (void)fcGetExerciseData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步运动数据--");
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetExerciseData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    
    _syncType = FCSyncTypeGetExerciseData;
    _syncDataResultHandler = retHandler;
    [self wbSyncDataWithKey:0x01];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}

- (void)fcGetSleepData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步睡眠数据--");
    BOOL ret = [self isSyncEnabled:FCSyncTypeGetSleepData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetSleepData;
    _syncDataResultHandler = retHandler;
    
    [self wbSyncDataWithKey:0x02];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}

- (void)fcGetHeartRateData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步心率数据--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeHeartRate];
    if (!ret)
    {
        if (retHandler) {
            retHandler(nil, FCSyncTypeGetHeartRateData, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }
    
    ret = [self isSyncEnabled:FCSyncTypeGetHeartRateData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetHeartRateData;
    _syncDataResultHandler = retHandler;
    
    [self wbSyncDataWithKey:0x03];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}


- (void)fcGetBloodOxygenData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步血氧数据--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeBloodOxygen];
    if (!ret)
    {
        if (retHandler)
        {
            retHandler(nil, FCSyncTypeGetBloodOxygenData, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }
    
    ret = [self isSyncEnabled:FCSyncTypeGetBloodOxygenData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetBloodOxygenData;
    _syncDataResultHandler = retHandler;
    
    [self wbSyncDataWithKey:0x04];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}

- (void)fcGetUltravioletData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步UV数据--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeUV];
    if (!ret)
    {
        if (retHandler)
        {
            retHandler(nil, FCSyncTypeGetUltravioletData, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }
    
    ret = [self isSyncEnabled:FCSyncTypeGetUltravioletData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetUltravioletData;
    _syncDataResultHandler = retHandler;
    
    [self wbSyncDataWithKey:0x05];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}


- (void)fcGetBloodPressureData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步血压数据--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeBloodPressure];
    if (!ret)
    {
        if (retHandler)
        {
            retHandler(nil, FCSyncTypeGetBloodPressureData, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }
    
    ret = [self isSyncEnabled:FCSyncTypeGetBloodPressureData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetBloodPressureData;
    _syncDataResultHandler = retHandler;
    
    [self wbSyncDataWithKey:0x0a];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}

- (void)fcGetBreathingRateData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步呼吸频率数据--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeBreathingRate];
    if (!ret)
    {
        if (retHandler)
        {
            retHandler(nil, FCSyncTypeGetBreathingRateData, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }
    
    ret = [self isSyncEnabled:FCSyncTypeGetBreathingRateData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetBreathingRateData;
    _syncDataResultHandler = retHandler;
    
    [self wbSyncDataWithKey:0x0b];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}


- (void)fcGetSevenDaysSleepTotalData:(FCSyncDataResultHandler)retHandler
{
    DEBUG_METHOD(@"--同步七日睡眠总数据--");
    BOOL ret = [self isSyncEnable:FCSensorFlagTypeSevenDaysSleep];
    if (!ret)
    {
        if (retHandler)
        {
            retHandler(nil, FCSyncTypeGetSevenDaysSleepData, FCSyncResponseStateNoSensorFlag);
        }
        return;
    }
    
    ret = [self isSyncEnabled:FCSyncTypeGetSevenDaysSleepData resultData:retHandler];
    if (!ret)
    {
        return;
    }
    _syncType = FCSyncTypeGetSevenDaysSleepData;
    _syncDataResultHandler = retHandler;
    
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:0x23 l2Payload:nil];
    [self sendPacketDataWithResponse:data];
    [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
}


#pragma mark - 历史数据同步

- (void)fcGetHistoryDataWithUser:(FCUserObject*)aUser stepCallback:(FCStepCallbackHandler)stepCallback  dataCallback:(FCSyncDataHandler)dataCallback result:(FCSyncResultHandler)retHandler
{
    if (stepCallback) {
        stepCallback(FCSyncTypeUpdateWatchTime);
    }
    // 同步系统时间
    WS(ws);
    [self fcUpdateWatchTime:^(FCSyncType syncType, FCSyncResponseState state) {
        if (state == FCSyncResponseStateSuccess)
        {
            // 同步功能开关设置
            if (stepCallback) {
                stepCallback(FCSyncTypeSetFeatures);
            }
            NSData *featureData = aUser.featuresData;
            [ws fcSetFeaturesData:featureData result:^(FCSyncType syncType, FCSyncResponseState state) {
                if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateParameterError)
                {
                    // 同步ANCS语言
                    if (stepCallback) {
                        stepCallback(FCSyncTypeSetANCSLanguage);
                    }
                    [ws fcSetANCSLanguage:^(FCSyncType syncType, FCSyncResponseState state) {
                        if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                        {
                            // 同步日总数据
                            if (stepCallback) {
                                stepCallback(FCSyncTypeGetDayTotalData);
                            }
                            [ws fcGetDailyTotalData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                if (state == FCSyncResponseStateSuccess)
                                {
                                    if (data && dataCallback) {
                                        dataCallback(syncType, data);
                                    }
                                    
                                    // 同步运动数据数据
                                    if (stepCallback) {
                                        stepCallback(FCSyncTypeGetExerciseData);
                                    }
                                    [ws fcGetExerciseData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                        if (state == FCSyncResponseStateSuccess)
                                        {
                                            if (data && dataCallback) {
                                                dataCallback(syncType, data);
                                            }
                                            
                                            // 同步睡眠数据
                                            if (stepCallback) {
                                                stepCallback(FCSyncTypeGetSleepData);
                                            }
                                            [ws fcGetSleepData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                if (state == FCSyncResponseStateSuccess)
                                                {
                                                    if (data && dataCallback) {
                                                        dataCallback(syncType, data);
                                                    }
                                                    
                                                    // 同步血氧数据
                                                    if (stepCallback) {
                                                        stepCallback(FCSyncTypeGetBloodOxygenData);
                                                    }
                                                    [ws fcGetBloodOxygenData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                        if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                                                        {
                                                            if (data && dataCallback) {
                                                                dataCallback(syncType, data);
                                                            }
                                                            
                                                            // 同步血压数据
                                                            if (stepCallback) {
                                                                stepCallback(FCSyncTypeGetBloodPressureData);
                                                            }
                                                            [ws fcGetBloodPressureData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                                if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                                                                {
                                                                    if (data && dataCallback) {
                                                                        dataCallback(syncType, data);
                                                                    }
                                                                    
                                                                    // 同步呼吸频率数据
                                                                    if (stepCallback) {
                                                                        stepCallback(FCSyncTypeGetBreathingRateData);
                                                                    }
                                                                    [ws fcGetBreathingRateData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                                        if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                                                                        {
                                                                            if (data && dataCallback) {
                                                                                dataCallback(syncType, data);
                                                                            }
                                                                            
                                                                            // 同步心率数据
                                                                            if (stepCallback) {
                                                                                stepCallback(FCSyncTypeGetHeartRateData);
                                                                            }
                                                                            [ws fcGetHeartRateData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                                                if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                                                                                {
                                                                                    if (data && dataCallback) {
                                                                                        dataCallback(syncType, data);
                                                                                    }
                                                                                    
                                                                                    // 同步七日睡眠数据
                                                                                    [ws fcGetSevenDaysSleepTotalData:^(NSData *data, FCSyncType syncType, FCSyncResponseState state) {
                                                                                        
                                                                                        if (state == FCSyncResponseStateSuccess || state == FCSyncResponseStateNoSensorFlag)
                                                                                        {
                                                                                            if (data && dataCallback) {
                                                                                                dataCallback(syncType, data);
                                                                                            }
                                                                                            
                                                                                            if (retHandler) {
                                                                                                retHandler(syncType, state);
                                                                                            }
                                                                                            
                                                                                            // 后面需要补充心电数据
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            if (retHandler) {
                                                                                                retHandler(syncType, state);
                                                                                            }
                                                                                        }
                                                                                    }]; // 七日睡眠数据
                                                                                }
                                                                                else
                                                                                {
                                                                                    if (retHandler) {
                                                                                        retHandler(syncType, state);
                                                                                    }
                                                                                }
                                                                            }]; // 同步心率数据
                                                                        }
                                                                        else
                                                                        {
                                                                            if (retHandler) {
                                                                                retHandler(syncType, state);
                                                                            }
                                                                        }
                                                                    }]; // 呼吸频率
                                                                }
                                                                else
                                                                {
                                                                    if (retHandler) {
                                                                        retHandler(syncType, state);
                                                                    }
                                                                }
                                                            }]; // 血压数据
                                                        }
                                                        else
                                                        {
                                                            if (retHandler) {
                                                                retHandler(syncType, state);
                                                            }
                                                        }
                                                    }]; // 血氧数据
                                                }
                                                else
                                                {
                                                    if (retHandler) {
                                                        retHandler(syncType, state);
                                                    }

                                                }
                                            }]; // 睡眠数据
                                        }
                                        else
                                        {
                                            if (retHandler) {
                                                retHandler(syncType, state);
                                            }
                                        }
                                    }]; // 运动量
                                }
                                else
                                {
                                    if (retHandler) {
                                        retHandler(syncType, state);
                                    }
                                }
                            }]; // 日总数据
                        }
                        else
                        {
                            if (retHandler) {
                                retHandler(syncType, state);
                            }
                        }
                    }]; // ancs
                }
                else
                {
                    if (retHandler) {
                        retHandler(syncType, state);
                    }
                }
            }]; // 功能开关
        }
        else
        {
            if (retHandler) {
                retHandler(syncType, state);
            }
        }
    }];
}


#pragma mark - 设置数据解析

- (void)wbRxParseSettingData:(Byte *)l2Packet andLength:(int)length
{
    [self wbSendSuccessACKData];
    switch (l2Packet[0])
    {
        case KEY_SETTING_GET_ALARM_LIST_RSP:
        {
            DEBUG_METHOD(@"---闹钟列表--");
            
            [self cancelScheduledTimer];
            
            NSData *data = [NSData dataWithBytes:l2Packet length:length];
            
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                    _syncDataResultHandler(data, FCSyncTypeGetAlarmList, FCSyncResponseStateSuccess);
                }
            });
        }
            break;
        case KEY_SETTING_FW_VERSION_RSP:
        {
            DEBUG_METHOD(@"--固件信息返回---");
            [self cancelScheduledTimer];
            
            NSData *data = [NSData dataWithBytes:&l2Packet[3] length:length-3];
            DEBUG_METHOD(@"--获取到固件版本信息--%@",data);
            
            // 存储传感器标识位
            NSData *hardwareData = [NSData dataWithBytes:&l2Packet[9] length:4];
            Byte *byte = (Byte*)[hardwareData bytes];
            _sensorFlag = (byte[0] << 24) + (byte[1] << 16) + (byte[2] << 8) + byte[3];
            DEBUG_METHOD(@"---传感器标识--%X",(unsigned int)_sensorFlag);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@(_sensorFlag) forKey:@"fc.SensorFlag"];
            [userDefaults synchronize];
            
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                    _syncDataResultHandler(data, FCSyncTypeGetFirmwareVersion, FCSyncResponseStateSuccess);
                }
            });
        }
            break;
        case KEY_SETTING_ALL_SETTING_REQ:
        {
            DEBUG_METHOD(@"--系统设置返回--");
            [self cancelScheduledTimer];
            NSData *data = [NSData dataWithBytes:&l2Packet[3] length:length-3];
            DEBUG_METHOD(@"---系统设置数据--%@",data);
            
            // 存储传感器标识位
            NSData *hardwareData = [NSData dataWithBytes:&l2Packet[17] length:4];
            Byte *byte = (Byte*)[hardwareData bytes];
            _sensorFlag = (byte[0] << 24) + (byte[1] << 16) + (byte[2] << 8) + byte[3];
            DEBUG_METHOD(@"---传感器标识--%X",(unsigned int)_sensorFlag);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@(_sensorFlag) forKey:@"fc.SensorFlag"];
            [userDefaults synchronize];
            
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                    _syncDataResultHandler(data, FCSyncTypeGetWatchConfig, FCSyncResponseStateSuccess);
                }
            });
        }
            break;
        case KEY_SETTING_POWER_AND_CHARGING_RSP:
        {
            DEBUG_METHOD(@"--电量和充电状态返回--");
            [self cancelScheduledTimer];
            
            NSData *data = [NSData dataWithBytes:&l2Packet[3] length:2];
            
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                    _syncDataResultHandler(data,FCSyncTypeGetBatteryLevelAndState,FCSyncResponseStateSuccess);
                }
            });
            
        }
            break;
        case KEY_SETTING_FIND_YOUR_PHONE:
        {
            DEBUG_METHOD(@"--查找手机--");
            st_dispatch_async_main(^{
                if (_findTheMobileBlock) {
                    _findTheMobileBlock();
                }
            });
        }
            break;
        case 0x2d:
        {
            DEBUG_METHOD(@"--mac地址返回--");
            [self cancelScheduledTimer];
            
            NSData *data = [NSData dataWithBytes:&l2Packet[3] length:length-3];
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                    _syncDataResultHandler(data, FCSyncTypeGetMacAddress, FCSyncResponseStateSuccess);
                }
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark - 固件绑定解析

-(void)wbRxParseBondData:(Byte*)l2Packet andLength:(int)length
{
    [self cancelScheduledTimer];
    switch (l2Packet[0])
    {
        case KEY_LOGIN_RSP:
        {
            [self wbSendSuccessACKData];
            UInt8 status = l2Packet[3];
            if (status == BOND_STATUS_SUCCESS)
            {
                DEBUG_METHOD(@"LOGIN SUCCESS");
                FCSyncType tmpSyncType = _syncType;
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(tmpSyncType, FCSyncResponseStateSuccess);
                    }
                });
            }
            else
            {
                DEBUG_METHOD(@"LOGIN failed. BOND.");
                FCSyncType tmpSyncType = _syncType;
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(tmpSyncType, FCSyncResponseStateError);
                    }
                });
            }
        }
            break;
        case KEY_BOND_RSP:
        {
            [self wbSendSuccessACKData];
            UInt8 status = l2Packet[3];
            if (status == BOND_STATUS_SUCCESS)
            {
                NSLog(@"BOND SUCCESS, set user profile");
                FCSyncType tmpSyncType = _syncType;
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(tmpSyncType, FCSyncResponseStateSuccess);
                    }
                });
            }
            else
            {
                NSLog(@"BOND failed.");
                FCSyncType tmpSyncType = _syncType;
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(tmpSyncType, FCSyncResponseStateError);
                    }
                });
            }
        }
            break;
        case KEY_UNBOND_RSP:
        {
            [self wbSendSuccessACKData];
            
            UInt8 status = l2Packet[3];
            if (status == BOND_STATUS_SUCCESS)
            {
                NSLog(@"UNBOND SUCCESS");
                [self.peripheralsArray removeAllObjects];
                self.scanUUIDString = nil;
                
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(FCSyncTypeUnBindDevice, FCSyncResponseStateSuccess);
                    }
                });
            }
            else
            {
                NSLog(@"UNBOND FAILED");
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(FCSyncTypeUnBindDevice, FCSyncResponseStateError);
                    }
                });
            }
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - 固件更新数据解析

- (void)wbRxParseUpdateData:(Byte *)l2Packet andLength:(int)length
{
    [self wbSendSuccessACKData];
    switch (l2Packet[0])//key
    {
        case KEY_FIRMWARE_UPDATE_RESPONSE:
        {
            [self cancelScheduledTimer];
            UInt8 statusCode = l2Packet[3];
            if (statusCode == 0x00)
            {
                DEBUG_METHOD(@"--成功进入固件升级模式--");
                self.otaPeripheralName = self.servicePeripheral.name;
                // 调度固件升级连接超时定时器
                st_dispatch_async_main(^{
                    _firmwareUpgradeTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(firmwareUpgradeTimeout) userInfo:nil repeats:NO];
                });
            }
            else if (statusCode == 0x01)
            {
                DEBUG_METHOD(@"--进入固件升级模式失败--");
                
                _syncType = FCSyncTypeEnd;
                st_dispatch_async_main(^{
                    if (_syncResultHandler) {
                        _syncResultHandler(FCSyncTypeFirmwareUpgrade,FCSyncResponseStateLowPower);
                    }
                });
            }
        }
            break;
        default:
            NSLog(@"update other key");
            break;
    }
}

#pragma mark - 运动数据返回

- (void)wbRxParseSportsData:(Byte *)l2Packet andLength:(int)length
{
    Byte l2PayloadKey = l2Packet[0];
    if ( l2PayloadKey == KEY_SPORTS_DAILY_TOTAL_DATA_RSP )
    {
        [self wbSendSuccessACKData];
        [self cancelScheduledTimer];
        NSData *data = [NSData dataWithBytes:l2Packet+L2_PAYLOAD_HEADER_SIZE length:length-L2_PAYLOAD_HEADER_SIZE];
        DEBUG_METHOD(@"--日总运动总数据返回--%@",data);
        
        _syncType = FCSyncTypeEnd;
        st_dispatch_async_main(^{
            if (_syncDataResultHandler) {
                _syncDataResultHandler(data, FCSyncTypeGetDayTotalData, FCSyncResponseStateSuccess);
            }
        });
    }
    else if (l2PayloadKey == 0x24)
    {
        [self wbSendSuccessACKData];
        [self cancelScheduledTimer];
        NSData *data = [NSData dataWithBytes:l2Packet+L2_PAYLOAD_HEADER_SIZE length:length-L2_PAYLOAD_HEADER_SIZE];
        DEBUG_METHOD(@"--睡眠历史总数据--%@",data);
        
        _syncType = FCSyncTypeEnd;
        st_dispatch_async_main(^{
            if (_syncDataResultHandler) {
                _syncDataResultHandler(data, FCSyncTypeGetSevenDaysSleepData, FCSyncResponseStateSuccess);
            }
        });
    }
    else if (l2PayloadKey == KEY_SPORTS_REALTIME_SYNC_DATA_RSP)
    {
        DEBUG_METHOD(@"--健康实时同步数据返回--");
        [self wbSendSuccessACKData];
        NSData *data = [NSData dataWithBytes:l2Packet length:length];
        if (data.length >= 5)
        {
            Byte byte[5] = {0};
            [data getBytes:byte range:NSMakeRange(data.length-5, 5)];
            NSData *rtData = [NSData dataWithBytes:&byte length:5];
            st_dispatch_async_main(^{
                if (_syncDataHandler) {
                    _syncDataHandler(FCSyncTypeOpenRealtimeSync,rtData);
                }
            });
        }
    }
    else if (l2PayloadKey == KEY_SPORTS_HISTORY_DATA_RSP)
    {
        DEBUG_METHOD(@"--历史数据返回--");
        
        [self wbSendSuccessACKData];
        _historyDataLength = ((l2Packet[1] & 1) << 8) + l2Packet[2];
        DEBUG_METHOD(@"-数据长度-%@",@(_historyDataLength));
        
        NSData *syncData = [NSData dataWithBytes:l2Packet+L2_PAYLOAD_HEADER_SIZE length:length-L2_PAYLOAD_HEADER_SIZE];
        if (syncData && syncData.length > 0)
        {
            [self.historyData appendData:syncData];
        }
        // 每一包数据回来重新设置一次15s超时
        [self scheduledTimerWithTimeInterval:15 andSelector:@selector(syncTimeOut)];
        
    }
    else if (l2PayloadKey == KEY_SPORTS_HISTORY_DATA_SYNC_BEG)
    {
        DEBUG_METHOD(@"--数据同步开始--");
        [self wbSendSuccessACKData];
        
        _historyDataLength = 0;
        [self.historyData resetBytesInRange:NSMakeRange(0, self.historyData.length)];
        [self.historyData setLength:0];
    }
    else if (l2PayloadKey == KEY_SPORTS_HISTORY_DATA_SYNC_END)
    {
        [self cancelScheduledTimer];
        UInt32 totalLength = (l2Packet[3] << 24) + (l2Packet[4] << 16 ) + (l2Packet[5] << 8) + l2Packet[6];
        DEBUG_METHOD(@"-历史数据同步结束[%@]--数据长度[%d]",@(_syncType),(unsigned int)totalLength);
        if (totalLength == _historyDataLength)
        {
            [self wbSuccessSyncHistoryACKData];
            DEBUG_METHOD(@"长度校验成功,回复同步成功");
            
            WS(ws);
            FCSyncType tmpSyncType = _syncType;
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                    _syncDataResultHandler(ws.historyData, tmpSyncType, FCSyncResponseStateSuccess);
                }
            });
        }
        else
        {
            DEBUG_METHOD(@"长度校验失败，回复同步失败");
            [self wbErrorSyncHistoryACKData];
            FCSyncType tmpSyncType = _syncType;
            _syncType = FCSyncTypeEnd;
            st_dispatch_async_main(^{
                if (_syncDataResultHandler) {
                     _syncDataResultHandler(nil,tmpSyncType, FCSyncResponseStateError);
                }
            });
        }
    }
}

#pragma mark - 控制命令返回

- (void)wbRxParseDefaultData:(Byte *)l2Packet andLength:(int)length
{
    [self wbSendSuccessACKData];
    Byte l2PayloadKey = l2Packet[0];
    if (l2PayloadKey == 0x01)
    {
        DEBUG_METHOD(@"--相机控制命令返回--");
        st_dispatch_async_main(^{
            if (_takePicturesBlock) {
                _takePicturesBlock();
            }
        });
    }
}


#pragma mark - 固件升级代理

- (void)onReadFwVersion:(UInt16)version
{
    DEBUG_METHOD(@"%s: %d", __FUNCTION__, version);
}

- (void)onOTAFinishedWithStatus:(UInt8)status
{
    DEBUG_METHOD(@"%s: %d", __FUNCTION__, status);
    _syncType = FCSyncTypeEnd;
    
    FCSyncResponseState state = (status == 0x01 ? FCSyncResponseStateSuccess : FCSyncResponseStateError);
    st_dispatch_async_main(^{
        if (_syncResultHandler) {
            _syncResultHandler(FCSyncTypeFirmwareUpgrade,state);
        }
    });
}

- (void)onGetFileVersion:(UInt16)version andSize:(UInt64)fileSize
{
    DEBUG_METHOD(@"%s: %d, %llu", __FUNCTION__, version, fileSize);
}

- (void)onSendAUnit:(UInt64)totalSendSize andFileSize:(UInt64)fileSize
{
    DEBUG_METHOD(@"progress: %llu/%llu", totalSendSize, fileSize);
    st_dispatch_async_main(^{
        CGFloat progress = (float)totalSendSize/fileSize;
        if (_progressHandler) {
            _progressHandler(progress);
        }
    });
}




#pragma mark - 同步超时

- (void)syncTimeOut
{
    DEBUG_METHOD(@"--同步超时--%@",@(_syncType));
    _nextRxDataBytes = 0;
    [self.receiveData resetBytesInRange:NSMakeRange(0, self.receiveData.length)];
    [self.receiveData setLength:0];
    
    [self endSyncWithResponseState:FCSyncResponseStateTimeOut];
}


- (void)endSyncWithResponseState:(FCSyncResponseState)state
{
    [self cancelScheduledTimer];
    if (_syncType == FCSyncTypeEnd) {
        return;
    }
    
    FCSyncType tmpSyncType = _syncType;
    _syncType = FCSyncTypeEnd;
    
    st_dispatch_async_main(^{
        
        if (tmpSyncType == FCSyncTypeGetWatchConfig ||
            tmpSyncType == FCSyncTypeGetAlarmList ||
            tmpSyncType == FCSyncTypeGetBatteryLevelAndState ||
            tmpSyncType == FCSyncTypeGetFirmwareVersion ||
            tmpSyncType == FCSyncTypeGetDayTotalData ||
            tmpSyncType == FCSyncTypeGetExerciseData ||
            tmpSyncType == FCSyncTypeGetSleepData ||
            tmpSyncType == FCSyncTypeGetBloodOxygenData ||
            tmpSyncType == FCSyncTypeGetBloodPressureData ||
            tmpSyncType == FCSyncTypeGetBreathingRateData ||
            tmpSyncType == FCSyncTypeGetHeartRateData ||
            tmpSyncType == FCSyncTypeGetUltravioletData ||
            tmpSyncType == FCSyncTypeGetSevenDaysSleepData)
        {
            if (_syncDataResultHandler) {
                _syncDataResultHandler(nil, tmpSyncType, state);
            }
        }
        else
        {
            if (_syncResultHandler) {
                _syncResultHandler(tmpSyncType, state);
            }
        }
    });
}

#pragma mark - 定时器调度

- (void)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval andSelector:(SEL)selector
{
    st_dispatch_async_main(^{
        if (_syncTimeoutTimer) {
            [_syncTimeoutTimer invalidate];
            _syncTimeoutTimer = nil;
        }
        _syncTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:selector userInfo:nil repeats:NO];
    });
}

- (void)cancelScheduledTimer
{
    st_dispatch_async_main(^{
        if (_syncTimeoutTimer) {
            [_syncTimeoutTimer invalidate];
            _syncTimeoutTimer = nil;
        }
    });
}

- (void)cancelAllTimers
{
    st_dispatch_async_main(^{
        if (_syncTimeoutTimer)
        {
            [_syncTimeoutTimer invalidate]; _syncTimeoutTimer = nil;
        }
        if (_realtimeSyncTimeoutTimer)
        {
            [_realtimeSyncTimeoutTimer invalidate]; _realtimeSyncTimeoutTimer = nil;
        }
        
        if (_firmwareUpgradeTimer)
        {
            [_firmwareUpgradeTimer invalidate]; _firmwareUpgradeTimer = nil;
        }
    });
}

#pragma mark - 历史数据同步回复

- (void)wbSuccessSyncHistoryACKData
{
    Byte byte = 0x00;
    NSData *payload = [NSData dataWithBytes:&byte length:1];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:KEY_SPORTS_HISTORY_SYNC_RESULT_RSP l2Payload:payload];
    [self sendPacketDataWithResponse:data];
}


- (void)wbErrorSyncHistoryACKData
{
    Byte byte = 0x01;
    NSData *payload = [NSData dataWithBytes:&byte length:1];
    NSData *data = [self wbDataWithSequenceId:_txSequenceId command:CMD_SPORTS key:KEY_SPORTS_HISTORY_SYNC_RESULT_RSP l2Payload:payload];
    [self sendPacketDataWithResponse:data];
}


#pragma mark - 协议数据包

- (NSData*)wbDataWithSequenceId:(UInt16)sequenceId command:(Byte)commandId key:(Byte)key l2Payload:(NSData*)data
{
    // 分配L1header和 L2packet长度的内存
    UInt32 l1PayloadLength = (UInt32)(L2_FIRST_VALUE_POS + data.length);
    
    Byte *packet = (Byte*)malloc(L1_HEADER_SIZE + l1PayloadLength);
    // L1 Magic
    packet[L1_HEADER_MAGIC_POS] = 0xAB;
    // L1 r + e + a + v
    packet[L1_HEADER_PROTOCOL_VERSION_POS] = 0x00;
    
    // l1 payload length 16bits
    packet[L1_PAYLOAD_LENGTH_HIGH_BYTE_POS] = (l1PayloadLength >> 8) & 0xFF;
    packet[L1_PAYLOAD_LENGTH_LOW_BYTE_POS] = l1PayloadLength & 0xFF;
    
    // l1 sequence id 16bits
    packet[L1_HEADER_SEQ_ID_HIGH_BYTE_POS] = (sequenceId >> 8) & 0XFF;
    packet[L1_HEADER_SEQ_ID_LOW_BYTE_POS] = sequenceId & 0XFF;
    
    if (l1PayloadLength == 0)
    {
        packet[L1_HEADER_CRC16_HIGH_BYTE_POS] = 0;
        packet[L1_HEADER_CRC16_LOW_BYTE_POS] = 0;
    }
    else
    {
        // l2 packet
        // command id
        packet[L1_HEADER_SIZE] = commandId;
        // version + reversion << 4
        packet[L1_HEADER_SIZE + 1] = 0;
        // l2 key
        packet[L1_HEADER_SIZE + L2_HEADER_SIZE] = key;
        // l2 key header (7 r + 9 kvl)
        
        UInt32 l2payloadLength = (UInt32)data.length;
        packet[L1_HEADER_SIZE + L2_HEADER_SIZE + 1] = (l2payloadLength >> 8) & 0x1;
        packet[L1_HEADER_SIZE + L2_HEADER_SIZE + 2] = l2payloadLength & 0xFF;
        
        if (l2payloadLength  > 0)
        {
            // 将l2负载拷贝到l1packet
            memcpy(packet + L1_PACKET_PRE_SIZE, [data bytes], l2payloadLength);
        }
        // 对l1payload进行crc16校验
        UInt16 crc16 = [self crc16:0 andByte:packet + L1_HEADER_SIZE andLength:l1PayloadLength];
        packet[L1_HEADER_CRC16_HIGH_BYTE_POS] = ( crc16 >> 8 ) & 0xff;
        packet[L1_HEADER_CRC16_LOW_BYTE_POS] = crc16 & 0xff;
    }
    NSData *packetData = [NSData dataWithBytes:(const void*)packet length:l1PayloadLength + L1_HEADER_SIZE];
    free(packet);
    return packetData;
}

// crc16
- (UInt16)crc16:(uint16_t)crc andByte:(uint8_t*)buffer andLength:(uint16_t)len
{
    while (len--) {
        crc = (crc >> 8) ^ fc_crc16_table[(crc ^ *buffer++) & 0xff];
    }
    return crc;
}


#pragma mark - 发送回复

- (void)wbSendSuccessACKData
{
    DEBUG_METHOD(@"--%s--",__FUNCTION__);
    Byte packet[8] = {0xAB, 0x10, 00, 00, 00, 00, (_rxSequenceID >> 8) & 0XFF, _rxSequenceID & 0XFF};
    NSData *packetData = [NSData dataWithBytes:packet length:sizeof(packet)];
    [self sendPacketDataWithResponse:packetData];
}

- (void)wbSendErrorACKData
{
    DEBUG_METHOD(@"--%s--",__FUNCTION__);
    Byte packet[8] = {0xAB, 0x30, 00, 00, 00, 00, (_rxSequenceID >> 8 ) & 0XFF, _rxSequenceID & 0XFF};
    NSData *packetData = [NSData dataWithBytes:packet length:sizeof(packet)];
    [self sendPacketDataWithResponse:packetData];
}


- (void)sendPacketDataWithResponse:(NSData*)data
{
    if (!data || !self.servicePeripheral || !self.wirteCharacteristic) {
        NSLog(@"发送参数错误");
        return;
    }
    DEBUG_METHOD(@"--data--%@",data);
    NSUInteger location = 0;
    NSUInteger length = data.length;
    while (location < length)
    {
        NSUInteger packetLen = location + KPackageNum < length ? KPackageNum : length - location;
        
        Byte buffer[packetLen];
        [data getBytes:&buffer range:NSMakeRange(location, packetLen)];
        NSData *subPacketData = [NSData dataWithBytes:buffer length:sizeof(buffer)];
        
        [self.servicePeripheral writeValue:subPacketData forCharacteristic:self.wirteCharacteristic type:CBCharacteristicWriteWithResponse];
        
        location += packetLen;
        // 每隔60ms放一包数据
        [NSThread sleepForTimeInterval:0.06f];
    }
}

#pragma mark - 同步log
- (void)logSycnCallBack:(FCSyncType)type
{
    if (type == FCSyncTypeSetAlarmData) {
        DEBUG_METHOD(@"--闹钟设置返回--");
    }
    else if (type == FCSyncTypeSetScreenDisplay)
    {
        DEBUG_METHOD(@"--手表显示设置返回--");
    }
    else if (type == FCSyncTypeUpdateWatchTime)
    {
        DEBUG_METHOD(@"--更新系统时间返回--");
    }
    else if (type == FCSyncTypeSetFeatures)
    {
        DEBUG_METHOD(@"--手环功能开关设置返回--");
    }
    else if (type == FCSyncTypeSetANCSLanguage)
    {
        DEBUG_METHOD(@"--ancs语言同步返回--");
    }
    else if (type == FCSyncTypeSetNotification)
    {
        DEBUG_METHOD(@"--消息通知开关设置返回--");
    }
    else if (type == FCSyncTypeSetSedentaryReminder)
    {
        DEBUG_METHOD(@"--久坐提醒设置返回--");
    }
    else if (type == FCSyncTypeSetHealthMonitoring)
    {
        DEBUG_METHOD(@"--健康实时监测设置返回--");
    }
    else if (type == FCSyncTypeSetDrinkReminder)
    {
        DEBUG_METHOD(@"--喝水提醒设置返回--");
    }
    else if (type == FCSyncTypeSetWearingStyle)
    {
        DEBUG_METHOD(@"--左右手佩戴设置返回--");
    }
    else if (type == FCSyncTypeSetCameraState)
    {
        DEBUG_METHOD(@"--相机应用状态返回--");
    }
    else if (type == FCSyncTypeSetDefaultBloodPressure)
    {
        DEBUG_METHOD(@"--默认血压设置返回--");
    }
    else if (type == FCSyncTypeUpdateWeather)
    {
        DEBUG_METHOD(@"--天气设置返回--");;
    }
    else if (type == FCSyncTypeSetUserProfile)
    {
        DEBUG_METHOD(@"--用户资料设置返回--");
    }
    else if (type == FCSyncTypeFindTheWatch)
    {
        DEBUG_METHOD(@"--查找手环返回--");
    }
    else if (type == FCSyncTypeCloseRealtimeSync)
    {
        DEBUG_METHOD(@"--关闭心率实时同步--");
    }
    else if (type == FCSyncTypeOpenRealtimeSync)
    {
        DEBUG_METHOD(@"--打开健康实时同步--");
    }
    else if (type == FCSyncTypeFoundPhoneReplay)
    {
        DEBUG_METHOD(@"--找到了手机同步返回--");
    }
}

#pragma mark - Getter

- (NSMutableData*)receiveData
{
    if (_receiveData) {
        return _receiveData;
    }
    _receiveData = [[NSMutableData alloc]init];
    return _receiveData;
}

- (NSMutableData*)historyData
{
    if (_historyData) {
        return _historyData;
    }
    _historyData = [[NSMutableData alloc]init];
    return _historyData;
}

- (NSMutableArray*)peripheralsArray
{
    if (_peripheralsArray) {
        return _peripheralsArray;
    }
    _peripheralsArray = [[NSMutableArray alloc]init];
    return _peripheralsArray;
}

- (CBCentralManager*)centralManager
{
    if (_centralManager) {
        return _centralManager;
    }
    NSString *queueName = NSStringFromClass([self class]);
    dispatch_queue_t queue = dispatch_queue_create([queueName UTF8String], NULL);
    _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:queue];
    _centralManager.delegate = self;
    return _centralManager;
}

@end

