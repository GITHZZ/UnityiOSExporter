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
typedef NS_ENUM(EventType, EventTypeCommon)
{
    //通用模块
    EventAddNewInfoContent = 10000,
    EventAddErrorContent,
    EventAddNewSuccessContent,
    EventAddNewWarningContent,
    EventCleanInfoContent,                                     
};

#endif /* EventType_h */
