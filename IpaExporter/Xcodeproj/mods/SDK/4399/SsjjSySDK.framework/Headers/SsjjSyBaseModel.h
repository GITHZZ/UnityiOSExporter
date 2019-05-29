//
//  SsjjSyBaseModel.h
//  SsjjSySDK
//
//  Created by 4399 on 14-7-15.
//  Copyright (c) 2014年 4399. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SsjjSyBaseModel : NSObject<NSCoding>

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
