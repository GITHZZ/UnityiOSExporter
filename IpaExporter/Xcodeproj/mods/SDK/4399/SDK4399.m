//
//  4399SDK.m
//  Unity-iPhone
//
//  Created by 4399 on 2018/1/10.
//

#import "SDK4399.h"
#import "UnityAppController.h"

@implementation SDK4399

@synthesize testString;

static SDK4399 *_instance = nil;

+(id)instance
{
    if(nil == _instance)
    {
        NSLog(@"========");
        _instance = [[SDK4399 alloc] init];
    }
    
    return _instance;
}

-(void) test:(NSArray*)array
{
    //UnityGetGLViewController();
    
    testString = @"1";
   // UnitySendMessage("", "", "");
    //return @"123";
}

-(void) test2:(NSArray*)array
{
    NSLog(@"++%@", testString);
    // UnitySendMessage("", "", "");
    //return @"1234";
}


@end
