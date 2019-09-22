//
//  NSFileManager+Search.h
//  IpaExporter
//
//  Created by 4399 on 9/22/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Search)

- (NSArray*)searchByExtension:(NSString*)extension withDir:(NSString*)searchDir;

@end

NS_ASSUME_NONNULL_END
