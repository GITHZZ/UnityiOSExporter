//
//  DetailsInfo.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/13.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoView.h"
#import "DetailsInfoData.h"

@implementation DetailsInfoView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[EventManager instance] regist:EventDetailsInfoSettingClose
                               func:@selector(DetailsInfoViewClose:)
                           withData:nil
                               self:self];
    
    _dataDict = [[NSMutableArray alloc] initWithCapacity:10];
    [self roadSaveData];
    
    //设置数据源
    _infoTbls.delegate = self;
    _infoTbls.dataSource = self;
}

- (IBAction)addInfo:(id)sender
{
}

- (IBAction)removeInfo:(id)sender
{
    NSInteger row = [_infoTbls selectedRow];
    if(row > -1)
    {
        [_dataDict removeObjectAtIndex:row];
        [_infoTbls reloadData];
    }
}

- (void)roadSaveData
{
    //读取存储数据并显示
}

- (void)DetailsInfoViewClose:(NSNotification*)notification
{
    DetailsInfoData* info = (DetailsInfoData*)[notification object];
    [_dataDict addObject:info];
    [_infoTbls reloadData];
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
        NSLog(@"存在没有设置Identifier列");
        return nil;
    }

    DetailsInfoData* info = [_dataDict objectAtIndex:row];
    return [info valueForKey:columnIdentifier];
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier=[tableColumn identifier];
    DetailsInfoData* info = [_dataDict objectAtIndex:row];
    
    NSString* newValue = (NSString*)object;
    [info setValue:newValue forKey:columnIdentifier];
}


@end
