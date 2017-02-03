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
        NSMutableString* result = [NSMutableString stringWithString:_content];
        NSString* bundleIdentifier = [NSString stringWithFormat:@"\"%@\"", info.bundleIdentifier];
        NSString* productName = [NSString stringWithFormat:@"\"%@\"", info.appName];
        
        [result replaceOccurrencesOfString:@"${bundleIdentifier}"
                                withString:bundleIdentifier
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [_content length])];
        
        [result replaceOccurrencesOfString:@"${productName}"
                                withString:productName
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [_content length])];
        
        [self replaceContent:result];
    }
}

@end
