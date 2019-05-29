//
//  LoginManager.h
//  SsjjSySDK
//
//  Created by 4399 on 7/11/14.
//  Copyright (c) 2014 4399. All rights reserved.
//

#import "SsjjSyUserModel.h"
#import <UIKit/UIKit.h>
#import "SsjjSyActionTag.h"


@class SsjjSyLoginManager;
@protocol SsjjSyLoginManagerDelegate <NSObject>
@optional
- (void)actionManager:(SsjjSyLoginManager *)manager didLoginManagerOrder: (SsjjSyActionTag *) actionTag;

- (void)actionManager:(SsjjSyLoginManager *)manager
 didLoginManagerOrder: (SsjjSyActionTag *) actionTag
didLoginManagerSucceed:(SsjjSyUserModel *)userModel;

//请求失败的回调接口
- (void)actionManager:(SsjjSyLoginManager *)manager didLoginManagerFaild:(NSError *)error actionTag:(SsjjSyActionTag *) actionTag;
//自动登录失败回调
- (void)actionManager:(SsjjSyLoginManager *)manager autoLoginFaild:(NSError *)error;
@end

typedef void(^CheckMessageStatusBlock)(NSDictionary *resultDic,BOOL isCallBack);
typedef void(^CompleteMessageBlock)(NSString *userAddress,NSString *content,NSString *checkCode);
typedef void(^ErrorMessageBlock)(NSString *errorMessage);
typedef void(^CheckRegServerSettingBlcok)(NSString *needLogin);
@interface SsjjSyLoginManager : NSObject{
    
    UIView               *loadView;
    id<SsjjSyLoginManagerDelegate> delegate;
}

@property (nonatomic, assign) id<SsjjSyLoginManagerDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary  *commParams;
@property (nonatomic, retain)   SsjjSyActionTag     *actionTag;
@property (nonatomic, retain)   UIView             *loadView;



- (id)init;
-(void)startActionWithTag:(SsjjSyActionTag *)tag;

//获取手机注册图片验证码
- (BOOL) getPhoneRegcaptcha:(NSString *)phoneNumber;

//发送手机验证码
- (void) sendPhoneVerificationCode: (NSString *) phoneNumber;
- (BOOL) sendPhoneVerificationCodeSyn:(NSString *)phoneNumber;

//获取发送手机短信的一些信息
- (void) loadMessageCodeWithURL:(NSString *)urlString withData:(NSDictionary *)postData completeSuccess:(CompleteMessageBlock)messageBlock errorMessageBlock:(ErrorMessageBlock)errorMessageBlock;

//发送请求查询短信的状态
- (void) checkMessageStatusWithURL:(NSString *)urlString withData:(NSDictionary *)postData completeSuccess:(CheckMessageStatusBlock)messageBlock errorMessageBlock:(ErrorMessageBlock)errorMessageBlock;

- (void)checkRegServerSettingWithURL:(NSString *)urlStinrg withData:(NSDictionary *)postData completeSuccess:(CheckRegServerSettingBlcok)checkRegServerSettingBlcok errorMessageBlock:(ErrorMessageBlock)errorMessageBlock;

+ (instancetype)sharedInstance;
@end
