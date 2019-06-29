//
//  DetailsInfoSetting.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "DetailsInfoData.h"
#import "Common.h"

@interface DetailsInfoSetting : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *platform;
@property (weak) IBOutlet NSTextField *appName;
@property (weak) IBOutlet NSTextField *appID;
@property (weak) IBOutlet NSTextField *debugProfileName;
@property (weak) IBOutlet NSTextField *debugDevelopTeam;
@property (weak) IBOutlet NSTextField *releaseProfileName;
@property (weak) IBOutlet NSTextField *releaseDevelopTeam;
@property (weak) IBOutlet NSComboBox *customSDKPath;
@property (weak) IBOutlet NSView *detailView;
@property (weak) IBOutlet NSButton *sureBtn;
@property (weak) IBOutlet NSTableView *frameworkTbl;
@property (weak) IBOutlet NSTableView *libsTbl;
@property (weak) IBOutlet NSTableView *linkerFlagTbl;
@property (weak) IBOutlet NSTableView *embedTbl;

- (void)setUpDataInfoOnShow:(DetailsInfoData*)info isEditMode:(BOOL)isEdit;

@end

