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
    BOOL _isExporting;
}
@end

@implementation LuaCammond

- (void)startUp
{
    _isExporting = false;
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

- (void)open:(const char*)logPath
{
    if(L != nil)
        return;
    
    L = open_lua(logPath);
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
    //导出中不走逻辑
    if(_isExporting)
        return;
    
    _isExporting = true;
    
    showLog("*开始打包");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, queue, ^{
        ExportInfoManager* view = [ExportInfoManager instance];
        NSMutableArray<DetailsInfoData*>* detailArray = view.detailArray;
        
        showLog("*打包具体信息可在%s路径中查看", view.info->exportFolderParh);
        dispatch_queue_t sq = dispatch_queue_create("exportInfo", DISPATCH_QUEUE_SERIAL);
        for(int i = 0; i < [detailArray count]; i++)
        {
            dispatch_sync(sq, ^{
                DetailsInfoData* infoData = [detailArray objectAtIndex:i];
                if([infoData.isSelected isEqualToString:@"1"]){
                    BOOL result = [[LuaCammond instance] exportOnePlatform:infoData];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (result) {
                            showLog("*%@ 打包成功", infoData.platform);
                        }else{
                            showError("*%@ 打包失败", infoData.platform);
                        }
                    });
                }
            });
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //全部打包完毕
        showLog("*打包结束");
        _isExporting = false;
    });
    
}

- (BOOL)exportOnePlatform:(DetailsInfoData*)infoData
{
    BOOL result = NO;
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
    [[LuaCammond instance] open:view.info->exportFolderParh];
    NSString* mainLuaPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ExportIpaUtil.lua"];
    [[LuaCammond instance] dofile:mainLuaPath];
    result = [[LuaCammond instance] callLuaMain:infoData];
    [[LuaCammond instance] close];
    
    //删除文件夹
    [[DataResManager instance] end];
    
    return result;
}

- (void)sureBtnClicked:(NSNotification*)notification
{
    [[LuaCammond instance] startExport];
}

@end
