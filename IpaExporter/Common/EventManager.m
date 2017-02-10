//
//  EventManager.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/8.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager

+ (id)instance
{
    static EventManager* s_instance = nil;
    if(nil == s_instance)
    {
        @synchronized (self)
        {
            if(nil == s_instance)
                s_instance = [[self alloc] init];
        }
    }
    return s_instance;
}

- (void)regist:(EventType)eventType
          func:(SEL)func
      withData:(id)obj
          self:(id)s
{
    [[NSNotificationCenter defaultCenter] addObserver:s
                                             selector:func
                                                 name:[NSString stringWithFormat:@"%d", eventType]
                                               object:obj];
}

- (void)unRegist:(EventType)eventType self:(id)s
{
    [[NSNotificationCenter defaultCenter] removeObserver:s
                                                    name:[NSString stringWithFormat:@"%d",eventType]
                                                  object:nil];
}

- (void)send:(EventType)eventType withData:(id)obj
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%ld", (long)eventType]
                                                        object:obj];
    
}

@end
