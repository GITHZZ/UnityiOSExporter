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

#define SETTING_FOLDER [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/IpaExporter"]
#define PLIST_PATH [SETTING_FOLDER stringByAppendingFormat:@"/%@.plist", [[NSBundle mainBundle] bundleIdentifier]]

#define XCODE_PROJ_NAME @"xcodeProj"
#define LIB_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Libs"]
#define PACK_FOLDER_PATH [LIB_PATH stringByAppendingString:@"/Packer"]
#define DATA_PATH @"/TempCode"
#define CODETEST_PATH @"/CodeTest/Test"

//view main key
#define Export_Path @"exportPath"

//detail view key
#define Defs_Platform_Name            @"platform"
#define Defs_App_Name_Key             @"appName"
#define Defs_App_ID_Key               @"bundleIdentifier"
#define Defs_Code_Sign_Identity_Key   @"codeSignIdentity"
#define Defs_Provisioning_Profile_key @"provisioningProfile"
#define Defs_Linker_Flag              @"linkerFlag"
#define Defs_Embed_Framework          @"embedFramework"
#define Defs_Copy_Dir_Path            @"customSDKPath"
#define Defs_Is_Selected              @"isSelected"
#define Defs_Debug_Profile_Name       @"debugProfileName"
#define Defs_Debug_Develop_Team       @"debugDevelopTeam"
#define Defs_Release_Profile_Name     @"releaseProfileName"
#define Defs_Release_Develop_Team     @"releaseDevelopTeam"
#define Defs_Frameworks               @"frameworks"
#define Defs_Framework_Names          @"frameworkNames"
#define Defs_Framework_IsWeaks        @"frameworkIsWeaks"
#define Defs_Libs                     @"libs"
#define Defs_Lib_Names                @"libNames"
#define Defs_Lib_IsWeaks              @"libIsWeaks"
#define Defs_Pack_Scene               @"packScene"
#define Defs_Export_Config_Path       @"ipaPlistPath"
#define Defs_Custom_Sdk_Child         @"customSDKChild"

#define s_true  @"1"
#define s_false @"0"

typedef struct
{
    const char* unityProjPath;
    const char* exportFolderParh;
    int isRelease;
    int isExportXcode;
    int isExportIpa;
}ExportInfo;

typedef NS_ENUM(EventType, CustomEventType)
{
    EventGeneralViewLoaded       = 200,
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
    EventSettingFileSelect       = 218,
    EventSetViewMainTab          = 219,
    EventOnMenuSelect            = 220,
    EventExportXcodeCilcked      = 221,
    EventExportIpaChilcked       = 222,
    EventViewWillAppear           = 223,
    EventViewDidDisappear        = 224,
    EventShowSubView             = 225,
    EventHideSubView             = 226,
    EventSelectSceneClicked      = 227,
};

#endif /* Defs_h */
