//
//  Defs.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/10/10.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef Defs_h
#define Defs_h

#import <Foundation/Foundation.h>
#import "EventManager.h"

#define DATA_PATH @"/DataTemplete"
#define BUILDER_CS_PATH @"/Assets/Editor/DataTemplete/Builder/Builder.cs"
#define XCODEPROJECT_CS_PATH @"/Assets/Editor/DataTemplete/XcodeApi/XcodeProjectSetting.cs"

//view main key
#define Export_Path @"exportPath"

//detail view key
#define Platform_Name @"platform"
#define App_Name_Key @"appName"
#define App_ID_Key @"bundleIdentifier"
#define Code_Sign_Identity_Key @"codeSignIdentity"
#define Provisioning_Profile_key @"provisioningProfile"
#define Frameworks_Key @"frameworks"
#define libs_Key @"libs"
#define Libker_Flag @"libkerFlag"
#define Copy_Dir_Path @"copyDirectoryPath"
#define Is_Selected @"isSelected"
#define Development_Info @"developmentInfo"

typedef struct
{
    const char* unityProjPath;
    const char* exportFolderParh;
}ExportInfo;

#endif /* Defs_h */
