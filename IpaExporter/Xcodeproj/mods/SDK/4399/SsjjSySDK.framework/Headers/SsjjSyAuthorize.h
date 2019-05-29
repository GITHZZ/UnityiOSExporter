//
//  SsjjSyAuthorize.h
//  SsjjsySDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 4399. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SsjjSyRequest.h"
#import "SsjjSyAuthorizeWebView.h"
#import "SsjjSyUser.h"
#import "SsjjSyActionTag.h"




@class SsjjSyAuthorize;

@protocol SsjjSyAuthorizeDelegate <NSObject>

@optional

- (void)authorize:(SsjjSyAuthorize *)authorize didOrder:(NSString *)order;
- (void)authorize:(SsjjSyAuthorize *)authorize didSucceedWithSsjjLogin:(SsjjSyUser *)dict;

- (void)authorize:(SsjjSyAuthorize *)authorize didSucceedWithQuickLogin:(SsjjSyUser *)dict;

- (void)authorize:(SsjjSyAuthorize *)authorize didFailWithError:(NSError *)error;
- (void)authorize:(SsjjSyAuthorize *)authorize didQuickLoginFailWithError:(NSError *)error;

- (void)authorize:(SsjjSyAuthorize *)authorize didFailWithBindAccount:(NSString *)uesrName;
- (void)authorize:(SsjjSyAuthorize *)authorize didSuccessWithBindAccount:(NSString *)uesrName;

@end

@interface SsjjSyAuthorize : NSObject <SsjjSyAuthorizeWebViewDelegate, SsjjSyRequestDelegate> 
{
    
    NSString    *appKey;
    NSString    *appSecret;
    
    NSString    *redirectURI;
    //设置渠道Id
    NSString    *channelId;
    
    //设置服务器的登录频道 channelId
    NSString        *device_adid;
    NSString        *device_id;
    NSString        *appVersion;
    NSString        *areaId;
    NSString        *serverId;
    //添加快速登陆字段
    NSString        *syDid;
    NSString       *isNeedLogin;
    
    SsjjSyRequest   *request;
    
    UIViewController *rootViewController;
    
    NSMutableDictionary  *commParams;
    
    id<SsjjSyAuthorizeDelegate> delegate;
    
    
}


@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;

@property (nonatomic, retain) NSString *redirectURI;
@property (nonatomic, retain) NSString *channelId;
@property (nonatomic, retain) NSString *quickUserName;

@property (nonatomic, retain) SsjjSyRequest *request;
@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, assign) id<SsjjSyAuthorizeDelegate> delegate;

//新增变量
@property (nonatomic, retain) NSString *syDid;
@property (nonatomic, retain) NSString *device_id;
@property (nonatomic, retain) NSString *device_adid;
@property (nonatomic, retain) NSString *appVersion;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *serverId;
@property (nonatomic, retain) NSString *isNeedLogin;
@property (nonatomic, retain) NSMutableDictionary  *commParams;

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
- (void)openLoginView:(id)engine;
- (void)showAssiGuide;
- (void)startAuthorize;


- (void)exchargeAuthorize:(NSString *) token serverId:(NSString *)theServerId money:(NSString *)theMoney callbackInfo:(NSString *) thCallbackInfo;
- (void)bindStartAuthorize;
- (void)autoLoadWithAccessToken:(NSString *) token;
- (void)quickStartAuthorize;
- (void)loginForumAuthorize:(NSString *) token;;
- (void)failBindAccoutView:(id)engine;
- (void)successBindAccoutView:(NSString *)userID;

- (void)appstorePayMentLogWithReceipt:(NSString *)receipt
                             callback:(NSString *)callbackInfo
                             serverID:(NSString *)theServerID
                                token:(NSString *)mToken;

-(void)startOauthWithTag:(SsjjSyActionTag *)tag;

@end
