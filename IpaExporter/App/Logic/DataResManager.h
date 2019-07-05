//
//  DataControlBase.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//
//  用于拷贝文件夹以及文件夹下所有文件

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Defs.h"
#import "NSObject+Singletion.h"

@interface DataResManager : NSObject

- (void)start:(ExportInfo*)info;
- (void)appendingFolder:(NSString*)path;
- (void)end;

@property (readonly) NSString *rootPath;

@end
