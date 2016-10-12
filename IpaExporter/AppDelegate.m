//
//  AppDelegate.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/8/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "AppDelegate.h"
#import "EventManager.h"
#import "LuaCammond.h"
#import "ViewMain.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //init
    [[LuaCammond instance] startUp];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:@"/Users/apple/Documents/Xcode Project/IpaExporter/IpaExporter/Data_t/Templete_t/Builder_t.cs"];
    NSData* contentData = [fileHandle readDataToEndOfFile];
    NSString* contentStr = [NSString stringWithUTF8String:[contentData bytes]];
    NSArray *lines=[contentStr componentsSeparatedByString:@"\n"];
    NSEnumerator *iter=[lines objectEnumerator];

    NSString* result = [[NSString alloc] init];
    NSString* line;
    while (line=[iter nextObject])
    {
        NSString* changeStr = [line stringByReplacingOccurrencesOfString:@"${bundleIdentifier}" withString:@"\"com.4399sy.zzsj.online\""];
        result = [result stringByAppendingFormat:@"%@\n", changeStr];
        //NSLog(@"===%@",line);
    }
    
    NSLog(@"%@", result);
    [fileHandle closeFile];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
}
@end
