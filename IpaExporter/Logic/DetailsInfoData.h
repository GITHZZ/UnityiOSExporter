//
//  DetailsInfoData.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsInfoData : NSObject

@property(nonatomic, readonly) NSMutableDictionary *dict;

@property(nonatomic, readonly) NSString *platform;
@property(nonatomic, readonly) NSString *appName;
@property(nonatomic, readonly) NSString *bundleIdentifier;
@property(nonatomic, readonly) NSString *codeSignIdentity;
@property(nonatomic, readonly) NSString *provisioningProfile;
@property(nonatomic, readonly) NSString *frameworks;
@property(nonatomic, readonly) NSString *cDirPath;//自定义资源路径
@property(nonatomic, readonly) NSString *isSelected;//是否已经选择
@property(nonatomic, readonly) NSString *cDirectoryPath;
@property(nonatomic, readonly) NSString *libkerFlag;
@property(nonatomic, readonly) NSString *libs;
@property(nonatomic, readonly) NSString *debugProfileName;
@property(nonatomic, readonly) NSString *debugDevelopTeam;
@property(nonatomic, readonly) NSString *releaseProfileName;
@property(nonatomic, readonly) NSString *releaseDevelopTeam;
@property(nonatomic, readonly) NSMutableArray<NSString*> *frameworkNames;
@property(nonatomic, readonly) NSMutableArray<NSString*> *frameworkIsWeaks;
@property(nonatomic, readonly) NSMutableArray<NSString*> *libNames;

- (id)initWithInfoDict:(NSDictionary*) dic;
- (void)setValueForKey:(NSString*)key withObj:(id)obj;
- (id)getValueForKey:(NSString*)key;

@end
