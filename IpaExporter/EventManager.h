//
//  EventManager.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/8.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, EventType){
    EventViewMainLoaded  = 0,
    
    //view 
    EventViewSureClicked         = 101,
    EventUnityPathSelect         = 102,
    EventUnityPathSelectEnd      = 103,
    EventExportPathSelectEnd     = 104,
    EventDevelopProfileSelectEnd = 105,
    EventDetailsInfoSettingClose = 106,
};

@interface EventManager : NSObject

+ (id)instance;

- (void)regist:(EventType)eventType
          func:(SEL)func
      withData:(id)obj
          self:(id)s;

- (void)unRegist:(EventType)eventType self:(id)s;
- (void)send:(EventType)eventType withData:(id)obj;

@end
