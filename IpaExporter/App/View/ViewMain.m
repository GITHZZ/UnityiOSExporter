//
//  ViewMain.m
//  IpaExporter
//
//  Created by 4399 on 7/27/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "ViewMain.h"
#import "Defs.h"
#import "PreferenceView.h"
#import "DetailsInfoSetting.h"
#import "LogicManager.h"

@implementation ViewMain

- (void)viewDidLoad
{
    //子界面
    _subView = [NSSet setWithObjects:
                @"PreferenceView",
                @"DetailsInfoSetting",
                @"SceneSelectView",
                nil];
    _subViewQueue = [NSMutableArray array];
    
    [super viewDidLoad];
}

- (void)viewDidAppear
{
    EVENT_REGIST(EventSetViewMainTab, @selector(setTab:));
    EVENT_REGIST(EventShowSubView, @selector(showSubView:));
    EVENT_REGIST(EventHideSubView, @selector(hideSubView:))
    
    [self checkIsShowSetting];
}


- (void)showSubView:(NSNotification*)notification
{
    NSString *viewName = (NSString*)notification.object;
    if(![_subView containsObject:viewName])
        return;
   
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *vc = [sb instantiateControllerWithIdentifier:viewName];
    vc.identifier = viewName;
    NSViewController *mainControler = [[[NSApplication sharedApplication] mainWindow] contentViewController];

    EVENT_SEND(EventViewWillAppear, vc);
    [mainControler presentViewControllerAsSheet:vc];
    
    [_subViewQueue addObject:vc];
}

- (void)hideSubView:(NSNotification*)notification
{
    if(_subViewQueue.count <= 0)
        return;
    
    NSViewController *vc = _subViewQueue.lastObject;
    [vc dismissController:vc];
    
    EVENT_SEND(EventViewDidDisappear, vc);
    [_subViewQueue removeObject:vc];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem
{
    [super tabView:tabView didSelectTabViewItem:tabViewItem];
    
    EVENT_SEND(EventViewDidDisappear, nil);
    EVENT_SEND(EventViewWillAppear,nil);
}

- (void)setTab:(NSNotification*)notification
{
    NSInteger index = (NSInteger)notification.object;
    self.selectedTabViewItemIndex = index;
}

- (void)checkIsShowSetting
{
    VersionInfo *instance = (VersionInfo*)get_instance(@"VersionInfo");
    if([instance isUpdate])
    {
        if(![[NSFileManager defaultManager] fileExistsAtPath:PLIST_PATH])
        {
            NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
            DetailsInfoSetting *vc = [sb instantiateControllerWithIdentifier:@"UserDefaultsSetting"];
            [self presentViewControllerAsSheet:vc];
        }else{
            [[Alert instance] alertTip:@"确定" MessageText:@"更新" InformativeText:@"检测到版本更新,点击确认同步代码" callBackFrist:^{
                inst_method_call(@"PreferenceData", restoreCustomCode);
            }];
        }
    }
}

@end
