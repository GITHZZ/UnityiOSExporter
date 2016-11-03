//
//  DetailsInfoData.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoData.h"

@implementation DetailsInfoData

-(void)setInfoWithAppID:(NSString*)appID
       codeSignIdentity:(NSString*)codeS
{
    _appID = appID;
    _codeSignIdentity = codeS;
    _provisioningProfile = @"123";
}

@end
