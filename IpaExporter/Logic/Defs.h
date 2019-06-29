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
#import "Common.h"

#define XCODE_PROJ_NAME @"xcodeProj"
#define PACK_FOLDER_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Packer"]
#define DATA_PATH @"/TempCode"
#define CODETEST_PATH @"/CodeTest/Test"

//view main key
#define Export_Path @"exportPath"

//detail view key
#define Platform_Name            @"platform"
#define App_Name_Key             @"appName"
#define App_ID_Key               @"bundleIdentifier"
#define Code_Sign_Identity_Key   @"codeSignIdentity"
#define Provisioning_Profile_key @"provisioningProfile"
#define Linker_Flag              @"linkerFlag"
#define Embed_Framework          @"embedFramework"
#define Copy_Dir_Path            @"customSDKPath"
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
#define Export_Config_Path       @"ipaPlistPath"

#define s_true  @"1"
#define s_false @"0"

typedef struct
{
    const char* unityProjPath;
    const char* exportFolderParh;
    int isRelease;
    int isExportXcode;
}ExportInfo;

typedef NS_ENUM(EventType, CustomEventType){
    
    EventViewMainLoaded          = 200,
    EventViewSureClicked         = 201,
    EventUnityPathSelect         = 202,
    EventUnityPathSelectEnd      = 203,
    EventExportPathSelectEnd     = 204,
    EventDevelopProfileSelectEnd = 205,
    EventDetailsInfoSettingClose = 206,
    EventDetailsInfoAdd          = 207,
    EventDetailsInfoRemove       = 208,
    EventDetailsInfoUpdate       = 209,
    EventSelectCopyDirPath       = 210,
    EventDetailsInfoSettingEdit  = 213,
    EventSetExportButtonState    = 214,
    EventScenePathSelectEnd      = 215,
    EventStartRecordTime         = 216,
    EventStopRecordTime          = 217,
};

#endif /* Defs_h */
