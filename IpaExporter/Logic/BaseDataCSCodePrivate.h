//
//  BaseDataCSCodeEditPrivate.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/2/13.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#ifndef BaseDataCSCodeEditPrivate_h
#define BaseDataCSCodeEditPrivate_h

@interface BaseDataCSCodeEdit()
{
    NSString* _path;
    NSFileHandle* _fileHandle;
    
    NSMutableString* _content;
}

- (BOOL)initWithPath:(NSString*)path;
- (void)replaceContent:(NSMutableString*) newContent;
- (void)replaceVarFromData:(DetailsInfoData*)data withKeyArr:(NSArray*)keyArr;
@end

#endif /* BaseDataCSCodeEditPrivate_h */
