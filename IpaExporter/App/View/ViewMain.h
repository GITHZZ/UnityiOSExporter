//
//  ViewMain.h
//  IpaExporter
//
//  Created by 4399 on 7/27/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@interface ViewMain : NSTabViewController
{
    NSSet *_subView;
    NSMutableArray<NSViewController*> *_subViewQueue;
}

@property (weak) IBOutlet NSTabView *tabs;

@end
NS_ASSUME_NONNULL_END
