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

@class SsjjSyActionTag;


@interface SsjjSyActionTag :NSObject
{
    int   actionType;
    int   eventType;
    NSString    *phoneNumber;
    NSString    *name;
    NSString    *psw;
    NSString    *captchaId;
    NSString    *captchaUrl;
    NSString    *captcha;
    NSString    *smsCode;
    NSString    *game_user;
    NSString    *need_bind;
    NSString    *game_bind_suid;
}


- (id)init;

@property (nonatomic,assign) int   actionType;
@property (nonatomic,assign) int   eventType;
@property (nonatomic, retain) NSString    *phoneNumber;
@property (nonatomic, retain) NSString    *name;
@property (nonatomic, retain) NSString    *psw;
@property (nonatomic, retain) NSString    *captchaId;
@property (nonatomic, retain) NSString    *captchaUrl;
@property (nonatomic, retain) NSString    *captcha;
@property (nonatomic, retain) NSString    *smsCode;

@property (nonatomic, retain) NSString    *game_user;
@property (nonatomic, retain) NSString    *need_bind;
@property (nonatomic, retain) NSString    *game_bind_suid;

@property (nonatomic, copy) NSString    *sign;
@property(nonatomic,copy)NSString       *syDid;
@property(nonatomic,copy)NSString *token;

@property (nonatomic,copy) NSString *sendNumber;
@property (nonatomic,copy) NSString *sendText;
@property (nonatomic,copy) NSString *alertViewMsg;

@property (nonatomic,assign) int httpStatusCode;

@end
