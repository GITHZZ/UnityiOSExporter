//
//  DataCSCodeEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/11.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defs.h"
#import "DetailsInfoData.h"

@interface BaseDataCSCodeEdit : NSObject
{
    NSString* _path;
    NSFileHandle* _fileHandle;
    
    NSString* _content;
}

@property (nonatomic, readonly) NSArray* lines;

- (void)start:(NSString*)dstPath withPackInfo:(DetailsInfoData*)info;
- (BOOL)initWithPath:(NSString*)path;
- (void)replaceContent:(NSString*) newContent;

@end
