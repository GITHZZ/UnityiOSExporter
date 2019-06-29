//
//  EventType.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/2/9.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#ifndef EventType_h
#define EventType_h

typedef NS_ENUM(int, EventType){
    
    //通用模块
    EventAddNewInfoContent       = 111,
    EventAddErrorContent         = 112,
    EventAddNewSuccessContent    = 118,
    EventAddNewWarningContent    = 119,
    EventCleanInfoContent        = 120,
    
    //应用层面模块，想办法拆出去
    EventViewMainLoaded          = 200,
    EventViewSureClicked         = 201,
    EventUnityPathSelect         = 202,
    EventUnityPathSelectEnd      = 203,
    EventExportPathSelectEnd     = 204,
    EventDevelopProfileSelectEnd = 205,
    EventDetailsInfoSettingClose = 206,
    EventDetailsInfoAdd          = 207,
    EventDetailsInfoRemove       = 208,
    EventDetailsInfoUpdate       = 209,
    EventSelectCopyDirPath       = 210,
    EventDetailsInfoSettingEdit  = 213,
    EventSetExportButtonState    = 214,
    EventScenePathSelectEnd      = 215,
    EventStartRecordTime         = 216,
    EventStopRecordTime          = 217,
};


#endif /* EventType_h */
