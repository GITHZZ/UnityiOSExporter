//
//  DetailsInfoData.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsInfoData : NSObject<NSCoding>

@property(readonly) NSDictionary *dict;

- (id)initWithInfoDict:(NSDictionary*) dic;
- (id)getValueForKey:(NSString*)key;

@end
