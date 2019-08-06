//
//  NSMutableDictionary+ArraySupport.h
//  IpaExporter
//
//  Created by 4399 on 8/6/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary<KeyType, ObjectType> (ArraySupport)

/**
 根据数组进行初始化

 @param array 需要初始化的数组(注意会根据classnName作为key)
 @return 返回转换后的字典
 */
+(nullable NSMutableDictionary<NSString *, ObjectType> *)dictionaryWithArray:(NSArray*)array;

@end

NS_ASSUME_NONNULL_END
