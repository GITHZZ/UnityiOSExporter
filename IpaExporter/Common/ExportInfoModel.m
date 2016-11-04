//
//  ExportInfoModel.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ExportInfoModel.h"

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

- (void)saveData
{
    //NSValue* value = [NSValue valueWithBytes:_info objCType:@encode(ExportInfo)];
    //[_saveData setObject:value forKey:@"test"];
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
- (NSMutableArray*)reLoad
{
    NSData* arrayData = (NSData*)[_saveData objectForKey:@"detailArray"];
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

    NSData* arrayData = [NSKeyedArchiver archivedDataWithRootObject:_detailArray];
    [_saveData setObject:arrayData forKey:@"detailArray"];
    [_saveData setInteger:[_detailArray count] forKey:@"test"];
     
    [_saveData synchronize];
}

- (void)removeDetail:(NSUInteger)index
{
    [_detailArray removeObjectAtIndex:index];
    NSData* arrayData = [NSKeyedArchiver archivedDataWithRootObject:_detailArray];
    [_saveData setObject:arrayData forKey:@"detailArray"];
    [_saveData synchronize];
}

- (void)getDetail:(NSUInteger)index
{
    
}

@end
