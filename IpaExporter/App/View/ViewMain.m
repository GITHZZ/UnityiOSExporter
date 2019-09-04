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
#import "NSViewController+LogicSupport.h"

@implementation ViewMain

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear
{
    [super onShow];
    
    EVENT_REGIST(EventSetViewMainTab, @selector(setTab:));

    [self checkIsShowSetting];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem
{
    [super tabView:tabView didSelectTabViewItem:tabViewItem];
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
