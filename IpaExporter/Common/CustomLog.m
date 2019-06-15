//
//  CustomLog.m
//  IpaExporter
//
//  Created by 何遵祖 on 2017/2/17.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventManager.h"
#import "Defs.h"

void show_log_sync_safe(EventType et, NSString* showString);

void showLog(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr =  [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    show_log_sync_safe(EventAddNewInfoContent, showStr);
}

void showError(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr =  [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    show_log_sync_safe(EventAddErrorContent, showStr);
}

void showWarning(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr =  [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    show_log_sync_safe(EventAddNewWarningContent, showStr);
}

void showSuccess(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr = [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    show_log_sync_safe(EventAddNewSuccessContent, showStr);
}

void show_log_sync_safe(EventType et, NSString* showString)
{
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        [[EventManager instance] send:et withData:showString];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[EventManager instance] send:et withData:showString];
        });
    }
}
