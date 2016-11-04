//
//  DetailsInfoData.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoData.h"

@implementation DetailsInfoData

- (id)initWithAppName:(NSString*)appName
                appID:(NSString*)appID
     codeSignIdentity:(NSString*)codeS
  provisioningProfile:(NSString*)profile
{
    if(self = [super init])
    {
        [self setInfoWithAppName:appName
                           appID:appID
                codeSignIdentity:codeS
             provisioningProfile:profile];
    }
    
    return self;
}

-(void)setInfoWithAppName:(NSString*)appName
                    appID:(NSString*)appID
         codeSignIdentity:(NSString*)codeS
      provisioningProfile:(NSString*)profile
{
    [self setValue:appName forKey:App_Name_Key];
    [self setValue:appID forKey:App_ID_Key];
    [self setValue:codeS forKey:Code_Sign_Identity_Key];
    [self setValue:profile forKey:Provisioning_Profile_key];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_appName forKey:App_Name_Key];
    [encoder encodeObject:_bundleIdentifier forKey:App_ID_Key];
    [encoder encodeObject:_codeSignIdentity forKey:Code_Sign_Identity_Key];
    [encoder encodeObject:_provisioningProfile forKey:Provisioning_Profile_key];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    NSString* appName = [decoder decodeObjectForKey:App_Name_Key];
    NSString* appID = [decoder decodeObjectForKey:App_ID_Key];
    NSString* codeS = [decoder decodeObjectForKey:Code_Sign_Identity_Key];
    NSString* profile = [decoder decodeObjectForKey:Provisioning_Profile_key];
    
    return [self initWithAppName:appName
                           appID:appID
                codeSignIdentity:codeS
             provisioningProfile:profile];
    
}

@end
