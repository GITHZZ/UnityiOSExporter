//
//  DetailsInfoSetting.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "EventManager.h"
#import "DetailsInfoData.h"

@interface DetailsInfoSetting : NSViewController

@property (nonatomic, weak) IBOutlet NSTextField *platform;
@property (nonatomic, weak) IBOutlet NSTextField *appName;
@property (nonatomic, weak) IBOutlet NSTextField *appID;
@property (nonatomic, weak) IBOutlet NSTextField *codeSignIdentity;
@property (nonatomic, weak) IBOutlet NSTextField *provisioningProfile;
@property (nonatomic, weak) IBOutlet NSTextField *frameworks;
@property (nonatomic, weak) IBOutlet NSComboBox *cDirPath;

@end

