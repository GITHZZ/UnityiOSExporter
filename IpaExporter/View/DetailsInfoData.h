//
//  DetailsInfoData.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsInfoData : NSObject

@property(nonatomic, readonly) NSString* appID; //Bundle Identifier
@property(nonatomic, readonly) NSString* codeSignIdentity;
@property(nonatomic, readonly) NSString* provisioningProfile;

-(void)setInfoWithAppID:(NSString*)appID
       codeSignIdentity:(NSString*)codeS;

@end
