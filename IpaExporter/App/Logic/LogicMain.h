//
//  LogicMain.h
//  IpaExporter
//
//  Created by 4399 on 8/4/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogicMain : NSObject
{
    NSArray *_instanceArray;
}

- (void)startUp;
- (NSObject*)getInstByClassName:(NSString*)className;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
