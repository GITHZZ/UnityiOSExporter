//
//  LocalDataSave.h
//  IpaExporter
//
//  Created by 4399 on 6/29/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalDataSave : NSObject

- (void)setAllSaveKey:(NSDictionary*)saveTpDict;
- (void)saveAll;
- (void)saveDataForKey:(nullable NSString*)key;
- (id)dataForKey:(NSString*)key;
- (void)setAndSaveData:(nullable id)data withKey:(NSString*)key;
- (void)setDataForKey:(NSString*)key withData:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
