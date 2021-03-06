//
//  SceneSelectView.m
//  IpaExporter
//
//  Created by 4399 on 9/22/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "SceneSelectView.h"
#import "Defs.h"
#import "LogicManager.h"

@implementation SceneSelectView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _unitySceneTbl.delegate = self;
    _unitySceneTbl.dataSource = self;
    
    _exportManager = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    _progress.displayedWhenStopped = NO;
}

- (void)viewDidAppear
{
    [_progress startAnimation:nil];
    
    //获取数据
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        self->_sceneArray = [NSMutableArray arrayWithArray:[self->_exportManager getAllUnityScenePath]];
        NSString *unityProjPath = [NSString stringWithUTF8String:self->_exportManager.info->unityProjPath];
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *path in [self->_exportManager getSceneArray]) {
            NSString *relaPath = [path substringFromIndex:[unityProjPath length] + 1];
            [array addObject:relaPath];
        }
        self->_selectScene = [NSMutableSet setWithArray:array];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self->_progress stopAnimation:nil];
        [self->_unitySceneTbl reloadData];
    });
}

//返回表格的行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    if([tableView.identifier isEqualToString:@"unitySceneTbl"]){
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
    if([tableView.identifier isEqualToString:@"unitySceneTbl"])
    {
        NSString *sceneName = [_sceneArray objectAtIndex:row];
        NSButtonCell* cell = [tableColumn dataCellForRow:row];
        cell.tag = row;
        cell.title = sceneName;
        itemCell = cell;
        [cell setState:[_selectScene containsObject:sceneName] ? 1 : 0];
    }
    
    return itemCell;
}

//修改行内容
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSButtonCell* cell = [tableColumn dataCellForRow:row];
    if([tableView.identifier isEqualToString:@"unitySceneTbl"]){
        NSString *sceneName = [_sceneArray objectAtIndex:row];
        NSInteger newState = ![cell state];
        [cell setState:newState];
        
        if(newState == 1){
            [_selectScene addObject:sceneName];
        }else{
            if([_selectScene containsObject:sceneName])
                [_selectScene removeObject:sceneName];
        }
    }
}

- (IBAction)SureBtnClick:(id)sender
{
    NSString *unityProjPath = [NSString stringWithUTF8String:_exportManager.info->unityProjPath];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *path in _selectScene) {
        [array addObject:[unityProjPath stringByAppendingFormat:@"/%@", path]];
    }
    
    EVENT_SEND(EventSelectSceneClicked, array);
    EVENT_SEND(EventHideSubView, self);
}

- (IBAction)cancelBtnClick:(id)sender
{
    EVENT_SEND(EventHideSubView, self);
}

@end
