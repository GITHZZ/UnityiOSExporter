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

int main(int argc, const char * argv[])
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:SETTING_FOLDER]){
        [[NSFileManager defaultManager] createDirectoryAtPath:SETTING_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [[LogicManager defaultInstance] startUp];
    
    return NSApplicationMain(argc, argv);
}

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[LogicManager defaultInstance] applicationWillResignActive:notification];
}

@end
