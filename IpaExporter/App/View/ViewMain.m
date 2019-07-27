//
//  ViewMain.m
//  IpaExporter
//
//  Created by 4399 on 7/27/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "ViewMain.h"
#import "Defs.h"

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
}

- (void)setTab:(NSNotification*)notification
{
    NSInteger index = (NSInteger)notification.object;
    self.selectedTabViewItemIndex = index;
}

@end

