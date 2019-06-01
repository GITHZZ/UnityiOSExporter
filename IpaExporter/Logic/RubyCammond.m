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

@interface RubyCammond()
{
    BOOL _isExporting;
}
@end

@implementation RubyCammond

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

- (void)sureBtnClicked:(NSNotification*)notification
{
    //导出中不走逻辑
    if(_isExporting)
        return;
    
    _isExporting = true;
    [[EventManager instance] send:EventSetExportButtonState withData:s_false];
    [[EventManager instance] send:EventStartRecordTime withData:nil];
    
    NSString *shellPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Xcodeproj/Main.sh"];
    NSString *rubyMainPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Xcodeproj/Main.rb"];
    
    showLog("*开始执行打包脚本\n");
    //showLog("*打包具体信息可在%s路径中查看", view.info->exportFolderParh);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        ExportInfoManager* view = [ExportInfoManager instance];
        NSMutableArray<DetailsInfoData*>* detailArray = view.detailArray;
        
        dispatch_queue_t sq = dispatch_queue_create("exportInfo", DISPATCH_QUEUE_SERIAL);
        for(int i = 0; i < [detailArray count]; i++){
            dispatch_sync(sq, ^{
                ExportInfoManager* view = [ExportInfoManager instance];
                DetailsInfoData *data = [detailArray objectAtIndex:i];
                
                //配置json文件
                NSMutableDictionary *jsonData = [NSMutableDictionary dictionary];
                jsonData[@"frameworks"] = data.frameworkNames;
                jsonData[@"Libs"] = data.libNames;
                jsonData[@"linker_flags"] = data.linkerFlag;
                jsonData[@"enable_bit_code"] = @"NO";
                jsonData[@"develop_signing_identity"] = [NSMutableArray array];
                jsonData[@"release_signing_identity"] = [NSMutableArray array];
                [self writeConfigToJsonFile:data.customSDKPath withData:jsonData];
                
                //ruby入口文件路径
                //sdk资源文件路径
                //导出ipa和xcode工程路径
                //平台名称
                NSArray *args = [NSArray arrayWithObjects:rubyMainPath,
                                 data.customSDKPath,
                                 [NSString stringWithUTF8String:view.info->exportFolderParh],
                                 data.platform,
                                 nil];
                
                NSString *shellLog = [self invokingShellScriptAtPath:shellPath withArgs:args];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    showLog([shellLog UTF8String]);
                });
            });
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //全部打包完毕
        _isExporting = false;
        [[EventManager instance] send:EventSetExportButtonState withData:s_true];
        [[EventManager instance] send:EventStopRecordTime withData:nil];
        showLog("*打包结束");
        showLog("--------------------------------");
    });
}

- (BOOL)writeConfigToJsonFile:(NSString*)customSDKPath withData:(NSMutableDictionary*)jsonData
{
    BOOL isVaild = [NSJSONSerialization isValidJSONObject:jsonData];
    if(!isVaild){
        //showError("json格式有错，请检查");
        //return error code
        return NO;
    }
    
    NSString *configPath = [customSDKPath stringByAppendingString:@"/config.json"];
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
        return NO;
    }
    
    [outStream close];
    
    return YES;
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
    [shellTask launch];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSData *data = [file readDataToEndOfFile];
    NSString *strReturnFormShell = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"The return content from shell script is: %@",strReturnFormShell);
    
    return strReturnFormShell;
}

@end

