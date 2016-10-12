//
//  XcodeProjModCSFileEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defs.h"

@interface XcodeProjModCSFileEdit : NSObject

- (void)start:(NSString*)dstPath withPackInfo:(IpaPackInfo)info;

@end
