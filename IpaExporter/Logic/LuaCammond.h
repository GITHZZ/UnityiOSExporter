//
//  LuaDLL.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/8/31.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "LuaDLL.h"

@interface LuaCammond : NSObject

+ (LuaCammond*)instance;

- (void)open;
- (void)close;

- (void)startUp;

- (void)dofile:(NSString*)path;
- (void)dostring:(NSString*)content;

- (void)startExport;

- (void)printTest:(const char*)content;

@end
