//
//  LogicMain.h
//  IpaExporter
//
//  Created by 4399 on 8/4/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "PackCammond.h"
#import "ExportInfoManager.h"
#import "DataResManager.h"
#import "BuilderCSFileEdit.h"
#import "PreferenceData.h"
#import "VersionInfo.h"
#import "CodeTester.h"

#define get_instance(instanceName) [[LogicManager defaultInstance] getInstByClassName:instanceName];

#define inst_method_call(instanceName, methodName) objc_msgSend([[LogicManager defaultInstance] getInstByClassName:instanceName], @selector(methodName));

NS_ASSUME_NONNULL_BEGIN
@interface LogicManager : NSObject
{
    NSArray *_instanceArray;
}

+ (instancetype)defaultInstance;
- (void)startUp;
- (NSObject*)getInstByClassName:(NSString*)className;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
