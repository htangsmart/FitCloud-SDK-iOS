//
//  FCProtocol.h
//  FitCloud
//
//  Created by 远征 马 on 16/9/5.
//  Copyright © 2016年 远征 马. All rights reserved.
//


/**
 *  FitCloud SDK 协议数据类型定义
 */

#ifndef FCProtocol_h
#define FCProtocol_h


#define L1_HEADER_MAGIC (0xAB) /* L1 Magic Byte (8bits)*/
#define L1_HEADER_VERSION (0X00) /* L1 protocal version*/
#define L1_HEADER_SIZE (8) /* L1 header length*/

/***********************************************************
 * L1 header byte
 ***********************************************************/
#define L1_HEADER_MAGIC_POS             (0)

#define L1_HEADER_PROTOCOL_VERSION_POS  (1)

// Payload Length
#define L1_PAYLOAD_LENGTH_HIGH_BYTE_POS (2)
#define L1_PAYLOAD_LENGTH_LOW_BYTE_POS  (3)

// CRC16
#define L1_HEADER_CRC16_HIGH_BYTE_POS   (4)
#define L1_HEADER_CRC16_LOW_BYTE_POS    (5)

// Sequence id
#define L1_HEADER_SEQ_ID_HIGH_BYTE_POS  (6)
#define L1_HEADER_SEQ_ID_LOW_BYTE_POS   (7)


/**************************************************************************
 * define L2 header byte order
 ***************************************************************************/
#define L2_HEADER_SIZE   (2)      /*L2 header length*/
#define L2_PAYLOAD_HEADER_SIZE (3)        /*L2 payload header*/
#define L2_HEADER_VERSION (0x00)     /*L2 header version*/
#define L2_KEY_SIZE         (1)
#define L2_FIRST_VALUE_POS (L2_HEADER_SIZE + L2_PAYLOAD_HEADER_SIZE)
#define L1_PACKET_PRE_SIZE   (L1_HEADER_SIZE+L2_FIRST_VALUE_POS)      /*L2 header length*/


typedef NS_ENUM(NSInteger, CommandID)
{
    CMD_UPDATE = 0x01, // 固件升级
    CMD_SETTING = 0x02, // 设置命令
    CMD_BOND_REG = 0x03, // 绑定命令
    CMD_NOTIFY = 0x04, // 提醒命令
    CMD_SPORTS = 0x05, // 运动数据命令
    CMD_FACTORY = 0x06, // 工厂测试命令
    CMD_CTRL = 0x07, // 控制命令
    CMD_DUMP = 0x08, // dump stack 命令
    CMD_FLASH = 0x09, // 测试flash读取命令
    CMD_LOG = 0x0a, // 日志命令
};


// 固件升级
typedef NS_ENUM(NSInteger, KEY_FIRMWARE_UPDATE)
{
    KEY_FIRMWARE_UPDATE_REQUEST = 0x1, // 进入固件升级模式请求
    KEY_FIRMWARE_UPDATE_RESPONSE = 0x2, // 进入固件升级模式返回
};

// 绑定key
typedef NS_ENUM(NSInteger, KEY_BOND)
{
    KEY_BOND_REQ = 0x01, // 绑定用户请求
    KEY_BOND_RSP = 0x02, // 绑定用户请求返回
    KEY_LOGIN_REQ = 0x03, // 用户登录请求
    KEY_LOGIN_RSP = 0x04, // 用户登录返回
    KEY_UNBOND_REQ = 0x05, // 用户解除绑定
    KEY_SUP_BOND_KEY = 0x06, // 超级绑定key
    KEY_SUP_BOND_KEY_RSP = 0x07, // 超级绑定返回key
    KEY_UNBOND_RSP = 0x08, // 用户解除绑定返回
};

// 绑定状态
typedef NS_ENUM(NSInteger, BOND_STATUS_RETURN)
{
    BOND_STATUS_SUCCESS = 0,
    BOND_STATUS_FAIL = 1,
};

// 设置命令
typedef NS_ENUM(NSInteger, KEY_SETTING)
{
    KEY_SETTING_TIMER = 0x01,
    KEY_SETTING_SET_ALARM_DATA = 0x02, // 设置闹钟数据
    KEY_SETTING_GET_ALARM_LIST_REQ = 0x03, // 获取设备闹钟列表请求
    KEY_SETTING_GET_ALARM_LIST_RSP = 0x04, // 获取设备闹钟列表返回
    KEY_SETTING_SET_USER_PROIFLE = 0x10, // 用户资料设置
    KEY_SETTING_FW_VERSION_REQ = 0x11, // 手环软硬件版本信息请求
    KEY_SETTING_FW_VERSION_RSP = 0x12, // 手环软硬件版本信息返回
    KEY_SETTING_POWER_AND_CHARGING_REQ = 0x14, // 电量和充电状态请求
    KEY_SETTING_POWER_AND_CHARGING_RSP = 0x15, // 电量和充电状态响应
    KEY_SETTING_SET_DISPLAY_DATA = 0x18, // 手表显示设置
    KEY_SETTING_SET_FUNCTION_SWITCH_DATA = 0x1b, // 手表功能开关设置
    KEY_SETTING_SET_HEALTH_MONITOR_DATA = 0x1c, // 健康实时监测
    KEY_SETTING_SET_DRINK_REMIND_DATA = 0x1d, // 喝水提醒
    KEY_SETTING_ALL_SETTING_RSP = 0x1e, // 手环所有设置请求
    KEY_SETTING_ALL_SETTING_REQ = 0x1f, // 手环所有设置返回
    KEY_SETTING_SET_LONGSIT_DATA = 0x21, // 久坐提醒
    KEY_SETTING_SET_WEARING_STYLE = 0x22, // 穿戴方式
    KEY_SETTING_DEFAULT_BLOOD_PRESSURE = 0x26, // 默认血压设置
    KEY_SETTING_FIND_YOUR_PHONE = 0x2a, // 查找手机
    KEY_SETTING_FIND_WRISTBAND = 0x27, // 查找手环
    KEY_SETTING_SET_NOTIFICATION_DATA = 0x30, // 消息通知开关设置
};


// 运动同步
typedef NS_ENUM(NSInteger, KEY_SPORTS)
{
    KEY_SPORTS_HISTORY_DATA_SYNC_BEG = 0x07, // 历史数据同步开始
    KEY_SPORTS_HISTORY_DATA_SYNC_END = 0x08, // 历史数据同步结束
    KEY_SPORTS_REALTIME_SYNC_DATA_RSP = 0x15, // 实时同步返回
    KEY_SPORTS_HISTORY_SYNC_RESULT_RSP = 0x20,// 历史数据同步结果返回
    KEY_SPORTS_DAILY_TOTAL_DATA_REQ = 0x21, // 请求当天运动总数据
    KEY_SPORTS_DAILY_TOTAL_DATA_RSP = 0x22, // 请求当天运动总数据返回
    KEY_SPORTS_HISTORY_DATA_RSP = 0x30, // 历史数据返回key
};


typedef struct _L1_HEADER
{
    UInt8  magicByte;  //0xab
    UInt8  reserve:2;
    UInt8  errFlag:1;
    UInt8  ackFlag:1;
    UInt8  version:4;
    UInt16 payloaddLength;
    UInt16 crc16;
    UInt16 seqID;
}L1_HEADER;

typedef struct _L1_PACKET
{
    L1_HEADER l1Header;
    UInt8 l1Payload[0];  //----> l2PACKAT
}L1_PACKET;


typedef struct _SET_LONG_SIT
{
    UInt8 reserve;
    UInt8 onOff;
    UInt16 threshold;
    UInt8 sitTime;    //单位是分钟
    UInt8 startTime;  //单位是小时
    UInt8 endTime;    //单位是小时
    UInt8 dayFlags;
}SET_LONG_SIT;


//  L2 header = cmdid(8bit) + L2version(4bit) + reserve(4bit)
//  L2 payload = key(1Byte) + key header(2Byte) + key value (N byte)
//key header = reserve(7bit) + key value length(9bit)

typedef struct _L2_HEADER
{
    UInt8 cmdID;
    UInt8  version:4;
    UInt8  reserve:4;
}L2_HEADER;


typedef struct _L2_PACKET
{
    L2_HEADER l2Header;
    UInt8 l2Payload[0];
}L2_PACKET;

typedef struct _L2_PAYLOAD_PRE
{
    UInt8 key;
    //    struct _KEY_HEADER
    //    {
    //        UInt16 reserve:7;
    //        UInt16 key_value_length:9;
    //    }
    UInt16 keyHeader;
}L2_PAYLOAD_PRE;
#endif /* FCProtocol_h */
