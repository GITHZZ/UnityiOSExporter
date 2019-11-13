//
//  Alert.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/3/28.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^AlertFunc)(void);
@interface Alert : NSObject<NSAlertDelegate,NSWindowDelegate>

+ (instancetype)instance;

- (void)alertTip:(NSString *)firstname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)(void))func1;

- (void)alertModalFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)(void))func1 callBackSecond:(void(^)(void))func2;

@end
