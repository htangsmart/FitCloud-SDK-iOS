//
//  GlobalDef.h
//  BleHub
//
//  Created by Tang on 15/3/24.
//  Copyright (c) 2015年 Tang. All rights reserved.
//

#ifndef RtkBand_GlobalDef_h
#define RtkBand_GlobalDef_h

#define SERVICE_LINK_LOSS       @"1803"
#define SERVICE_IMMEDIATE_ALERT @"1802"
#define SERVICE_TX_POWER        @"1804"
#define SERVICE_BATTERY         @"180F"
#define SERVICE_DEVICE_INFO     @"180A"
#define SERVICE_CURRENT_TIME    @"1805"
//#define SERVICE_DFU             @"8762"

#define SERVICE_DFU                     @"00006287-3C17-D293-8E48-14FE2E4DA212"
#define AN_DEVICE_DFU_DATA              @"00006387-3C17-D293-8E48-14FE2E4DA212"
///DFU Control Point
#define AN_DEVICE_FIRMWARE_UPDATE_CHAR  @"00006487-3C17-D293-8E48-14FE2E4DA212"

#define SERVICE_WRISTBAND2               @"000004ff-3C17-D293-8E48-14FE2E4DA212"
#define SERVICE_WRISTBAND               @"000001ff-3C17-D293-8E48-14FE2E4DA212"
#define WRISTBAND_CHAR_WRITE            @"ff02"
#define WRISTBAND_CHAR_NOTIFY           @"ff03"
#define WRISTBAND_CHAR_DEVICE_NAME      @"ff04"

//#define WRISTBAND_CHAR_DEBUG_CONTROL            @"ff07"
//#define WRISTBAND_CHAR_DEBUG_DATA           @"ff06"

#define SERVICE_OTA_INTERFACE           @"0000d0ff-3C17-D293-8E48-14FE2E4DA212"
#define CHAR_OTA_ENTER                  @"FFD1"
#define CHAR_OTA_BDADDR                 @"FFD2"
#define CHAR_OTA_PATCH_VERSION          @"FFD3"
#define CHAR_OTA_APP_VERSION            @"FFD4"


#define CHAR_ALERT_LEVEL                @"2A06"
#define CHAR_BATTERY_LEVEL              @"2A19"

#define CHAR_DI_SYS                     @"2A23"
#define CHAR_DI_MODEL                   @"2A24"
#define CHAR_DI_SERIAL                  @"2A25"
#define CHAR_DI_FW                      @"2A26"
#define CHAR_DI_HW                      @"2A27"
#define CHAR_DI_SW                      @"2A28"
#define CHAR_DI_MANU                    @"2A29"
#define CHAR_DI_IEEE                    @"2A2A"
#define CHAR_DI_PNP                     @"2A50"



#endif
