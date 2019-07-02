//
//  PreferenceData.m
//  IpaExporter
//
//  Created by 4399 on 7/1/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PreferenceData.h"
#import "Defs.h"

@interface PreferenceData()
{
    LocalDataSave *_saveData;
}
@end

@implementation PreferenceData

- (id)init
{
    if(self = [super init])
    {
        _saveData = [[LocalDataSave alloc] init];
        [_saveData setAllSaveKey:@{
                                   OPEN_CODE_APP_SAVE_KEY:@[[NSMutableArray class]],
                                   OPEN_JSON_APP_SAVE_KEY:@[[NSMutableArray class]],
                                   }];
        _codeAppArray = [_saveData dataForKey:OPEN_CODE_APP_SAVE_KEY];
        _jsonAppArray = [_saveData dataForKey:OPEN_JSON_APP_SAVE_KEY];
        
        if(_codeAppArray.count <= 0){
            [_codeAppArray addObject:@"Sublime Text.app"];
            [_codeAppArray addObject:@"其它..."];
        }
        
        if(_jsonAppArray.count <= 0){
            [_jsonAppArray addObject:@"Sublime Text.app"];
            [_jsonAppArray addObject:@"其它..."];
        }
        
        [_saveData setDataForKey:OPEN_CODE_APP_SAVE_KEY withData:_codeAppArray];
        [_saveData setDataForKey:OPEN_JSON_APP_SAVE_KEY withData:_jsonAppArray];
        [_saveData saveAll];
    }
    return self;
}

- (NSMutableArray*)addAndSave:(NSString*)data withKey:(NSString*)key;
{
    NSMutableArray *array = [_saveData dataForKey:key];
    if([array containsObject:data]){
        [array removeObject:data];
    }
    [array insertObject:data atIndex:0];
    [_saveData setDataForKey:key withData:array];
    [_saveData saveAll];

    return array;
}

- (NSString*)getCodeFilePath
{
     NSString *filePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users/_CustomBuilder.cs"];
    return filePath;
}

- (NSString*)getJsonFilePath
{
    NSString *filePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users/_CustomConfig.json"];
    return filePath;
}

@end
