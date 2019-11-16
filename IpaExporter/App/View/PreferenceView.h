//
//  PreferenceView.h
//  IpaExporter
//
//  Created by 4399 on 6/17/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Common.h"
#import "LogicManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtensionsMenu : NSMenuItem{
    CodeTester *_tester;
    PreferenceData *_dataInst;
}
@end

@interface PreferenceView : NSViewController<NSMenuDelegate>
{
    NSMutableDictionary<NSString*, NSPopUpButtonCell*> *_itemCellDict;
    
}

@property (weak) IBOutlet NSTextField *savePath;
@property (weak) IBOutlet NSPopUpButtonCell *codeApp;
@property (weak) IBOutlet NSButton *isSimpleSearch;

@end

@interface UserDefaultsSetting : NSViewController
@property (weak) IBOutlet NSTextField *plistPath;
@end

NS_ASSUME_NONNULL_END
