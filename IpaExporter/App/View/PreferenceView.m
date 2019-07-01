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

@implementation ExtensionsMenu

- (IBAction)openCustomCodeFile:(id)sender
{
    NSMutableArray *codeAppArray = [PreferenceData instance].codeAppArray;
    NSString *filePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users/_CustomBuilder.cs"];
    [[NSWorkspace sharedWorkspace] openFile:filePath withApplication:[codeAppArray firstObject]];
}

- (IBAction)openCustomConfig:(id)sender
{
    NSMutableArray *jsonAppArray = [PreferenceData instance].jsonAppArray;
    NSString *filePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users/_CustomConfig.json"];
    [[NSWorkspace sharedWorkspace] openFile:filePath withApplication:[jsonAppArray firstObject]];
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

//-(void)menuNeedsUpdate:(NSMenu *)menu
//{
//    NSArray* fakeSeparators = [[menu itemArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == '---'"]];
//    for (NSMenuItem* fakeSep in fakeSeparators) {
//        [menu insertItem:[NSMenuItem separatorItem] atIndex:[menu indexOfItem:fakeSep]];
//        [menu removeItem:fakeSep];
//    }
//}
		
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
            
            
            NSMutableArray *newArr = [[PreferenceData instance] addAndSaveItem:appName
                                                                  withSaveKey:menu.identifier];
            [cell addItemsWithTitles:newArr];
            [cell synchronizeTitleAndSelectedItem];
        }else{
            NSMutableArray *newArr = [[PreferenceData instance] addAndSaveItem:[[cell itemTitles] firstObject]
                                                                   withSaveKey:menu.identifier];
            [cell addItemsWithTitles:newArr];
            [cell synchronizeTitleAndSelectedItem];
        }
    
    }else{
        NSMutableArray *newArr = [[PreferenceData instance] addAndSaveItem:menu.highlightedItem.title
                                                               withSaveKey:menu.identifier];
        [cell addItemsWithTitles:newArr];
        [cell synchronizeTitleAndSelectedItem];
    }
}

@end
