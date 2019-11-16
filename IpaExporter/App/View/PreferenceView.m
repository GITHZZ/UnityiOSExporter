//
//  PreferenceView.m
//  IpaExporter
//
//  Created by 4399 on 6/17/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PreferenceView.h"
#import "GeneralView.h"
#import "NSFileManager+Extern.h"

int _viewOpeningCount = 0;

@implementation ExtensionsMenu

- (IBAction)openPreferenceView:(id)sender
{
    if(_viewOpeningCount >= 1)
        return;
    
    _viewOpeningCount++;
    
    EVENT_SEND(EventShowSubView, @"PreferenceView");
}

- (IBAction)openCustomCodeFile:(id)sender
{
    PreferenceData* dataInst = (PreferenceData*)get_instance(@"PreferenceData");
    NSMutableArray *codeAppArray = inst_method_call(@"PreferenceData", getCodeAppArray);
    NSString *filePath = dataInst.codeFilePath;
    [[NSWorkspace sharedWorkspace] openFile:filePath withApplication:[codeAppArray firstObject]];
}

- (IBAction)openCustomConfig:(id)sender
{
    PreferenceData* dataInst = (PreferenceData*)get_instance(@"PreferenceData");
    NSString *filePath = dataInst.jsonFilePath;
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)CodeTest:(id)sender
{
    CodeTester *tester = (CodeTester*)get_instance(@"CodeTester");
    [tester run];
}

- (IBAction)CopyTestCodeToProject:(id)sender
{
    CodeTester *tester = (CodeTester*)get_instance(@"CodeTester");
    [tester copyTestFolderToProject];
}

- (IBAction)deletTestCodeFormProject:(id)sender
{
    CodeTester *tester = (CodeTester*)get_instance(@"CodeTester");
    [tester saveAndRemoveTestFolder];
}

- (IBAction)backup:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"代码备份" InformativeText:@"点击确认备份扩展代码（如果偏好设置没有路径，默认备份到导出路径）" callBackFrist:^{
        PreferenceData* dataInst = (PreferenceData*)get_instance(@"PreferenceData");
        [dataInst backUpCustomCode];
    } callBackSecond:^{
    }];
}

- (IBAction)restore:(id)sender
{
    [[Alert instance]alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"代码恢复" InformativeText:@"点击确认恢复扩展代码" callBackFrist:^{
        PreferenceData* dataInst = (PreferenceData*)get_instance(@"PreferenceData");
        [dataInst restoreCustomCode];
    } callBackSecond:^{
    }];
}

- (IBAction)editCustomShell:(id)sender
{
    NSMutableArray *codeAppArray = inst_method_call(@"PreferenceData", getCodeAppArray);
    NSString *filePath = [LIB_PATH stringByAppendingString:@"/TempCode/Builder/Users/_CustomShell.sh"];
    [[NSWorkspace sharedWorkspace] openFile:filePath withApplication:[codeAppArray firstObject]];
}

- (IBAction)testCustomShell:(id)sender
{
    EVENT_SEND(EventTestCustomShell, nil);
}

- (IBAction)testCode:(id)sender
{
    inst_method_call(@"PackCammond", testCode);
}

- (IBAction)ShowHelp:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/README.md"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)switchState:(id)sender
{
    NSMenuItem *item = (NSMenuItem*)sender;
    EVENT_SEND(EventOnMenuSelect, item.identifier);
}
    
- (IBAction)startRun:(id)sender
{
    EVENT_SEND(EventViewSureClicked, sender);
}

- (IBAction)openCustomCodeFolder:(id)sender
{
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:LIB_PATH];
}

@end

@implementation PreferenceView

- (void)viewDidAppear
{
    _itemCellDict = [NSMutableDictionary dictionary];
    _viewOpeningCount++;

    ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSString *codeSavePath = view.codeBackupPath;
    if(codeSavePath != nil)
        _savePath.stringValue = codeSavePath;
    
    [[_codeApp menu] setIdentifier:OPEN_CODE_APP_SAVE_KEY];
    [[_codeApp menu] setDelegate:self];
    
    [self initFileOpenApp];
}

- (void)viewDidDisappear
{
    _viewOpeningCount--;
}
    
- (IBAction)savePathSelect:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    [openDlg beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse result) {
        if(result == NSModalResponseOK){
            ExportInfoManager* view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
            NSString* selectPath = [[openDlg URL] path];
            self->_savePath.stringValue = selectPath;
            [view setCodeSavePath:selectPath];
        }
    }];
    
}

- (void)initFileOpenApp
{
    NSMutableArray *codeAppArray = inst_method_call(@"PreferenceData", getCodeAppArray);
    
    [_codeApp removeAllItems];
    [_codeApp addItemsWithTitles:codeAppArray];
    
    _itemCellDict[OPEN_CODE_APP_SAVE_KEY] = _codeApp;
    
    PreferenceData *data = get_instance(@"PreferenceData");
    _isSimpleSearch.state = data.isSimpleSearch;
}

- (void)menuDidClose:(NSMenu *)menu
{
    if(menu.highlightedItem == nil)
        return;
    
    PreferenceData* dataInst = (PreferenceData*)get_instance(@"PreferenceData");
    NSPopUpButtonCell* cell = _itemCellDict[menu.identifier];
    if([menu.highlightedItem.title containsString:@"其它"]){
        NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        [openDlg setCanChooseFiles:YES];
        [openDlg setCanChooseDirectories:NO];
        [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", nil]];
    
        if ([openDlg runModal] == NSModalResponseOK){
            NSString *selectPath = [[openDlg URL] path];
            NSString *appName = [selectPath lastPathComponent];
            
            NSMutableArray *newArr = [dataInst addAndSave:appName withKey:menu.identifier];
            [cell addItemsWithTitles:newArr];
            [cell synchronizeTitleAndSelectedItem];
        }else{
            NSMutableArray *newArr = [dataInst addAndSave:[[cell itemTitles] firstObject] withKey:menu.identifier];
            [cell addItemsWithTitles:newArr];
            [cell synchronizeTitleAndSelectedItem];
        }
    
    }else{
        NSMutableArray *newArr = [dataInst
                                  addAndSave:menu.highlightedItem.title
                                  withKey:menu.identifier];
        [cell addItemsWithTitles:newArr];
        [cell synchronizeTitleAndSelectedItem];
    }
}

- (IBAction)close:(id)sender
{
    PreferenceData* dataInst = (PreferenceData*)get_instance(@"PreferenceData");
    [dataInst setOpenSimpleSearch:_isSimpleSearch.state];
    
    _viewOpeningCount--;
    EVENT_SEND(EventHideSubView, self);
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
    [[NSFileManager defaultManager] copyFile:_plistPath.stringValue toDst:PLIST_PATH];
    [self dismissViewController:self];
    EVENT_SEND(EventSettingFileSelect, nil);
}

- (IBAction)cancelBtnSelect:(id)sender
{
    [self dismissViewController:self];
}

@end
