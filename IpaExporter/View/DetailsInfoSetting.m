//
//  DetailsInfoSetting.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoSetting.h"
#import "Defs.h"

@implementation DetailsInfoSetting

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)checkContent
{
    return NO;
}

- (IBAction)sureBtnClickFuncion:(id)sender
{
    NSString* appName = _appName.stringValue;
    NSString* appID = _appID.stringValue;
    NSString* codeSignIdentity = _codeSignIdentity.stringValue;
    NSString* provisioning = _provisioningProfile.stringValue;
    NSString* platform = _platform.stringValue;
    NSString* frameworks = _frameworks.stringValue;
    NSString* cDirPath = _cDirPath.stringValue;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appName, App_Name_Key,
                          appID, App_ID_Key, codeSignIdentity, Code_Sign_Identity_Key,
                          provisioning, Provisioning_Profile_key, platform, Platform_Name,
                          frameworks, Frameworks_Key, cDirPath, Copy_Dir_Path, nil];

    DetailsInfoData* info = [[DetailsInfoData alloc] initWithInfoDict:dict];
    [[EventManager instance] send:EventDetailsInfoSettingClose
                         withData:info];
    
    [self dismissViewController:self];
}
 
- (IBAction)cancelBtnClickFunction:(id)sender
{
    [self dismissViewController:self];
}

@end
