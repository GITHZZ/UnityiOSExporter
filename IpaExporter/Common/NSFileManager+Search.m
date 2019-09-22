//
//  NSFileManager+Search.m
//  IpaExporter
//
//  Created by 4399 on 9/22/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "NSFileManager+Search.h"

@implementation NSFileManager (Search)

- (NSArray*)searchByExtension:(NSString*)extension withDir:(NSString*)searchDir
{
    NSMutableArray *array = [NSMutableArray array];
    BOOL isDir;
    [self fileExistsAtPath:searchDir isDirectory:&isDir];
    if(!isDir){
        NSLog(@"传入路径必须是文件夹:%@", searchDir);
        return array;
    }
    
    NSString *curPath;
    NSDirectoryEnumerator *dirEnum = [self enumeratorAtPath: searchDir];//枚举目录的内容
    while ((curPath = [dirEnum nextObject]) != nil) {
        if ([[curPath pathExtension] isEqualToString: extension]) {
            [array addObject:curPath];
        }
    }
    return array;
}
@end
