//
//  DetailsInfoSetting.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoSetting.h"
#import "Defs.h"

#define FrameworkKey  @"frameworkTbl"
#define LibKey        @"libsTbl"
#define LinkerFlagKey @"linkerFlagTbl"

@interface DetailsInfoSetting ()
{
    BOOL _isSetDataOnShow;
    DetailsInfoData *_info;
    
    NSMutableArray<NSString*> *_frameworkNameArr;
    NSMutableArray<NSString*> *_frameworkIsWeakArr;
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
    {
        _sureBtn.title = @"添加";
    }
    
    if(_frameworkNameArr == nil){
        _frameworkNameArr = [NSMutableArray arrayWithCapacity:10];
    }
    if(_frameworkIsWeakArr == nil){
        _frameworkIsWeakArr = [NSMutableArray arrayWithCapacity:10];
    }
    if(_libNameArr == nil){
        _libNameArr = [NSMutableArray arrayWithCapacity:10];
    }
    if(_linkerFlagArr == nil){
        _linkerFlagArr = [NSMutableArray arrayWithCapacity:10];
    }
    
    _frameworkTbl.delegate = self;
    _frameworkTbl.dataSource = self;
    _libsTbl.delegate = self;
    _libsTbl.dataSource = self;
    _linkerFlagTbl.delegate = self;
    _linkerFlagTbl.dataSource = self;
}

- (void)setUpDataInfoOnShow:(DetailsInfoData*)info
{
    _info = info;
    _isSetDataOnShow = YES;
}

- (void)setUpInfo
{
    if(nil == _info)
        return;
    
    _appName.stringValue = [_info getValueForKey:App_Name_Key];
    _appID.stringValue = [_info getValueForKey:App_ID_Key];
    _debugProfileName.stringValue = [_info getValueForKey:Debug_Profile_Name];
    _debugDevelopTeam.stringValue = [_info getValueForKey:Debug_Develop_Team];
    _releaseProfileName.stringValue = [_info getValueForKey:Release_Profile_Name];
    _releaseDevelopTeam.stringValue = [_info getValueForKey:Release_Develop_Team];
    _platform.stringValue = [_info getValueForKey:Platform_Name];
    _cDirPath.stringValue = [_info getValueForKey:Copy_Dir_Path];
    _frameworkNameArr = [_info getValueForKey:Framework_Names];
    _frameworkIsWeakArr = [_info getValueForKey:Framework_IsWeaks];
    _libNameArr = [_info getValueForKey:Lib_Names];
    _linkerFlagArr = [_info getValueForKey:Linker_Flag];
}

- (IBAction)sureBtnClickFuncion:(id)sender
{
    NSString* appName = _appName.stringValue;
    NSString* appID = _appID.stringValue;
    NSString* debugProfileName = _debugProfileName.stringValue;
    NSString* debugDevelopTeam = _debugDevelopTeam.stringValue;
    NSString* releaseProfileName = _releaseProfileName.stringValue;
    NSString* releaseDevelopTeam = _releaseDevelopTeam.stringValue;
    NSString* platform = _platform.stringValue;
    NSString* cDirPath = _cDirPath.stringValue;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appName, App_Name_Key, appID, App_ID_Key, debugProfileName, Debug_Profile_Name, debugDevelopTeam, Debug_Develop_Team, releaseProfileName, Release_Profile_Name, releaseDevelopTeam, Release_Develop_Team, platform, Platform_Name, cDirPath, Copy_Dir_Path, s_false, Is_Selected ,_frameworkNameArr, Framework_Names, _frameworkIsWeakArr, Framework_IsWeaks, _libNameArr, Lib_Names, _linkerFlagArr, Linker_Flag, nil];

    DetailsInfoData* info = [[DetailsInfoData alloc] initWithInfoDict:dict];
    if(_isSetDataOnShow)
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
    [self dismissViewController:self];
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
                    _cDirPath.stringValue = selectPath;
                    break;
                default:
                    break;
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

    if([columnIdentifier isEqualToString:Framework_Names]){
        return [_frameworkNameArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Framework_IsWeaks]){
        return [_frameworkIsWeakArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Lib_Names]){
        return [_libNameArr objectAtIndex:row];
    }else if([columnIdentifier isEqualToString:Linker_Flag]){
        return [_linkerFlagArr objectAtIndex:row];
    }
    return nil;
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier=[tableColumn identifier];
    NSString *newValue = (NSString*)object;
    
    if([columnIdentifier isEqualToString:Framework_Names]){
        if([[newValue pathExtension] isEqualToString:@"framework"]){
            [_frameworkNameArr replaceObjectAtIndex:row withObject:newValue];
        }
    }else if([columnIdentifier isEqualToString:Framework_IsWeaks]){
        [_frameworkIsWeakArr replaceObjectAtIndex:row withObject:newValue];
    }else if([columnIdentifier isEqualToString:Lib_Names]){
        if([[newValue pathExtension] isEqualToString:@"tbd"]){
            [_libNameArr replaceObjectAtIndex:row withObject:newValue];
        }
    }else if([columnIdentifier isEqualToString:Linker_Flag]){
        [_linkerFlagArr replaceObjectAtIndex:row withObject:newValue];
    }
}

@end
