//
//  BuilderCSFileEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuilderCSFileEdit : NSObject{
@private
    NSString* _path;
    NSFileHandle* _fileHandle;
    NSMutableString* _content;
}

- (void)startWithDstPath:(NSString*)dstPath;

@property (nonatomic, readonly) NSArray* lines;

@end
