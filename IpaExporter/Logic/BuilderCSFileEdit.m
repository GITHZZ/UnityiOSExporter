//
//  BuilderCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "BuilderCSFileEdit.h"
#import "Common.h"
#import "ExportInfoManager.h"

@interface BuilderCSFileEdit()
{
    NSString* _path;
    NSFileHandle* _fileHandle;
    
    NSMutableString* _content;
}
@end

@implementation BuilderCSFileEdit

- (void)startWithDstPath:(NSString*)rootPath
{
    NSString* builderCSPath = [rootPath stringByAppendingPathComponent:@"/TempCode/Builder/_Builder.cs"];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSArray *keyArr = [NSArray arrayWithObjects:Pack_Scene,Export_Path, nil];
        [self replaceVarWithKeyArr:keyArr];
    }
}

- (BOOL)initWithPath:(NSString*)path
{
    _path = path;
    
    NSError* error;
    _content = [NSMutableString stringWithContentsOfFile:path
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
    if(error != nil)
    {
        showError("读取路径文件失败:%@", path);
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
        return NO;
    }
    
    _lines = [_content componentsSeparatedByString:@"\n"];
    
    return YES;
}

/*
 通过key来取和替换变量 以def文件中的为准
 */
- (void)replaceVarWithKeyArr:(NSArray*)keyArr
{
    ExportInfo* info = [ExportInfoManager instance].info;
    NSString *replaceFormat = @"\"%@\"";
    NSMutableString* result = [NSMutableString stringWithString:_content];
    
    for(int i = 0; i < [keyArr count]; i++)
    {
        NSString *key = [keyArr objectAtIndex:i];
        NSString *keyStr = [NSString stringWithFormat:@"//木有任何数据"];
        
        if([key isEqualToString:Export_Path]){
            
            const char* path = info->exportFolderParh;
            keyStr = [[NSString stringWithUTF8String:path] stringByAppendingFormat:@"/%@",XCODE_PROJ_NAME];
        }else if([key isEqualToString:Pack_Scene]){
        
            NSMutableArray *scenes = [ExportInfoManager instance].sceneArray;
            keyStr = [self getReplaceStrFromArray:scenes];
        }
        
        [result replaceOccurrencesOfString:[NSString stringWithFormat:@"${%@}", key]
                                withString:[NSString stringWithFormat:replaceFormat, keyStr]
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [result length])];
        
    }
    
    [self replaceContent:result];
}

- (void)replaceContent:(NSString*) newContent
{
    NSError* error;
    [newContent writeToFile:_path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error != nil)
    {
        showError("*替换内容失败:目标路径%@", _path);
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
    }
}

//多个选项转成字符串
- (NSString*)getReplaceStrFromArray:(NSArray<NSString*> *) array
{
    NSMutableArray *classArr = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < [array count]; i++)
    {
        NSString *name = array[i];
        [classArr addObject:name];
    }
    
    NSString *keyStr = [classArr componentsJoinedByString:@",\n"];
    return keyStr;
}

//argsStr: 格式 args1,args2
- (NSString*) createCSClassStr:(NSString*)className withArgsStr:(NSString*)argsStr
{
    NSArray<NSString*> *argsArr = [argsStr componentsSeparatedByString:@"|"];
    NSString *newStr = [[NSString alloc] init];
    
    for (int i = 0; i < [argsArr count]; i++)
    {
        NSString *str = argsArr[i];
        NSString *classStr = [NSString stringWithFormat:@"new %@(%@),", className, str];
        if(i == [argsArr count] - 1)
            newStr = [newStr stringByAppendingFormat:@"%@", classStr];
        else
            newStr = [newStr stringByAppendingFormat:@"%@,\n", classStr];
    }
    
    return newStr;
}

@end
