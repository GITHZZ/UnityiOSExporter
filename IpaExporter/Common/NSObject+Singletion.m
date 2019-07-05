//
//  NSObject+Instance.m
//  IpaExporter
//
//  Created by 4399 on 7/4/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "NSObject+Singletion.h"
#import <objc/runtime.h>

@implementation NSObject (Singletion)

+ (instancetype)instance
{
    Class cls = [self class];
    //动态去取属性方法
    id instance = objc_getAssociatedObject(cls, @"instance");
    if(!instance)
    {
        instance = [[self allocWithZone:NULL] init];
        objc_setAssociatedObject(cls, @"instance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return objc_getAssociatedObject([self class], @"instance");
}

@end

