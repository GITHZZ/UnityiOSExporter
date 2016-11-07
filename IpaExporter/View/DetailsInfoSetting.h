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

@property (nonatomic, retain) IBOutlet NSTextField* platform;
@property (nonatomic, retain) IBOutlet NSTextField* appName;
@property (nonatomic, retain) IBOutlet NSTextField* appID;
@property (nonatomic, retain) IBOutlet NSTextField* codeSignIdentity;
@property (nonatomic, retain) IBOutlet NSTextField* provisioningProfile;

@end

