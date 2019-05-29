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
#import <UIKit/UIKit.h>
#import "SsjjSyAuthorizeWebView.h"

@class SsjjSyHelper;

@protocol SsjjSyHelperDelegate <NSObject>

@optional
- (void)helper:(SsjjSyHelper *)helper didFailWithBindAccount:(NSString *)url_array;
- (void)helper:(SsjjSyHelper *)helper didSuccessWithBindAccount:(NSString *)url_array;
- (void)helper:(SsjjSyHelper *)helper didSuccessWithRegAccount:(NSDictionary *)dict;
//请求小助手配置信息完成后回调
- (void)requestComplete:(NSDictionary *)dic;
@end

@interface SsjjSyHelper : NSObject <SsjjSyAuthorizeWebViewDelegate, SsjjSyRequestDelegate>
{
    
    NSString    *appKey;
    NSString    *appSecret;
    
    NSString    *redirectURI;
    //设置渠道Id
    NSString    *channelId;
    
    NSString    *token;
    //设置服务器的登录频道 channelId
    NSString        *device_adid;
    NSString        *device_id;
    NSString        *appVersion;
    NSString        *areaId;
    NSString        *serverId;
    int interfaceOrientation;
    
    NSDictionary    *allParams;
    SsjjSyRequest   *request;
    id<SsjjSyHelperDelegate> delegate;
    UIViewController *rootViewController;
    
}

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
- (void)loadAssistant:(NSString *)atoken;

@property(nonatomic, retain) NSString *appKey;
@property(nonatomic, retain) NSString *appSecret;
@property(nonatomic, retain) NSString *token;

@property(nonatomic, retain) NSString *redirectURI;
@property(nonatomic, retain) NSString *channelId;
@property(nonatomic, retain) NSString *quickUserName;
@property(nonatomic, assign) UIViewController *rootViewController;
@property(nonatomic, retain) SsjjSyRequest *request;

//新增变量
@property(nonatomic, retain) NSString *device_id;
@property(nonatomic, retain) NSString *device_adid;
@property(nonatomic, retain) NSString *appVersion;
@property(nonatomic, retain) NSString *areaId;
@property(nonatomic, retain) NSString *serverId;
@property(nonatomic, retain) NSDictionary *allParams;
@property(nonatomic, assign) int interfaceOrientation;
@property(nonatomic, assign) id<SsjjSyHelperDelegate> delegate;

@end
