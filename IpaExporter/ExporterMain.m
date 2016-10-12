//
//  ExporterMain.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ExporterMain.h"

@implementation ExporterMain

+(ExporterMain*)instance
{
    static ExporterMain* s_instance = nil;
    if(nil == s_instance)
    {
        @synchronized (self)
        {
            if(nil == s_instance)
            {
                s_instance = [[self alloc]init];
            }
        }
    }
    return s_instance;
}

-(void)startUp
{
    _l_inst = [[LuaCammond alloc] init];
    _v_inst = [[ViewMain alloc] init];
}

-(void)startMain
{
    [_l_inst startExport];
}

@end
