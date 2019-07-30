//
//  VersionInfo.h
//  IpaExporter
//
//  Created by 4399 on 7/30/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionInfo : NSObject
{
    NSString *_localVersion;
    BOOL _isUpdate;
}

@property (nonatomic, readonly)NSString *version;
@property (nonatomic, readonly)NSString *build;

- (BOOL)isUpdate;

@end

NS_ASSUME_NONNULL_END
