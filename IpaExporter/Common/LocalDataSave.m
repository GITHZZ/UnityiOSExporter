//
//  LocalDataSave.m
//  IpaExporter
//
//  Created by 4399 on 6/29/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "LocalDataSave.h"
#import <objc/runtime.h>

#define CHECK_KEY_IS_AVAILABEL(key) \
    if(![_savedict objectForKey:key]){NSLog(@"不存在该存储key:%@", key); return NO;}

@interface LocalDataSave()
{
    NSUserDefaults* _saveData;
    NSMutableDictionary<NSString*, id> *_savedict;
    BOOL _keyIsSet;
}
@end

@implementation LocalDataSave

- (id)init
{
    if(self=[super init])
    {
        _keyIsSet = NO;
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
    _keyIsSet = YES;
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
            item = [[cls alloc] init];
        }
        _savedict[key] = item;
    }
}

- (BOOL)saveAll
{
    return [self saveDataForKey:nil];
}

//如果传nil值 代表全部存储
- (BOOL)saveDataForKey:(nullable NSString*)key
{
    if(key != nil && ![_savedict objectForKey:key]){
        NSLog(@"不存在该存储key:%@", key);
        return NO;
    }
    
    NSArray *keyArr = [_savedict allKeys];
    for(int i = 0; i < keyArr.count; i++)
    {
        NSString *saveKey = keyArr[i];
        if(key == nil || saveKey == key){
            NSError *error;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_savedict[saveKey] requiringSecureCoding:YES error:&error];
            
            if(error != nil){
                NSLog(@"存储出错:%@", error);
                return NO;
            }
            
            [_saveData setObject:data forKey:saveKey];
        }
    }
    [_saveData synchronize];
    return YES;
}

- (id)dataForKey:(nonnull NSString*)key
{
    return [_savedict objectForKey:key];
}

- (BOOL)setDataForKey:(nonnull NSString*)key withData:(nullable id)data
{
    CHECK_KEY_IS_AVAILABEL(key)
    [_savedict setObject:data forKey:key];
    return YES;
}

- (BOOL)setAndSaveData:(nullable id)data withKey:(nonnull NSString*)key
{
    CHECK_KEY_IS_AVAILABEL(key)
    [_savedict setObject:data forKey:key];
    return [self saveDataForKey:key];
}

- (void)removeAll
{
    NSArray *keyArr = [_savedict allKeys];
    for(int i = 0; i < keyArr.count; i++)
    {
        NSString *saveKey = keyArr[i];
        [self removeObjectForKey:saveKey];
    }
}

- (BOOL)removeObjectForKey:(nonnull NSString*)key
{
    CHECK_KEY_IS_AVAILABEL(key)
    [_saveData removeObjectForKey:key];
    return YES;
}

@end
