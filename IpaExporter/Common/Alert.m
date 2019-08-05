//
//  Alert.m
//  IpaExporter
//
//  Created by 何遵祖 on 2017/3/28.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#import "Alert.h"
#import <objc/runtime.h>

@implementation Alert

+ (instancetype)instance
{
    Class cls = [self class];
    //动态去取属性方法
    id instance = objc_getAssociatedObject(cls, @"instance");
    if(!instance)
    {
        instance = [[self allocWithZone:NULL] init];
        objc_setAssociatedObject(cls, @"instance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instance;
}

- (void)alertTip:(NSString *)firstname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)())func1
{
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:firstname];
    [alert setMessageText:messagetext];
    [alert setInformativeText:informativetext];
    
    [alert setAlertStyle:NSAlertStyleWarning];
    
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        //响应window的按钮事件
        if(result == NSAlertFirstButtonReturn)
        {
            func1();
        }
    }];
    
}

- (void)alertModalFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)())func1 callBackSecond:(void(^)())func2
{
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:firstname];
    [alert addButtonWithTitle:secondname];
    [alert setMessageText:messagetext];
    [alert setInformativeText:informativetext];
    
    [alert setAlertStyle:NSAlertStyleWarning];

    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        //响应window的按钮事件
        if(result == NSAlertFirstButtonReturn)
        {
            func1();
        }
        else if(result == NSAlertSecondButtonReturn )
        {
            func2();
        }
    }];
    
}

@end
