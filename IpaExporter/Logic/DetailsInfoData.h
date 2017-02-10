//
//  DetailsInfoData.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsInfoData : NSObject

@property(readonly) NSDictionary *dict;

@property(readonly) NSString* platform;
@property(readonly) NSString* appName;
@property(readonly) NSString* bundleIdentifier;
@property(readonly) NSString* codeSignIdentity;
@property(readonly) NSString* provisioningProfile;
@property(readonly) NSArray* frameworks;

- (id)initWithInfoDict:(NSDictionary*) dic;
- (id)getValueForKey:(NSString*)key;

@end
