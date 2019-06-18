//
//  PreferenceView.m
//  IpaExporter
//
//  Created by 4399 on 6/17/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PreferenceView.h"

@implementation PreferenceView

- (void)viewDidAppear
{
}

- (void)viewDidDisappear
{
    
}

- (IBAction)openCustomCodeFolder:(id)sender
{
    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder"];
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:resPath];
}

- (IBAction)cleanAllCache:(id)sender
{
    
}
@end

@implementation ExtensionsMenu

- (IBAction)openCustomCodeFile:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder/_CustomBuilder.cs"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)openCustomConfig:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder/_CustomConfig.json"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}
@end
