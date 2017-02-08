//
//  ExportInfoModel.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ExportInfoModel.h"

#define INFOS_MAX_CAPACITY 100

#define SAVE_DETAIL_ARRARY_KEY @"detailArray"
#define SAVE_PROJECT_PATH_KEY @"projectPath"
#define SAVE_EXPORT_PATH_KEY @"exportPath"

@implementation ExportInfoModel

+ (ExportInfoModel*)instance
{
    static ExportInfoModel* s_instance = nil;
    if(nil == s_instance)
    {
        @synchronized (self)
        {
            s_instance = [[self alloc] init];
        }
    }
    
    return s_instance;
}

- (void)dealloc
{
    free(_info);
}

- (id)init
{
    if(self =[super init])
    {
        _info = (ExportInfo*)malloc(sizeof(ExportInfo)); 
        _info->developProfilePath = "";
        _info->exportFolderParh = "";
        _info->publishProfilePath = "";
        _info->unityProjPath = "";
        _info->isRelease = NO;
        
        _saveData = [NSUserDefaults standardUserDefaults];
        _detailArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return self;
}

//主路径部分
- (void)reloadPaths
{
    NSString* projPath = (NSString*)[_saveData objectForKey:SAVE_PROJECT_PATH_KEY];
    NSString* exportPath = (NSString*)[_saveData objectForKey:SAVE_EXPORT_PATH_KEY];
    
    _info->unityProjPath = [projPath UTF8String];
    _info->exportFolderParh = [exportPath UTF8String];
}

- (void)saveData
{
    NSString* projectPath = [NSString stringWithUTF8String:_info->unityProjPath];
    NSString* exportPath = [NSString stringWithUTF8String:_info->exportFolderParh];
    [_saveData setObject:projectPath forKey:SAVE_PROJECT_PATH_KEY];
    [_saveData setObject:exportPath forKey:SAVE_EXPORT_PATH_KEY];
}

- (ExportInfo*)getData
{
    ExportInfo* val;
    NSValue* value = (NSValue*)[_saveData objectForKey:@"test"];
    [value getValue:&val];
    return val;
}

- (void)addNewInfo:(ExportInfo*)newInfo
{
}

- (void)removeNewInfo
{
}

//包配置 信息表格数据部分
- (void) saveDetail
{
    NSData* arrayData = [NSKeyedArchiver archivedDataWithRootObject:_detailArray];
    [_saveData setObject:arrayData forKey:SAVE_DETAIL_ARRARY_KEY];
    [_saveData synchronize];
}

- (NSMutableArray*)reLoadDetails
{
    NSData* arrayData = (NSData*)[_saveData objectForKey:SAVE_DETAIL_ARRARY_KEY];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
    NSMutableArray* mutable = [NSMutableArray arrayWithArray:array];
    _detailArray = mutable;
    return mutable;
}

- (void)addDetail:(DetailsInfoData*)data
{
    if (data == nil)
        return;
    
    [_detailArray addObject:data];
    [self saveDetail];
}

- (void)removeDetail:(NSUInteger)index
{
    [_detailArray removeObjectAtIndex:index];
    [self saveDetail];
}

- (void)updateDetail:(NSUInteger)index withObject:(id)object
{
    if (object == nil)
        return;
    
    [_detailArray replaceObjectAtIndex:index withObject:object];
    [self saveDetail];
}

@end
