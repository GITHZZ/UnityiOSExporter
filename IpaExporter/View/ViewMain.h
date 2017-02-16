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

@interface ViewMain : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate>

@property (nonatomic, readonly) NSMutableArray* dataDict;

@property (nonatomic, strong) IBOutlet NSTextView* infoLabel;
@property (nonatomic, weak) IBOutlet NSComboBox* unityPathBox;
@property (nonatomic, weak) IBOutlet NSComboBox* exportPathBox;
@property (weak) IBOutlet NSTableView *platformTbl;


- (IBAction)sureBtnClick:(id)sender;
- (IBAction)unityPathSelect:(id)sender;
- (IBAction)exportPathSelect:(id)sender;

@end
