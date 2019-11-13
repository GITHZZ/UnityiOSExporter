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

static AlertFunc _block;
static AlertFunc _block2;

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

- (void)alertTip:(NSString *)firstname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(AlertFunc)func1
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    _block = func1;
    [alert addButtonWithTitle:firstname];
    [alert setMessageText:messagetext];
    [alert setInformativeText:informativetext];
    [alert setAlertStyle:NSAlertStyleWarning];

    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if(result == NSAlertFirstButtonReturn)
            _block();
    }];
}

- (void)alertModalFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)(void))func1 callBackSecond:(void(^)(void))func2
{
    NSAlert *alert = [[NSAlert alloc] init];
 
    _block = func1;
    _block2 = func2;

    [alert addButtonWithTitle:firstname];
    [alert addButtonWithTitle:secondname];
    [alert setMessageText:messagetext];
    [alert setInformativeText:informativetext];
    
    [alert setAlertStyle:NSAlertStyleWarning];

    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result){
        
        if(result == NSAlertFirstButtonReturn)
        {
            _block();
        }
        else if(result == NSAlertSecondButtonReturn )
        {
            _block2();
        }
    }];
}

@end
