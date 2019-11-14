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
#import "UnityAssetManager.h"
#import "BuilderCSFileEdit.h"
#import "PreferenceData.h"
#import "VersionInfo.h"
#import "CodeTester.h"
#import "NSObject+LogicBase.h"

#define get_instance(instanceName) [[LogicManager defaultManager] getInstByClassName:instanceName error:nil]
#define inst_method_call(instanceName, methodName) \
    objc_msgSend([[LogicManager defaultManager] getInstByClassName:instanceName error:nil], @selector(methodName))

NS_ASSUME_NONNULL_BEGIN

@interface LogicManager : NSObject
{
    NSArray *_instanceArray;
    NSMutableDictionary *_instanceDict;
}

+ (instancetype)defaultManager;
- (void)startUp;
- (id)getInstByClassName:(NSString*)className error:(NSError**)err;
- (void)applicationDelegateCallBack:(AppDelegateType)tp
                   withNotification:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
