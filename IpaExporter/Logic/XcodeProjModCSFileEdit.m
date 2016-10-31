//
//  XcodeProjModCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "XcodeProjModCSFileEdit.h"

@implementation XcodeProjModCSFileEdit

- (void)start:(NSString*)dstPath withPackInfo:(IpaPackInfo)info
{
    NSString* builderCSPath = [dstPath stringByAppendingPathComponent:BUILDER_CS_PATH];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSString* result;
        result = [_content stringByReplacingOccurrencesOfString:@"${bundleIdentifier}" withString:@"\"com.4399sy.zzsj.online\""];
        result = [result stringByReplacingOccurrencesOfString:@"${productName}" withString:@"\"测试项目\""];
        [self replaceContent:result];
    }
}

@end 
