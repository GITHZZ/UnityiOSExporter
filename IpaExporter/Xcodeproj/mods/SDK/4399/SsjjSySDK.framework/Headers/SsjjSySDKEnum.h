//
//  SsjjSySDKEnum.h
//  SsjjSySDK
//
//  Created by xianxian on 2017/8/27.
//  Copyright © 2017年 ssjjsyinner. All rights reserved.
//

#ifndef SsjjSySDKEnum_h
#define SsjjSySDKEnum_h

typedef NS_ENUM(NSUInteger, SsjjsyChangeAccountBtnPosition) {
    SsjjsyChangeAccountBtnPositionDefault   = 0,
    SsjjsyChangeAccountBtnPositionLeft      = 1,
};

typedef NS_ENUM(NSUInteger, SsjjsyChangeAccountBtnColor) {
    SsjjsyChangeAccountBtnWhite   = 0,
    SsjjsyChangeAccountBtnOrange  = 1,
};

typedef NS_ENUM(NSUInteger, SsjjsyWelcomeBannerColor) {
    SsjjsyWelcomeBannerWhite      = 0,
    SsjjsyWelcomeBannerOrange     = 1,
};

typedef NS_ENUM(NSUInteger, SsjjsySDKType) {
    SsjjsySDKNormal      = 0,
    SsjjsySDKJM          = 1,
};

typedef NS_ENUM(NSUInteger, SsjjsyPhotoType) {
    SsjjsyPhotoTypeAlbum     = 0,
    SsjjsyPhotoTypeCamera    = 1,
};

typedef NS_ENUM(NSUInteger, SsjjsyFindOldAccountSucceedType) {
    SsjjsyFindOldAccountSucceedTypeFind = 0,//已经查询到旧帐号数据，下次不在查询
    SsjjsyFindOldAccountSucceedTypeNoNeedFind = 1,//非法设备，不用在调用查询接口了
    SsjjsyFindOldAccountSucceedTypeFindError = 2,//查询到旧帐号数据失败，下次接着调用
};

typedef NS_ENUM(NSUInteger, SsjjSyApiType) {
    SsjjSyApiTypeRelease = 0,       //正式服
    SsjjSyApiTypeDebug = 1,         //测试服
    SsjjSyApiTypeReleaseBGP = 2,    //正式服，BGP转发
};

typedef NS_ENUM(NSUInteger, SsjjSyThirdLoginType) {
    SsjjSyThirdLoginTypeWeinxin = 1,       //微信登录
    SsjjSyThirdLoginTypeQQ = 2,            //QQ登录
    SsjjSyThirdLoginTypeWeibo = 3,         //微博登录
};

#endif /* SsjjSySDKEnum_h */
