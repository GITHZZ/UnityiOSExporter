//
//  EventManager.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/8.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTypeDef.h"

@interface EventManager : NSObject

+ (id)instance;

- (void)regist:(EventType)eventType
          func:(SEL)func
      withData:(id)obj
          self:(id)s;

- (void)unRegist:(EventType)eventType self:(id)s;
- (void)send:(EventType)eventType withData:(id)obj;

@end
