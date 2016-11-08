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

- (void)viewDidLoad
{
    [self startUp];
    
    [[ExportInfoModel instance] reloadPaths];
    
    NSString* projectPath = [NSString stringWithUTF8String:[ExportInfoModel instance].info->unityProjPath];
    NSString* exportPath = [NSString stringWithUTF8String:[ExportInfoModel instance].info->exportFolderParh];
    
    _unityPathBox.stringValue = projectPath;
    _exportPathBox.stringValue = exportPath;
    
    //从本地读取存储数据
    NSMutableArray* saveArray = [[ExportInfoModel instance] reLoadDetails];
    _dataDict = [[NSMutableArray alloc] initWithArray:saveArray];
    
    //设置数据源
    _platformTbl.delegate = self;
    _platformTbl.dataSource = self;
    
    [self registEvent];
    [[EventManager instance] send:EventViewMainLoaded withData:nil];
}

- (void)startUp
{
    //_infoLabel.stringValue = @"";
    
    [_unityPathBox removeAllItems];
    [_exportPathBox removeAllItems];
}

- (void) registEvent
{
    [[EventManager instance] regist:EventDetailsInfoUpdate
                               func:@selector(DetailsInfoDictUpdate:)
                           withData:nil
                               self:self];
}

- (void) unRegistEvent
{
    [[EventManager instance] unRegist:EventDetailsInfoUpdate
                                 self:self];
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
            
            [[ExportInfoModel instance] saveData];
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

- (void)DetailsInfoDictUpdate:(NSNotification*)notification
{
    NSMutableArray* dict = (NSMutableArray*)[notification object];
    _dataDict = dict;
    [_platformTbl reloadData];
}

//返回表格的行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return [_dataDict count];
}

//初始化新行内容
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier=[tableColumn identifier];
    if(columnIdentifier == nil)
    {
        NSLog(@"存在没有设置Identifier属性");
        return nil;
    }
    
    DetailsInfoData* info = [_dataDict objectAtIndex:row];
    NSString* title = [info valueForKey:columnIdentifier];
    NSButtonCell* cell = [tableColumn dataCellForRow:row];
    cell.tag = row;
    cell.title = title;
    
    return cell;
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
//    NSString *columnIdentifier=[tableColumn identifier];
//    DetailsInfoData* info = [_dataDict objectAtIndex:row];
    NSButtonCell* cell = [tableColumn dataCellForRow:row];
    
//    NSString* newValue = (NSString*)object;
//    BOOL state = [object boolValue];
    
    if([cell state] == YES)
        [cell setState:NO];
    else
        [cell setState:YES];
    
//    [info setValue:newValue forKey:columnIdentifier];
}

@end
