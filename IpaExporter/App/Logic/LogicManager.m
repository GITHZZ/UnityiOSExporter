//
//  LogicMain.m
//  IpaExporter
//
//  Created by 4399 on 8/4/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "LogicManager.h"

@implementation LogicManager

+ (instancetype)defaultInstance
{
    Class cls = [self class];
    //动态去取属性方法
    id instance = objc_getAssociatedObject(cls, @"instance");
    if(!instance)
    {
        instance = [[self allocWithZone:NULL] init];
        objc_setAssociatedObject(cls, @"instance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instance;
}

- (void)startUp
{
    _instanceArray = @[[[CodeTester alloc] init],
                       [[PackCammond alloc] init],
                       [[ExportInfoManager alloc] init],
                       [[DataResManager alloc] init],
                       [[BuilderCSFileEdit alloc] init],
                       [[PreferenceData alloc] init],
                       [[VersionInfo alloc] init]];
}

- (id)getInstByClassName:(NSString*)className
{
    for (int i = 0; i < [_instanceArray count]; i++) {
        NSObject* item = _instanceArray[i];
        if([[item className] isEqualToString:className])
            return item;
    }
    return nil;
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    //inst_method_call(@"PreferenceData", backUpCustomCode);
}

@end
