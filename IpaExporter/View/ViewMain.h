//
//  ViewMain.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ExportInfoModel.h"

@interface ViewMain : NSViewController

@property(nonatomic, retain) IBOutlet NSTextField* infoLabel;
@property(nonatomic, retain) IBOutlet NSComboBox* unityPathBox;
@property(nonatomic, retain) IBOutlet NSComboBox* exportPathBox;
@property(nonatomic, retain) IBOutlet NSComboBox* developProfileBox;

- (IBAction)sureBtnClick:(id)sender;
- (IBAction)unityPathSelect:(id)sender;
- (IBAction)exportPathSelect:(id)sender;

@end
