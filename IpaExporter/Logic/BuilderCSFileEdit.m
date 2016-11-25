//
//  BuilderCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "BuilderCSFileEdit.h"

@implementation BuilderCSFileEdit

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info
{
    NSString* builderCSPath = [dstPath stringByAppendingPathComponent:BUILDER_CS_PATH];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSString* result;
        NSString* bundleIdentifier = [NSString stringWithFormat:@"\"%@\"", info.bundleIdentifier];
        NSString* productName = [NSString stringWithFormat:@"\"%@\"", info.appName];
        
        result = [_content stringByReplacingOccurrencesOfString:@"${bundleIdentifier}"
                                                     withString:bundleIdentifier];
        result = [result stringByReplacingOccurrencesOfString:@"${productName}"
                                                   withString:productName];
        
        [self replaceContent:result];
    }
}

@end
