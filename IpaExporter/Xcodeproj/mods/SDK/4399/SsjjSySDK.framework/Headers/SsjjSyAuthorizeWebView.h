//
//  SsjjSyAuthorizeWebView.h
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
#import <UIKit/UIKit.h>

@class SsjjSyAuthorizeWebView;

@protocol SsjjSyAuthorizeWebViewDelegate <NSObject>

- (void)authorizeWebView:(SsjjSyAuthorizeWebView *)webView didReceiveAuthorizeCode:(NSString *)url_array;
- (void)authorizeWebView:(SsjjSyAuthorizeWebView *)webView didReceiveFailAuthorizeCode:(NSString *)url_array;
- (void)authorizeWebView:(SsjjSyAuthorizeWebView *)webView didReceiveFailAccountBinded:(NSString *)userName;
- (void)authorizeWebView:(SsjjSyAuthorizeWebView *)webView didReceiveSuccessAccountBinded:(NSString *)url_array;

- (void)authorizeWebView:(SsjjSyAuthorizeWebView *)webView didReceiveSuccessAccountRegPhone:(NSDictionary *)dict;
- (void)authorizeWebView:(SsjjSyAuthorizeWebView *)webView didOrder:(NSString *)order;

- (void)exitAuthorizeWebView:(SsjjSyAuthorizeWebView *)webView;

@end

@interface SsjjSyAuthorizeWebView : UIView <UIWebViewDelegate,UIAlertViewDelegate>
{
    UIView *panelView;
    UIView *containerView;
    UIActivityIndicatorView *indicatorView;
	UIWebView *webView;
    UIButton *tagImgView;
    UIButton *closeImgView;
    UIInterfaceOrientation previousOrientation;
    
    NSString *appkey;
    
    NSString *currLoadUrl;
    
    id<SsjjSyAuthorizeWebViewDelegate> delegate;

}

@property (nonatomic, retain) id<SsjjSyAuthorizeWebViewDelegate> delegate;
@property (nonatomic, retain) NSString *appkey;
@property (nonatomic, retain) NSString *currLoadUrl;


- (void)loadRequestWithURL:(NSURL *)url;

- (void)show:(BOOL)animated;

- (void)showAssiGuide;

- (void)showWithController:(UIViewController *)controller;

- (void)hide:(BOOL)animated;

-(void)accoutRegPhone:(NSDictionary *)dict;

@end