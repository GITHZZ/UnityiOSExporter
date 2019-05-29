//
//  SsjjSyRequest.h
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

typedef enum
{
    kSsjjSyRequestPostDataTypeNone,
	kSsjjSyRequestPostDataTypeNormal,			// for normal data post, such as "user=name&password=psd"
	kSsjjSyRequestPostDataTypeMultipart,        // for uploading images and files.
}SsjjSyRequestPostDataType;


@class SsjjSyRequest;

@protocol SsjjSyRequestDelegate <NSObject>

@optional

- (void)request:(SsjjSyRequest *)request didReceiveResponse:(NSURLResponse *)response;

- (void)request:(SsjjSyRequest *)request didReceiveRawData:(NSData *)data;

- (void)request:(SsjjSyRequest *)request didFailWithError:(NSError *)error;

- (void)request:(SsjjSyRequest *)request didFinishLoadingWithResult:(id)result;

- (void)request:(SsjjSyRequest *)request didSaveLoadingWithResult:(NSString *)result;


@end

@interface SsjjSyRequest : NSObject
{
    NSString                *url;
    NSString                *httpMethod;
    NSDictionary            *params;
    SsjjSyRequestPostDataType   postDataType;
    NSDictionary            *httpHeaderFields;
    
    NSURLConnection         *connection;
    NSMutableData           *responseData;
    
    id<SsjjSyRequestDelegate>   delegate;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSDictionary *params;
@property SsjjSyRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary *httpHeaderFields;
@property (nonatomic, assign) id<SsjjSyRequestDelegate> delegate;

+ (SsjjSyRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
                 postDataType:(SsjjSyRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<SsjjSyRequestDelegate>)delegate;

+ (SsjjSyRequest *)requestWithAccessToken:(NSString *)accessToken
                                  url:(NSString *)url
                           httpMethod:(NSString *)httpMethod 
                               params:(NSDictionary *)params
                         postDataType:(SsjjSyRequestPostDataType)postDataType
                     httpHeaderFields:(NSDictionary *)httpHeaderFields
                             delegate:(id<SsjjSyRequestDelegate>)delegate;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

- (void)connect;
- (void)disconnect;

@end
