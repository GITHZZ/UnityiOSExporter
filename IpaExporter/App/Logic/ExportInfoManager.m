//
//  ExportInfoManager.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ExportInfoManager.h"
#import <objc/runtime.h>

@implementation ExportInfoManager

- (void)dealloc
{
    free(_info);
}

- (id)init
{
    if(self =[super init])
    {
        _info = (ExportInfo*)malloc(sizeof(ExportInfo)); 
        _info->exportFolderParh = "";
        _info->unityProjPath = "";
        
        _unityProjPathArr = [[NSMutableArray alloc] initWithCapacity:6];
        _exportPathArr = [[NSMutableArray alloc] initWithCapacity:6];
        _codeBackupPath = @"";
        
        _saveTpDict = @{
                       SAVE_DETAIL_ARRARY_KEY:@[[NSMutableArray class],[DetailsInfoData class], [NSMutableDictionary class], [NSArray class]],
                       SAVE_PROJECT_PATH_KEY:@[[NSArray class]],
                       SAVE_EXPORT_PATH_KEY:@[[NSArray class]],
                       SAVE_CODE_SAVE_PATH_KEY:@[[NSString class]],
                       SAVE_SCENE_ARRAY_KEY:@[[NSArray class]],
                       SAVE_IS_RELEASE_KEY:@[[NSString class]],
                       SAVE_IS_EXPORT_XCODE:@[[NSString class]],
                       SAVE_IS_EXPORT_IPA:@[[NSString class]]
                       };
        
        _userData = [[LocalDataSave alloc] init];
        [_userData setAllSaveKey:_saveTpDict];
    }
    return self;
}

- (void)refresh
{
    [_userData refresh];
    [self reloadPaths];
}

- (void)reloadPaths
{
    _unityProjPathArr = [_userData dataForKey:SAVE_PROJECT_PATH_KEY];
    _exportPathArr = [_userData dataForKey:SAVE_EXPORT_PATH_KEY];
    _codeBackupPath = [_userData dataForKey:SAVE_CODE_SAVE_PATH_KEY];

    NSString *isReleaseStr = [_userData dataForKey:SAVE_IS_RELEASE_KEY];
    _info->isRelease = [isReleaseStr isEqualToString:@""]?0:[isReleaseStr intValue];

    NSString *isExportStr = [_userData dataForKey:SAVE_IS_EXPORT_XCODE];
    _info->isExportXcode = [isExportStr isEqualToString:@""]?1:[isExportStr intValue];
    
    NSString *isExportIpa = [_userData dataForKey:SAVE_IS_EXPORT_IPA];
    _info->isExportIpa = [isExportIpa isEqualToString:@""]?1:[isExportIpa intValue];
}

- (void)addNewUnityProjPath:(NSString *)path
{
    NSAssert(path != nil, @"路径不能为空");
    [_unityProjPathArr addObject:path];
    
    if([_unityProjPathArr count] > 5)
    {
        [_unityProjPathArr removeObjectAtIndex:0];
    }
    [_userData setAndSaveData:_unityProjPathArr withKey:SAVE_PROJECT_PATH_KEY];
}

- (void)replaceUnityProjPath:(NSString*)path
{
    NSUInteger index = [_unityProjPathArr indexOfObject:path];
    id lastObj = [_unityProjPathArr lastObject];
    [_unityProjPathArr replaceObjectAtIndex:[_unityProjPathArr count] - 1 withObject:path];
    [_unityProjPathArr replaceObjectAtIndex:index withObject:lastObj];
    [_userData setAndSaveData:_unityProjPathArr withKey:SAVE_PROJECT_PATH_KEY];
}

- (void)addNewExportProjPath:(NSString *)path
{
    NSAssert(path != nil, @"路径不能为空");
    [_exportPathArr addObject:path];
    
    if([_exportPathArr count] > 5)
    {
        [_exportPathArr removeLastObject];
    }
    [_userData setAndSaveData:_exportPathArr withKey:SAVE_EXPORT_PATH_KEY];
}

- (void)replaceExportProjPath:(NSString*)path
{
    NSUInteger index = [_exportPathArr indexOfObject:path];
    id fristObj = [_exportPathArr objectAtIndex:0];
    [_exportPathArr replaceObjectAtIndex:[_exportPathArr count] - 1 withObject:path];
    [_exportPathArr replaceObjectAtIndex:index withObject:fristObj];
    [_userData setAndSaveData:_exportPathArr withKey:SAVE_EXPORT_PATH_KEY];
}

//包配置 信息表格数据部分
- (NSMutableArray*)reLoadDetails:(NSString*)saveKey
{
    return [_userData dataForKey:saveKey];
}

- (void)addDetail:(id)data withKey:(NSString*)saveKey
{
    NSMutableArray *array = [_userData dataForKey:saveKey];
    [array addObject:data];
    [self saveDataForKey:saveKey withData:array];
}

- (void)removeDetail:(NSUInteger)index withKey:(NSString*)saveKey
{
    NSMutableArray *array = [_userData dataForKey:saveKey];
    if([array count] > 0){
        [array removeObjectAtIndex:index];
        [self saveDataForKey:saveKey withData:array];
    }
}

- (void)updateDetail:(NSUInteger)index withObject:(id)object withKey:(NSString*)saveKey
{
    NSMutableArray *array = [_userData dataForKey:saveKey];
    [array replaceObjectAtIndex:index withObject:object];
    [self saveDataForKey:saveKey withData:array];
}

- (NSMutableArray*)getDetailArray
{
    return [_userData dataForKey:SAVE_DETAIL_ARRARY_KEY];
}

- (NSMutableArray*)getSceneArray
{
    return [_userData dataForKey:SAVE_SCENE_ARRAY_KEY];
}

- (void)setCodeSavePath:(NSString*)path
{
    _codeBackupPath = path;
    [self saveDataForKey:SAVE_CODE_SAVE_PATH_KEY withData:path];
}

- (void)saveDataForKey:(NSString*)key withData:(id) data
{
    [_userData setAndSaveData:data withKey:key];
}

//- (void)test
//{
//    NSString *testString = [_codeBackupPath stringByAppendingString:@"/com.IpaExporter.app.plist"];
//    [_userData mergeFormPlist:testString
//                    withBlock:^id _Nonnull(id  _Nonnull originItem, id  _Nonnull newItem) {
//                        if([originItem isKindOfClass:[NSArray class]] &&
//                           [newItem isKindOfClass:[NSArray class]]){
//                            
//                            NSArray *originArray = (NSArray*)originItem;
//                            NSArray *newArray = (NSArray*)newItem;
//                            originArray = [originArray arrayByAddingObjectsFromArray:newArray];
//                            return originArray;
//                        }
//                        return originItem;
//    }];
//}

@end
