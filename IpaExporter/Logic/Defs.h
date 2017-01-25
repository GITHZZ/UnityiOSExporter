//
//  Defs.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/10.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef Defs_h
#define Defs_h

#define DATA_PATH @"/DataTemplete"
#define BUILDER_CS_PATH @"/Assets/Editor/DataTemplete/Builder/Builder.cs"
#define XCODEPROJECT_CS_PATH @"/Assets/Editor/DataTemplete/XcodeApi/XcodeProjectSetting.cs"

typedef struct IpaPackInfo
{
    const char* bundleIdentifier;
    const char* appName;//应用名字
    const char* frameworks;//自带框架名字
    const char* outputPath;//导出路径
    const char* codesignidentity;//开发者账号名字
}IpaPackInfo;

//绑定到界面的数据(包界面)
typedef struct DetailsInfo
{
    const char* appName;//应用名字
    const char* appID;//id
    const char* codeSignIdentity;
    const char* provisioningProfile;
}DetailsInfo;

typedef struct ExportInfo
{
    BOOL isRelease;
    const char* unityProjPath;
    const char* exportFolderParh;
    const char* developProfilePath;
    const char* publishProfilePath;
}ExportInfo;

#endif /* Defs_h */
