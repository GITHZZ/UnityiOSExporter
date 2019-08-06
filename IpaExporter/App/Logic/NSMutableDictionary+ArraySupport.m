//
//  NSMutableDictionary+ArraySupport.m
//  IpaExporter
//
//  Created by 4399 on 8/6/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "NSMutableDictionary+ArraySupport.h"

@implementation NSMutableDictionary (ArraySupport)

+ (NSMutableDictionary *)dictionaryWithArray:(NSArray *)array
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [array count]; i++){
        id item = array[i];
        [dict setObject:item forKey:[item className]];
    }
    return dict;
}

@end
