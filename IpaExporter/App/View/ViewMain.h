//
//  ViewMain.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ExportInfoManager.h"

@interface ViewMain : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate>{
@private
    NSMutableArray<NSString*> *_sceneArray;
    NSTimer *_showTimer;
    NSTimeInterval _packTime;
    BOOL _isVisable;
}

@property (readonly) NSMutableArray<DetailsInfoData*>* dataDict;

@property (strong) IBOutlet NSTextView* infoLabel;
@property (weak) IBOutlet NSComboBox* unityPathBox;
@property (weak) IBOutlet NSComboBox* exportPathBox;
@property (weak) IBOutlet NSTableView *platformTbl;
@property (weak) IBOutlet NSTableView *packSceneTbl;
@property (weak) IBOutlet NSButton *isReleaseBox;
@property (weak) IBOutlet NSButton *exportBtn;
@property (weak) IBOutlet NSTextField *useTimeLabel;
@property (weak) IBOutlet NSButton *isExportXcode;
@property (weak) IBOutlet NSProgressIndicator *progressTip;


- (IBAction)sureBtnClick:(id)sender;
- (IBAction)unityPathSelect:(id)sender;
- (IBAction)exportPathSelect:(id)sender;

- (void)reloadAllInfo;

@end
