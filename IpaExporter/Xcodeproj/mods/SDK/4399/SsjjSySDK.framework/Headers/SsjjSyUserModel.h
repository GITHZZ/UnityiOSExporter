//
//  SsjjSyUserModel.h
//  SsjjSySDK
//
//  Created by 4399 on 14-7-15.
//  Copyright (c) 2014年 4399. All rights reserved.
//

#import "SsjjSyBaseModel.h"



/**
 *  NSString *sykey = userModel.sykey;
 
 NSString *sydid = userModel.sydid;
 */
@interface SsjjSyUserModel : SsjjSyBaseModel

@property(nonatomic,copy)NSString *autoStr;
@property(nonatomic,copy)NSString *timestamp;
@property(nonatomic,copy)NSString *signStr;
@property(nonatomic,copy)NSString *expires_in;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *suid;
@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *targetServerId;
@property(nonatomic,copy)NSString *bindPhone;
@property(nonatomic,copy)NSString *forcePayBack;
@property(nonatomic,copy)NSString *verifyToken;
@property(nonatomic,copy)NSString *isTempAccount;

@property(nonatomic,copy)NSString *sykey;
@property(nonatomic,copy)NSString *sydid;

//扫码登录新增字段
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *accessToken4399;

@end
