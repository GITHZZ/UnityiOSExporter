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
#define OPEN_SIMPLE_SEARCH @"openSimpleSearch"

@interface PreferenceData : NSObject
{
@private
    LocalDataSave *_saveData;
    NSMutableArray *_codeAppArray;
    NSString *_openSimpleSearch;
}

- (void)backUpCustomCode;
- (void)restoreCustomCode;
- (NSMutableArray*)addAndSave:(NSString*)data withKey:(NSString*)key;
- (NSMutableArray*)getCodeAppArray;
- (void)setOpenSimpleSearch:(BOOL)state;

@property(nonatomic, readonly, getter=getCodeFilePath) NSString *codeFilePath;
@property(nonatomic, readonly, getter=getJsonFilePath) NSString *jsonFilePath;
@property(nonatomic, readonly, getter=getIsOpenSimpleSearch) BOOL isSimpleSearch;

@end

NS_ASSUME_NONNULL_END
