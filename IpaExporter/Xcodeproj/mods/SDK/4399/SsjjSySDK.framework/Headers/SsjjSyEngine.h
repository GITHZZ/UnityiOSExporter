
//  SsjjSyEngine.h
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
#import <SsjjCoreSdk/4399CoreSdk.h>
#import "SsjjSySDKEnum.h"

@class SsjjSyEngine;
typedef void(^APNSblock)(NSString *deviceToken);
typedef void(^SsjjFindOldAccountSucceedBlock)(SsjjsyFindOldAccountSucceedType findType);
typedef void(^SsjjFindOldAccountFaildBlock)(NSError *error);
typedef void(^SsjjSySeasonFinishBlock)(NSDictionary *response,NSError *error);
typedef void(^SsjjSyGetSupportThirdLoginTypeBlock)(NSArray *loginTypes,NSError *error);

@protocol SsjjSyEngineDelegate <NSObject>

@optional

- (void)engine:(SsjjSyEngine *)engine requestDidSucceedWithResult:(id)result;

/**
 *
 *  登录成功回调函数，切换帐号操作也会回调到此，游戏注意处理切换帐号的逻辑
 *
 *  @param dict 登录成功后用户的数据
 */
- (void)engineCallBack:(NSDictionary *)dict;

/**
 *
 *  登录失败回调函数
 *
 *  @param error 登录失败错误,   error.code:  -404    帐号不存在
 *                                          -405    需要重新登录
 *
 */
- (void)loginFailCallBack:(NSError *)error;

/**
 登录频繁回调

 @param error 登录频繁错误，      error.code:  -406    登录太频繁，研发可在此回调里做相应的处理
 
 */
- (void)loginOftenCallBack:(NSError *)error;

/**
 *
 *  登录取消回调函数
 */
- (void)engineCancelLogin;

/**
 *  获取自分享短链接、二维码后回调函数
 *
 *  @param dic 返回的短链接地址还有二维码的base64数据，获取失败返回nil
 *              格式是dic = {
 *                          qrcode = "http://f1.img4399.com/sy~/2015/11/05/10_AZDi7Nw1qs7h.png";
 *                          qrdata = "……………………………………";
 *                          url = "http://dwz.cn/28rQH3";
 *                          title = "分享标题",
 *                          desc = "分享文案"
 *                          };
 */
- (void)getShareDataComplete:(NSDictionary *)dic;

/**
 *  上传图片后回调函数
 *
 *  @param picURL 图片URL地址,上传成功返回图片URL，上传失败返回@""
 */
- (void)uploadPicComplete:(NSString *)picURL;

/**
 *  获取审核结果回调函数
 *
 *  @param result 审核结果，审核通过返回图片地址，未通过返回原因
 */
- (void)checkPicComplete:(NSString *)result;

/**
 *  扫码登录完成回调函数
 *
 *  @param info 返回的状态码code
 *
 *		            token无效
 *			        {code:3017, message:"API_ERROR_ACCESS_TOKEN_VERIFY_FAIL",result:0}
 *			        签名无效
 *			        {code:3020, message:"API_ERROR_QAUTH_VERIFY_FAIL",result:0}
 *			        成功
 *			        {code:300, message:"API_SUCCESS_OP",result:0}
 */
- (void)scanQRCodeToLoginComplete:(NSString *)info;


/**
 *  确认登录后回调
 *
 *  @param info 返回的状态码code
 *
 *		            token无效
 *			        {code:3017, message:"API_ERROR_ACCESS_TOKEN_VERIFY_FAIL",result:0}
 *			        签名无效
 *			        {code:3020, message:"API_ERROR_QAUTH_VERIFY_FAIL",result:0}
 *			        成功
 *			        {code:300, message:"API_SUCCESS_OP",result:0}
 */
-(void)confirmQRCodeLoginComplete:(NSString *)info;

/**
 *  初始化分享图片成功回调
 *
 *  @param code 状态码，1为成功
 *  @param msg  状态信息
 */
-(void)initPhotoSucceed:(NSString *)code message:(NSString *)msg;
/**
 *  初始化分享图片失败回调
 *
 *  @param error 失败信息
 */
-(void)initPhotoFaild:(NSError *)error;

/**
 *  获取分享图片成功回调
 *
 *  @param sharePhoto 合成的待分享图片
 */
-(void)getPhotoSucceed:(UIImage *)sharePhoto;
/**
 *  获取分享图片失败回调
 *
 *  @param error 失败原因
 */
-(void)getPhotoFailed:(NSError *)error;

/**
 初始化减价分享成功回调

 @param info 返回分享文案、短链接等数据    具体字段如下
                                            @{
                                             desc = "文案内容";//文案内容
                                             iconurl = "http://sy-cdnres.unionsy.com/platform/upload/weixin_icon/2016/05/201605201151363910.png";//游戏icon
                                             qrcode = "http://sy-cdnres.unionsy.com/qrcode/2016/11/17/151421917d439ca2814282823ac97db74aee33.png";//二维码base64字符串或分享二维码地址，具体需要返回哪种类型可以和平台技术沟通
                                             title = "\U591a\U4eba\U8d2a\U5403\U86c7 \U866b\U866b\U5927\U4f5c\U6218\Uff01";//文案标题
                                             url = "http://unionsy.com/r/scobyc";//减价分享短链接地址
                                             }
 */
-(void)initSharePriceSucceed:(NSDictionary *)info;

/**
 初始化减价分享失败回调

 @param error 失败原因
 */
-(void)initSharePriceFaild:(NSError *)error;

/**
 减价分享通知成功接口

 @param type 通知类型    @"init" : 初始化减价/更换商品    @"stop": 停止减价
 */
-(void)notifySharePriceSucceedWithType:(NSString *)type;

/**
 减价分享通知失败接口

 @param type  通知类型    @"init" : 初始化减价/更换商品    @"stop": 停止减价
 @param error 失败原因
 */
-(void)notifySharePriceFaildWithType:(NSString *)type error:(NSError *)error;

/**
 获取减价分享图片成功回调

 @param sharePhoto 分享图片
 */
-(void)getSharePricePhotoSucceed:(UIImage *)sharePhoto;

/**
 获取减价分享图片失败回调

 @param error 失败原因
 */
-(void)getSharePricePhotoFaild:(NSError *)error;

/**
 绑定手机回调接口

 @param phone 绑定成功返回手机号，绑定失败返回@""
 @param error 绑定成功返回nil，绑定失败返回具体错误信息
 */
-(void)bindPhoneCallback:(NSString *)phone error:(NSError *)error;

/**
 当前静默帐号绑定结果回调

 @param isBind YES绑定  NO未绑定
 @param phone  绑定的手机号，未绑定返回@""
 */
-(void)getBindStatusSucceed:(BOOL)isBind Phone:(NSString *)phone;

/**
 当前帐号绑定结果获取失败回调

 @param error 失败原因
 */
-(void)getBindStatusFailed:(NSError *)error;

/**
 重新登录页面关闭回调
 */
-(void)reloginViewClose;

/**
 上传URL完成回调
 
 @param info 返回数据,上传失败的话返回值为nil
 */
- (void) uploadUrlAfterOpenAppComplete:(NSDictionary *)info;

/**
 邀请回调

 @param info 回调信息，失败返回nil
             回调信息格式如下：
                     {
                             desc = "";
                             iconurl = "http://sy-cdnres.unionsy.com/platform/upload/weixin_icon/2016/12/201612091944415175.png";
                             qrdata = "...";
                             title = "\U7ed9\U4f60\U4eec\U5b89\U5229\U4e00\U6b3e\U9b54\U6027\U5341\U8db3\U3001\U8da3\U5473\U6027\U5341\U8db3\U7684\U6e38\U620f~\U8d85\U840c\U8d85Q\Uff0c\U7b80\U76f4\U6709\U6bd2\U54e6\Uff01";
                             url = "http://t.cn/RJEoW5h";
                     }
 */
- (void)inviteComplete:(NSDictionary *)info;

/**
 显示交叉推广页回调
 
 @param error 返回nil代表显示成功，否则error为失败原因
 */
-(void)showAcrossExtendViewComplete:(NSError *)error;

@end

@interface SsjjSyEngine : SsjjCoreEngine

@property (nonatomic, assign) id<SsjjSyEngineDelegate> delegate;

/**
 *
 *  屏幕的方向 0：竖屏 1：横屏
 *
 */
@property (nonatomic, assign) int interfaceOrientation;

/**
 *
 *  程序的根控制器对象,传入window的rootViewController属性
 *
 */
@property (nonatomic, retain) UIViewController *rootViewController;

/*************************************   切换帐号按钮配置   ***************************************/
@property (nonatomic, assign) BOOL showChangeAccount;//默认YES显示
@property (nonatomic, assign) SsjjsyChangeAccountBtnPosition changeAccountBtnPosition;//默认右上角
@property (nonatomic, assign) SsjjsyChangeAccountBtnColor    changeAccountBtnColor;   //默认白色
@property (nonatomic, assign) SsjjsyWelcomeBannerColor       welcomeColor;            //默认白色

/*************************************   SDK初始化相关   ***************************************/
/**
 *
 *  SDK初始化
 *
 *  @param clientId      ：   由平台提供的ClientId
 *  @param clientKey     ：   由平台提供的ClientKey
 *  @param theChannelId  ：   由平台提供的渠道id，一般传10，联运等特殊情况联系运营提供具体数值。
 *  @param sdkType       :    SDK类型，SsjjsySDKNormal表示正版平台SDK，SsjjsySDKJM表示静默版SDK
 */
/**
 * 接入人员请先仔细阅读压缩包内"接入文档/4399sdk接入文档.html"
 * 里面有常见问题解答
 * 如果接口调有问题，先查上面的文档，解决不了在找平台技术人员
 */
- (id)initWithClientId:(NSString *)clientId
             ClientKey:(NSString *)clientKey
             ChannelId:(NSString *)theChannelId
               SDKType:(SsjjsySDKType)sdkType;


/**
 *  打开调试日志,默认是开启
 *
 *  @param isOpen 是否打开
 */
- (void)openDebugLog:(BOOL)isOpen;

/**
 * 隐藏切换账号的按钮
 *
 */

- (void)dismissChangeAccountBtn;

/**
 *  切换账号入口
 */
- (void)changeAccount;

/***********************************     静默版相关接口      **************************************/
/**
 *  显示静默版帐号设置页面，此接口暂时不支持iOS7及之下的系统
 */
- (void)showJMSettingView;

/**
 检测当前帐号是否绑定，结果在getBindStatusSucceed回调中获取
 */
- (void)isBindPhone;

/**
 修改静默帐号设置页的颜色

 @param colors 颜色参数，找运营获取
 */
- (void)changeJMViewColor:(NSDictionary *)colors;

/************************************************************************************************/
#pragma mark -
#pragma mark - 账户
/**
 *
 *  账户登录
 *
 *  @comment 登录成功后自动显示欢迎横幅和小助手（静默版SDK不会显示小助手）
 */
- (void)logIn;

/**
 *
 *  账户注销
 *
 */
- (void)logOut;

/**
 *
 *  账户绑定
 *
 */
- (void)bindAccount;

/**
 *  扫描二维码登录接口,需要在调用logIn后调用
 *
 *  @param url 扫描二维码取到的url
 */
- (void)scanQRCodeToLogin:(NSString *)url;

/**
 *  扫码登录确认登录接口
 */
- (void)confirmLogin;


#pragma mark 充值接口
/**
 * app store 充值成功后，需要将这条订单信息返回给平台。
 *
 * @param receipt       ：   app store的充值收据
 * @param callbackInfo  ：   返回给平台回调信息
 * @param theServerID   ：   当前充值的游戏服
 *
 * receipt是[transaction.transactionReceipt base64EncodedStringWithOptions:0]编码后的字符串，
 * 测试环境记得检查theServerID和ChannelId 是否传正确.
 */
- (void)appstorePayMentLogWithReceipt:(NSString *)receipt
                             callback:(NSString *)callbackInfo
                             serverID:(NSString *)theServerID;

#pragma mark 上传图片、审核图片接口
/**
 *  上传图片接口，上传结束后应该保存图片地址，待审核通过后调用审核接口查询审核结果
 *
 *  @param pic              图片数据
 *  @param uploadType       上传图片数据格式：upload_type=1为图片文件数据进行base64 encode字符串，2为表单中的文件数据
 *  @param imageType        图片的上传格式：约定的图片格式，其中1代表原图， 2代表128x128
 *  @param isShowProgress   是否显示顶部进度条
 */
-(void)uploadPicture:(UIImage *)pic withUploadType:(NSInteger)uploadType imageType:(NSInteger)imageType isShowProgress:(BOOL)isShowProgress;

/**
 *  上传图片结束后获取图片审核结果
 *
 *  @param urlStr 图片地址
 */
-(void)checkPicWithURL:(NSString *)urlStr;

#pragma mark - 图片分享接口
/**
 *  初始化分享图片
 *
 *  @param roleId     角色ID
 *  @param roleName   角色名
 *  @param serverName 服务器名
 *  @param callback   游戏透传参数，不需要的话传@""
 *  @param gameid     游戏id，互通请传Android版的gameid，传@""代表Android、iOS不互通
 */
-(void)initSharePhotoWithRoleID:(NSString *)roleId
                       RoleName:(NSString *)roleName
                     serverName:(NSString *)serverName
                   callbackinfo:(NSString *)callback
                         gameid:(NSString *)gameid;

/**
 *  合成分享图片（必须在上面初始化分享图片接口返回成功后，合成图片才有效）
 *
 *  @param action    操作名称，由研发在后台配置。不同游戏、不同action，下面的字段都不同
 *  @param cfg       合成图片元素配置，平台技术规定格式，研发按格式传入，具体请联系蜂鸟技术
 *                          例如:    NSString *action = @"exit_game";
 *                                  NSDictionary *cfg = @{
 *                                                        @"rank" : @"排名100",
 *                                                        @"length" : @"1000",
 *                                                        @"kill" : @"24",
 *                                                        @"head" : @"",//图片可以传服务器上的地址或者头像的UIImage对象
 *                                                        @"bgimage" : @"",
 *                                                        @"rank_text" : @"",
 *                                                        @"rank_number" : @"3",
 *                                                       };
 *  @param scale     合成图片压缩比例，值为0.01-1，1为不压缩,0.01为最小值
 *
 */
-(void)getSharePhotoWithAction:(NSString *)action Config:(NSDictionary *)cfg scale:(CGFloat)scale;

#pragma mark - 分享减价系统
/**
 初始化减价分享接口

 @param roleid     角色ID
 @param rolename   角色名
 @param serverName 服务器名
 @param callback   游戏透传参数，不需要的话传@""
 @param gameid     游戏gameid，如果要和Android互通则传Android的gameid，如果不需要互通传@""
 */
-(void)initSharePriceWithRoleId:(NSString *)roleid
                       RoleName:(NSString *)rolename
                     serverName:(NSString *)serverName
                   callbackinfo:(NSString *)callback
                         gameid:(NSString *)gameid;

/**
 减价分享通知接口，玩家第一次减价分享或切换减价商品时调用

 @param type       通知类型    @"init" : 初始化减价/更换商品    @"stop": 停止减价
 @param roleid     角色ID
 @param rolename   角色名
 @param serverName 服务器名
 @param callback   游戏透传参数，不需要的话传@""
 @param gameid     游戏gameid，如果要和Android互通则传Android的gameid，如果不需要互通传@""
 */
-(void)notifySharePriceType:(NSString *)type
                 WithRoleId:(NSString *)roleid
                   RoleName:(NSString *)rolename
                 serverName:(NSString *)serverName
               callbackinfo:(NSString *)callback
                     gameid:(NSString *)gameid;

/**
 获取减价分享图片，在initSharePriceWithRoleId成功后才能调用

 *  @param action      操作名称，由研发在后台配置。不同游戏、不同action，下面的字段都不同
 *  @param userConfig  合成图片元素配置，平台技术规定格式，研发按格式传入，具体请联系蜂鸟技术
 *                          例如:    NSString *action = @"exit_game";
 *                                  NSDictionary *cfg = @{
 *                                                        @"rank" : @"排名100",
 *                                                        @"length" : @"1000",
 *                                                        @"kill" : @"24",
 *                                                        @"head" : @"",//图片可以传服务器上的地址或者头像的UIImage对象
 *                                                        @"bgimage" : @"",
 *                                                        @"rank_text" : @"",
 *                                                        @"rank_number" : @"3",
 *                                                       };
 *  @param scale       合成图片压缩比例，值为0.01-1，1为不压缩,0.01为最小值
 */
-(void)getSharePricePhotoWithAction:(NSString *)action
                             config:(NSDictionary *)userConfig
                              scale:(CGFloat)scale;

#pragma mark - 赛季结算分享接口
/**
 获取赛季结算数据

 @param rolename 角色名
 @param roleid   角色id
 @param servername 服务器名
 @param headimage 玩家头像地址，没有则传@""
 @param seasontype 赛季唯一标识
 @param seasondata 玩家的赛季结算数据，传json格式的字符串，如{"kill": 100,"died": 10}
 @param callbackinfo 游戏透传参数，不需要传@""
 @param block 获取数据结果回调，判断error不为空则失败，error为空则response返回结算数据
                                                             response内的字段:{
                                                             desc = "\U7ed9\U4f60\U4eec\U5b89\U5229\U4e00\U6b3e\U9b54\U6027\U5341\U8db3\U3001\U8da3\U5473\U6027\U5341\U8db3\U7684\U591a\U4eba\U8d2a\U5403\U86c7\U6e38\U620f~\U8d85\U840c\U8d85Q\Uff0c\U7b80\U76f4\U6709\U6bd2\U54e6\Uff01";
                                                             fullurl = "http://4399sy.com/hd/tgxt/xldzz/season_wap/?id=6&s=84d49afed52c3726&g=iosdemo&t=1";
                                                             iconurl = "http://sy-cdnres.unionsy.com/platform/upload/weixin_icon/2017/06/201706121358101122.jpg";
                                                             qrdata = "iVBORw0KGgoAAAANSUhEUgAAAPgAAAD4AQMAAAD7H7lIAAAABlBMVEX///8AAABVwtN+AAAA9klEQVRYheWV0Q0DMQhD2X9pV02wIVUnsLlTivzSH8twVemFW6eRNKo/v9L3Oe/5kZrA0QqmpEbxTkstNYkzFgjjnI81JlID+EzEflr15yqsq//KlqNNolcFfiAjeC9EGsPtcKQAzm7Zo4Ak8N2CG3Klx51fjyjohOJjz6HjTQv98eaKhC5wTDgn/rzALVnyB7LInHMsnqEAw+LPRX/XBvPhzQWrsC/MxvDmTAjXBPSnyYczR1dBS2Ip/pzVF9bKqI1tuczYXWlm/Dnd0TH+ZPBx4vVpchPCJxFY2yKE447KUcGxieC1POEJAn9OJxQU9UyNNc+uD+lpErPhfJfDAAAAAElFTkSuQmCC";
                                                             title = "\U4ed9\U7075\U5927\U4f5c\U6218\U3001\U8d5b\U5b63\U7ed3\U7b97";
                                                             url = "http://t.cn/RKJhgob";
                                                             }
 */
- (void)getSeasonFinishDataWithRoleName:(NSString *)rolename
                                 RoleId:(NSString *)roleid
                             serverName:(NSString *)servername
                              headImage:(NSString *)headimage
                             seasonType:(NSString *)seasontype
                             seasonData:(NSString *)seasondata
                           callbackInfo:(NSString *)callbackinfo
                          completeBlock:(SsjjSySeasonFinishBlock)block;

#pragma mark - 邀请接口
/**
 邀请接口
 
 @param roleid 用户id
 @param rolename 用户名
 @param servername 服务器名
 @param serverid 服务器id
 @param headImage 用户头像地址
 @param invitetype 邀请类型，团队邀请填team，具体值找平台技术获取
 @param callback_info 游戏透传参数，不需要传@""
 @param gameid 游戏id，游戏id，需要和Android互通的话传Android的gameid，不需要互通的话传@""
 */
- (void)inviteWith:(NSString *)roleid
          roleName:(NSString *)rolename
        serverName:(NSString *)servername
          serverID:(NSString *)serverid
         headImage:(NSString *)headImage
        inviteType:(NSString *)invitetype
     callback_info:(NSString *)callback_info
            gameiD:(NSString *)gameid;

#pragma mark - 微信分享接口
/**
 *  分享链接到微信
 *
 *  @param appid        微信AppID,找平台技术申请
 *  @param title        自定义标题
 *  @param describe     自定义内容
 *  @param url          自定义url
 *  @param iconName     自定义图片名称
 *  @param isTimeLine   分享类型，YES分享到朋友圈，NO分享到好友会话
 */
-(void)shareLinkToWechatWithAppID:(NSString *)appid
                            title:(NSString *)title
                         describe:(NSString *)describe
                              url:(NSString *)url
                         iconName:(NSString *)iconName
                       isTimeLine:(BOOL)isTimeLine;

/**
 *  分享图片到微信
 *
 *  @param appid       微信AppID,找平台技术申请
 *  @param image       需要分享的图片
 *  @param isTimeLine  分享类型，YES分享到朋友圈，NO分享到好友会话
 */
- (void)shareImageToWechatWithAppID:(NSString *)appid image:(UIImage *)image isTimeLine:(BOOL)isTimeLine;

/**
 *  分享文字到微信
 *
 *  @param appid       微信AppID,找平台技术申请
 *  @param text        需要分享的文本
 *  @param isTimeLine  分享类型，YES分享到朋友圈，NO分享到好友会话
 */
- (void)shareTextToWechatWithAppID:(NSString *)appid text:(NSString *)text isTimeLine:(BOOL)isTimeLine;

#pragma mark - 自分享系统
/**
 *  获取分享短链接、二维码接口
 *
 *  @param roleId           角色id
 *  @param roleName         角色名
 *  @param serverName       服务器名字
 *  @param roleLevel        角色等级
 *  @param callback_info    游戏透传参数，不需要的话传@""
 *  @param gameid           游戏id，互通请传Android版的gameid，传@""代表Android、iOS不互通
 *
 */
- (void)getShareDataWithRoleId:(NSString *)roleId
                      roleName:(NSString *)roleName
                    serverName:(NSString *)serverName
                     roleLevel:(NSString *)roleLevel
                  callbackInfo:(NSString *)callback_info
                        gameid:(NSString *)gameid;

/**
 *  登录完成日志，在选服、创角完成后，正式进入游戏主城时调用
 *
 *  @param roleId     角色id
 *  @param roleName   角色名
 *  @param serverName 服务器名字
 *  @param roleLevel  角色等级
 *  @param gameid     游戏id，互通请传Android版的gameid，传@""代表Android、iOS不互通
 */
- (void)appAfterLoginLogWithRoleId:(NSString *)roleId
                          roleName:(NSString *)roleName
                        serverName:(NSString *)serverName
                         roleLevel:(NSString *)roleLevel
                            gameid:(NSString *)gameid;

#pragma mark 打开交叉推广页面
- (void)showAcrossExtendView;//尚未完工

#pragma mark web唤醒app，app回调服务端接口
/**
 通过URL Scheme打开APP后回调服务器接口，在以下两个回调
 -(BOOL)application:openURL:sourceApplication:annotation:  (>=iOS4.2)
 -(BOOL)application:openURL:options:                       (>=iOS9.0)
 中保存URL下来，登录选角后调用此方法将上面保存下来的URL上传
 
 @param url          上面回调中保存的url参数
 @param roleid       角色id
 @param rolename     角色名
 @param servername   服务器名
 @param callbackinfo 游戏透传参数，不需要的话传@""
 */
-(void)uploadUrlAfterOpenApp:(NSURL *)url withRoleId:(NSString *)roleid RoleName:(NSString *)rolename serverName:(NSString *)servername callbackInfo:(NSString *)callbackinfo;

#pragma mark - 广告和客服接口
/**
 * 
 * 广告的显示
 *
 */
-(void)showAds;

/**
 打开客服页面,需要在info.plist中添加QQ的URL Scheme，不然无法在客服页唤起QQ
 */
-(void)openKefuWebPage;


#pragma mark - 日志
/**
 *  打开应用日志,程序一开始启动的时候调用。
 *
 *  @param theAppKey (theClientId)
 *  @param theAppSecret (theClientKey)
 */
- (void)appOpenLog:(NSString *)theAppKey
         appSecret:(NSString *)theAppSecret;


/**
 *  登录前日志，登录前调用
 */
- (void)appLoginLog;


/**
 *  选服日志（最终ID以选服还有创角日志后传的为准）
 *
 *  @param serverId 游戏服务id
 */
- (void)appServerLogWithServerId:(NSString *)serverId;

/**
 *  创建角色日志
 *
 *  @param roleName 角色名
 *  @param serverId 游戏服务id
 */
- (void)createRoleLogWithRoleName:(NSString *)roleName serverID:(NSString *)serverId;

/**
 *  角色升级日志
 *
 *  @param roleLevel 角色等级
 */
- (void)roleLevelLogWithLevel:(NSString *)roleLevel;

/**
 分享系统日志接口,此接口和Android的逻辑不太一样，需要研发在特定的地方自行调用
 
 @param roleid       角色ID
 @param shareaction  操作名称，由研发在后台配置。不同游戏、不同action，下面的字段都不同
 @param status       分享状态，参照如下
                             1----打开默认分享列表对话框
                            -1----分享页面关闭取消分享
                             2----点击分享（打开第三方分享界面）
                             3----点击保存分享图片到本地
                            -2----取消分享（在第三方分享界面取消分享）
                             9----分享成功
                            -9----分享失败
                          -101----打开分享页面失败
                          -102----取消分享（未安装客户端APP）
 @param shareto      分享到哪，参照如下
                              wechat_friends 分享到微信好友
                              wechat_moments 分享到微信朋友圈
                              qq_friends 分享到qq好友
                              qq_zone 分享到qq空间
                              sina_weibo 分享到新浪微博
 @param sharetype    分享方式，image、url、text等
 @param sharescene   分享场景，比如dead、fight_result、game_home、fight_over、user_home
 @param fightmode    分享战斗模式, 分享场景dead/fight_result/fight_over记录为大于0的整数,具体含义与T后台约定;
 */
-(void)shareLogWithRoleID:(NSString *)roleid
              ShareAction:(NSString *)shareaction
                   Status:(NSString *)status
                  ShareTo:(NSString *)shareto
                ShareType:(NSString *)sharetype
               ShareScene:(NSString *)sharescene
                Fightmode:(NSString *)fightmode;

/**
 *
 *  发送礼包码接口
 *
 *  只有当激活码被成功激活时，游戏服务器才会向前端发送相应的礼包数据。
 *   激活码激活不成功（玩家乱填，激活码已被激活过等情况）是不会向前端发送信息的Ø。
 *
 *  @param giftCode   游戏礼包码
 *  @param roleName   角色名称
 */
- (void)sendGameGiftCode:(NSString *)giftCode roleName:(NSString *)roleName;

#pragma mark - 恢复帐号数据
/**
 查询此设备之前是否有旧帐号

 @param succeedBlock 查询结果回调
 @param faildBlock 查询失败回调
 */
- (void)findOldAccountSuccee:(SsjjFindOldAccountSucceedBlock)succeedBlock
                       Faild:(SsjjFindOldAccountFaildBlock)faildBlock;

/**
 将查询到的数据写入本地
 */
- (void)recoverAccountData;

/**
 查询是否写入过旧帐号数据
 
 @return 是否写入过旧帐号数据
 */
- (BOOL)isRecoverAccount;

/**
 帐号数据写入本地后调用此方法进行登录

 @param show 是否显示登录转圈动画
 */
- (void)quickLogIn:(Boolean)show;

#pragma mark - 获取设备信息
/**
 *  获取设备唯一标示符
 *
 *  @return IDFA            iOS7及以上系统
 *          MacAddress      iOS6及以下系统
 */
+ (NSString *)getUDID;

/**
 *  获取设备名称
 *
 *  @return DeviceName
 */
+ (NSString *)getDeviceName;

/**
 *  获取设备类型
 *
 *  @return DeviceType
 */
+ (NSString *)getDeviceType;

#pragma mark - 常用工具
/**
 *  保存截图到相册
 *
 *  @param view 需要保存的View
 */
+ (void)savePhotoToAlbum:(UIView *)view;

#pragma mark - 测试方法
/**
 *
 * 删除保存在keychain的用户数据
 *
 */
- (void)deleteAllKeychain;

/**
 删除临时帐号标识，调用此方法后重新登录会分配一个新的临时帐号(3.7.2.26版本之后此方法合并到deleteAllKeychain之中)
 */
- (void)deleteTempAccountIdentifier;

/**
 清除设备唯一标识
 */
- (void)deleteUUID;

/**
 切换服务器API，默认正式服
 
 @param type 服务器类型
 */
-(void)setApiType:(SsjjSyApiType)type;

@end
