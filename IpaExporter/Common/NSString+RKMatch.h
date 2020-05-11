//
//  NSString+RKMatch.h
//  IpaExporter
//
//  Created by 4399 on 5/7/20.
//  Copyright © 2020 何遵祖. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RKMatch)
- (BOOL)isMatch:(NSString*)keyword;
@end

NS_ASSUME_NONNULL_END
