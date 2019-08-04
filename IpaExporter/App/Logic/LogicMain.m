//
//  LogicMain.m
//  IpaExporter
//
//  Created by 4399 on 8/4/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "LogicMain.h"
#import "PackCammond.h"
#import "DetailsInfoData.h"
#import "ExportInfoManager.h"
#import "DataResManager.h"
#import "BuilderCSFileEdit.h"
#import "PreferenceData.h"
#import "VersionInfo.h"

@implementation LogicMain

- (void)startUp
{
    _instanceArray = @[[PackCammond instance],
                       [DetailsInfoData instance],
                       [ExportInfoManager instance],
                       [DataResManager instance],
                       [BuilderCSFileEdit instance],
                       [PreferenceData instance],
                       [VersionInfo instance]];
}

- (NSObject*)getInstByClassName:(NSString*)className
{
    for (int i = 0; i < [_instanceArray count]; i++) {
        NSObject* item = _instanceArray[i];
        if([[item className] isEqualToString:className])
            return item;
    }
    return nil;
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[PreferenceData instance] backUpCustomCode];
}

@end
