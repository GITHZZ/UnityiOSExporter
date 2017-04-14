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
#define IPA_PLIST_PATH @"/Assets/Editor/DataTemplete/IPA.plist"
#define BUILDER_CS_PATH @"/Assets/Editor/DataTemplete/Builder/_Builder.cs"
#define XCODEPROJECT_CS_PATH @"/Assets/Editor/DataTemplete/XcodeApi/_XcodeProjectSetting.cs"

//view main key
#define Export_Path @"exportPath"

//detail view key
#define Platform_Name            @"platform"
#define App_Name_Key             @"appName"
#define App_ID_Key               @"bundleIdentifier"
#define Code_Sign_Identity_Key   @"codeSignIdentity"
#define Provisioning_Profile_key @"provisioningProfile"
#define Linker_Flag              @"linkerFlag"
#define Copy_Dir_Path            @"cDirectoryPath"
#define Is_Selected              @"isSelected"
#define Debug_Profile_Name       @"debugProfileName"
#define Debug_Develop_Team       @"debugDevelopTeam"
#define Release_Profile_Name     @"releaseProfileName"
#define Release_Develop_Team     @"releaseDevelopTeam"
#define Frameworks               @"frameworks"
#define Framework_Names          @"frameworkNames"
#define Framework_IsWeaks        @"frameworkIsWeaks"
#define Libs                     @"libs"
#define Lib_Names                @"libNames"
#define Lib_IsWeaks              @"libIsWeaks"
#define Pack_Scene               @"packScene"
#define Export_Config_Path           @"ipaPlistPath"

#define s_true  @"1"
#define s_false @"0"

typedef struct
{
    const char* unityProjPath;
    const char* exportFolderParh;
    int isRelease;
}ExportInfo;

#endif /* Defs_h */
