//
//  XcodeProjModCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "XcodeProjModCSFileEdit.h"
#import "BaseDataCSCodePrivate.h"
#import "Common.h"

@implementation XcodeProjModCSFileEdit

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info
{
    NSString* builderCSPath = [dstPath stringByAppendingPathComponent:XCODEPROJECT_CS_PATH];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSArray *keyArr = [NSArray arrayWithObjects:Copy_Dir_Path, libs_Key, Linker_Flag,  Debug_Profile_Name, Debug_Develop_Team, Release_Profile_Name, Release_Develop_Team, Frameworks, Libs, nil];
        [self replaceVarFromData:info withKeyArr:keyArr];
    }
}

@end 
