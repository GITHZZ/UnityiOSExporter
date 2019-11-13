//
//  BuilderCSFileEdit.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/12.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "BuilderCSFileEdit.h"
#import "Common.h"

@implementation BuilderCSFileEdit

#define CS_PACKSCENE_KEY        @"getPackScenePath"
#define CS_EXPORTPATH_KEY       @"getExportPath"
#define CS_EXPORTXCODEPATH_KEY  @"getXcodeExportPath"

- (void)startWithDstPath:(NSString*)rootPath
{
    NSString* builderCSPath = [rootPath stringByAppendingPathComponent:@"/TempCode/Builder/_Builder.cs"];
    BOOL success = [self initWithPath:builderCSPath];
    if(success)
    {
        NSArray *keyArr = @[
                           CS_PACKSCENE_KEY,
                           CS_EXPORTPATH_KEY,
                           CS_EXPORTXCODEPATH_KEY
                           ];
        
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
    _view = (ExportInfoManager*)get_instance(@"ExportInfoManager");
    
    return YES;
}

/*
 通过key来取和替换变量
 
 #define CS_PACKSCENE_KEY        @"getPackScenePath"
 #define CS_EXPORTPATH_KEY       @"getExportPath"
 #define CS_EXPORTXCODEPATH_KEY  @"getXcodeExportPath"

 */
- (void)replaceVarWithKeyArr:(NSArray*)keyArr
{
    NSString *replaceFormat = @"\"%@\"";
    NSMutableString* result = [NSMutableString stringWithString:_content];
    
    for(int i = 0; i < [keyArr count]; i++)
    {
        NSString *key = [keyArr objectAtIndex:i];
        NSString *keyStr = [NSString stringWithFormat:@"//木有任何数据"];
        
        Method instMethod = class_getInstanceMethod([self class], NSSelectorFromString(key));
        if(instMethod != NULL){
            keyStr = ((NSString *(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(key));
          
            [result replaceOccurrencesOfString:[NSString stringWithFormat:@"${objcfunc_%@}", key]
                                        withString:[NSString stringWithFormat:replaceFormat, keyStr]
                                           options:NSLiteralSearch
                                             range:NSMakeRange(0, [result length])];
        }
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

- (NSString*)getExportPath
{
    ExportInfo* info = _view.info;
    return [NSString stringWithUTF8String:info->exportFolderParh];
}

- (NSString*)getXcodeExportPath
{
    ExportInfo* info = _view.info;
    const char* path = info->exportFolderParh;
    return [[NSString stringWithUTF8String:path] stringByAppendingFormat:@"/%@",XCODE_PROJ_NAME];
}

- (NSString*)getPackScenePath
{
    ExportInfo* info = _view.info;
    NSMutableArray *fullScenesPath = _view.sceneArray;
    NSString *projPath = [NSString stringWithFormat:@"%s", info->unityProjPath];
    NSMutableArray *scenes = [NSMutableArray array];
    
    for(int i = 0; i < fullScenesPath.count; i++){
      NSString *path = fullScenesPath[i];
      NSString *relativePath = [path substringFromIndex:[projPath length] + 1];
      [scenes addObject:relativePath];
    }
    
    return [self getReplaceStrFromArray:scenes];
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


@end
