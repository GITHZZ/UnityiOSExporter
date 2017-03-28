//
//  Alert.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/3/28.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Singletion.h"

@interface Alert : Singletion

- (void)alertModalFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext callBackFrist:(void(^)())func1 callBackSecond:(void(^)())func2;

@end
