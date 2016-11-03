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
#define BUILDER_CS_PATH @"/Assets/Editor/Data_t/Templete_t/Builder_t.cs"
#define XCODEPROJECT_CS_PATH @"/Assets/Editor/Data_t/XcodeApi_t/XcodeProjectMod_t.cs"

typedef struct IpaPackInfo
{
    const char* bundleIdentifier;
    const char* appName;//应用名字
    const char* frameworks;//自带框架名字
    const char* outputPath;//导出路径
    const char* codesignidentity;//开发者账号名字
}IpaPackInfo;

typedef struct ExportInfo{
    BOOL isRelease;
    const char* unityProjPath;
    const char* exportFolderParh;
    const char* developProfilePath;
    const char* publishProfilePath;
}ExportInfo;

typedef struct DetailsInfo{
    const char* appID;
    const char* codeSignIdentity;
    const char* provisioningProfile;
}DetailsInfo;

#endif /* Defs_h */
