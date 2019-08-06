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
#import "NSObject+LogicBase.h"

#define get_instance(instanceName) [[LogicManager defaultInstance] getInstByClassName:instanceName error:nil];
#define inst_method_call(instanceName, methodName) objc_msgSend([[LogicManager defaultInstance] getInstByClassName:instanceName error:nil], @selector(methodName));

NS_ASSUME_NONNULL_BEGIN

@interface LogicManager : NSObject
{
    NSMutableDictionary *_instanceDict;
}

+ (instancetype)defaultInstance;
- (void)startUp;
- (id)getInstByClassName:(NSString*)className error:(NSError**)err;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
