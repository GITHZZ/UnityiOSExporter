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

void showLog(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr =  [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EventManager instance] send:EventAddNewInfoContent withData:showStr];
    });
}

void showError(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr =  [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EventManager instance] send:EventAddErrorContent withData:showStr];
    });
}

void showSuccess(const char* content, ...)
{
    va_list ap;
    va_start(ap, content);
    NSString* contentStr = [NSString stringWithUTF8String:content];
    NSString* showStr = [[NSString alloc] initWithFormat:contentStr arguments:ap];
    va_end(ap);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EventManager instance] send:EventAddNewSuccessContent withData:showStr];
    });
}
