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

//- (void)addNewDetail:()
@end
