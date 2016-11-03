//
//  DetailsInfoData.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoData.h"

@implementation DetailsInfoData

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

@end
