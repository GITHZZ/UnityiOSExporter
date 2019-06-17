//
//  PreferenceView.m
//  IpaExporter
//
//  Created by 4399 on 6/17/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import "PreferenceView.h"

@implementation PreferenceView

-(IBAction)OpenCustomCodeFolder:(id)sender
{
    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/DataTemplete/Builder"];
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:resPath];
}

@end
