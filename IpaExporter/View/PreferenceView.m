//
//  PreferenceView.m
//  IpaExporter
//
//  Created by 4399 on 6/17/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PreferenceView.h"
#import "ExportInfoManager.h"
#import "PackCammond.h"

@implementation PreferenceView

- (void)viewDidAppear
{
    NSString *codeSavePath = [ExportInfoManager instance].codeBackupPath;
    if(codeSavePath != nil)
        _savePath.stringValue = codeSavePath;
}

- (void)viewDidDisappear
{
    
}

- (IBAction)openCustomCodeFolder:(id)sender
{
    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder/Users"];
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:resPath];
}

- (IBAction)cleanAllCache:(id)sender
{
    
}
    
- (IBAction)savePathSelect:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    if([openDlg runModal] == NSModalResponseOK)
    {
        NSString* selectPath = [[openDlg URL] path];
        _savePath.stringValue = selectPath;
        [[ExportInfoManager instance] setCodeSavePath:selectPath];
        [[ExportInfoManager instance] saveData];
    }
}
    
@end

@implementation ExtensionsMenu

- (IBAction)openCustomCodeFile:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder/Users/_CustomBuilder.cs"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)openCustomConfig:(id)sender
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder/Users/_CustomConfig.json"];
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (IBAction)backup:(id)sender
{
    [[PackCammond instance] backUpCustomCode];
}

- (IBAction)restore:(id)sender
{
    [[PackCammond instance] restoreCustomCode];
}

@end
