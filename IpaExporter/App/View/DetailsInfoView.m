//
//  DetailsInfo.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/13.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoView.h"
#import "DetailsInfoData.h"

#import "ExportInfoManager.h"

@interface DetailsInfoView()
{
    DetailsInfoData *_selectInfo;
}
@end

@implementation DetailsInfoView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray* saveArray = [[ExportInfoManager instance] reLoadDetails:SAVE_DETAIL_ARRARY_KEY];
    _dataDict = [[NSMutableArray alloc] initWithArray:saveArray];
    
    if([_dataDict count] > 0)
    {
        _selectInfo = [_dataDict objectAtIndex:0];
    }
    
    //设置数据源
    _infoTbls.delegate = self;
    _infoTbls.dataSource = self;
}

- (void)viewDidAppear
{
    [[EventManager instance] regist:EventDetailsInfoSettingClose
                               func:@selector(detailsInfoViewClose:)
                               self:self];
    [[EventManager instance] regist:EventDetailsInfoSettingEdit
                               func:@selector(detailsInfoViewEdit:)
                               self:self];
}

- (void)viewDidDisappear
{
    [[EventManager instance] unRegist:EventDetailsInfoSettingClose
                                 self:self];
    [[EventManager instance] unRegist:EventDetailsInfoSettingEdit
                                 self:self];
}

- (IBAction)AddBtnClick:(id)sender
{
    //open detail info settings
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
    [_dataDict addObject:info];
    [[ExportInfoManager instance] addDetail:info withKey:SAVE_DETAIL_ARRARY_KEY];
    [_infoTbls reloadData];
    
    [[EventManager instance] send:EventDetailsInfoUpdate withData:_dataDict];
}

- (void)editInfo:(DetailsInfoData*)info
{
    [self removeInfo];
    [self addInfo:info];
}

- (void)removeInfo
{
    NSInteger row = [_infoTbls selectedRow];
    if(row > -1)
    {
        [_dataDict removeObjectAtIndex:row];
        [[ExportInfoManager instance] removeDetail:row withKey:SAVE_DETAIL_ARRARY_KEY];
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
    [[ExportInfoManager instance] updateDetail:row withObject:info withKey:SAVE_DETAIL_ARRARY_KEY];
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

@end
