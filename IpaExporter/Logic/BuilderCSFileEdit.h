//
//  BuilderCSFileEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataCSCodeEdit.h"
#import "Defs.h"

@interface BuilderCSFileEdit : DataCSCodeEdit

- (void)start:(NSString*)dstPath withPackInfo:(IpaPackInfo)info;

@end
