//
//  DetailsInfo.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/13.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoView.h"
#import "DetailsInfoData.h"
#import "LogicManager.h"

#import "Common.h"
#import "DetailsInfoSetting.h"

@implementation DetailsInfoView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ExportInfoManager* manager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    NSMutableArray* saveArray = [manager reLoadDetails:SAVE_DETAIL_ARRARY_KEY];
    _dataDict = [[NSMutableArray alloc] initWithArray:saveArray];
    
    if([_dataDict count] > 0)
    {
        _selectInfo = [_dataDict objectAtIndex:0];
    }
    
    _infoTbls.delegate = self;
    _infoTbls.dataSource = self;
    
}

- (void)viewDidAppear
{
    if([_dataDict count] > 0)
    {
       NSInteger row = [_infoTbls selectedRow];
       _selectInfo = [_dataDict objectAtIndex:row];
    }
    
    EVENT_REGIST(EventDetailsInfoSettingClose, @selector(detailsInfoViewClose:));
    EVENT_REGIST(EventDetailsInfoSettingEdit, @selector(detailsInfoViewEdit:));
}

- (void)viewDidDisappear
{
    EVENT_UNREGIST(EventDetailsInfoSettingClose);
    EVENT_UNREGIST(EventDetailsInfoSettingEdit);
}

- (IBAction)AddBtnClick:(id)sender
{
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsInfoSetting *vc = [sb instantiateControllerWithIdentifier:@"detailsInfoSetting"];

    if([_dataDict count] > 0){
        DetailsInfoData *info = [_dataDict objectAtIndex:0];
        [vc setUpDataInfoOnShow:info isEditMode:NO];
    }
    
    [self presentViewControllerAsSheet:vc];
}

- (IBAction)removeBtnClick:(id)sender
{
    [[Alert instance] alertModalFirstBtnTitle:@"确定" SecondBtnTitle:@"取消" MessageText:@"温馨提示" InformativeText:@"你确定要删除该平台信息?此操作不可还原。" callBackFrist:^{
        [self removeInfo];
    } callBackSecond:^{
    }];
}

- (IBAction)editDetailInfo:(id)sender
{
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsInfoSetting *vc = [sb instantiateControllerWithIdentifier:@"detailsInfoSetting"];
    [vc setUpDataInfoOnShow:_selectInfo isEditMode:YES];
    [self presentViewControllerAsSheet:vc];
}

- (void)addInfo:(DetailsInfoData*)info
{
    ExportInfoManager* manager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    [_dataDict addObject:info];
    [manager addDetail:info withKey:SAVE_DETAIL_ARRARY_KEY];
    [_infoTbls reloadData];
    
    [[EventManager instance] send:EventDetailsInfoUpdate withData:_dataDict];
}

- (void)editInfo:(DetailsInfoData*)info
{
    NSInteger row = [_infoTbls selectedRow];
    ExportInfoManager* manager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    [_dataDict replaceObjectAtIndex:row withObject:info];
    [manager updateDetail:row withObject:info withKey:SAVE_DETAIL_ARRARY_KEY];
    [_infoTbls reloadData];
}

- (void)removeInfo
{
    NSInteger row = [_infoTbls selectedRow];
    if(row > -1)
    {
        ExportInfoManager* manager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
        [_dataDict removeObjectAtIndex:row];
        [manager removeDetail:row withKey:SAVE_DETAIL_ARRARY_KEY];
        [_infoTbls reloadData];

        [[EventManager instance] send:EventDetailsInfoUpdate withData:_dataDict];
    }
}

- (void)detailsInfoViewClose:(NSNotification*)notification
{
    DetailsInfoData* info = (DetailsInfoData*)[notification object];
    [self addInfo:info];
}

- (void)detailsInfoViewEdit:(NSNotification*)notification
{
    DetailsInfoData* info = (DetailsInfoData*)[notification object];
    [self editInfo:info];
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
    return [info getValueForKey:columnIdentifier];
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier = [tableColumn identifier];
    DetailsInfoData* info = [_dataDict objectAtIndex:row];
    
    NSString* newValue = (NSString*)object;
    [info setValue:newValue forKey:columnIdentifier];
    
    [_dataDict replaceObjectAtIndex:row withObject:info];
    ExportInfoManager* manager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    [manager updateDetail:row withObject:info withKey:SAVE_DETAIL_ARRARY_KEY];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    _selectInfo = [_dataDict objectAtIndex:row];
    return YES;//禁用
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return NO;
}

BOOL _commandKeyIsDown = NO;
- (void)keyDown:(NSEvent *)event
{
    if(_commandKeyIsDown){
        if ([event.characters isEqualToString:@"c"]){
            [[NSPasteboard generalPasteboard] clearContents];
            [[NSPasteboard generalPasteboard] setString:_selectInfo.toJson forType:NSPasteboardTypeString];
        }else if([event.characters isEqualToString:@"v"]){
            NSString *jsonString = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
            DetailsInfoData *data = [DetailsInfoData initWithJsonString:jsonString];
            if(data != nil)
                [self addInfo:data];
        }
    }
}

- (void)flagsChanged:(NSEvent *)event
{
    [super flagsChanged:event];
    if([event modifierFlags] & NSEventModifierFlagCommand){
        _commandKeyIsDown = YES;
        return;
    }
    _commandKeyIsDown = NO;
}

@end
