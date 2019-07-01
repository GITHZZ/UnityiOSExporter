//
//  RubyCommand.h
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singletion.h"

NS_ASSUME_NONNULL_BEGIN

@interface PackCammond : Singletion

- (void)startUp;
- (void)backUpCustomCode;
- (void)restoreCustomCode;

@end

NS_ASSUME_NONNULL_END
