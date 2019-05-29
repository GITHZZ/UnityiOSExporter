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

@class SsjjSyUser;
@interface SsjjSyUser :NSObject
{
    NSString *username;
    NSString *autoStr;
    NSString *access_token;
    NSString *signStr;
    NSString *expires_in;
    NSString *suid;
    NSString *timestamp;
    
    NSString *bindPhone;
    NSString *targetServerId;
    NSString *forcePayBack;
    NSString *isTempAccount;
    NSString *verifyToken;
    
    NSString *sykey;
    NSString *sydid;
}


- (id)init;

@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *autoStr;
@property(nonatomic, retain) NSString *access_token;
@property(nonatomic, retain) NSString *signStr;
@property(nonatomic, retain) NSString *expires_in;
@property(nonatomic, retain) NSString *suid;
@property(nonatomic, retain) NSString *timestamp;

@property(nonatomic, retain) NSString *bindPhone;
@property(nonatomic, retain) NSString *targetServerId;
@property(nonatomic, retain) NSString *forcePayBack;
@property(nonatomic, retain) NSString *isTempAccount;
@property(nonatomic, retain) NSString *verifyToken;

@property(nonatomic, retain) NSString *sykey;
@property(nonatomic, retain) NSString *sydid;

@end
