//
//  BuilderCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "BuilderCSFileEdit.h"
#import "BaseDataCSCodePrivate.h"
#import "Common.h"

@implementation BuilderCSFileEdit

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info
{
    NSString* builderCSPath = [dstPath stringByAppendingPathComponent:BUILDER_CS_PATH];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSArray *keyArr = [NSArray arrayWithObjects:Export_Path, App_ID_Key, App_Name_Key, nil];
        [self replaceVarFromData:info withKeyArr:keyArr];
    }
}

@end
