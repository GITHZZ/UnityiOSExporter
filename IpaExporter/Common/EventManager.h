//
//  EventManager.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/8.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTypeDef.h"

#define EVENT_REGIST(eventType, selector) \
    [[EventManager instance] regist:eventType func:selector self:self];
#define EVENT_UNREGIST(eventType) \
    [[EventManager instance] unRegist:eventType self:self];
#define EVENT_SEND(eventType, data) \
    [[EventManager instance] send:eventType withData:data];

@interface EventManager : NSObject

+ (instancetype)instance;

- (void)regist:(EventType)eventType func:(SEL)func self:(id)s;
- (void)unRegist:(EventType)eventType self:(id)s;
- (void)send:(EventType)eventType withData:(id)obj;

@end
