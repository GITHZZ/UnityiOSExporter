//
//  EventType.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/2/9.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#ifndef EventType_h
#define EventType_h

typedef int EventType;
typedef NS_ENUM(EventType, EventTypeCommon){
    
    //通用模块
    EventAddNewInfoContent       = 111,
    EventAddErrorContent         = 112,
    EventAddNewSuccessContent    = 118,
    EventAddNewWarningContent    = 119,
    EventCleanInfoContent        = 120,
};

#endif /* EventType_h */
