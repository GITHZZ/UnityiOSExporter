//
//  LocalDataSave.h
//  IpaExporter
//
//  Created by 4399 on 6/29/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalDataSave : NSObject

/**
 设置所有需要存储的key还有对应类型,如果该key已经有存储内容,同时也会解析出来
 
 @param saveTpDict 类型字典（格式:dict=@{NSString:NSArray<Class> *}）
 */
- (void)setAllSaveKey:(NSDictionary*)saveTpDict;

/**
 存储某个数据

 @param key 存储key，必须是在初始化中传入过的key。如果传入为空，代表存储所有
 @return 返回是否成功
 */
- (BOOL)saveDataForKey:(nullable NSString*)key;

/**
 存储全部
 */
- (BOOL)saveAll;

/**
 获取某个数据

 @param key 存储key，必须是在初始化中传入过的key
 @return 返回获取到的数据
 */
- (id)dataForKey:(nonnull NSString*)key;


/**
 设置某个待存储key

 @param key 存储key，必须是在初始化中传入过的key
 @param data 需要设置对象
 @return 返回结果
 */
- (BOOL)setDataForKey:(nonnull NSString*)key withData:(nullable id)data;

/**
 设置某个待存储key 会自动存储
 */
- (BOOL)setAndSaveData:(nullable id)data withKey:(NSString*)key;

/**
 移除某个数据

 @param key 存储key，必须是在初始化中传入过的key
 @return 返回结果
 */
- (BOOL)removeObjectForKey:(nonnull NSString*)key;

/**
 移除全部
 */
- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
