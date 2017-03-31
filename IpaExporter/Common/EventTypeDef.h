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
    EventViewMainLoaded  = 0,
    
    EventViewSureClicked         = 101,
    EventUnityPathSelect         = 102,
    EventUnityPathSelectEnd      = 103,
    EventExportPathSelectEnd     = 104,
    EventDevelopProfileSelectEnd = 105,
    EventDetailsInfoSettingClose = 106,
    EventDetailsInfoAdd          = 107,
    EventDetailsInfoRemove       = 108,
    EventDetailsInfoUpdate       = 109,
    EventSelectCopyDirPath       = 110,
    EventAddNewInfoContent       = 111,
    EventAddErrorContent         = 112,
    EventDetailsInfoSettingEdit  = 113,
    EventSetExportButtonState    = 114,
    EventScenePathSelectEnd      = 115,
};


#endif /* EventType_h */
