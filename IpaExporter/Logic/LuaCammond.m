//
//  LuaDLL.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/8/31.
//  Copyright © 2016年 何遵祖. All rights reserved.

#import "LuaCammond.h"
#import "ExportInfoModel.h"
#import "DataResControl.h"
#import "BuilderCSFileEdit.h"
#import "DetailsInfoData.h"

#include <stdio.h>
#include <assert.h>

#include "LuaDictionary.h"
#include "EventManager.h"

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
    ExportInfoModel* view = [ExportInfoModel instance];
    
    get_call_lua_func(L, "MainStart");
    push_lua_string_args(L,
                         3,
                         view.info->unityProjPath,
                         view.info->exportFolderParh,
                         view.info->developProfilePath);
    push_lua_boolean_args(L, 1, view.info->isRelease ? 1 : 0);
    start_call_lua_func(L, 4, 0, 0);
}

- (void)startExport
{
    [self open];
    NSString* mainLuaPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LuaMain.lua"];
    ExportInfoModel* view = [ExportInfoModel instance];
    BuilderCSFileEdit* builderEdit = [[BuilderCSFileEdit alloc] init];
    IpaPackInfo packInfo;
    
    [[DataResControl instance] start:view.info];
    //[builderEdit start:[NSString stringWithUTF8String:view.info->unityProjPath] withPackInfo:packInfo];
    
    //call lua
    [self dofile:mainLuaPath];
    [self callLuaMain];

    [[DataResControl instance] end];
    [self close];
}

- (void)sureBtnClicked:(NSNotification*)notification
{
    [[LuaCammond instance] startExport];
}

@end
