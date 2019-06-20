//
//  MobileprovisionParser.m
//  IpaExporter
//
//  Created by 4399 on 6/3/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "MobileprovisionParser.h"
#import "Common.h"

@interface MobileprovisionParser()
{
    NSString *_profilePath;
}
@end

@implementation MobileprovisionParser

- (id)initWithProfilePath:(NSString*)path
{
    if(self=[super init])
    {
        _profilePath = path;
        
        NSString* profile = [[path componentsSeparatedByString:@"/"] lastObject];
        _fileName = [[profile componentsSeparatedByString:@"."] firstObject];
        
        NSRange range = [path rangeOfString:profile];
        _rootPath = [path substringToIndex:range.location];
        
    }
    return self;
}

- (void)createPlistFile
{
    NSTask *shellTask = [[NSTask alloc] init];
    [shellTask setLaunchPath:@"/bin/sh"];
    
    NSString *shellStr = [NSString stringWithFormat:@"security cms -D -i %@%@.mobileprovision > %@/%@.plist", _rootPath, _fileName, PACK_FOLDER_PATH, _fileName];
    
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c", shellStr, nil]];
    NSPipe *pipe = [[NSPipe alloc] init];
    [shellTask setStandardOutput:pipe];
    [shellTask launch];
    [shellTask waitUntilExit];
}

- (void)parsePlistFile
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",PACK_FOLDER_PATH, _fileName, @"plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        showError([[NSString stringWithFormat:@"%@文件不存在", filePath] UTF8String]);
        return;
    }
        
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    _appIDName = plist[@"AppIDName"];
    _teamID = plist[@"ApplicationIdentifierPrefix"][0];
    _creationDate = plist[@"CreationDate"];
    
    NSString *applicationIdentifier = plist[@"Entitlements"][@"application-identifier"];
    NSRange range = [applicationIdentifier rangeOfString:_teamID];
    _bundleIdentifier = [applicationIdentifier substringFromIndex:range.location + range.length + 1];
}

@end
