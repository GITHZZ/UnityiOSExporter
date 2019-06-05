//
//  BuilderCSFileEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuilderCSFileEdit : NSObject

- (void)startWithDstPath:(NSString*)dstPath;

@property (nonatomic, readonly) NSArray* lines;

@end
