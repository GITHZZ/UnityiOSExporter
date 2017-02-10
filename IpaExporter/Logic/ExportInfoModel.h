//
//  ExportInfoModel.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//
//  唯一能与界面逻辑直接交互的逻辑类 用于读取和存储界面的数据
//

#import <Foundation/Foundation.h>
#import "Defs.h"
#import "DetailsInfoData.h"

@interface ExportInfoModel : NSObject
{
    NSUserDefaults* _saveData;
}

@property(nonatomic, readwrite) ExportInfo *info;
@property(nonatomic, readonly) NSMutableArray *unityProjPathArr;
@property(nonatomic, readonly) NSMutableArray *exportPathArr;
@property(nonatomic, readonly) NSMutableArray *detailArray;

+ (ExportInfoModel*)instance;
- (void)addNewUnityProjPath:(NSString*)path;
- (void)addNewExportProjPath:(NSString*)path;

//路径配置
- (void)reloadPaths;

//包配置 信息表格数据部分
- (NSMutableArray*)reLoadDetails;
- (void)addDetail:(DetailsInfoData*)data;
- (void)removeDetail:(NSUInteger)index;
- (void)updateDetail:(NSUInteger)index withObject:(id)object;

- (void)saveData;
- (ExportInfo*)getData;

@end
