//
//  ViewMain.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ViewMain.h"
#import "EventManager.h"
#import "LuaCammond.h"
#import "DetailsInfoView.h"

@implementation ViewMain

-(void)startUp
{
    _infoLabel.stringValue = @"";
    
    [_unityPathBox removeAllItems];
    [_exportPathBox removeAllItems];
}

- (IBAction)sureBtnClick:(id)sender
{
    [[EventManager instance] send:EventViewSureClicked withData:sender];
}

- (void)openFolderSelectDialog:(EventType)et
               IsCanSelectFile:(BOOL)chooseFile
        IsCanSelectDirectories:(BOOL)chooseDirectories
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:chooseFile];
    [openDlg setCanChooseDirectories:chooseDirectories];
    
    ExportInfo* tInfo = [ExportInfoModel instance].info;
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        for(NSURL* url in [openDlg URLs])
        {
            NSString* selectPath = [url path];
            
            switch (et)
            {
                case EventUnityPathSelectEnd:
                    tInfo->unityProjPath = [selectPath UTF8String];
                    [ExportInfoModel instance].info = tInfo;
                    _unityPathBox.stringValue = selectPath;
                    break;
                case EventExportPathSelectEnd:
                    tInfo->exportFolderParh = [selectPath UTF8String];
                    [ExportInfoModel instance].info = tInfo;
                    _exportPathBox.stringValue = selectPath;
                    break;
                default:
                    break;
            }
            
            [[ExportInfoModel instance]saveData];
        }
    }
}

- (IBAction)unityPathSelect:(id)sender
{
    [self openFolderSelectDialog:EventUnityPathSelectEnd
                 IsCanSelectFile:NO
          IsCanSelectDirectories:YES];
}

- (IBAction)exportPathSelect:(id)sender
{
    [self openFolderSelectDialog:EventExportPathSelectEnd
                 IsCanSelectFile:NO
          IsCanSelectDirectories:YES];
}

- (void)viewDidLoad
{
    [self startUp];
    [[EventManager instance] send:EventViewMainLoaded withData:nil];
}

@end
