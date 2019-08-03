//
//  main.m
//  ttt
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>
#import "PackCammond.h"
#import "Defs.h"

int main(int argc, const char * argv[])
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:SETTING_FOLDER]){
        [[NSFileManager defaultManager] createDirectoryAtPath:SETTING_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //init
    [[PackCammond instance] startUp];
    
    return NSApplicationMain(argc, argv);
}
