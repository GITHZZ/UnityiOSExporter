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
#import "DetailsInfoData.h"
#import "ExportInfoManager.h"

@interface ViewMain()<NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate>
@end

@implementation ViewMain

- (void)viewDidLoad
{
    [self startUp];
    [self registEvent];
    [[EventManager instance] send:EventViewMainLoaded withData:nil];
}

- (void)startUp
{
    [[ExportInfoManager instance] reloadPaths];
    
    ExportInfo* info = [ExportInfoManager instance].info;
    NSMutableArray* unityProjPathArr = [ExportInfoManager instance].unityProjPathArr;
    NSMutableArray* exportPathArr = [ExportInfoManager instance].exportPathArr;
    _unityPathBox.delegate = self;
    _exportPathBox.delegate = self;
    
    if ([unityProjPathArr count] > 0)
    {
        _unityPathBox.stringValue = (NSString*)[unityProjPathArr lastObject];
        info->unityProjPath = [_unityPathBox.stringValue UTF8String];
        [_unityPathBox addItemsWithObjectValues:unityProjPathArr];
    }
    
    if ([exportPathArr count] > 0)
    {
        _exportPathBox.stringValue = (NSString*)[exportPathArr lastObject];
        info->exportFolderParh = [_exportPathBox.stringValue UTF8String];
        [_exportPathBox addItemsWithObjectValues:exportPathArr];
    }
    
    //从本地读取存储数据
    NSMutableArray* saveArray = [[ExportInfoManager instance] reLoadDetails];
    _dataDict = [[NSMutableArray alloc] initWithArray:saveArray];
    
    //设置数据源
    _platformTbl.delegate = self;
    _platformTbl.dataSource = self;
}

- (void)registEvent
{
    [[EventManager instance] regist:EventDetailsInfoUpdate
                               func:@selector(detailsInfoDictUpdate:)
                           withData:nil
                               self:self];
    
    [[EventManager instance] regist:EventAddNewInfoContent
                               func:@selector(addNewInfoContent:)
                           withData:nil
                               self:self];
    
    [[EventManager instance] regist:EventAddErrorContent
                               func:@selector(addNewErrorContent:)
                           withData:nil
                               self:self];
}

- (void)unRegistEvent
{
    [[EventManager instance] unRegist:EventDetailsInfoUpdate
                                 self:self];
    [[EventManager instance] unRegist:EventAddNewInfoContent
                               self:self];
    [[EventManager instance] unRegist:EventAddErrorContent
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
    
    ExportInfo* tInfo = [ExportInfoManager instance].info;
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        for(NSURL* url in [openDlg URLs])
        {
            NSString* selectPath = [url path];
            
            switch (et)
            {
                case EventUnityPathSelectEnd:
                    tInfo->unityProjPath = [selectPath UTF8String];
                    [ExportInfoManager instance].info = tInfo;
                    [[ExportInfoManager instance] addNewUnityProjPath:selectPath];
                    _unityPathBox.stringValue = selectPath;
                    break;
                case EventExportPathSelectEnd:
                    tInfo->exportFolderParh = [selectPath UTF8String];
                    [ExportInfoManager instance].info = tInfo;
                    [[ExportInfoManager instance] addNewExportProjPath:selectPath];
                    _exportPathBox.stringValue = selectPath;
                    break;
                default:
                    break;
            }
            
            [[ExportInfoManager instance] saveData];
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

- (void)detailsInfoDictUpdate:(NSNotification*)notification
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
    
    NSString *isSelect = info.isSelected;
    if(isSelect == nil)
        isSelect = @"0";
    
    [cell setState:[isSelect integerValue]];
    
    return cell;
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSButtonCell* cell = [tableColumn dataCellForRow:row];
    
    DetailsInfoData *data = (DetailsInfoData*)[_dataDict objectAtIndex:row];
    NSInteger newState = ![cell state];
    NSString *newStateStr = [NSString stringWithFormat:@"%ld", newState];
    [cell setState: newState];
    [data setValueForKey:Is_Selected withObj:newStateStr];
    
    [[ExportInfoManager instance] updateDetail:row withObject:data];
}

//修改comboBox内容
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification
{
    //bug:延迟到下一帧取数据
    [self performSelector:@selector(readComboValue:) withObject:[notification object] afterDelay:0];
}


- (void)readComboValue:(id)object
{
    NSComboBox* box = (NSComboBox *)object;
    NSString *changePath = [box stringValue];
    ExportInfo* info = [ExportInfoManager instance].info;
    
    if([[box identifier] isEqualToString:@"unityPathBox"])
    {
        info->unityProjPath = [changePath UTF8String];
        [[ExportInfoManager instance] replaceUnityProjPath:changePath];
        [[ExportInfoManager instance] saveData];
    }
    else if([[box identifier] isEqualToString:@"exportPathBox"])
    {
        info->exportFolderParh = [changePath UTF8String];
        [[ExportInfoManager instance] replaceExportProjPath:changePath];
        [[ExportInfoManager instance] saveData];
    }
    else
    {
        showLog("未知路径类型%@", changePath);
    }
}

- (void)addNewInfoContent:(NSNotification*)notification
{
    NSString *content = [notification object];
    [self renderUpAttriString:content withColor:[NSColor blackColor]];
}

- (void)addNewErrorContent:(NSNotification*)notification
{
    NSString *content = [notification object];
    [self renderUpAttriString:content withColor:[NSColor redColor]];
}

- (void)renderUpAttriString:(NSString*)string withColor:(NSColor*) color
{
    NSString *newStr = [string stringByAppendingString:@"\n"];
    NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:newStr];
    [addString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [newStr length] - 1)];
    [[_infoLabel textStorage] appendAttributedString:addString];
    
    [_infoLabel scrollRectToVisible:CGRectMake(0, _infoLabel.textContainer.size.height-15, _infoLabel.textContainer.size.width, 10)];
}

@end
