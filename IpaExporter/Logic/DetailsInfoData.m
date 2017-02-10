//
//  DetailsInfoData.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/11/3.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "DetailsInfoData.h"
#import <objc/runtime.h>
#import "Defs.h"

#define Detail_Info_Dict_Coder_Key @"DetailInfoDict"

typedef struct IvarData
{
    Ivar* ivar; //变量列表首地址
    unsigned int count; //变量数量
}IvarData;

@interface DetailsInfoData()<NSCoding>
{
    IvarData _varStruct;
}
@end

@implementation DetailsInfoData

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
        
        _dict = dic;
        
        //获取所有变量
        unsigned int count = 0;
        _varStruct.ivar = class_copyIvarList([self class], &count);
        _varStruct.count = count;
    }
    
    return self;
}

- (id)getValueForKey:(NSString*)key
{
    unsigned int count = _varStruct.count;
    Ivar *ivars = _varStruct.ivar;
    for(int i = 0; i < count; i++)
    {
        Ivar *ivar = ivars + i;
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(*ivar)];
        NSString *keyName = [NSString stringWithFormat:@"_%@", key];
        if([varName isEqualToString:keyName])
        {
            return [self valueForKey:key];
        }
    }
    
    NSLog(@"不存在Key%@的属性变量", key);
    return @"";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@没有定义@property", key);
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_dict forKey:Detail_Info_Dict_Coder_Key];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    NSDictionary* dict = [decoder decodeObjectForKey:Detail_Info_Dict_Coder_Key];
    return [self initWithInfoDict:dict];
    
}

@end
