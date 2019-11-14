//
//  BuilderCSFileEdit.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicManager.h"


/// 编辑修改C#里面的TempCode/Builder/_Builder.cs文件
@interface BuilderCSFileEdit : NSObject
{
@private
    NSString* _path;
    NSFileHandle* _fileHandle;
    NSMutableString* _content;
    ExportInfoManager* _view;
}

- (void)startWithDstPath:(NSString*)dstPath;

@property (nonatomic, readonly) NSArray* lines;

@end
