//
//  ExportInfoManager.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ExportInfoManager.h"
#import "PreferenceData.h"
#import <objc/runtime.h>
#import "Common.h"

@implementation ExportInfoManager

- (void)dealloc
{
    free(_info);
}

- (void)initialize
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
    _userData = [[LocalDataSave alloc] initWithPlist:PLIST_PATH];
    [_userData setAllSaveKey:_saveTpDict];
}

- (void)reload
{
    [_userData reload];
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

- (BOOL)addNewUnityProjPath:(NSString *)path
{
    NSAssert(path != nil, @"路径不能为空");
    if([self checkIsChinese:path]){
        showError("路径包含中文");
        return NO;
    }
    
    [_unityProjPathArr addObject:path];
    
    if([_unityProjPathArr count] > 5)
    {
        [_unityProjPathArr removeObjectAtIndex:0];
    }
    [_userData setAndSaveData:_unityProjPathArr withKey:SAVE_PROJECT_PATH_KEY];
    
    return YES;
}

- (void)replaceUnityProjPath:(NSString*)path
{
    NSUInteger index = [_unityProjPathArr indexOfObject:path];
    id lastObj = [_unityProjPathArr lastObject];
    [_unityProjPathArr replaceObjectAtIndex:[_unityProjPathArr count] - 1 withObject:path];
    [_unityProjPathArr replaceObjectAtIndex:index withObject:lastObj];
    [_userData setAndSaveData:_unityProjPathArr withKey:SAVE_PROJECT_PATH_KEY];
}

- (BOOL)addNewExportProjPath:(NSString *)path
{
    NSAssert(path != nil, @"路径不能为空");
    if([self checkIsChinese:path]){
        showError("路径包含中文");
        return NO;
    }

    [_exportPathArr addObject:path];
    
    if([_exportPathArr count] > 5)
    {
        [_exportPathArr removeLastObject];
    }
    [_userData setAndSaveData:_exportPathArr withKey:SAVE_EXPORT_PATH_KEY];
    
    return YES;
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

/**
 *  @author zhengju, 16-06-29 10:06:05
 *
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *
 *  @param string 传入检测到中文字符串
 *
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
- (BOOL)checkIsChinese:(NSString *)string
{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

- (NSArray*)getAllUnityScenePath
{
    PreferenceData *dataInst = get_instance(@"PreferenceData");
    NSString *unityProjPath = [NSString stringWithUTF8String:_info->unityProjPath];
    NSString *appendString = @"";
    
    if(dataInst.isSimpleSearch){
        appendString = @"Assets/Scene/";
        unityProjPath = [unityProjPath stringByAppendingFormat:@"/%@",appendString];
    }
    
    NSArray *sceneArr = [[NSFileManager defaultManager] searchByExtension:@"unity" withDir:unityProjPath appendPath:appendString];
    return sceneArr;
}

@end
