//
//  ExportInfoManager.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//
//  唯一能与界面逻辑直接交互的逻辑类 用于读取和存储界面的数据
//

#import <Foundation/Foundation.h>
#import "DetailsInfoData.h"
#import "Common.h"
#import "Defs.h"

#define SAVE_DETAIL_ARRARY_KEY  @"detailArray"
#define SAVE_PROJECT_PATH_KEY   @"projectPath"
#define SAVE_CODE_SAVE_PATH_KEY @"codeSavePath"
#define SAVE_EXPORT_PATH_KEY    @"exportPath"
#define SAVE_SCENE_ARRAY_KEY    @"scenePath"
#define SAVE_IS_RELEASE_KEY     @"isRelease"
#define SAVE_IS_EXPORT_XCODE    @"isExportKey"
#define SAVE_IS_EXPORT_IPA      @"isExportIpa"

NS_ASSUME_NONNULL_BEGIN
@interface ExportInfoManager : NSObject
{
@private
    LocalDataSave *_userData;
    NSDictionary *_saveTpDict;
}

@property(nonatomic, readwrite) ExportInfo *info;
@property(nonatomic, readonly) NSMutableArray *unityProjPathArr;
@property(nonatomic, readonly) NSMutableArray *exportPathArr;
@property(nonatomic, readonly) NSString *codeBackupPath;
@property(nonatomic, readonly, getter=getDetailArray) NSMutableArray *detailArray;
@property(nonatomic, readonly, getter=getSceneArray) NSMutableArray *sceneArray;

- (void)saveDataForKey:(NSString*)key withData:(id) data;

- (BOOL)addNewUnityProjPath:(NSString*)path;
- (void)replaceUnityProjPath:(NSString*)path;
- (BOOL)addNewExportProjPath:(NSString*)path;
- (void)replaceExportProjPath:(NSString*)path;

//路径配置
- (void)reload;
- (void)reloadPaths;

//包配置 信息表格数据部分
- (NSMutableArray*)reLoadDetails:(NSString*)saveKey;
- (void)addDetail:(id)data withKey:(NSString*)saveKey;
- (void)removeDetail:(NSUInteger)index withKey:(NSString*)saveKey;
- (void)updateDetail:(NSUInteger)index withObject:(id)object withKey:(NSString*)saveKey;

//设置备份存储路径
- (void)setCodeSavePath:(NSString*)path;
- (NSArray*)getAllUnityScenePath;

NS_ASSUME_NONNULL_END

@end
