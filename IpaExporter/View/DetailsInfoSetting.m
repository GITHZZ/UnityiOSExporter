//
//  DetailsInfoSetting.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoSetting.h"
#import "Defs.h"

@interface DetailsInfoSetting ()
{
    BOOL _isSetDataOnShow;
    DetailsInfoData *_info;
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
    _frameworks.stringValue = [_info getValueForKey:Frameworks_Key];
    _cDirPath.stringValue = [_info getValueForKey:Copy_Dir_Path];
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
    NSString* frameworks = _frameworks.stringValue;
    NSString* cDirPath = _cDirPath.stringValue;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appName, App_Name_Key,
                          appID, App_ID_Key, debugProfileName, Debug_Profile_Name,
                          debugDevelopTeam, Debug_Develop_Team, releaseProfileName, Release_Profile_Name, releaseDevelopTeam, Release_Develop_Team, platform, Platform_Name,
                          frameworks, Frameworks_Key, cDirPath, Copy_Dir_Path, @"0", Is_Selected ,nil];

    DetailsInfoData* info = [[DetailsInfoData alloc] initWithInfoDict:dict];
    if(_isSetDataOnShow)
    {
        [[EventManager instance] send:EventDetailsInfoSettingEdit
                             withData:info];
    }
    else{
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

@end
