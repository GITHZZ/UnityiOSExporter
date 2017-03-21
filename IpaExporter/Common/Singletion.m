//
//  NSObject+Singletion.m
//  IpaExporter
//
//  Created by 何遵祖 on 2017/3/20.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

#import "Singletion.h"
#import <objc/runtime.h>

@implementation Singletion

+ (instancetype)instance
{
    Class cls = [self class];
    //动态去取属性方法
    id instance = objc_getAssociatedObject(cls, @"instance");
    if(!instance)
    {
        @synchronized (self)
        {
            if(!instance)
            {
                instance = [[super allocWithZone:NULL] init];
                objc_setAssociatedObject(cls, @"instance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return instance;
}

//不要试图使用allocWithZone来申请内存
//好像已经被打入冷宫了了
//为了保证单例唯一性先封住
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self instance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return objc_getAssociatedObject([self class], @"instance");
}

@end
