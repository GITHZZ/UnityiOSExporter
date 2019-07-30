//
//  ViewMain.m
//  IpaExporter
//
//  Created by 4399 on 7/27/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "ViewMain.h"
#import "PreferenceView.h"
#import "DetailsInfoSetting.h"
#import "Defs.h"
#import "VersionInfo.h"
#import "PreferenceData.h"
#import "Alert.h"

@implementation ViewMain

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [[EventManager instance] regist:EventSetViewMainTab
                               func:@selector(setTab:)
                               self:self];
    [self checkIsShowSetting];
}

- (void)setTab:(NSNotification*)notification
{
    NSInteger index = (NSInteger)notification.object;
    self.selectedTabViewItemIndex = index;
}

- (void)checkIsShowSetting
{
    if([[VersionInfo instance] isUpdate])
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *preferencePath = [path stringByAppendingFormat:@"/Preferences/%@.plist", [[NSBundle mainBundle] bundleIdentifier]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:preferencePath])
        {
            NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
            DetailsInfoSetting *vc = [sb instantiateControllerWithIdentifier:@"UserDefaultsSetting"];
            [self presentViewControllerAsSheet:vc];
        }else{
            [[Alert instance] alertTip:@"确定" MessageText:@"更新" InformativeText:@"检测到版本更新,点击确认同步代码" callBackFrist:^{
                [[PreferenceData instance] restoreCustomCode];
            }];
        }
    }
}

@end
