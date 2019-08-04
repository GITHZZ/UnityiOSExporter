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

@implementation LocalDataSave

- (id)init
{
    if(self = [super init])
    {
        _keyIsSet = NO;
        _useUserDefault = YES;
        
        _bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:_bundleIdentifier];
        NSError *error;
        _saveData = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[[NSMutableDictionary class], [NSMutableData class]]]
                                                        fromData:userData
                                                           error:&error];
        if(_saveData == nil)
            _saveData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithPlist:(NSString*)path
{
    if(self=[super init]){
        _keyIsSet = NO;
        _useUserDefault = NO;
        if([[path pathExtension] isEqualToString:@"plist"]){
            _plistPath = path;
            _saveData = [NSMutableDictionary dictionaryWithContentsOfFile:_plistPath];
        }else{
            NSLog(@"%@:文件错误,非plist文件",path);
        }
    }
    return self;
}

- (void)reload
{
    _saveData = [NSMutableDictionary dictionaryWithContentsOfFile:_plistPath];
    [self setAllSaveKey:_saveTpDict];
}

- (void)setAllSaveKey:(NSDictionary*)saveTpDict
{
    _keyIsSet = YES;
    _saveTpDict = saveTpDict;
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
    
    if(_useUserDefault){
        NSError *error;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_saveData requiringSecureCoding:YES error:&error];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:_bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
        [_saveData writeToFile:_plistPath atomically:YES];
    
    return YES;
}

- (id)dataForKey:(nonnull NSString*)key
{
    return [[_savedict objectForKey:key] mutableCopy];
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
