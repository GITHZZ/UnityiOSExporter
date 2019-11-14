//
//  CodeTester.h
//  IpaExporter
//
//  Created by 4399 on 6/24/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeTester : NSObject
{
@private
    ExportInfoManager* _manager;
    UnityAssetManager* _dataInst;
}
- (void)run;
- (void)copyTestFolderToProject;
- (void)saveAndRemoveTestFolder;

@end

NS_ASSUME_NONNULL_END
