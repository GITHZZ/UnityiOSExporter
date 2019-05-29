//
//  FNSharePlugin.h
//  FNSharePlugin
//
//  Created by xianxian on 16/9/6.
//  Copyright © 2016年 ssjjsyinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FNShareTypeToQQ = 0,    //QQ
    FNShareTypeToQQQzone,   //QQ空间，仅支持分享Url
    FNShareTypeToWXSession, //微信会话
    FNShareTypeToWXTimeLine,//微信朋友圈
    FNShareTypeToWeibo      //微博
} FNShareType;

//分享插件单例
#define FNSHAREPLUGININSTANCE [FNSharePlugin shareInstance]

@protocol FNSharePluginDelegate <NSObject>

@optional
/**
 *  分享结束，非必须
 *
 *  @param type 分享类型
 *  @param code 请求发送结果码
 */
-(void)shareComplete:(FNShareType)type code:(NSString *)code;

@end

@interface FNSharePlugin : NSObject

/**
 *  获取单例
 *
 *  @return 单例
 */
+(instancetype)shareInstance;

/**
 *  获取单例后设置平台分配的分享参数
 *
 *  @param type      分享类型
 *  @param appid     应用ID，找平台技术进行申请
 *  @param appSecret 应用密钥，找平台技术进行申请
 */
-(void)setShareType:(FNShareType)type AppId:(NSString *)appid AppSecret:(NSString *)appSecret;

/**
 *  检测对应客户端是否安装，未安装可以隐藏分享按钮或者获取客户端下载地址进行下载
 *
 *  @param type 客服端类型
 *
 *  @return 客户端是否安装
 */
-(BOOL)isInstalled:(FNShareType)type;

/**
 *  获取客户端下载地址
 *
 *  @param type 客服端类型
 *
 *  @return 客户端安装地址
 */
-(NSString *)getInstallUrl:(FNShareType)type;

/**
 *  分享链接
 *
 *  @param toApp    分享的类型
 *  @param title    自定义标题
 *  @param describe 自定义内容
 *  @param url      自定义url
 *  @param previewImage 预览图
 */
-(void)shareLinkTo:(FNShareType)type title:(NSString *)title describe:(NSString *)describe url:(NSString *)url previewImage:(UIImage *)previewImage;

/**
 *  分享图片
 *
 *  @param type     分享的类型
 *  @param image    需要分享的图片
 *  @param title    自定义标题
 *  @param describe 自定义内容
 */
- (void)shareImageTo:(FNShareType)type image:(UIImage *)image title:(NSString *)title describe:(NSString *)describe;

/**
 *  分享文字
 *
 *  @param type 分享的类型
 *  @param text 需要分享的文本
 */
- (void)shareTextTo:(FNShareType)type text:(NSString *)text;

/**
 * 判断要分享的种类是否可用
 * @param type 分享的类型
 */
- (BOOL)canShareFNShareType:(FNShareType)type;

@property (nonatomic,weak) id<FNSharePluginDelegate> delegate;
@property (nonatomic,copy) NSString *wbtoken;//第三方应用之前申请的Token，当此值不为空并且无法通过客户端分享的时候,会使用此token进行分享。

@end
