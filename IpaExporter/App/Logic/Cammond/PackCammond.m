//
//  Rubycammand.m
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PackCammond.h"
#import <Cocoa/Cocoa.h>
#import "common.h"
#import "LogicManager.h"

@implementation PackCammond

#define CAMM_REGIST() NSMutableArray *camm = [NSMutableArray array]
#define CAMM_ADD(code) [camm addObject:code]
#define CAMM_RUN() [self startExport:camm]

- (void)initialize
{    
    _isExporting = false;
    [[NSFileManager defaultManager]createDirectoryAtPath:PACK_FOLDER_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    
    _cammondCode = [@{
                     CODE_EXPORT_XCODE:@"exportXcode",
                     CODE_EDIT_XCODE:@"editXcode",
                     CODE_EXPORT_IPA:@"exportIpa",
                     CODE_GEN_RESFOLDER:@"genResFolder",
                     CODE_RUN_CUSTOM_SHELL:@"runCustomShell",
                     CODE_ACTIVE_WND_TOP:@"activateIgnoringOtherApps",
                     CODE_BACKUP_XCODE:@"backupXcode",
                     }mutableCopy];

    EVENT_REGIST(EventViewSureClicked, @selector(sureBtnClicked:));
    EVENT_REGIST(EventExportXcodeCilcked, @selector(exportXcodeBtnClicked));
    EVENT_REGIST(EventExportIpaChilcked, @selector(exportIpaChilcked));
    EVENT_REGIST(EventTestCustomShell, @selector(testCustomShell));
}

#pragma mark -
#pragma mark Cammond regist
- (void)exportXcodeBtnClicked
{
    CAMM_REGIST();
    CAMM_ADD(CODE_BACKUP_XCODE);
    CAMM_ADD(CODE_GEN_RESFOLDER);
    CAMM_ADD(CODE_EXPORT_XCODE);
    CAMM_ADD(CODE_RUN_CUSTOM_SHELL);
    CAMM_ADD(CODE_EDIT_XCODE);
    CAMM_ADD(CODE_ACTIVE_WND_TOP);
    
    [self checkConfigInfo:^{
        CAMM_RUN();
    }];
}

- (void)exportIpaChilcked
{
    CAMM_REGIST();
    CAMM_ADD(CODE_GEN_RESFOLDER);
    CAMM_ADD(CODE_EXPORT_IPA);
    CAMM_ADD(CODE_ACTIVE_WND_TOP);
    CAMM_RUN();
}

- (void)sureBtnClicked:(NSNotification*)notification
{
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    CAMM_REGIST();
    
    CAMM_ADD(CODE_BACKUP_XCODE);
    CAMM_ADD(CODE_GEN_RESFOLDER);
    if(exportManager.info->isExportXcode == 1)
        CAMM_ADD(CODE_EXPORT_XCODE);
    else
        showWarning("xcode工程生成已跳过,直接进行平台打包");

    CAMM_ADD(CODE_RUN_CUSTOM_SHELL);
    CAMM_ADD(CODE_EDIT_XCODE);
    CAMM_ADD(CODE_EXPORT_IPA);
    CAMM_ADD(CODE_ACTIVE_WND_TOP);
    
    [self checkConfigInfo:^{
        CAMM_RUN();
    }];
}

- (void)testCustomShell
{
    CAMM_REGIST();
    CAMM_ADD(CODE_GEN_RESFOLDER);
    CAMM_ADD(CODE_RUN_CUSTOM_SHELL);
    CAMM_RUN();
}

- (void)testCode
{
    CAMM_REGIST();
    CAMM_ADD(CODE_EDIT_XCODE);
    CAMM_RUN();
}

#pragma mark -
#pragma mark Cammond driver
- (void)startExport:(NSArray*)camm
{
    if(_isExporting)
        return;
    
    _isExporting = true;

    EVENT_SEND(EventSetExportButtonState, s_false);
    EVENT_SEND(EventStartRecordTime, nil);
    
    showLog("开始执行Unity打包脚本");
    [self runWithCammond:camm withBlock:^{
        self->_isExporting = false;
        
        EVENT_SEND(EventSetExportButtonState, s_true);
        EVENT_SEND(EventStopRecordTime, nil);
    }];
}

- (void)runWithCammond:(NSArray*)camm withBlock:(void(^)(void))finCallback
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
       for(int i = 0; i < [camm count]; i++){
           NSString *order = [self->_cammondCode objectForKey:camm[i]];
            if(order != nil){
                CammondResult code = ((NSNumber* (*)(id, SEL))objc_msgSend)(get_instance(@"PackCammond"), NSSelectorFromString(order));
                if([code isEqualToNumber:CAMM_EXIT]){
                    showError([[NSString stringWithFormat:@"%@---指令执行失败", order] UTF8String]);
                    return; //终止指令
                }
                if([code isEqualToNumber:CAMM_BREAK])
                    break;
                if([code isEqualToNumber:CAMM_CONTINUE])
                    continue;
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

- (CammondResult)exportXcode
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    BOOL result = [self exportXcodeProjInThread:queue];
    if(!result){
        showError("由于生成xcode报错,打包ipa中断");
        return CAMM_EXIT;
    }
    return CAMM_SUCCESS;
}

- (CammondResult)editXcode
{
    showLog("开始xcode工程修改");
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray<DetailsInfoData*>* detailArray = exportManager.detailArray;
    for(int i = 0; i < [detailArray count]; i++){
        DetailsInfoData *data = [detailArray objectAtIndex:i];
        CammondResult result = [self editXcodeForPlatform:data];
        if([result isEqualToNumber:CAMM_CONTINUE])
            continue;
        else
            return result;
    }
    return CAMM_SUCCESS;
}

- (CammondResult)exportIpa
{
    showLog("开始进行平台打包");
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray<DetailsInfoData*>* detailArray = exportManager.detailArray;
    for(int i = 0; i < [detailArray count]; i++){
        DetailsInfoData *data = [detailArray objectAtIndex:i];
        BOOL isSuccess = [self exportIpaForPlatform:data];
        if(!isSuccess)
            return CAMM_EXIT;
    }
    return CAMM_SUCCESS;
}

- (CammondResult)genResFolder
{
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray<DetailsInfoData*>* detailArray = exportManager.detailArray;
    NSError *error;
    for(int i = 0; i < [detailArray count]; i++){
        NSString *resourcePath = [PACK_FOLDER_PATH stringByAppendingFormat:@"/%@/", detailArray[i].appName];
        [[NSFileManager defaultManager]createDirectoryAtPath:resourcePath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error != nil)
            return CAMM_EXIT;
    }
    
    return CAMM_SUCCESS;
}

- (CammondResult)runCustomShell
{
    ExportInfoManager *exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray<DetailsInfoData*>* detailArray = exportManager.detailArray;
    for(int i = 0; i < [detailArray count]; i++){
        DetailsInfoData *data = [detailArray objectAtIndex:i];
        NSString *shellPath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users/_CustomShell.sh"];
        NSString *shellLog = [self runShellWithData:data withPath:shellPath];
        BOOL isSuccess = [shellLog containsString:@"CUSTOM_RUN_SUCCESS"] ||
                         [shellLog containsString:@"PLATFORM_NOT_SELECT"];
        if(!isSuccess)
            return CAMM_EXIT;
    }
    return CAMM_SUCCESS;
}

- (CammondResult)activateIgnoringOtherApps
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSApp activateIgnoringOtherApps:YES];
        ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
        [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[NSString stringWithFormat:@"%s/export", view.info->exportFolderParh]];
    });
    return CAMM_SUCCESS;
}

- (CammondResult)backupXcode
{
    ExportInfoManager *view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSString *xcodeProjPath = [NSString stringWithFormat:@"%s/%@", view.info->exportFolderParh, XCODE_PROJ_NAME];
    if([[NSFileManager defaultManager] fileExistsAtPath:xcodeProjPath]){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY.MM.dd-hh:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        NSString *backUpProjPath = [NSString stringWithFormat:@"%s/%@-%@", view.info->exportFolderParh, XCODE_PROJ_NAME, dateString];

        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/bash"];
        [task setArguments:@[@"-c", [NSString stringWithFormat:@"mv %@ %@", xcodeProjPath, backUpProjPath]]];
        [task launch];
    }
    
    return CAMM_SUCCESS;
}

#pragma mark -
#pragma mark Support
- (BOOL)exportXcodeProjInThread:(dispatch_queue_t)sq
{
    __block BOOL result = YES;
    
    NSString *xcodeShellPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/ExportXcode.sh"];
    ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    UnityAssetManager *resManager = (UnityAssetManager*)get_instance(@"UnityAssetManager");
    
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
        UnityAssetManager *resManager = (UnityAssetManager*)get_instance(@"UnityAssetManager");
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
        
        NSString *xcodePath = [NSString stringWithFormat:@"%s/%@/Unity-iPhone.xcodeproj", view.info->exportFolderParh, XCODE_PROJ_NAME];

        BOOL projectExisted = [[NSFileManager defaultManager] fileExistsAtPath:xcodePath];
        BOOL notError = [logStr containsString:@"*****SUCCESS*****"];
        if(projectExisted && notError){
            showSuccess("导出xcode成功");
        }else{
            result = NO;
            showError("导出xcode失败，具体请查看log文件");
            [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%s/xcodeproj_create_log.txt", view.info->exportFolderParh]];
        }
    });
    
    return result;
}

- (CammondResult)editXcodeForPlatform:(DetailsInfoData*)data
{
    NSString *shellPath = [LIB_PATH stringByAppendingString:@"/Xcodeproj/EditXcode.sh"];
    NSString *shellLog = [self runShellWithData:data withPath:shellPath];
    
    if([shellLog containsString:@"** EDIT XCODE PROJECT SUCCESS **"]){
            showSuccess([[NSString stringWithFormat:@"%@(%@)修改Xcode成功", data.appName, data.platform] UTF8String]);
    }else if([shellLog containsString:@"PLATFORM_NOT_SELECT"]){
        return CAMM_CONTINUE;
    }else{
        return CAMM_EXIT;
    }
    return CAMM_SUCCESS;
}

- (NSString*)runShellWithData:(DetailsInfoData*)data withPath:(NSString*)path
{
    NSString *shellPath = path;
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
        
        
        if(configPath == nil)
            return @"";
        
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
        //$19 bundleIdentifier - release
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
                         data.appidRelease,
                         nil];
        
        showLog([[NSString stringWithFormat:@"开始修改工程=>%@(%@)", data.appName, data.platform] UTF8String]);
        NSString *shellLog = [self invokingShellScriptAtPath:shellPath withArgs:args];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
        return shellLog;
    }
    return @"PLATFORM_NOT_SELECT";
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
                         data.appidRelease,
                         nil];
        
        showLog([[NSString stringWithFormat:@"开始打包=>%@(%@)", data.appName, data.platform] UTF8String]);
        NSString *shellLog = [self invokingShellScriptAtPath:shellPath withArgs:args];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
        
        if([shellLog containsString:@"** EXPORT SUCCEEDED **"]){
            showSuccess([[NSString stringWithFormat:@"%@平台,打包成功", data.platform] UTF8String]);
        }else{
            showError([[NSString stringWithFormat:@"%@平台,打包失败,日志已经保存在%s路径中", data.platform, view.info->unityProjPath] UTF8String]);
            return NO;
        }
    }
    return YES;
}

- (NSString*)writeConfigToJsonFile:(NSString*)appName withData:(NSMutableDictionary*)jsonData
{
    BOOL isVaild = [NSJSONSerialization isValidJSONObject:jsonData];
    if(!isVaild){
        showError("json格式有错，请检查");
        //return error code
        return @"";
    }
    
    NSString *resourcePath = [PACK_FOLDER_PATH stringByAppendingFormat:@"/%@/", appName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:resourcePath]){
        showError([[NSString stringWithFormat:@"缺少指令CAMM_GEN_RESFOLDER导致%@ 文件夹不存在",resourcePath] UTF8String]);
        return nil;
    }
    
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

- (void)checkConfigInfo:(void(^)(void))sureCallback
{
    NSString *plistPath = [NSString stringWithFormat:@"%@/TempCode/Builder/Users/_CustomConfig.plist", LIB_PATH];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[ _`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"];
    NSString *desc = [[data description] stringByTrimmingCharactersInSet:set];
    desc = [desc stringByReplacingOccurrencesOfString:@"    " withString:@""];
    desc = [desc stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    if(data.count <= 0){
        sureCallback();
    }else{
        [[Alert instance] alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"请确认传给C#代码参数信息" InformativeText:desc callBackFrist:^{
            sureCallback();
          } callBackSecond:^{}];
    }
}

@end
