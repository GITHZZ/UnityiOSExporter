//
//  DataCSCodeEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/11.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCSCodeEdit : NSObject
{
    NSString* _path;
    NSFileHandle* _fileHandle;
    
    NSString* _content;
}

@property (nonatomic, readonly) NSArray* lines;

+ (DataCSCodeEdit*)openCSFile:(NSString*)path;
- (void)replaceContent:(NSString*) newContent;

@end
