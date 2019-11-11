//
//  AppDelegate.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/8/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>

#import "AppMain.h"
#import "Defs.h"
#import "LogicManager.h"

int printf(const char * __restrict format, ...)
{
    va_list args;
    va_start(args, format);
    NSLogv([NSString stringWithUTF8String:format], args);
    va_end(args);
    return 1;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        if(![[NSFileManager defaultManager] fileExistsAtPath:SETTING_FOLDER]){
            [[NSFileManager defaultManager] createDirectoryAtPath:SETTING_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [[LogicManager defaultManager] startUp];
        
        return NSApplicationMain(argc, argv);
    }
}

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[LogicManager defaultManager] applicationDelegateCallBack:ApplicationWillFinishLaunching withNotification:notification];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[LogicManager defaultManager] applicationDelegateCallBack:ApplicationDidFinishLaunching withNotification:aNotification];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[LogicManager defaultManager] applicationDelegateCallBack:ApplicationWillTerminate withNotification:aNotification];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [[LogicManager defaultManager] applicationDelegateCallBack:ApplicationDidBecomeActive withNotification:notification];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[LogicManager defaultManager] applicationDelegateCallBack:ApplicationWillResignActive withNotification:notification];
}

@end
