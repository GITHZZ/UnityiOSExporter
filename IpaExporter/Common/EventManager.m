//
//  EventManager.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/8.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager


- (void)regist:(EventType)eventType func:(SEL)func self:(id)s
{
    [[NSNotificationCenter defaultCenter] addObserver:s
                                             selector:func
                                                 name:[NSString stringWithFormat:@"%d", eventType]
                                               object:nil];
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
