//
//  LocalDataSave.m
//  IpaExporter
//
//  Created by 4399 on 6/29/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "LocalDataSave.h"
#import <objc/runtime.h>

@interface LocalDataSave()
{
    NSUserDefaults* _saveData;
    NSMutableDictionary<NSString*, id> *_savedict;
}
@end

@implementation LocalDataSave

- (id)init
{
    if(self=[super init])
    {
        _saveData = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

/**
 设置所有需要存储的key还有对应类型,如果该key已经有存储内容,同时也会解析出来

 @param saveTpDict 类型字典（格式:dict=@{NSString:NSArray<Class> *}）
 */
- (void)setAllSaveKey:(NSDictionary*)saveTpDict
{
    _savedict = [NSMutableDictionary dictionary];
    NSArray *keyArr = [saveTpDict allKeys];
    for(int i = 0; i < keyArr.count; i++)
    {
        NSString *key = keyArr[i];
        NSSet *set = [NSSet setWithArray:saveTpDict[key]];
        NSData *data = (NSData*)[_saveData objectForKey:key];
        NSError *error;
        id item = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
        
        if(error != nil)
            NSLog(@"%@", error);
        
        if(item == nil){
            Class cls = saveTpDict[key][0];
            item = class_createInstance(cls, 0);
        }
        _savedict[key] = item;
    }
}

//如果传nil值 代表全部存储
- (void)saveAll
{
    [self saveDataForKey:nil];
}

- (void)saveDataForKey:(nullable NSString*)key
{
    NSArray *keyArr = [_savedict allKeys];
    for(int i = 0; i < keyArr.count; i++)
    {
        NSString *saveKey = keyArr[i];
        if(key == nil || saveKey == key){
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_savedict[key] requiringSecureCoding:YES error:nil];
            [_saveData setObject:data forKey:saveKey];
        }
    }
    [_saveData synchronize];
}

- (id)dataForKey:(NSString*)key
{
    return [_savedict objectForKey:key];
}

- (void)setDataForKey:(NSString*)key withData:(nullable id)data
{
    [_savedict setObject:data forKey:key];
}

@end
