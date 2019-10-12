//
//  CodeTester.m
//  IpaExporter
//
//  Created by 4399 on 6/24/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "CodeTester.h"
#import "ExportInfoManager.h"
#import "DataResManager.h"
#import "NSFileManager+Extern.h"
#import "PreferenceData.h"

#import <Cocoa/Cocoa.h>

@implementation CodeTester

- (void)initialize
{
    _manager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    _dataInst = (DataResManager*)get_instance(@"DataResManager");
}

- (void)run
{
    NSString *resourcePath = LIB_PATH;
    NSString *args = [NSString stringWithFormat:@"%s\t%s\t%@",
                      _manager.info->unityProjPath,
                      _manager.info->exportFolderParh,
                      resourcePath];

    NSString *shellScriptPath = [NSString stringWithFormat:@"%@/CodeTest/CodeTest.sh", resourcePath];
    NSString *shellStr = [NSString stringWithFormat:@"sh %@ %@", shellScriptPath, args];

    [_dataInst start:_manager.info];

    NSString *customCodePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users"];
    NSString *codeTestPath = [LIB_PATH stringByAppendingString:@"/CodeTest/Test"];
    NSString *litJsonPath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/LitJson"];
    [_dataInst appendingFolder:customCodePath];
    [_dataInst appendingFolder:codeTestPath];
    [_dataInst appendingFolder:litJsonPath];

    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [self createTerminalTask:shellStr];
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%s/code_test_log.xml", _manager.info->unityProjPath]];
        [_dataInst end];
    });
}

BOOL _isCopyed = NO;
- (void)copyTestFolderToProject
{
    if(_isCopyed){
        showWarning("文件夹已经存在");
        return;
    }
    
    _isCopyed = YES;
    
    [_dataInst start:_manager.info];
    NSString *customCodePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users"];
    NSString *codeTestPath = [LIB_PATH stringByAppendingString:@"/CodeTest/Test"];
    NSString *litJsonPath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/LitJson"];
    [_dataInst appendingFolder:customCodePath];
    [_dataInst appendingFolder:codeTestPath];
    [_dataInst appendingFolder:litJsonPath];
    
    NSString *shellStr = [NSString stringWithFormat:@"/Applications/Unity/Unity.app/Contents/MacOS/Unity -projectPath %s", _manager.info->unityProjPath];
    [self createTerminalTask:shellStr waitUntilExit:NO];
}

- (void)saveAndRemoveTestFolder
{
    if(!_isCopyed){
        showWarning("未进行拷贝操作，无法保存和删除");
        return;
    }
    
    _isCopyed = NO;
    NSString *rootPath = _dataInst.rootPath;
    rootPath = [rootPath stringByAppendingString:@"/TempCode/Builder/Users"];
    
    NSString *backUpPath = _manager.codeBackupPath;
    backUpPath = [backUpPath stringByAppendingString:@"/Users"];
    
    [[NSFileManager defaultManager] copyFolderFrom:rootPath toDst:backUpPath];
    [_dataInst end];
    inst_method_call(@"PreferenceData", restoreCustomCode);
}

- (NSString*)createTerminalTask:(NSString*)order
{
   return [self createTerminalTask:order waitUntilExit:YES];
}

- (NSString*)createTerminalTask:(NSString*)order waitUntilExit:(BOOL)isWait
{
    NSTask *shellTask = [[NSTask alloc] init];
    [shellTask setLaunchPath:@"/bin/sh"];
    
    //-c 表示将后面的内容当成shellcode来执行、
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c", order, nil]];
    
    NSPipe *pipe = [[NSPipe alloc] init];
    [shellTask setStandardOutput:pipe];
    [shellTask setStandardError:pipe];
    [shellTask launch];
    
    if(isWait){
        [shellTask waitUntilExit];
    
        NSFileHandle *file = [pipe fileHandleForReading];
        NSData *data = [file readDataToEndOfFile];
        NSString *strReturnFormShell = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"The return content from shell script is: %@",strReturnFormShell);
    
        return strReturnFormShell;
    }
    return @"";
}

@end
