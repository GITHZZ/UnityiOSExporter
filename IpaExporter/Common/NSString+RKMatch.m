//
//  NSString+RKMatch.m
//  IpaExporter
//
//  Created by 4399 on 5/7/20.
//  Copyright © 2020 何遵祖. All rights reserved.
//

#import "NSString+RKMatch.h"

#import <AppKit/AppKit.h>


@implementation NSString (RKMatch)

- (BOOL)isMatch:(NSString*)keyword
{
    NSInteger keyHash = [keyword hash];
    NSInteger keyLength = [keyword length];
    
    NSString *subString;
    for(int i = 0; i < self.length; i++){
        if (keyLength + i >= self.length + 1) break;
        subString = [self substringWithRange:NSMakeRange(i, keyLength)];
        if([subString hash] == keyHash){
            for (int j = 0; j < keyLength; j++) {
                NSString *c1 = [subString substringWithRange:NSMakeRange(j, 1)];
                NSString *c2 = [keyword substringWithRange:NSMakeRange(j, 1)];
               
                if(![c1 isEqualToString:c2]) break;
                
                if (j == keyLength - 1) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

@end
