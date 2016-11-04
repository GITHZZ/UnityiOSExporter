//
//  ExportInfoModel.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//
//  唯一能与界面直接交互的逻辑类 用于读取和存储界面的数据
//

#import <Foundation/Foundation.h>
#import "Defs.h"

#define INFOS_MAX_CAPACITY 100

@interface ExportInfoModel : NSObject
{
    NSUserDefaults* _saveData;
}

@property(nonatomic, readwrite) ExportInfo* info;

+ (ExportInfoModel*)instance;
- (void)addNewInfo:(ExportInfo*)newInfo;
- (void)saveData;
- (ExportInfo*)getData;

@end
