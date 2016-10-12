//
//  ExporterMain.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCammond.h"
#import "ViewMain.h"

@interface ExporterMain : NSObject

@property(nonatomic, readonly) LuaCammond* l_inst;
@property(nonatomic, readonly) ViewMain* v_inst;

+ (ExporterMain*)instance;
- (void)startUp;
- (void)startMain;

@end
