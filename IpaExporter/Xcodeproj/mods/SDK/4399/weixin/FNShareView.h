//
//  FNShareView.h
//  FNSharePlugin
//
//  Created by xianxian on 16/10/12.
//  Copyright © 2016年 ssjjsyinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNSharePlugin.h"

typedef NS_ENUM(NSInteger,FNShareViewType)
{
    FNShareViewTypeShowInCenter,//在中间显示
    FNShareViewTypeShowInBottom,//在底部显示
    FNShareViewTypeShowInBottomWithoutTitle//在底部显示且没有显示标题
};

//  分享类型
typedef NS_ENUM(NSInteger, FNSHARE_TYPE){
    //文本
    FNSHARE_TYPE_TEXT=0,
    //图片
    FNSHARE_TYPE_IMAGE,
    //链接
    FNSHARE_TYPE_URL,
};

@protocol FNShareViewDelegate <NSObject>

@optional
/**
 点击按钮回调

 @param type 点击按钮的类型
 */
-(void)clickButtonType:(FNShareType)type;

/**
 关闭分享View
 */
-(void)closeShareView;

@end

@interface FNShareView : UIView{
    //  图片项
    NSMutableArray *iconList;
    //  文字项
    NSMutableArray *textList;
}

//  分享文本，文本、图片、连接类型均可设置
@property (nonatomic, copy) NSString *shareText;
//  分享图片，图片类型可设置
@property (nonatomic, strong) UIImage *shareImage;
//  分享链接
@property (nonatomic, copy) NSString *shareUrl;
//  分享标题，链接类型可设置
@property (nonatomic, copy) NSString *shareTitle;
//  分享网页缩略图，链接类型可设置
@property (nonatomic, strong) UIImage *thumbImage;
//  分享类型
@property (nonatomic, assign) FNSHARE_TYPE share_type;
//页面显示样式
@property (nonatomic, assign) FNShareViewType shareViewType;
//  点击按钮delegate
@property (nonatomic, weak) id<FNShareViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
           ViewType:(FNShareViewType)type;

@end
