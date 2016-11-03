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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(IBAction)ViewHasBeenClosed:(id)sender
{
    NSString* appID = _appID.stringValue;
    NSString* codeSignIdentity = _codeSignIdentity.stringValue;
    
    DetailsInfoData* info = [[DetailsInfoData alloc] init];
    [info setInfoWithAppID:appID codeSignIdentity:codeSignIdentity];
    
    [[EventManager instance] send:EventDetailsInfoSettingClose
                         withData:info];
    [self dismissViewController:self];
}

@end
