//
//  ViewMain.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ViewMain.h"
#import "EventManager.h"
#import "DetailsInfoView.h"
#import "DetailsInfoData.h"
#import "ExportInfoManager.h"
#import "NSString+Emoji.h"

#define PlatformTblKey @"platformTbl"
#define PackSceneKey   @"packScene"

@interface ViewMain()<NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate>
{
    NSMutableArray<NSString*> *_sceneArray;
    NSTimer *_showTimer;
    NSTimeInterval _packTime;
}
@end

@implementation ViewMain

- (void)viewDidLoad
{
    [self startUp];
    [[EventManager instance] send:EventViewMainLoaded withData:nil];
}

- (void)viewDidAppear
{
    [self registEvent];
}

- (void)viewDidDisappear
{
    [self unRegistEvent];
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
    NSMutableArray<DetailsInfoData*> *saveArray = [[ExportInfoManager instance] reLoadDetails:SAVE_DETAIL_ARRARY_KEY];
    _dataDict = [[NSMutableArray alloc] initWithArray:saveArray];
    
    NSMutableArray<NSString*> *saveSceneArr = [[ExportInfoManager instance] reLoadDetails:SAVE_SCENE_ARRAY_KEY];
    _sceneArray = [[NSMutableArray alloc] initWithArray:saveSceneArr];
    
    //设置数据源
    _platformTbl.delegate = self;
    _platformTbl.dataSource = self;
    
    _packSceneTbl.delegate = self;
    _packSceneTbl.dataSource = self;
    
    _isReleaseBox.state = 0;
    _isExportXcode.state = 1;
    
    info->isRelease = (int)_isReleaseBox.state;
    info->isExportXcode = (int)_isExportXcode.state;
    
    _useTimeLabel.stringValue = @"";
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
    
    [[EventManager instance] regist:EventAddNewSuccessContent
                               func:@selector(addNewSuccessContent:)
                           withData:nil
                               self:self];
    
    
    [[EventManager instance] regist:EventAddNewWarningContent
                               func:@selector(addNewWarningContent:)
                           withData:nil
                               self:self];
    
    [[EventManager instance] regist:EventAddErrorContent
                               func:@selector(addNewErrorContent:)
                           withData:nil
                               self:self];
    
    [[EventManager instance] regist:EventSetExportButtonState
                               func:@selector(setExportBtnState:)
                           withData:nil
                               self:self];
    
    [[EventManager instance] regist:EventStartRecordTime
                               func:@selector(startShowPackTime:)
                           withData:nil
                               self:self];
    
    [[EventManager instance] regist:EventStopRecordTime
                               func:@selector(stopShowPackTime:)
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
    [[EventManager instance] unRegist:EventAddNewSuccessContent
                               self:self];
    [[EventManager instance] unRegist:EventAddNewWarningContent
                               self:self];
    [[EventManager instance] unRegist:EventSetExportButtonState
                                 self:self];
    [[EventManager instance] unRegist:EventStartRecordTime
                               self:self];
    [[EventManager instance] unRegist:EventStopRecordTime
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
                case EventScenePathSelectEnd:
                    if(![[selectPath pathExtension] isEqualToString:@"unity"]){
                        showError("**[加入新打包场景失败]：选择场景文件必须为unity后缀文件");
                        return;
                    }
                    
                    [_sceneArray addObject:selectPath];
                    [[ExportInfoManager instance] addDetail:selectPath withKey:SAVE_SCENE_ARRAY_KEY];
                    [_packSceneTbl reloadData];
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

- (IBAction)scenePathSelect:(id)sender
{
    [self openFolderSelectDialog:EventScenePathSelectEnd
                 IsCanSelectFile:YES
          IsCanSelectDirectories:NO];
}

- (IBAction)removeScenePath:(id)sender
{
    NSInteger row = [_packSceneTbl selectedRow];
    if([_sceneArray count] > 0){
        [_sceneArray removeObjectAtIndex:row];
    }
    [[ExportInfoManager instance] removeDetail:row withKey:SAVE_SCENE_ARRAY_KEY];
    [_packSceneTbl reloadData];
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
    if([tableView.identifier isEqualToString:PlatformTblKey]){
        return [_dataDict count];
    }
    else if([tableView.identifier isEqualToString:PackSceneKey]){
        return [_sceneArray count];
    }
    
    return 0;
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
    
    id itemCell;
    if([tableView.identifier isEqualToString:PlatformTblKey]){
        DetailsInfoData *info = [_dataDict objectAtIndex:row];
        NSString* title = [info valueForKey:columnIdentifier];
        NSButtonCell* cell = [tableColumn dataCellForRow:row];
        cell.tag = row;
        cell.title = title;
    
        NSString *isSelect = info.isSelected;
        if(isSelect == nil)
            isSelect = s_false;
    
        [cell setState:[isSelect integerValue]];
        itemCell = cell;
    }else if([tableView.identifier isEqualToString:PackSceneKey]){
        if([_sceneArray count] > 0){
            NSString *item = [_sceneArray objectAtIndex:row];
            itemCell = [item lastPathComponent];
        }
    }
    
    return itemCell;
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSButtonCell* cell = [tableColumn dataCellForRow:row];
    
    if([tableView.identifier isEqualToString:PlatformTblKey]){
        DetailsInfoData *data = (DetailsInfoData*)[_dataDict objectAtIndex:row];
        NSInteger newState = ![cell state];
        NSString *newStateStr = [NSString stringWithFormat:@"%ld", newState];
        [cell setState: newState];
        [data setValueForKey:Is_Selected withObj:newStateStr];
    
        [[ExportInfoManager instance] updateDetail:row withObject:data withKey:SAVE_DETAIL_ARRARY_KEY];
    }else if([tableView.identifier isEqualToString:PackSceneKey]){
        
    }
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
    NSString *infoString = [NSString stringWithFormat:@":arrow_forward:%@", content];
    infoString = [infoString stringByReplacingEmojiCheatCodesWithUnicode];
    [self renderUpAttriString:infoString withColor:[NSColor blackColor]];
}

- (void)addNewSuccessContent:(NSNotification*)notification
{
    NSString *content = [notification object];
    NSString *infoString = [NSString stringWithFormat:@":heavy_check_mark:%@", content];
    infoString = [infoString stringByReplacingEmojiCheatCodesWithUnicode];
    [self renderUpAttriString:infoString withColor:[NSColor greenColor]];
}

- (void)addNewErrorContent:(NSNotification*)notification
{
    NSString *content = [notification object];
    NSString *infoString = [NSString stringWithFormat:@":heavy_multiplication_x:%@", content];
    infoString = [infoString stringByReplacingEmojiCheatCodesWithUnicode];
    [self renderUpAttriString:infoString withColor:[NSColor redColor]];
}

- (void)addNewWarningContent:(NSNotification*)notification
{
    NSString *content = [notification object];
    NSString *infoString = [NSString stringWithFormat:@":eight_spoked_asterisk:%@", content];
    infoString = [infoString stringByReplacingEmojiCheatCodesWithUnicode];
    [self renderUpAttriString:infoString withColor:[NSColor systemYellowColor]];
}

- (void)setExportBtnState:(NSNotification*)notification
{
    NSString *isEnable = (NSString*)[notification object];
    if ([isEnable isEqualToString: s_true]) {
        _exportBtn.enabled = YES;
    }else{
        _exportBtn.enabled = NO;
    }
}

- (void)renderUpAttriString:(NSString*)string withColor:(NSColor*) color
{
    NSString *newStr = [string stringByAppendingString:@"\n"];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    
    NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:newStr];
    [addString addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, [newStr length] - 1)];
    [addString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [newStr length] - 1)];
    [addString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,[newStr length] - 1)];
    
    [[_infoLabel textStorage] appendAttributedString:addString];
    
    [_infoLabel scrollRectToVisible:CGRectMake(0, _infoLabel.textContainer.size.height-15, _infoLabel.textContainer.size.width, 10)];
}

- (void)startShowPackTime:(NSNotification*)notification
{
    _useTimeLabel.hidden = false;
    _packTime = 0.0f;
    
    _showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _packTime += timer.timeInterval;
        int min=(int)_packTime / 60;
        int sec=(int)_packTime % 60;
        
        NSString *minStr;
        NSString *secStr;
        if(min < 10){
            minStr = [NSString stringWithFormat:@"0%d", min];
        }else{
            minStr = [NSString stringWithFormat:@"%d", min];
        }
        
        if(sec < 10){
            secStr = [NSString stringWithFormat:@"0%d", sec];
        }else{
            secStr = [NSString stringWithFormat:@"%d", sec];
        }
        
        _useTimeLabel.stringValue = [NSString stringWithFormat:@"本次打包用时 %@:%@", minStr, secStr];
    }];
}

- (void)stopShowPackTime:(NSNotification*)notification
{
    showLog("总共打包用时%@", _useTimeLabel.stringValue);
    _useTimeLabel.stringValue = @"";
    if([_showTimer isValid]){
        [_showTimer invalidate];
        _showTimer = nil;
    }
}

- (IBAction)isReleaseBtnSelect:(id)sender
{
    NSButton *btn = (NSButton*)sender;
    ExportInfo* info = [ExportInfoManager instance].info;
    if([btn.identifier isEqualToString:@"isReleaseBox"]){
        info->isRelease = (int)_isReleaseBox.state;
    }else if([btn.identifier isEqualToString:@"isExportXcode"]){
        info->isExportXcode = (int)_isExportXcode.state;
    }
}

- (IBAction)ShowHelp:(id)sender
{
    
}

@end
