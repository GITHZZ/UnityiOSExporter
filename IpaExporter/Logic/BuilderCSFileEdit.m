//
//  BuilderCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "BuilderCSFileEdit.h"
#import "Defs.h"

@implementation BuilderCSFileEdit

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info
{
    NSString* builderCSPath = [dstPath stringByAppendingPathComponent:BUILDER_CS_PATH];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSMutableString* result = [NSMutableString stringWithString:_content];
        
        NSString *infoBundleIdentifier = [info.dict objectForKey:App_ID_Key];
        NSString *infoAppName = [info.dict objectForKey:App_Name_Key];
        
        NSString* bundleIdentifier = [NSString stringWithFormat:@"\"%@\"", infoBundleIdentifier];
        NSString* productName = [NSString stringWithFormat:@"\"%@\"", infoAppName];
        
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
