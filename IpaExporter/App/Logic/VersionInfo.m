//
//  VersionInfo.m
//  IpaExporter
//
//  Created by 4399 on 7/30/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "VersionInfo.h"

@implementation VersionInfo

- (id)init
{
    if(self = [super init])
    {
        [self checkVersionInfo];
    }
    return self;
}

- (BOOL)isUpdate
{
    return _isUpdate;
}

- (void)checkVersionInfo
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *localVerFile = [NSString stringWithFormat:@"%@/version.txt", documents];
    NSArray *localVer = [NSArray arrayWithObjects:@"1.0.0", @"0", nil];;
    NSArray *packageVer;

    packageVer = @[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:localVerFile]){
        [[NSFileManager defaultManager] createFileAtPath:localVerFile contents:nil attributes:nil];
        _isUpdate = YES;
    }else{
        localVer = [[NSString stringWithContentsOfFile:localVerFile encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];

        _isUpdate = [self compareShortVersion:packageVer[0] withLocalVer:localVer[0] error:nil] != 0 ||
                    ![self compareVersion:packageVer[1] withLocalVer:localVer[1] error:nil];
    }
    
    _version = packageVer[0];
    _build = packageVer[1];
    
    [[NSString stringWithFormat:@"%@\n%@", _version, _build] writeToFile:localVerFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//@格式 1.0.0
- (int)compareShortVersion:(NSString*)packageVer withLocalVer:(NSString*)localVer error:(NSError**)error
{
    NSArray *packageArr = [localVer componentsSeparatedByString:@"."];
    NSArray *localArr = [localVer componentsSeparatedByString:@"."];

    //如果版本号不是三位数 就返回
    if([localArr count] != 3 || [packageArr count] != 3)
        return 0;
    
    for(int i = 0; i < 3; i++){
        int package = [packageArr[i] intValue];
        int local = [packageArr[i] intValue];
        
        if(package > local)
            return 1;
        
        if(package < local)
            return -1;
    }
    
    return 0;
}

//格式;任意字符串
- (BOOL)compareVersion:(NSString*)packageVer withLocalVer:(NSString*)localVer error:(NSError**)error
{
    return [packageVer isEqualToString:localVer];
}

@end
