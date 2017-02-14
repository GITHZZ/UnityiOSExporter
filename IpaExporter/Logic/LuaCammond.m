//
//  LuaDLL.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/8/31.
//  Copyright © 2016年 何遵祖. All rights reserved.

#import "LuaCammond.h"
#import "ExportInfoManager.h"
#import "DataResManager.h"
#import "BuilderCSFileEdit.h"
#import "DetailsInfoData.h"
#import "XcodeProjModCSFileEdit.h"

#include <stdio.h>
#include <assert.h>

#include "LuaDictionary.h"
#include "EventManager.h"

@interface LuaCammond ()
{
    lua_State *L;
}
@end

@implementation LuaCammond

+ (LuaCammond*)instance
{
    static LuaCammond* s_inctance = nil;
    if(nil == s_inctance)
    {
        @synchronized (self)
        {
            if(nil == s_inctance)
            {
                s_inctance = [[self alloc] init];
            }
        }
    }
    
    return s_inctance;
}


- (void)startUp
{
    [self initEvent];
}

- (void)initEvent
{
    [[EventManager instance] regist:EventViewSureClicked
                               func:@selector(sureBtnClicked:)
                           withData:nil
                               self:self];
}

- (void)close
{
    close_lua(L);
    L = nil;
}

- (void)open
{
    if(L != nil)
        return;
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    L = open_lua([resourcePath UTF8String]);
    int code = open_lua_libs(L);
    
    [self printErrorByCode:code];
}

- (void)dofile:(NSString*)path
{
    int code = do_lua_file(L, [path UTF8String]);
    [self printErrorByCode:code];
}

- (void)dostring:(NSString*)content
{
    int code = do_lua_string(L, [content UTF8String]);
    [self printErrorByCode:code];
}

- (void)printErrorByCode:(int)code
{
    const char* errorStr = get_error_description(L, code);
    if(errorStr != NULL)
    {
        NSLog(@"%s", errorStr);
    }
}

- (void)callLuaMain
{
    ExportInfoManager* view = [ExportInfoManager instance];
    
    get_call_lua_func(L, "MainStart");
    push_lua_string_args(L,
                         3,
                         view.info->unityProjPath,
                         view.info->exportFolderParh,
                         "");
    push_lua_boolean_args(L, 1, 0);
    start_call_lua_func(L, 4, 0, 0);
}

- (void)startExport
{
    ExportInfoManager* view = [ExportInfoManager instance];
    NSMutableArray* detailArray = view.detailArray;
    
    //拷贝Data_t所有文件
    [[DataResManager instance] start:view.info];
    
    //测试(修改目标目录的builder_t.cs文件)
    DetailsInfoData* infoData = [detailArray objectAtIndex:0];
    BuilderCSFileEdit* builderEdit = [[BuilderCSFileEdit alloc] init];
    [builderEdit start:[NSString stringWithUTF8String:view.info->unityProjPath]
          withPackInfo:infoData];
    
    //修改目标目录的XcodeApi下的文件
    XcodeProjModCSFileEdit* xcodeProjEdit = [[XcodeProjModCSFileEdit alloc] init];
    [xcodeProjEdit start:[NSString stringWithUTF8String:view.info->unityProjPath]
          withPackInfo:infoData];
    
    //call lua
    [self open];
    NSString* mainLuaPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LuaMain.lua"];
    [self dofile:mainLuaPath];
    [self callLuaMain];
    [self close];
    
    //删除文件夹
    //[[DataResManager instance] end];
}

- (void)sureBtnClicked:(NSNotification*)notification
{
    [[LuaCammond instance] startExport];
}

@end
