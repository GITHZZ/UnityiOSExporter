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

#define INFOS_MAX_CAPACITY 100

#define SAVE_DETAIL_ARRARY_KEY @"detailArray"
#define SAVE_PROJECT_PATH_KEY @"projectPath"
#define SAVE_EXPORT_PATH_KEY @"exportPath"

@interface ExportInfoModel : NSObject
{
    NSUserDefaults* _saveData;
    NSMutableArray* _detailArray;
}

@property(nonatomic, readwrite) ExportInfo* info;

+ (ExportInfoModel*)instance;
- (void)addNewInfo:(ExportInfo*)newInfo;

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
