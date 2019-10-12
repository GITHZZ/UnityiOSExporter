//
//  NSFileManager+Copy.h
//  IpaExporter
//
//  Created by 4399 on 7/9/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Copy)

/**
 拷贝文件夹内容，同步
 @param src 需要被拷贝的文件夹
 @param dst 拷贝目标文件夹
 */
- (void)copyFolderFrom:(NSString*)src toDst:(NSString*)dst;


/**
 拷贝文件夹内容，同步
 @param cover 是否覆盖，如果目标文件夹存在（注意会直接替换）
 */
- (void)copyFolderFrom:(NSString*)src toDst:(NSString*)dst isCover:(BOOL)cover;

/**
 使用shell指令拷贝文件夹，异步,线程阻塞（需要修改）
 @return 返回指令执行内容和相关结果
 */
- (NSString*)copyUseShell:(NSString*)src toDst:(NSString*)dst;

- (void)copyFile:(NSString*)src toDst:(NSString*)dst;

@end

@interface NSFileManager (Search)

- (NSArray*)searchByExtension:(NSString*)extension withDir:(NSString*)searchDir;

@end

NS_ASSUME_NONNULL_END
