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
typedef void (^FCStepCallbackHandler)(NSInteger syncType);




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
 同步结果回掉，如果state是<i>FCSyncResponseStateSuccess</i>，则同步正确，并返回data。
 注：部分同步入同步运动数据等同步成功，如果没有运动记录，data为空

 @param data 同步数据回掉
 @param syncType 当前同步类型
 @param state 同步响应状态
 */
typedef void (^FCSyncDataResultHandler)(NSData *data, FCSyncType syncType, FCSyncResponseState state);




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


#endif /* FitCloudBlock_h */
