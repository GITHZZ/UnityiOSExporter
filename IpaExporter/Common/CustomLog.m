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

void lua_show_log(const char *s)
{
    showLog(@"*Lua:%@", [NSString stringWithUTF8String:s]);
}

void lua_show_error(const char *s)
{
    showError(@"*Lua:%s", s);
}
