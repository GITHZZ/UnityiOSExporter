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

#define FrameworkKey  @"frameworkTbl"
#define EmbedFrameworksKey @"embedTbl"
#define LibKey        @"libsTbl"
#define LinkerFlagKey @"linkerFlagTbl"

@interface DetailsInfoSetting ()
{
    BOOL _isSetDataOnShow;
    BOOL _isEditMode;
    DetailsInfoData *_info;
    
    NSMutableArray<NSString*> *_frameworkNameArr;
    NSMutableArray<NSString*> *_frameworkIsWeakArr;
    NSMutableArray<NSString*> *_embedFrameworksArr;
    NSMutableArray<NSString*> *_libNameArr;
    NSMutableArray<NSString*> *_linkerFlagArr;
}
@end

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
    
    _frameworkTbl.delegate = self;
    _frameworkTbl.dataSource = self;
    _libsTbl.delegate = self;
    _libsTbl.dataSource = self;
    _linkerFlagTbl.delegate = self;
    _linkerFlagTbl.dataSource = self;
    _embedTbl.delegate = self;
    _embedTbl.dataSource = self;
    
    _appID.enabled = NO;
    _debugProfileName.enabled = NO;
    _debugDevelopTeam.enabled = NO;
    _releaseProfileName.enabled = NO;
    _releaseDevelopTeam.enabled = NO;
    
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
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appName, Defs_App_Name_Key, appID, Defs_App_ID_Key, debugProfileName, Defs_Debug_Profile_Name, debugDevelopTeam, Defs_Debug_Develop_Team, releaseProfileName, Defs_Release_Profile_Name, releaseDevelopTeam,Defs_Release_Develop_Team, platform, Defs_Platform_Name, customSdkPath, Defs_Copy_Dir_Path, s_false, Defs_Is_Selected ,_frameworkNameArr, Defs_Framework_Names, _frameworkIsWeakArr, Defs_Framework_IsWeaks, _libNameArr, Defs_Lib_Names, _linkerFlagArr, Defs_Linker_Flag, _embedFrameworksArr, Defs_Embed_Framework, nil];

    DetailsInfoData* info = [[DetailsInfoData alloc] initWithInfoDict:dict];
    if(_isEditMode)
    {
        [[EventManager instance] send:EventDetailsInfoSettingEdit
                             withData:info];
    }
    else
    {
        [[EventManager instance] send:EventDetailsInfoSettingClose
                         withData:info];
    }
    
    _isSetDataOnShow = NO;
    [self dismissViewController:self];
}
 
- (IBAction)cancelBtnClickFunction:(id)sender
{
    _isSetDataOnShow = NO;
    [self cancelSetting];
}

- (IBAction)cDirectorySelected:(id)sender
{
    [self openFolderSelectDialog:EventSelectCopyDirPath
                 IsCanSelectFile:NO
          IsCanSelectDirectories:YES];
}

- (void)openFolderSelectDialog:(EventType)et
               IsCanSelectFile:(BOOL)chooseFile
        IsCanSelectDirectories:(BOOL)chooseDirectories
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:chooseFile];
    [openDlg setCanChooseDirectories:chooseDirectories];
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        for(NSURL* url in [openDlg URLs])
        {
            NSString* selectPath = [url path];
            switch (et)
            {
                case EventSelectCopyDirPath:
                    _customSDKPath.stringValue = selectPath;
                    break;
                default:
                    break;
            }
        }
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
    if([btn.identifier isEqualToString:FrameworkKey]){
        [_frameworkNameArr addObject:@""];
        [_frameworkIsWeakArr addObject:@""];
        [_frameworkTbl reloadData];
    }else if([btn.identifier isEqualToString:LibKey]){
        [_libNameArr addObject:@""];
        [_libsTbl reloadData];
    }else if([btn.identifier isEqualToString:LinkerFlagKey]){
        [_linkerFlagArr addObject:@"-ObjC"];
        [_linkerFlagTbl reloadData];
    }else if([btn.identifier isEqualToString:EmbedFrameworksKey]){
        [_embedFrameworksArr addObject:@""];
        [_embedTbl reloadData];
    }
}

- (IBAction)tblItemRemove:(id)sender
{
    NSButton *btn = (NSButton*)sender;
    
    if([btn.identifier isEqualToString:FrameworkKey]){
        NSInteger row = [_frameworkTbl selectedRow];
        if(row <= -1){
            return;
        }
        
        [_frameworkNameArr removeObjectAtIndex:row];
        [_frameworkIsWeakArr removeObjectAtIndex:row];
        [_frameworkTbl reloadData];
    }else if([btn.identifier isEqualToString:LibKey]){
        NSInteger row = [_libsTbl selectedRow];
        if(row <= -1){
            return;
        }
        
        [_libNameArr removeObjectAtIndex:row];
        [_libsTbl reloadData];
    }else if([btn.identifier isEqualToString:LinkerFlagKey]){
        NSInteger row = [_linkerFlagTbl selectedRow];
        if(row <= -1){
            return;
        }
        
        [_linkerFlagArr removeObjectAtIndex:row];
        [_linkerFlagTbl reloadData];
    }else if([btn.identifier isEqualToString:EmbedFrameworksKey]){
        NSInteger row = [_embedTbl selectedRow];
        if(row <= -1){
            return;
        }
        
        [_embedFrameworksArr removeObjectAtIndex:row];
        [_embedTbl reloadData];
    }
}

//返回表格的行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    if([tableView.identifier isEqualToString:FrameworkKey]){
        return [_frameworkNameArr count];
    }else if([tableView.identifier isEqualToString:LibKey]){
        return [_libNameArr count];
    }else if([tableView.identifier isEqualToString:LinkerFlagKey]){
        return [_linkerFlagArr count];
    }else if([tableView.identifier isEqualToString:EmbedFrameworksKey]){
        return [_embedFrameworksArr count];
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
    [self cancelSetting];
}

- (void)cancelSetting
{
    [[Alert instance] alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"温馨提示" InformativeText:@"你确定要取消操作？本次填写的信息将不会保存。" callBackFrist:^{
        [self dismissViewController:self];
    } callBackSecond:^{
    }];
}
  
@end
