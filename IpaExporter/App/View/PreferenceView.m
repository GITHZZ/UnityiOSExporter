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
#import "PreferenceData.h"
#import "GeneralView.h"
#import "NSFileManager+Copy.h"

int _viewOpeningCount = 0;

@implementation ExtensionsMenu

- (IBAction)openPreferenceView:(id)sender
{
    if(_viewOpeningCount >= 1)
        return;
    
    _viewOpeningCount++;
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    PreferenceView *vc = [sb instantiateControllerWithIdentifier:@"PreferenceView"];
    NSViewController *mainControler = [[[NSApplication sharedApplication] mainWindow] contentViewController];
    [mainControler presentViewControllerAsSheet:vc];
}

- (IBAction)openCustomCodeFile:(id)sender
{
    NSMutableArray *codeAppArray = [PreferenceData instance].codeAppArray;
    NSString *filePath = [PreferenceData instance].codeFilePath;
    [[NSWorkspace sharedWorkspace] openFile:filePath withApplication:[codeAppArray firstObject]];
}

- (IBAction)openCustomConfig:(id)sender
{
    NSMutableArray *jsonAppArray = [PreferenceData instance].jsonAppArray;
    NSString *filePath = [PreferenceData instance].jsonFilePath;
    [[NSWorkspace sharedWorkspace] openFile:filePath withApplication:[jsonAppArray firstObject]];
}

- (IBAction)CodeTest:(id)sender
{
    [[CodeTester instance] run];
}

- (IBAction)CopyTestCodeToProject:(id)sender
{
    [[CodeTester instance] copyTestFolderToProject];
}

- (IBAction)deletTestCodeFormProject:(id)sender
{
    [[CodeTester instance] saveAndRemoveTestFolder];
}

- (IBAction)backup:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"代码备份" InformativeText:@"点击确认备份扩展代码（如果偏好设置没有路径，默认备份到导出路径）" callBackFrist:^{
        [[PreferenceData instance] backUpCustomCode];
    } callBackSecond:^{
    }];
}

- (IBAction)restore:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"代码恢复" InformativeText:@"点击确认恢复扩展代码" callBackFrist:^{
        [[PreferenceData instance] restoreCustomCode];
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

- (void)viewDidAppear
{
    _itemCellDict = [NSMutableDictionary dictionary];
    _viewOpeningCount++;

    NSString *codeSavePath = [ExportInfoManager instance].codeBackupPath;
    if(codeSavePath != nil)
        _savePath.stringValue = codeSavePath;
    
    [[_codeApp menu] setIdentifier:OPEN_CODE_APP_SAVE_KEY];
    [[_codeApp menu] setDelegate:self];
    [[_jsonApp menu] setIdentifier:OPEN_JSON_APP_SAVE_KEY];
    [[_jsonApp menu] setDelegate:self];
    
    [self initFileOpenApp];
}

- (void)viewDidDisappear
{
    _viewOpeningCount--;
}

- (IBAction)openCustomCodeFolder:(id)sender
{
    NSString *resPath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users"];
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:resPath];
}

- (IBAction)cleanAllCache:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"数据清除" InformativeText:@"点击确认清除所有数据（所有平台信息）" callBackFrist:^{
    } callBackSecond:^{
    }];
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
    }
}

- (void)initFileOpenApp
{
    NSMutableArray *codeAppArray = [PreferenceData instance].codeAppArray;
    NSMutableArray *jsonAppArray = [PreferenceData instance].jsonAppArray;
    
    [_codeApp removeAllItems];
    [_jsonApp removeAllItems];

    [_codeApp addItemsWithTitles:codeAppArray];
    [_jsonApp addItemsWithTitles:jsonAppArray];
    
    _itemCellDict[OPEN_CODE_APP_SAVE_KEY] = _codeApp;
    _itemCellDict[OPEN_JSON_APP_SAVE_KEY] = _jsonApp;
}

- (void)menuDidClose:(NSMenu *)menu
{
    if(menu.highlightedItem == nil)
        return;
    
    NSPopUpButtonCell* cell = _itemCellDict[menu.identifier];
    if([menu.highlightedItem.title containsString:@"其它"]){
        NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        [openDlg setCanChooseFiles:YES];
        [openDlg setCanChooseDirectories:NO];
        [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", nil]];
    
        if ([openDlg runModal] == NSModalResponseOK){
            NSString *selectPath = [[openDlg URL] path];
            NSString *appName = [selectPath lastPathComponent];
            
            NSMutableArray *newArr = [[PreferenceData instance] addAndSave:appName
                                                                   withKey:menu.identifier];
            [cell addItemsWithTitles:newArr];
            [cell synchronizeTitleAndSelectedItem];
        }else{
            NSMutableArray *newArr = [[PreferenceData instance] addAndSave:[[cell itemTitles] firstObject]
                                                                   withKey:menu.identifier];
            [cell addItemsWithTitles:newArr];
            [cell synchronizeTitleAndSelectedItem];
        }
    
    }else{
        NSMutableArray *newArr = [[PreferenceData instance]
                                  addAndSave:menu.highlightedItem.title
                                  withKey:menu.identifier];
        [cell addItemsWithTitles:newArr];
        [cell synchronizeTitleAndSelectedItem];
    }
}

- (IBAction)close:(id)sender
{
    _viewOpeningCount--;
    [self dismissViewController:self];
}

@end

@implementation UserDefaultsSetting

- (IBAction)plistFileSelect:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"plist", nil]];
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        NSString *plistPath = [[openDlg URL] path];
        _plistPath.stringValue = plistPath;
    }
}

- (IBAction)sureBtnSelect:(id)sender
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *preferencePath = [path stringByAppendingFormat:@"/Preferences/%@.plist", [[NSBundle mainBundle] bundleIdentifier]];
    [[NSFileManager defaultManager] copyFile:_plistPath.stringValue toDst:preferencePath];
    
    [self dismissViewController:self];
    [[EventManager instance] send:EventSettingFileSelect withData:nil];
}

- (IBAction)cancelBtnSelect:(id)sender
{
    [self dismissViewController:self];
}

@end
