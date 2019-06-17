//
//  EventManager.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/8.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTypeDef.h"
#import "Singletion.h"

@interface EventManager : Singletion

- (void)regist:(EventType)eventType func:(SEL)func self:(id)s;
- (void)unRegist:(EventType)eventType self:(id)s;
- (void)send:(EventType)eventType withData:(id)obj;

@end
