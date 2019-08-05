//
//  PreferenceData.h
//  IpaExporter
//
//  Created by 4399 on 7/1/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "LogicManager.h"

NS_ASSUME_NONNULL_BEGIN

#define OPEN_CODE_APP_SAVE_KEY @"openCodeAppKey"
#define OPEN_JSON_APP_SAVE_KEY @"openJsonAppKey"

@interface PreferenceData : NSObject
{
@private
    LocalDataSave *_saveData;
    NSMutableArray *_codeAppArray;
    NSMutableArray *_jsonAppArray;
}

- (void)backUpCustomCode;
- (void)restoreCustomCode;
- (NSMutableArray*)addAndSave:(NSString*)data withKey:(NSString*)key;
- (NSMutableArray*)getCodeAppArray;
- (NSMutableArray*)getJsonAppArray;

@property(nonatomic, readonly, getter=getCodeFilePath) NSString *codeFilePath;
@property(nonatomic, readonly, getter=getJsonFilePath) NSString *jsonFilePath;

@end

NS_ASSUME_NONNULL_END
