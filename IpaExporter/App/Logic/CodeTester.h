//
//  CodeTester.h
//  IpaExporter
//
//  Created by 4399 on 6/24/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Singletion.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeTester : NSObject

- (void)run;
- (void)copyTestFolderToProject;
- (void)saveAndRemoveTestFolder;

@end

NS_ASSUME_NONNULL_END
