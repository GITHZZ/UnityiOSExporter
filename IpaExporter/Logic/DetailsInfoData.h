//
//  DetailsInfoData.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsInfoData : NSObject

@property(readonly) NSMutableDictionary *dict;

@property(readonly) NSString* platform;
@property(readonly) NSString* appName;
@property(readonly) NSString* bundleIdentifier;
@property(readonly) NSString* codeSignIdentity;
@property(readonly) NSString* provisioningProfile;
@property(readonly) NSString* frameworks;
@property(readonly) NSString* cDirPath;//自定义资源路径
@property(readonly) NSString* isSelected;//是否已经选择
@property(readonly) NSString* cDirectoryPath;
@property(readonly) NSString* libkerFlag;
@property(readonly) NSString* libs;

- (id)initWithInfoDict:(NSDictionary*) dic;
- (void)setValueForKey:(NSString*)key withObj:(id)obj;
- (id)getValueForKey:(NSString*)key;

@end
