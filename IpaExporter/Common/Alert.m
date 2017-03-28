//
//  Alert.m
//  IpaExporter
//
//  Created by 何遵祖 on 2017/3/28.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#import "Alert.h"

@implementation Alert

- (void)alertModalFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)())func1 callBackSecond:(void(^)())func2
{
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:firstname];
    [alert addButtonWithTitle:secondname];
    [alert setMessageText:messagetext];
    [alert setInformativeText:informativetext];
    
    [alert setAlertStyle:NSWarningAlertStyle];
    
    NSUInteger action = [alert runModal];
    //响应window的按钮事件
    if(action == NSAlertFirstButtonReturn)
    {
        func1();
    }
    else if(action == NSAlertSecondButtonReturn )
    {
        func2();
    }
}

@end
