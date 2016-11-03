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
    
    //设置数据源
    _infoTbls.delegate = self;
    _infoTbls.dataSource = self;
}

- (IBAction)addInfo:(id)sender
{
}

- (IBAction)removeInfo:(id)sender
{
    NSLog(@"++++removeInfo++++");
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

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *columnIdentifier=[tableColumn identifier];
    DetailsInfoData* info = [_dataDict objectAtIndex:row];
    
    if ([columnIdentifier isEqualToString:@"bundleIdentifier"])
    {
        return info.appID;
    }
    else if([columnIdentifier isEqualToString:@"codeSignIdentity"])
    {
        return info.codeSignIdentity;
    }
    else if([columnIdentifier isEqualToString:@"provisioningProfile"])
    {
        return info.provisioningProfile;
    }
    else
    {
        NSLog(@"无效的类型%@", columnIdentifier);
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"123");
}

@end
