//
//  PreferenceView.m
//  IpaExporter
//
//  Created by 4399 on 6/17/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PreferenceView.h"
#import "ExportInfoManager.h"
#import "PackCammond.h"
#import "CodeTester.h"

@implementation ExtensionsMenu

- (IBAction)openCustomCodeFile:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/TempCode/Builder/Users/_CustomBuilder.cs"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)openCustomConfig:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/TempCode/Builder/Users/_CustomConfig.json"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)CodeTest:(id)sender
{
    [[CodeTester instance] run];
}

- (IBAction)backup:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"代码备份" InformativeText:@"点击确认备份扩展代码（如果偏好设置没有路径，默认备份到导出路径）" callBackFrist:^{
        [[PackCammond instance] restoreCustomCode];
    } callBackSecond:^{
    }];
    
    [[PackCammond instance] backUpCustomCode];
}

- (IBAction)restore:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"代码恢复" InformativeText:@"点击确认恢复扩展代码" callBackFrist:^{
        [[PackCammond instance] restoreCustomCode];
    } callBackSecond:^{
    }];
}

- (IBAction)ShowHelp:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/README.md"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

@end

@implementation PreferenceView

static int _viewOpeningCount = 0;

- (void)viewDidAppear
{
    _viewOpeningCount++;
    NSString *codeSavePath = [ExportInfoManager instance].codeBackupPath;
    if(codeSavePath != nil)
        _savePath.stringValue = codeSavePath;
    
    [[_codeApp menu] setDelegate:self];
    [[_jsonApp menu] setDelegate:self];
    
    [_codeApp removeAllItems];
    [_jsonApp removeAllItems];
    
    [_codeApp addItemWithTitle:@"1"];
    [_codeApp addItemWithTitle:@"2"];
}

- (void)viewDidDisappear
{
    _viewOpeningCount--;
}

- (IBAction)openCustomCodeFolder:(id)sender
{
    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/TempCode/Builder/Users"];
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:resPath];
}

- (IBAction)cleanAllCache:(id)sender
{
}
    
- (IBAction)savePathSelect:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    if([openDlg runModal] == NSModalResponseOK)
    {
        NSString* selectPath = [[openDlg URL] path];
        _savePath.stringValue = selectPath;
        [[ExportInfoManager instance] setCodeSavePath:selectPath];
        [[ExportInfoManager instance] saveDataForKey:SAVE_CODE_SAVE_PATH_KEY];
    }
}

- (void)menuDidClose:(NSMenu *)menu
{
    NSLog(@"%@",_codeApp.selectedItem.title);
}

@end
