//
//  DataCSCodeEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/11.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "BaseDataCSCodeEdit.h"
#import "BaseDataCSCodePrivate.h"
#import "Defs.h"

@implementation BaseDataCSCodeEdit

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info
{    
}

- (BOOL)initWithPath:(NSString*)path
{
    _path = path;
        
    NSError* error;
    _content = [NSMutableString stringWithContentsOfFile:path
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
    if(error != nil)
    {
        showError(@"读取路径文件失败:%@", path);
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
        return NO;
    }
        
    _lines = [_content componentsSeparatedByString:@"\n"];
    
    return YES;
}

/*
 通过key来取和替换变量 以def文件中的为准
 */
- (void)replaceVarFromData:(DetailsInfoData*)data withKeyArr:(NSArray*)keyArr
{
    NSMutableString* result = [NSMutableString stringWithString:_content];
    for(int i = 0; i < [keyArr count]; i++)
    {
        NSString *key = [keyArr objectAtIndex:i];
        NSString *keyStr = [data getValueForKey:key];
        //需要特殊处理的
        if([key isEqualToString:Frameworks_Key])
        {
            [keyStr stringByReplacingOccurrencesOfString:@"|"
                                              withString:@","];
        }
        
        [result replaceOccurrencesOfString:[NSString stringWithFormat:@"${%@}", key]
                                  withString:keyStr
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [result length])];

    }
    [self replaceContent:result];
}

- (void)replaceContent:(NSString*) newContent
{
    NSError* error;
    [newContent writeToFile:_path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error != nil)
    {
        showError(@"*替换内容失败:目标路径%@", _path);
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
    }
}

@end
