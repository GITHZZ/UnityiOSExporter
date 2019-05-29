////
////  SsjjSyTransactionManager.h
////  SsjjSySDK
////
////  苹果IAP充值接口
////  Created by 4399 on 14-11-4.
////  Copyright (c) 2014年 4399. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <StoreKit/StoreKit.h>
//
//typedef NS_ENUM(NSInteger, SsjjSyTransactionFailureType){
//
//    SsjjSyTransactionInvalidPurchase    = 0,    //禁止应用内付费购买
//    SsjjSyTransactionProductNotFount    = 1,    //产品信息获取失败
//    SsjjSyTransactionPurchaseFailure    = 2,    //交易失败
//    SsjjSyTransactionUserCancelPurchase = 3,    //用户取消购买
//    SsjjSyTransactionRestorePurchase    = 4,    //对于非消耗品重复购买。
//};
//
//typedef void(^SsjjSyTransactionProductSuccess)(NSArray *products);
//typedef void(^SsjjSyTransactionRequestSuccess)(NSString * receipt); //成功后返回凭证
//
//typedef void(^SsjjSyTransactionFailure)(NSString *errorMessage,SsjjSyTransactionFailureType errorType);
//
//
//@interface SsjjSyTransactionManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
//
//+(instancetype)sharedInstance;
//
///*
// *
// * 查询产品的信息,查询成功后会返回商品信息
// *
// * 购买商品的id,传入的时候要放入数组
// *
// */
//- (void)requestProducts:(NSArray *)productIdArrays
//                success:(SsjjSyTransactionProductSuccess)successBlock
//                failure:(SsjjSyTransactionFailure)failureBlock;
//
///*
// *
// *  购买产品
// *  product:购买的产品
// *  quantity:数量
// */
//- (void)addPayment:(SKProduct *)product
//          quantity:(NSInteger)quantity
//           success:(SsjjSyTransactionRequestSuccess)successBlock
//           failure:(SsjjSyTransactionFailure)failureBlock;
//
//@end
