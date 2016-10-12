//
//  Defs.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/10.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef Defs_h
#define Defs_h

#define DATA_PATH @"/Data_t"

typedef struct ExportInfo{
    BOOL isRelease;
    const char* unityProjPath;
    const char* exportFolderParh;
    const char* developProfilePath;
    const char* publishProfilePath;
}ExportInfo;

#endif /* Defs_h */
