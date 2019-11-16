//
//  NSFileManager+Copy.m
//  IpaExporter
//
//  Created by 4399 on 7/9/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "NSFileManager+Extern.h"

@implementation NSFileManager (Copy)

- (void)copyFolderFrom:(NSString*)src toDst:(NSString*)dst
{
    [self copyFolderFrom:src toDst:dst isCover:YES];
}

- (void)copyFolderFrom:(NSString*)src toDst:(NSString*)dst isCover:(BOOL)cover
{
    if(cover)
        [self removeFolderForm:dst];
    
    BOOL isFolder = [[dst pathExtension] isEqualToString:@""];
    BOOL isExist = [self fileExistsAtPath:dst isDirectory:&isFolder];
    if(isFolder && !isExist)
        [self createFolder:dst];
        
    NSError *error;
    NSArray *array = [self contentsOfDirectoryAtPath:src error:&error];
    if(error != nil){
        NSLog(@"%@", [error userInfo]);
        return;
    }
    
    for(int i = 0; i < [array count]; i++){
        NSString *srcChildPath = [src stringByAppendingPathComponent:array[i]];
        NSString *dstChildPath = [dst stringByAppendingPathComponent:array[i]];
        
        isFolder = NO;
        BOOL isExist = [self fileExistsAtPath:srcChildPath isDirectory:&isFolder];
        if(isExist){
            if(isFolder){
                [self createFolder:dstChildPath];
                [self copyFolderFrom:srcChildPath toDst:dstChildPath];
            }else{
                [self copyFile:srcChildPath toDst:dstChildPath];
            }
        }
    }
}

- (void)copyFile:(NSString*)src toDst:(NSString*)dst
{
    NSError* error = nil;
    [self copyItemAtPath:src toPath:dst error:&error];
    if(error != nil){
        NSLog(@"%@", [error userInfo]);
    }
}

- (void)createFolder:(NSString*) path
{
    BOOL isDir = [[path pathExtension] isEqualToString:@""];
    BOOL existed = [self fileExistsAtPath:path];
    if(!(isDir && existed))
    {
        NSError* error;
        [self createDirectoryAtPath:path
        withIntermediateDirectories:YES
                         attributes:nil
                              error:&error];
        if(error != nil){
            NSLog(@"*拷贝文件夹失败 原因:%@", error);
            NSLog(@"%@", [error userInfo]);
        }
    }
}

- (void)removeFolderForm:(NSString*)dst
{
    NSError *error;
    BOOL isExist = [self fileExistsAtPath:dst];
    if(isExist)
        [self removeItemAtPath:dst error:&error];
    
    if(error != nil){
        NSLog(@"移除目标路径文件失败:%@ 错误原因:%@", dst, error);
        NSLog(@"%@", [error userInfo]);
    }
}

- (NSString*)copyUseShell:(NSString*)src toDst:(NSString*)dst
{
    NSString *shellStr = [NSString stringWithFormat:@"cp -r %@ %@", src, dst];
    NSString *strReturnFormShell = [self createTerminalTask:shellStr];
    return strReturnFormShell;
}

- (NSString*)createTerminalTask:(NSString*)order
{
    NSTask *shellTask = [[NSTask alloc] init];
    [shellTask setLaunchPath:@"/bin/sh"];
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c", order, nil]];
    
    NSPipe *pipe = [[NSPipe alloc] init];
    [shellTask setStandardOutput:pipe];
    [shellTask setStandardError:pipe];
    [shellTask launch];
    [shellTask waitUntilExit];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSData *data = [file readDataToEndOfFile];
    NSString *strReturnFormShell = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return strReturnFormShell;
}

@end

@implementation NSFileManager (Search)

- (NSArray*)searchByExtension:(NSString*)extension withDir:(NSString*)searchDir
{
    return [self searchByExtension:extension withDir:searchDir appendPath:@""];
}

- (NSArray*)searchByExtension:(NSString*)extension withDir:(NSString*)searchDir appendPath:(NSString*)append
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
            [array addObject:[append stringByAppendingString:curPath]];
        }
    }
    return array;
}

@end
