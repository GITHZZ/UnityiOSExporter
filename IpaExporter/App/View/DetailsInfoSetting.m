//
//  DetailsInfoSetting.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoSetting.h"
#import "Common.h"
#import "Defs.h"
#import "DetailsInfoData.h"
#import "Common.h"

@implementation DetailsInfoSetting

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_detailView scrollRectToVisible:CGRectMake(0, _detailView.frame.size.height-15, _detailView.frame.size.width, 10)];
    
    if(_isSetDataOnShow)
    {
        [self setUpInfo];
        _sureBtn.title = @"确定";
    }
    else
        _sureBtn.title = @"添加";
    
    if(!_frameworkNameArr)
        _frameworkNameArr = [NSMutableArray arrayWithCapacity:10];
    
    if(!_frameworkIsWeakArr)
        _frameworkIsWeakArr = [NSMutableArray arrayWithCapacity:10];
    
    if(!_embedFrameworksArr)
        _embedFrameworksArr = [NSMutableArray arrayWithCapacity:10];
    
    if(!_libNameArr)
        _libNameArr = [NSMutableArray arrayWithCapacity:10];
    
    if(!_linkerFlagArr)
        _linkerFlagArr = [NSMutableArray arrayWithCapacity:10];
    
    if(!_customSdkArr)
        _customSdkArr = [NSMutableArray arrayWithCapacity:10];
    
    [self setUpTableInfo];
    
    _appID.enabled = NO;
    _debugProfileName.enabled = NO;
    _debugDevelopTeam.enabled = NO;
    _releaseProfileName.enabled = NO;
    _releaseDevelopTeam.enabled = NO;
}

- (void)viewDidAppear
{
    _sureBtnClicked = NO;
}

- (void)viewDidDisappear
{
    if(_sureBtnClicked)
        EVENT_SEND(EventSetViewMainTab, 0);
    
    _isSetDataOnShow = NO;
    _sureBtnClicked = NO;
}

- (void)setUpTableInfo
{
    _frameworkTbl.identifier = Defs_Frameworks;
    _libsTbl.identifier = Defs_Libs;
    _linkerFlagTbl.identifier = Defs_Linker_Flag;
    _embedTbl.identifier = Defs_Embed_Framework;
    
    _frameworkTbl.delegate = self;
    _frameworkTbl.dataSource = self;
    _libsTbl.delegate = self;
    _libsTbl.dataSource = self;
    _linkerFlagTbl.delegate = self;
    _linkerFlagTbl.dataSource = self;
    _embedTbl.delegate = self;
    _embedTbl.dataSource = self;
    _sdkChildTbl.delegate = self;
    _sdkChildTbl.dataSource = self;
}

- (void)setUpDataInfoOnShow:(DetailsInfoData*)info isEditMode:(BOOL)isEdit
{
    _info = info;
    _isEditMode = isEdit;
    _isSetDataOnShow = YES; 
}

- (void)setUpInfo
{
    if(nil == _info)
        return;
    
    if(_isEditMode){
        _platform.stringValue = [_info getValueForKey:Defs_Platform_Name];
        _appName.stringValue = [_info getValueForKey:Defs_App_Name_Key];
    }
    
    _appID.stringValue = [_info getValueForKey:Defs_App_ID_Key];
    _debugProfileName.stringValue = [_info getValueForKey:Defs_Debug_Profile_Name];
    _debugDevelopTeam.stringValue = [_info getValueForKey:Defs_Debug_Develop_Team];
    _releaseProfileName.stringValue = [_info getValueForKey:Defs_Release_Profile_Name];
    _releaseDevelopTeam.stringValue = [_info getValueForKey:Defs_Release_Develop_Team];
    _customSDKPath.stringValue = [_info getValueForKey:Defs_Copy_Dir_Path];
    
    _frameworkNameArr = [_info getValueForKey:Defs_Framework_Names];
    _frameworkIsWeakArr = [_info getValueForKey:Defs_Framework_IsWeaks];
    _libNameArr = [_info getValueForKey:Defs_Lib_Names];
    _linkerFlagArr = [_info getValueForKey:Defs_Linker_Flag];
    _embedFrameworksArr = [_info getValueForKey:Defs_Embed_Framework];
    _customSdkArr = [_info getValueForKey:Defs_Custom_Sdk_Child];
}


- (int)checkOneInputIsNull:(NSTextField*)field
{
    if([field.stringValue isEqualToString:@""]){
        [field setBackgroundColor:[[NSColor redColor] colorWithAlphaComponent:0.5]];
        return 0;
    }else{
        [field setBackgroundColor:[NSColor clearColor]];
    }
    
    return 1;
}

- (BOOL)checkAndShowTipIfInputNull
{
    int code = ([self checkOneInputIsNull:_platform]&
                [self checkOneInputIsNull:_appName]&
                [self checkOneInputIsNull:_appID]&
                [self checkOneInputIsNull:_debugProfileName]&
                [self checkOneInputIsNull:_debugDevelopTeam]&
                [self checkOneInputIsNull:_releaseProfileName]&
                [self checkOneInputIsNull:_releaseDevelopTeam]&
                [self checkOneInputIsNull:_customSDKPath]);
    
    return code == 1 ? NO : YES;
}
    
- (IBAction)sureBtnClickFuncion:(id)sender
{
    if([self checkAndShowTipIfInputNull]){
        [[Alert instance] alertTip:@"确定" MessageText:@"错误提示" InformativeText:@"请将必填选项信息填写完整" callBackFrist:^{}];
        return;
    }
    
    NSString* appName = _appName.stringValue;
    NSString* appID = _appID.stringValue;
    NSString* debugProfileName = _debugProfileName.stringValue;
    NSString* debugDevelopTeam = _debugDevelopTeam.stringValue;
    NSString* releaseProfileName = _releaseProfileName.stringValue;
    NSString* releaseDevelopTeam = _releaseDevelopTeam.stringValue;
    NSString* platform = _platform.stringValue;
    NSString* customSdkPath = _customSDKPath.stringValue;
    
                         //value  key
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          appName, Defs_App_Name_Key,
                          appID, Defs_App_ID_Key,
                          debugProfileName, Defs_Debug_Profile_Name,
                          debugDevelopTeam, Defs_Debug_Develop_Team,
                          releaseProfileName, Defs_Release_Profile_Name,
                          releaseDevelopTeam,Defs_Release_Develop_Team,
                          platform, Defs_Platform_Name,
                          customSdkPath, Defs_Copy_Dir_Path,
                          s_true, Defs_Is_Selected ,
                          _frameworkNameArr, Defs_Framework_Names,
                          _frameworkIsWeakArr, Defs_Framework_IsWeaks,
                          _libNameArr, Defs_Lib_Names,
                          _linkerFlagArr, Defs_Linker_Flag,
                          _embedFrameworksArr, Defs_Embed_Framework,
                          _customSdkArr, Defs_Custom_Sdk_Child, nil];

    DetailsInfoData* info = [[DetailsInfoData alloc] initWithInfoDict:dict];
    if(_isEditMode){
        EVENT_SEND(EventDetailsInfoSettingEdit, info);
    }else{
        EVENT_SEND(EventDetailsInfoSettingClose, info);
    }
    
    _sureBtnClicked = YES;
    [self dismissViewController:self];
}
 
- (IBAction)cancelBtnClickFunction:(id)sender
{
    [[Alert instance] alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"温馨提示" InformativeText:@"你确定要取消操作？本次填写的信息将不会保存。" callBackFrist:^{
        [self dismissViewController:self];
    } callBackSecond:^{
    }];
}

- (IBAction)cDirectorySelected:(id)sender
{
    [self openFolderSelectDialog:@"SelectCopyDirPath"
                 IsCanSelectFile:NO
          IsCanSelectDirectories:YES
          allowMultipleSelection:NO
                 setDirectoryURL:nil
                        callback:^(NSOpenPanel *openDlg) {
                            if([openDlg.identifier isEqualToString:@"SelectCopyDirPath"]){
                                NSString *selectPath = [[openDlg URL] path];
                                _customSDKPath.stringValue = selectPath;
                            }
                        }];
}

- (void)openFolderSelectDialog:(NSString*)identifier
               IsCanSelectFile:(BOOL)chooseFile
        IsCanSelectDirectories:(BOOL)chooseDirectories
        allowMultipleSelection:(BOOL)isAllow
               setDirectoryURL:(nullable NSString*)urlString
                      callback:(void(^)(NSOpenPanel* openDlg))callback
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    openDlg.identifier = identifier;
    [openDlg setCanChooseFiles:chooseFile];
    [openDlg setCanChooseDirectories:chooseDirectories];
    [openDlg setAllowsMultipleSelection:isAllow];
    [openDlg setDelegate:self];
    [openDlg setDirectoryURL:[NSURL URLWithString:urlString]];

    if ([openDlg runModal] == NSModalResponseOK){
        callback(openDlg);
    }
}

- (IBAction)mobileprovisionSelect:(id)sender
{
    NSButton* button = (NSButton*)sender;
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"mobileprovision", nil]];
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        for(NSURL* url in [openDlg URLs])
        {
            NSString* selectPath = [url path];
            MobileprovisionParser* parser = [[MobileprovisionParser alloc] initWithProfilePath:selectPath];
            [parser createPlistFile];
            [parser parsePlistFile];
            
            if([button.identifier isEqualToString:@"debug"]){
                _appID.stringValue = parser.bundleIdentifier;
                _debugProfileName.stringValue = parser.fileName;
                _debugDevelopTeam.stringValue = parser.teamID;
            }else if([button.identifier isEqualToString:@"release"]){
                _releaseProfileName.stringValue = parser.fileName;
                _releaseDevelopTeam.stringValue = parser.teamID;
            }
        }
    }
}

- (IBAction)tblItemAdd:(id)sender
{
    NSButton *btn = (NSButton*)sender;
    if([btn.identifier isEqualToString:Defs_Frameworks]){
        [_frameworkNameArr addObject:@""];
        [_frameworkIsWeakArr addObject:@"false"];
        [_frameworkTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Libs]){
        [_libNameArr addObject:@""];
        [_libsTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Linker_Flag]){
        [_linkerFlagArr addObject:@"-ObjC"];
        [_linkerFlagTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Embed_Framework]){
        [_embedFrameworksArr addObject:@""];
        [_embedTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Custom_Sdk_Child]){
        if([_customSDKPath.stringValue isEqualToString:@""]){
            [[Alert instance] alertTip:@"确定" MessageText:@"错误提示" InformativeText:@"请先选择根路径" callBackFrist:^{}];
            [_customSDKPath setBackgroundColor:[[NSColor redColor] colorWithAlphaComponent:0.5]];
            return;
        }
        
        [self openFolderSelectDialog:@"customSDKChild"
                     IsCanSelectFile:NO
              IsCanSelectDirectories:YES
              allowMultipleSelection:YES
                     setDirectoryURL:_customSDKPath.stringValue
                            callback:^(NSOpenPanel *openDlg) {
                                if([openDlg.identifier isEqualToString:@"customSDKChild"]){
                                    NSArray *urls =[openDlg URLs];
                                    for(int i = 0; i < urls.count; i++){
                                        [_customSdkArr addObject:[urls[i] path]];
                                    }
                                    [_sdkChildTbl reloadData];
                                }
                            }];
    }
}

#define CHECK_IS_SELECT_ROW(tbl) if([tbl selectedRow] <= -1){return;}
- (IBAction)tblItemRemove:(id)sender
{
    NSButton *btn = (NSButton*)sender;
    
    if([btn.identifier isEqualToString:Defs_Frameworks]){
        CHECK_IS_SELECT_ROW(_frameworkTbl)
        [_frameworkNameArr removeObjectAtIndex:[_frameworkTbl selectedRow]];
        [_frameworkIsWeakArr removeObjectAtIndex:[_frameworkTbl selectedRow]];
        [_frameworkTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Libs]){
        CHECK_IS_SELECT_ROW(_libsTbl)
        [_libNameArr removeObjectAtIndex:[_libsTbl selectedRow]];
        [_libsTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Linker_Flag]){
        CHECK_IS_SELECT_ROW(_linkerFlagTbl)
        [_linkerFlagArr removeObjectAtIndex:[_linkerFlagTbl selectedRow]];
        [_linkerFlagTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Embed_Framework]){
        CHECK_IS_SELECT_ROW(_embedTbl)
        [_embedFrameworksArr removeObjectAtIndex:[_embedTbl selectedRow]];
        [_embedTbl reloadData];
    }else if([btn.identifier isEqualToString:Defs_Custom_Sdk_Child]){
        CHECK_IS_SELECT_ROW(_sdkChildTbl);
        [_customSdkArr removeObjectAtIndex:[_sdkChildTbl selectedRow]];
        [_sdkChildTbl reloadData];
    }
}

//返回表格的行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    if([tableView.identifier isEqualToString:Defs_Frameworks]){
        return [_frameworkNameArr count];
    }else if([tableView.identifier isEqualToString:Defs_Libs]){
        return [_libNameArr count];
    }else if([tableView.identifier isEqualToString:Defs_Linker_Flag]){
        return [_linkerFlagArr count];
    }else if([tableView.identifier isEqualToString:Defs_Embed_Framework]){
        return [_embedFrameworksArr count];
    }else if([tableView.identifier isEqualToString:Defs_Custom_Sdk_Child]){
        return [_customSdkArr count];
    }else{
        return 0;
    }
}

//初始化新行内容
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier=[tableColumn identifier];
    if(columnIdentifier == nil){
        NSLog(@"存在没有设置Identifier属性");
        return nil;
    }

    if([columnIdentifier isEqualToString:Defs_Framework_Names]){
        return [_frameworkNameArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Defs_Framework_IsWeaks]){
        return [_frameworkIsWeakArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Defs_Lib_Names]){
        return [_libNameArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Defs_Linker_Flag]){
        return [_linkerFlagArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Defs_Embed_Framework]){
        return [_embedFrameworksArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Defs_Custom_Sdk_Child]){
        NSString *folderName = [_customSdkArr objectAtIndex:row];
        return [folderName lastPathComponent];
    }
    return nil;
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier=[tableColumn identifier];
    NSString *newValue = (NSString*)object;
    
    if([columnIdentifier isEqualToString:Defs_Framework_Names]){
        if([[newValue pathExtension] isEqualToString:@"framework"]){
            [_frameworkNameArr replaceObjectAtIndex:row withObject:newValue];
        }else{
            newValue = [newValue stringByAppendingString:@".framework"];
            [_frameworkNameArr replaceObjectAtIndex:row withObject:newValue];
        }
    }else if([columnIdentifier isEqualToString:Defs_Framework_IsWeaks]){
        [_frameworkIsWeakArr replaceObjectAtIndex:row withObject:newValue];
    }else if([columnIdentifier isEqualToString:Defs_Lib_Names]){
        if([[newValue pathExtension] isEqualToString:@"tbd"]){
            [_libNameArr replaceObjectAtIndex:row withObject:newValue];
        }else{
            newValue = [newValue stringByAppendingString:@".tbd"];
            [_libNameArr replaceObjectAtIndex:row withObject:newValue];
        }
    }else if([columnIdentifier isEqualToString:Defs_Linker_Flag]){
        [_linkerFlagArr replaceObjectAtIndex:row withObject:newValue];
    }else if([columnIdentifier isEqualToString:Defs_Embed_Framework]){
        if([[newValue pathExtension] isEqualToString:@"framework"]){
            [_embedFrameworksArr replaceObjectAtIndex:row withObject:newValue];
        }else{
            newValue = [newValue stringByAppendingString:@".framework"];
            [_embedFrameworksArr replaceObjectAtIndex:row withObject:newValue];
        }
    }
}

- (IBAction)closeView:(id)sender
{
    [[Alert instance] alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"温馨提示" InformativeText:@"你确定要取消操作？本次填写的信息将不会保存。" callBackFrist:^{
        [self dismissViewController:self];
    } callBackSecond:^{
    }];
}

- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url
{
    NSOpenPanel *openDlg = (NSOpenPanel*)sender;
    if(![openDlg.identifier isEqualToString:@"customSDKChild"])
        return YES;
    
    NSString *path = [url path];
    NSString *rootDir = _customSDKPath.stringValue;
    
    return [[path stringByDeletingLastPathComponent] isEqualToString:rootDir] && ![path isEqualToString:rootDir];
}

- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing *)outError
{
    NSOpenPanel *openDlg = (NSOpenPanel*)sender;
    if(![openDlg.identifier isEqualToString:@"customSDKChild"])
        return YES;
    
    NSString *path = [url path];
    NSString *rootDir = _customSDKPath.stringValue;
    
    return [[path stringByDeletingLastPathComponent] isEqualToString:rootDir] && ![path isEqualToString:rootDir];
}

- (void)panel:(id)sender didChangeToDirectoryURL:(NSURL *)url
{
    NSOpenPanel *openDlg = (NSOpenPanel*)sender;
    if([openDlg.identifier isEqualToString:@"customSDKChild"])
    {
        NSString *path = [url path];
        NSString *rootDir = _customSDKPath.stringValue;
        if([path hasPrefix:rootDir])
            [sender setDirectoryURL:[NSURL URLWithString:path]];
    }
}

@end
