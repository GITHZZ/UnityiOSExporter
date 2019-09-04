//
//  NSViewController+LogicSupport.m
//  IpaExporter
//
//  Created by 4399 on 9/4/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "NSViewController+LogicSupport.h"
#import "EventManager.h"
#import "EventTypeDef.h"
#import "Defs.h"

@implementation NSViewController (LogicSupport)

- (void)onShow
{
    EVENT_SEND(EventViewDidAppear, self);
}

- (void)onHide
{
    EVENT_SEND(EventViewDidDisappear, self);
}

@end
