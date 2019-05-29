//
//  4399SDK.h
//  Unity-iPhone
//
//  Created by 4399 on 2018/1/10.
//

#import <Foundation/Foundation.h>

@interface SDK4399 : NSObject

+(id)instance;
-(void) test:(NSArray*)array;
-(void) test2:(NSArray*)array;
-(NSString*) test3:(NSArray*)array;

@property NSString* testString;
@end
