//
//  RubyCommand.m
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PackCammond.h"
#import <Cocoa/Cocoa.h>
#import "Common.h"
#import "LogicManager.h"

@implementation PackCammond

- (void)initialize
{    
    _isExporting = false;
    
    [[NSFileManager defaultManager]createDirectoryAtPath:PACK_FOLDER_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    
    EVENT_REGIST(EventViewSureClicked, @selector(sureBtnClicked:));
 
    _commFunc = [NSSet setWithObjects:@"exportXcode", @"editXcode", @"exportIpa", nil];
}

- (void)sureBtnClicked:(NSNotification*)notification
{
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray *comm = [NSMutableArray array];
    if(exportManager.info->isExportXcode == 1)
        [comm addObject:@"exportXcode"];
    else
        showWarning("xcode工程生成已跳过,直接进行平台打包");

    [comm addObject:@"editXcode"];
    [comm addObject:@"exportIpa"];
    [self startExport:comm];
}

- (void)startExport:(NSArray*)comm
{
    if(_isExporting)
        return;
    
    _isExporting = true;

    EVENT_SEND(EventSetExportButtonState, s_false);
    EVENT_SEND(EventStartRecordTime, nil);
    
    showLog("开始执行Unity打包脚本");
    [self runWithCommond:comm withBlock:^{
        _isExporting = false;
        
        EVENT_SEND(EventSetExportButtonState, s_true);
        EVENT_SEND(EventStopRecordTime, nil);
        
        [NSApp activateIgnoringOtherApps:YES];
        
        ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
        [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[NSString stringWithFormat:@"%s/export", view.info->exportFolderParh]];
    }];
}

- (void)runWithCommond:(NSArray*)comm withBlock:(void(^)())finCallback
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
       for(int i = 0; i < [comm count]; i++){
            NSString *order = comm[i];
            if([_commFunc containsObject:order]){
                int code = ((int (*)(id, SEL))objc_msgSend)(get_instance(@"PackCammond"), NSSelectorFromString(order));
                if(code == COMM_EXIT) break; //终止指令
            }else{
                NSLog(@"不存在指令%@", order);
            }
        }
        NSLog(@"执行完毕");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        finCallback();
    });
}

- (int)exportXcode
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    BOOL result = [self exportXcodeProjInThread:queue];
    if(!result){
        showError("由于生成xcode报错,打包ipa中断");
        return COMM_EXIT;
    }
    return COMM_SUCCESS;
}

- (int)editXcode
{
    showLog("开始xcode工程修改");
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray<DetailsInfoData*>* detailArray = exportManager.detailArray;
    for(int i = 0; i < [detailArray count]; i++){
        DetailsInfoData *data = [detailArray objectAtIndex:i];
        BOOL isSuccess = [self editXcodeForPlatform:data];
        if(!isSuccess)
            return COMM_EXIT;
    }
    return COMM_SUCCESS;
}

- (int)exportIpa
{
    showLog("开始进行平台打包");
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray<DetailsInfoData*>* detailArray = exportManager.detailArray;
    for(int i = 0; i < [detailArray count]; i++){
        DetailsInfoData *data = [detailArray objectAtIndex:i];
        BOOL isSuccess = [self exportIpaForPlatform:data];
        if(!isSuccess)
            return COMM_EXIT;
    }
    return COMM_SUCCESS;
}

- (NSString*)writeConfigToJsonFile:(NSString*)appName withData:(NSMutableDictionary*)jsonData
{
    BOOL isVaild = [NSJSONSerialization isValidJSONObject:jsonData];
    if(!isVaild){
        //showError("json格式有错，请检查");
        //return error code
        return @"";
    }
    
    NSString *resourcePath = [PACK_FOLDER_PATH stringByAppendingFormat:@"/%@/", appName];
    [[NSFileManager defaultManager]createDirectoryAtPath:resourcePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *configPath = [resourcePath stringByAppendingString:@"config.json"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:configPath]){
        [[NSFileManager defaultManager] createFileAtPath:configPath contents:nil attributes:nil];
    }
    
    NSOutputStream *outStream = [[NSOutputStream alloc] initToFileAtPath:configPath append:NO];
    [outStream open];
    
    NSError *error;
    [NSJSONSerialization writeJSONObject:jsonData
                                toStream:outStream
                                 options:NSJSONWritingPrettyPrinted
                                   error:&error];
    
    if(error != nil){
        [outStream close];
        return @"";
    }
    
    [outStream close];
    
    return configPath;
}

- (id)invokingShellScriptAtPath:(NSString*)shellScriptPath withArgs:(NSArray*)args
{
    //设置参数
    NSString *shellArgsStr = [[NSString alloc] init];
    for(int i = 0; i < [args count]; i++)
        shellArgsStr = [shellArgsStr stringByAppendingFormat:@"%@\t", args[i]];
    
    NSString *shellStr = [NSString stringWithFormat:@"sh %@ %@", shellScriptPath, shellArgsStr];
    NSString *strReturnFormShell = [self createTerminalTask:shellStr];
    
    return strReturnFormShell;
}

- (BOOL)exportXcodeProjInThread:(dispatch_queue_t)sq
{
    __block BOOL result = YES;
    NSString *xcodeShellPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/ExportXcode.sh"];
    ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    
    DataResManager *resManager = (DataResManager*)get_instance(@"DataResManager");
    [resManager start:view.info];
    NSString *srcPath = [LIB_PATH stringByAppendingString:@"/TempCode"];
    [resManager appendingFolder:srcPath];
    
    showLog("开始生成xcode工程");
    showLog([[NSString stringWithFormat:@"[配置信息]Unity工程路径:%s", view.info->unityProjPath] UTF8String]);
    
    BuilderCSFileEdit* builderEdit = [[BuilderCSFileEdit alloc] init];
    [builderEdit startWithDstPath: resManager.rootPath];
    
    dispatch_sync(sq, ^{
        //生成xcode工程
        //$1 unity工程路径
        //$2 导出路径
        //$3 沙盒路径
        //$4 代码根目录
        DataResManager *resManager = (DataResManager*)get_instance(@"DataResManager");
        NSArray *args = [NSArray arrayWithObjects:
                         [NSString stringWithUTF8String:view.info->unityProjPath],
                         [NSString stringWithUTF8String:view.info->exportFolderParh],
                         LIB_PATH,
                         resManager.rootPath,
                         nil];
        
        NSString *shellLog = [self invokingShellScriptAtPath:xcodeShellPath withArgs:args];
    
        [resManager end];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
        
        if([logStr containsString:@"Completed 'Build.Player.iOSSupport'"] ||
           (![logStr containsString:@"error CS"])){
            showSuccess("导出xcode成功");
            [NSApp activateIgnoringOtherApps:YES];
        }else{
            result = NO;
            showError("导出xcode失败，具体请查看log文件");
            [NSApp activateIgnoringOtherApps:YES];
            [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%s/xcodeproj_create_log.txt", view.info->exportFolderParh]];
        }
    });
    
    return result;
}

- (BOOL)editXcodeForPlatform:(DetailsInfoData*)data
{
    NSString *shellPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/EditXcode.sh"];
    NSString *rubyMainPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/Main.rb"];
    
    ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    
    if([data.isSelected isEqualToString:@"1"]){
        //配置json文件
        NSMutableDictionary *jsonData = [NSMutableDictionary dictionary];
        jsonData[@"frameworks"] = data.frameworkNames;
        jsonData[@"embedFrameworks"] = data.embedFramework;
        jsonData[@"Libs"] = data.libNames;
        jsonData[@"linker_flags"] = data.linkerFlag;
        jsonData[@"enable_bit_code"] = @"NO";
        jsonData[@"develop_signing_identity"] = [NSMutableArray arrayWithObjects:data.debugProfileName, data.debugDevelopTeam, nil];
        jsonData[@"release_signing_identity"] = [NSMutableArray arrayWithObjects:data.releaseProfileName, data.releaseDevelopTeam, nil];
        jsonData[@"product_bundle_identifier"] = data.bundleIdentifier;
        NSString *configPath = [self writeConfigToJsonFile:data.appName withData:jsonData];
        
        //$1 ruby入口文件路径
        //$2 sdk资源文件路径
        //$3 导出ipa和xcode工程路径
        //$4 平台名称
        //$5 configPath 配置路径
        //$6 unity工程路径
        //$7 xcode工程名称 目前固定xcodeProj
        //$8 开发者teamid（debug）
        //$9 开发者签名文件名字（debug）
        //$10 开发者teamid（release）
        //$11 开发者签名文件名字（release）
        //$12 沙盒文件路径
        //$13 bundleIdentifier
        //$14 是否release包
        //$15 缓存文件位置
        //$16 需要关联的sdk文件夹
        //$17 是否导出ipa文件
        //$18 应用名字
        NSArray *args = [NSArray arrayWithObjects:
                         rubyMainPath,//$1
                         data.customSDKPath,
                         [NSString stringWithUTF8String:view.info->exportFolderParh],
                         data.platform,
                         configPath,
                         [NSString stringWithUTF8String:view.info->unityProjPath],
                         XCODE_PROJ_NAME,
                         data.debugDevelopTeam,
                         data.debugProfileName,
                         data.releaseDevelopTeam,
                         data.releaseProfileName,
                         LIB_PATH,
                         data.bundleIdentifier,
                         [NSString stringWithFormat:@"%d",view.info->isRelease],
                         PACK_FOLDER_PATH,
                         [self convertArrayToString:data.customSDKChild],
                         [NSString stringWithFormat:@"%d",view.info->isExportIpa],
                         data.appName,
                         nil];
        
        showLog([[NSString stringWithFormat:@"开始修改工程 平台:%@", data.platform] UTF8String]);
        NSString *shellLog = [self invokingShellScriptAtPath:shellPath withArgs:args];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
        
        if([shellLog containsString:@"** EDIT XCODE PROJECT SUCCESS **"]){
            [NSApp activateIgnoringOtherApps:YES];
            showSuccess([[NSString stringWithFormat:@"%@修改Xcode成功", data.platform] UTF8String]);
        }
    }
    return YES;
}

- (BOOL)exportIpaForPlatform:(DetailsInfoData*)data
{
    NSString *shellPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/ExportIpa.sh"];
    NSString *rubyMainPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/Main.rb"];
    ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    
    if([data.isSelected isEqualToString:@"1"])
    {
        NSArray *args = [NSArray arrayWithObjects:
                         rubyMainPath,//$1
                         data.customSDKPath,
                         [NSString stringWithUTF8String:view.info->exportFolderParh],
                         data.platform,
                         @"null",
                         [NSString stringWithUTF8String:view.info->unityProjPath],
                         XCODE_PROJ_NAME,
                         data.debugDevelopTeam,
                         data.debugProfileName,
                         data.releaseDevelopTeam,
                         data.releaseProfileName,
                         LIB_PATH,
                         data.bundleIdentifier,
                         [NSString stringWithFormat:@"%d",view.info->isRelease],
                         PACK_FOLDER_PATH,
                         [self convertArrayToString:data.customSDKChild],
                         [NSString stringWithFormat:@"%d",view.info->isExportIpa],
                         data.appName,
                         nil];
        
        showLog([[NSString stringWithFormat:@"开始打包 平台:%@", data.platform] UTF8String]);
        NSString *shellLog = [self invokingShellScriptAtPath:shellPath withArgs:args];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
        
        if([shellLog containsString:@"** EXPORT SUCCEEDED **"]){
            [NSApp activateIgnoringOtherApps:YES];
            showSuccess([[NSString stringWithFormat:@"%@平台,打包成功", data.platform] UTF8String]);
        }else{
            [NSApp activateIgnoringOtherApps:YES];
            showError([[NSString stringWithFormat:@"%@平台,打包失败,日志已经保存在%s路径中", data.platform, view.info->unityProjPath] UTF8String]);
            return NO;
        }
    }
    return YES;
}

- (NSString*)createTerminalTask:(NSString*)order
{
    NSTask *shellTask = [[NSTask alloc] init];
    [shellTask setLaunchPath:@"/bin/sh"];
    
    //-c 表示将后面的内容当成shellcode来执行、
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c", order, nil]];
    
    NSError *error;
    NSPipe *pipe = [[NSPipe alloc] init];
    [shellTask setStandardOutput:pipe];
    [shellTask setStandardError:pipe];
    [shellTask launchAndReturnError:&error];
    [shellTask waitUntilExit];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSData *data = [file readDataToEndOfFile];
    NSString *strReturnFormShell = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"The return content from shell script is: %@",strReturnFormShell);
    
    return strReturnFormShell;
}

- (NSString*)convertArrayToString:(NSArray*)array
{
    NSString *arrayString = [array description];
    arrayString = [arrayString stringByReplacingOccurrencesOfString:@"(" withString:@"\""];
    arrayString = [arrayString stringByReplacingOccurrencesOfString:@")" withString:@"\""];
    arrayString = [arrayString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    arrayString = [arrayString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    return arrayString;
}

@end
