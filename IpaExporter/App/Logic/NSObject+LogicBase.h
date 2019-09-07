//
//  NSObject+LogicBase.h
//  IpaExporter
//
//  Created by 4399 on 8/6/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LogicBase)

/**
 逻辑类初始化方法,应用开启调用一次
 */
-(void)initialize;


/**
 更新数据方法,每次界面打开时候调用一次
 */
-(void)updateData;


/**
 清除数据方法,每次关闭界面时候调用一次
 */
-(void)clear;

@end

NS_ASSUME_NONNULL_END
