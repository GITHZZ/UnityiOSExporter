//
//  XcodeProjModCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "XcodeProjModCSFileEdit.h"
#import "BaseDataCSCodePrivate.h"

@implementation XcodeProjModCSFileEdit

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info
{
    NSString* builderCSPath = [dstPath stringByAppendingPathComponent:XCODEPROJECT_CS_PATH];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSArray *keyArr = [NSArray arrayWithObjects:Frameworks_Key, nil];
        [self replaceVarFromData:info withKeyArr:keyArr];
    }
}

@end 
