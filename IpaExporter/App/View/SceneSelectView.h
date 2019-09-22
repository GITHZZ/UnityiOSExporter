//
//  SceneSelectView.h
//  IpaExporter
//
//  Created by 4399 on 9/22/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ExportInfoManager;
@interface SceneSelectView : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate>
{
    NSMutableArray *_sceneArray;
    NSMutableSet *_selectScene;
    ExportInfoManager *_exportManager;
}
@property (weak) IBOutlet NSTableView *unitySceneTbl;

@end

NS_ASSUME_NONNULL_END
