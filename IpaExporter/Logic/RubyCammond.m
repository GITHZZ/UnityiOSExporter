//
//  RubyCommand.m
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "RubyCammond.h"
#import "Common.h"
#import "ExportInfoManager.h"
#import "DataResManager.h"
#import "BuilderCSFileEdit.h"
#import "NSString+Emoji.h"

@interface RubyCammond()
{
    BOOL _isExporting;
}
@end

@implementation RubyCammond

- (void)startUp
{
    _isExporting = false;

    [[EventManager instance] regist:EventViewSureClicked
                               func:@selector(sureBtnClicked:)
                           withData:nil
                               self:self];
}

- (void)sureBtnClicked:(NSNotification*)notification
{
    //导出中不走逻辑
    if(_isExporting)
        return;
    
    _isExporting = true;
    
    [[EventManager instance] send:EventSetExportButtonState withData:s_false];
    [[EventManager instance] send:EventStartRecordTime withData:nil];
    
    showLog("开始执行Unity打包脚本");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        ExportInfoManager* view = [ExportInfoManager instance];
        NSMutableArray<DetailsInfoData*>* detailArray = view.detailArray;
        
        dispatch_queue_t sq = dispatch_queue_create("exportInfo", DISPATCH_QUEUE_SERIAL);
        
        if(view.info->isExportXcode == 1)
            [self exportXcodeProjInThread:sq];
        else
            showWarning("xcode工程生成已跳过,直接进行平台打包");
        
        for(int i = 0; i < [detailArray count]; i++){
            dispatch_sync(sq, ^{
                DetailsInfoData *data = [detailArray objectAtIndex:i];
                [self editXcodeProject:data];
            });
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        _isExporting = false;
        [[EventManager instance] send:EventSetExportButtonState withData:s_true];
        [[EventManager instance] send:EventStopRecordTime withData:nil];
        
        showSuccess("打包结束");
    });
}

- (NSString*)writeConfigToJsonFile:(NSString*)platformName withData:(NSMutableDictionary*)jsonData
{
    BOOL isVaild = [NSJSONSerialization isValidJSONObject:jsonData];
    if(!isVaild){
        //showError("json格式有错，请检查");
        //return error code
        return @"";
    }
    
    
    NSString *resourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingFormat:@"/%@/", platformName];
    [[NSFileManager defaultManager]createDirectoryAtPath:resourcePath withIntermediateDirectories:YES         attributes:nil error:nil];

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
        //return error code
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
    
    NSTask *shellTask = [[NSTask alloc] init];
    [shellTask setLaunchPath:@"/bin/sh"];
    NSString *shellStr = [NSString stringWithFormat:@"sh %@ %@", shellScriptPath, shellArgsStr];
    
    //-c 表示将后面的内容当成shellcode来执行、
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c", shellStr, nil]];
    
    NSPipe *pipe = [[NSPipe alloc] init];
    [shellTask setStandardOutput:pipe];
    [shellTask setStandardError:pipe];
    [shellTask launch];
    [shellTask waitUntilExit];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSData *data = [file readDataToEndOfFile];
    NSString *strReturnFormShell = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"The return content from shell script is: %@",strReturnFormShell);
    
    return strReturnFormShell;
}

- (void)exportXcodeProjInThread:(dispatch_queue_t)sq
{
    NSString *xcodeShellPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Xcodeproj/ExportXcode.sh"];
    ExportInfoManager* view = [ExportInfoManager instance];
    
    [[DataResManager instance] start:view.info];
    showLog("开始生成xcode工程");
    showLog([[NSString stringWithFormat:@"[配置信息]Unity工程路径:%s", view.info->unityProjPath] UTF8String]);
    
    BuilderCSFileEdit* builderEdit = [[BuilderCSFileEdit alloc] init];
    [builderEdit startWithDstPath:[NSString stringWithUTF8String:view.info->unityProjPath]];
    
    dispatch_sync(sq, ^{
        //生成xcode工程
        //$1 unity工程路径
        //$2 导出路径
        NSArray *args = [NSArray arrayWithObjects:
                         [NSString stringWithUTF8String:view.info->unityProjPath],
                         [NSString stringWithUTF8String:view.info->exportFolderParh],
                         nil];
        NSString *shellLog = [self invokingShellScriptAtPath:xcodeShellPath withArgs:args];
        

        [[DataResManager instance] end];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
        
        if([logStr containsString:@"Completed 'Build.Player.iOSSupport'"]){
            showSuccess("导出xcode成功");
        }else{
            showError("导出xcode失败，具体请查看log文件");
        }
        showLog("开始进行平台打包");
    });
}

- (void)editXcodeProject:(DetailsInfoData*)data
{
    NSString *shellPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Xcodeproj/Main.sh"];
    NSString *rubyMainPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Xcodeproj/Main.rb"];
    
    ExportInfoManager* view = [ExportInfoManager instance];
    
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
        
        NSString *configPath = [self writeConfigToJsonFile:data.platform withData:jsonData];
        
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
                         [[NSBundle mainBundle]resourcePath],
                         data.bundleIdentifier,
                         [NSString stringWithFormat:@"%d",view.info->isRelease],
                         nil];
         
        showLog([[NSString stringWithFormat:@"开始打包 平台:%@", data.platform] UTF8String]);
        NSString *shellLog = [self invokingShellScriptAtPath:shellPath withArgs:args];
        NSString* logStr = [shellLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        showLog([logStr UTF8String]);
            
        if([shellLog containsString:@"** EXPORT SUCCEEDED **"])
            showSuccess([[NSString stringWithFormat:@"%@平台,打包成功", data.platform] UTF8String]);
        else
            showError([[NSString stringWithFormat:@"%@平台,打包失败,日志已经保存在%s路径中", data.platform, view.info->unityProjPath] UTF8String]);
    }
}

@end
