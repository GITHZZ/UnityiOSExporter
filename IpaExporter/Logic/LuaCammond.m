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

#import "Common.h"

#include <stdio.h>
#include <assert.h>

@interface LuaCammond ()
{
    lua_State *L;
}
@end

@implementation LuaCammond

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
        showError("LuaError:%s", errorStr);
    }
}

- (BOOL)callLuaMain:(DetailsInfoData*)data
{
    ExportInfoManager* view = [ExportInfoManager instance];
    get_call_lua_func(L, "ExportMain");
    push_lua_string_args(L,
                         3,
                         view.info->unityProjPath,
                         view.info->exportFolderParh,
                         [data.appName UTF8String]);
    push_lua_boolean_args(L, 1, view.info->isRelease);
    
    int result = start_call_lua_main(L, 4);
    if(result == LUA_DLL_ERROR){
        showError("*调用脚本出错,导出失败");
        return NO;
    }
    return YES;
}

- (void)startExport
{
    showLog("*开始打包");
    
    //--- for start
    ExportInfoManager* view = [ExportInfoManager instance];
    NSMutableArray<DetailsInfoData*>* detailArray = view.detailArray;
    DetailsInfoData* infoData = [detailArray objectAtIndex:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[LuaCammond instance] exportOnePlatform:infoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            showLog("*打包结束");
        });
    });
    //----for end
}

- (void)exportOnePlatform:(DetailsInfoData*)infoData
{
    ExportInfoManager* view = [ExportInfoManager instance];
    
    //拷贝Data_t所有文件
    [[DataResManager instance] start:view.info];
    
    //测试(修改目标目录的builder_t.cs文件)
    BuilderCSFileEdit* builderEdit = [[BuilderCSFileEdit alloc] init];
    [builderEdit start:[NSString stringWithUTF8String:view.info->unityProjPath]
          withPackInfo:infoData];
    
    //修改目标目录的XcodeApi下的文件
    XcodeProjModCSFileEdit* xcodeProjEdit = [[XcodeProjModCSFileEdit alloc] init];
    [xcodeProjEdit start:[NSString stringWithUTF8String:view.info->unityProjPath]
            withPackInfo:infoData];
    
    //call lua
    [[LuaCammond instance] open];
    NSString* mainLuaPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ExportIpaUtil.lua"];
    [[LuaCammond instance] dofile:mainLuaPath];
    [[LuaCammond instance] callLuaMain:infoData];
    [[LuaCammond instance] close];
    
    //删除文件夹
    [[DataResManager instance] end];

}

- (void)sureBtnClicked:(NSNotification*)notification
{
    [[LuaCammond instance] startExport];
}

@end
