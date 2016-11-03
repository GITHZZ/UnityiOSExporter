//
//  DetailsInfo.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/13.
//  Copyright © 2016年 何遵祖. All rights reserved.
//
//  PS:坑爹的NSTableView 要把属性contentMode改成View Based设置成Cell Based不是不能显示
//  @http://www.07net01.com/2015/10/937976.html

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "EventManager.h"
#import "DetailsInfoSetting.h"

@interface DetailsInfoView : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (retain) DetailsInfoSetting* settingView;
@property (nonatomic, readonly) NSMutableArray* dataDict;
@property (weak) IBOutlet NSTableView *infoTbls;

- (IBAction)addInfo:(id)sender;
- (IBAction)removeInfo:(id)sender;

@end
