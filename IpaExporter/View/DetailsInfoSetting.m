//
//  DetailsInfoSetting.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoSetting.h"

@interface DetailsInfoSetting ()

@end

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
    
    DetailsInfoData* info = [[DetailsInfoData alloc] init];
    [info setInfoWithAppName:appName
                       appID:appID
            codeSignIdentity:codeSignIdentity
         provisioningProfile:provisioning];
    
    [[EventManager instance] send:EventDetailsInfoSettingClose
                         withData:info];
    
    [self dismissViewController:self];
}

- (IBAction)cancelBtnClickFunction:(id)sender
{
    [self dismissViewController:self];
}

@end
