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
#import "NSFileManager+Copy.h"
#import "PackCammond.h"
#import "PreferenceData.h"

#import <Cocoa/Cocoa.h>

@implementation CodeTester

- (void)run
{
    ExportInfoManager* view = [ExportInfoManager instance];
    NSString *resourcePath = LIB_PATH;
    NSString *args = [NSString stringWithFormat:@"%s\t%s\t%@",
                      view.info->unityProjPath,
                      view.info->exportFolderParh,
                      resourcePath];
    
    NSString *shellScriptPath = [NSString stringWithFormat:@"%@/CodeTest/CodeTest.sh", resourcePath];
    NSString *shellStr = [NSString stringWithFormat:@"sh %@ %@", shellScriptPath, args];
    
    [[DataResManager instance] start:view.info];
    
    NSString *customCodePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users"];
    NSString *codeTestPath = [LIB_PATH stringByAppendingString:@"/CodeTest/Test"];
    NSString *litJsonPath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/LitJson"];
    [[DataResManager instance] appendingFolder:customCodePath];
    [[DataResManager instance] appendingFolder:codeTestPath];
    [[DataResManager instance] appendingFolder:litJsonPath];
    
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [self createTerminalTask:shellStr];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%s/code_test_log.xml", view.info->unityProjPath]];
        [[DataResManager instance] end];
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
    ExportInfoManager* view = [ExportInfoManager instance];

    [[DataResManager instance] start:view.info];
    NSString *customCodePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users"];
    NSString *codeTestPath = [LIB_PATH stringByAppendingString:@"/CodeTest/Test"];
    NSString *litJsonPath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/LitJson"];
    [[DataResManager instance] appendingFolder:customCodePath];
    [[DataResManager instance] appendingFolder:codeTestPath];
    [[DataResManager instance] appendingFolder:litJsonPath];
    
    NSString *shellStr = [NSString stringWithFormat:@"/Applications/Unity/Unity.app/Contents/MacOS/Unity -projectPath %s", view.info->unityProjPath];
    [self createTerminalTask:shellStr];
}

- (void)saveAndRemoveTestFolder
{
    if(!_isCopyed){
        showWarning("未进行拷贝操作，无法保存和删除");
        return;
    }
    
    _isCopyed = NO;
    NSString *rootPath = [DataResManager instance].rootPath;
    rootPath = [rootPath stringByAppendingString:@"/TempCode/Builder/Users"];
    
    NSString *backUpPath = [ExportInfoManager instance].codeBackupPath;
    backUpPath = [backUpPath stringByAppendingString:@"/Users"];
    
    [[NSFileManager defaultManager] copyFolderFrom:rootPath toDst:backUpPath];
    [[DataResManager instance] end];
    [[PreferenceData instance] restoreCustomCode];
}

- (NSString*)createTerminalTask:(NSString*)order
{
    NSTask *shellTask = [[NSTask alloc] init];
    [shellTask setLaunchPath:@"/bin/sh"];
    
    //-c 表示将后面的内容当成shellcode来执行、
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c", order, nil]];
    
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

@end
