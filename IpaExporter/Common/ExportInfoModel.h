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
#define DETAIL_COUNT_KEY @"detailCount"

@interface ExportInfoModel : NSObject
{
    NSUserDefaults* _saveData;
    NSMutableArray* _detailArray;
}

@property(nonatomic, readwrite) ExportInfo* info;

+ (ExportInfoModel*)instance;
- (void)addNewInfo:(ExportInfo*)newInfo;

//包配置 信息表格数据部分
- (NSMutableArray*)reLoad;
- (void)addDetail:(DetailsInfoData*)data;
- (void)removeDetail:(NSUInteger)index;
- (void)getDetail:(NSUInteger)index;

- (void)saveData;
- (ExportInfo*)getData;

@end
