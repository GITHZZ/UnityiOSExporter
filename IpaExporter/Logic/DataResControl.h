//
//  DataControlBase.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defs.h"

@interface DataResControl : NSObject
{
    BOOL _isStarting;
    NSString* _srcPath;
    NSString* _dstPath;
    
    NSFileManager* _fileManager;
}

+ (DataResControl*) instance;
- (void)start:(ExportInfo*) info;
- (void)end;

@end
