//
//  DetailsInfoData.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoData.h"
#import "Common.h"

#import <objc/runtime.h>

#define Detail_Info_Dict_Coder_Key @"DetailInfoDict"

@implementation DetailsInfoData

+ (id)initWithJsonString:(NSString *)string
{
    if(string == nil)
        return nil;
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return [[DetailsInfoData alloc] initWithInfoDict:dic];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithInfoDict:(NSDictionary*) dic
{
    if(self = [super init])
    {
        NSEnumerator *iter = [dic keyEnumerator];
        for(NSObject *object in iter)
        {
            NSString* key = (NSString*)object;
            id content = [dic objectForKey:key];
            if(content != nil)
            {
                [self setValue:content forKey:key];
            }
        }
        
        _dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

- (void)setValueForKey:(NSString*)key withObj:(id)obj
{
    if(nil == obj)
        return;
    
    [_dict setObject:obj forKey:key];
    [self setValue:obj forKey:key];
}

- (id)getValueForKey:(NSString*)key
{
    //获取所有变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for(int i = 0; i < count; i++)
    {
        Ivar *ivar = ivars + i;
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(*ivar)];
        NSString *keyName = [NSString stringWithFormat:@"_%@", key];
        if([varName isEqualToString:keyName])
        {
            free(ivars);
            NSString *result = [self valueForKey:key];
            if(!result)
                result = nil;
        
            return result;
        }
    }
    
    NSLog(@"不存在Key:%@的属性变量", key);
    free(ivars);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@没有定义@property, 请在.h文件查看是否有定义到该变量", key);
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_dict forKey:Detail_Info_Dict_Coder_Key];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSMutableDictionary *dict = [decoder decodeObjectForKey:Detail_Info_Dict_Coder_Key];
    return [self initWithInfoDict:dict];
}

- (NSString*)toJson
{
    NSString *jsonString = @"";
    if([NSJSONSerialization isValidJSONObject:_dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_dict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    return jsonString;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[DetailsInfoData allocWithZone:zone] init];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    NSEnumerator *enumerator = [_dict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id value = _dict[key];
        [newDict setObject:[value mutableCopy] forKey:key];
    }
    
    DetailsInfoData *newData = [[DetailsInfoData alloc] initWithInfoDict:newDict];
    return newData;
}

@end
