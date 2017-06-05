//
//  FitCloudBlock.h
//  FitCloud
//
//  Created by 远征 马 on 2016/11/7.
//  Copyright © 2016年 马远征. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FCDefine.h"


#ifndef FitCloudBlock_h
#define FitCloudBlock_h


/**
 同步类型回调block

 @param syncType 同步类型，查看<i>FCDefine</i>类型定义
 */
typedef void (^FCStepCallbackHandler)(FCSyncType syncType);


/**
 登录结果回调block
 
 @param syncType 手表当前同步类型，此处为登录
 @param loginSyncType 当前登录同步子类型
 @param state 登录同步响应结果
 */
typedef void (^FCLoginResultHandler)(FCSyncType syncType, FCLoginSyncType loginSyncType, FCSyncResponseState state);


/**
 绑定结果回调block
 
 @param syncType 手表当前同步类型
 @param bindSyncType 当前绑定同步子类型
 @param state 绑定状态回调
 */
typedef void (^FCBindResultHandler)(FCSyncType syncType, FCBindSyncType bindSyncType, FCSyncResponseState state);

/**
 历史数据同步回调block

 @param syncType 数据同步类型
 @param hdSyncType 历史数据同步类型
 @param data 历史数据
 */
typedef void (^FCHistoryDataHandler)(FCSyncType syncType, FCHistoryDataSyncType hdSyncType, NSData *data);

/**
 历史数据同步结果回调

 @param syncType 数据同步类型
 @param hdSyncType 历史数据同步类型
 @param state 历史数据同步结果状态
 */
typedef void (^FCHistoryDataResultHandler)(FCSyncType syncType, FCHistoryDataSyncType hdSyncType, FCSyncResponseState state);

/**
 处理进入回调block

 @param progress 进度值,0.0-1.0之间的浮点数
 */
typedef void (^FCProgressHandler)(CGFloat progress);

/**
 此block返回当前正在同步的数据记录数量

 @param count 已经同步的数据记录数量
 */
typedef void (^FCSyncCountHandler) (UInt16 count);

/**
 此block返回当前同步的类型和同步到的数据，如果没有数据返回，此block不会被调用

 @param syncType 手表同步类型
 @param data 同步到的数据
 @see FCSyncType
 */
typedef void (^FCSyncDataHandler)(FCSyncType syncType, NSData *data);

/**
 同步完成后，此block返回当前正在同步的类型和同步响应结果。如果状态是<i>FCSyncResponseStateSuccess</i>，则意味着同步正确完成。

 @param syncType 当前同步的类型
 @param state 同步响应结果
 @see FCSyncType
 @see FCSyncResponseState
 */
typedef void (^FCSyncResultHandler)(FCSyncType syncType, FCSyncResponseState state);


/**
 外设回调block，返回当前扫描到的外设和所有扫描的外设列表，当有新外设被扫描到，此block会被调用

 @param retArray 一组 <i>CBPeripheral</i> 对象
 @param aPeripheral 当前被扫描到的外设
 */
typedef void (^FCPeripheralsHandler)(NSArray<CBPeripheral*>*retArray, CBPeripheral *aPeripheral);


/**
 实时同步数据回调block

 @param data 健康实时同步数据
 */
typedef void (^FCRTSyncDataHandler)(NSData *data);


/**
 电池电量和充电状态回调block

 @param powerValue 电池电量百分比
 @param chargingState 充电状态
 */
typedef void (^FCSyncBatteryLevelAndStateHandler)(UInt8 powerValue, UInt8 chargingState);

#endif /* FitCloudBlock_h */
