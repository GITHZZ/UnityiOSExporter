//  XcodeProjectUpdater.cs
//  ProductName Test
//
//  Created by kikuchikan on 2015.07.29.

using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.Collections;
using System.Collections.Generic;
using System.IO;

/// <summary>
/// Xcodeのプロジェクトを書き出す際に諸々の設定を自動で行うクラス
/// </summary>
public class XcodeProjectMod : MonoBehaviour
{
	//ビルド後に呼ばれる
	[PostProcessBuild]
	private static void OnPostprocessBuild(BuildTarget buildTarget, string buildPath)
    {
		//iOS以外にビルドしている場合は更新処理を行わないように
		if (buildTarget != BuildTarget.iOS){
			return;
		}

		//Xcodeプロジェクトの読み込み
		string pbxProjPath = PBXProject.GetPBXProjectPath(buildPath);
		PBXProject pbxProject = new PBXProject();
		pbxProject.ReadFromString(File.ReadAllText(pbxProjPath));

		//ターゲットのID取得
		string targetGuid = pbxProject.TargetGuidByName(PBXProject.GetUnityTargetName());

		//根据设置路径先拷贝文件夹下的所有文件并在XcodeBuild中设置
		//指定ディレクトリ内のファイルを全てコピーする
		if(!string.IsNullOrEmpty(setting.CopyDirectoryPath)){
			DirectoryProcessor.CopyAndAddBuildToXcode (pbxProject, targetGuid, setting.CopyDirectoryPath, buildPath, "");
		}

		//设置文件 CompilerFlags 属性
		//设置其它属性 URL Identifier以下的配置
		//コンパイラフラグの設定
		foreach (XcodeProjectSetting.CompilerFlagsSet compilerFlagsSet in setting.CompilerFlagsSetList) 
		{
			foreach (string targetPath in compilerFlagsSet.TargetPathList) {
				if(!pbxProject.ContainsFileByProjectPath(targetPath)){
					Debug.Log (targetPath + "が無いのでコンパイラフラグが設定できませんでした");
					continue;
				}

				string fileGuid        = pbxProject.FindFileGuidByProjectPath(targetPath);
				List<string> flagsList = pbxProject.GetCompileFlagsForFile(targetGuid, fileGuid);

				flagsList.Add(compilerFlagsSet.Flags);
				pbxProject.SetCompileFlagsForFile(targetGuid, fileGuid, flagsList);
			}

		}

		//システムのフレームワークを追加
		foreach (XcodeProjectSetting.FrameworkSet framework in setting.FrameworkList) {
			pbxProject.AddFrameworkToProject(targetGuid, framework.content, framework.weak);
		}

		//add tbd file
		//发现在Xcode8以下使用这个会有bug 请务必升级到最新版本
		foreach (string tbdName in setting.LibsList) {
			pbxProject.AddFileToBuild (targetGuid, pbxProject.AddFile (
				"usr/lib/" + tbdName, 
				"Frameworks/" + tbdName, 
				PBXSourceTree.Sdk)
			);
		}

		//Linker Flagの設定
		pbxProject.UpdateBuildProperty(targetGuid, XcodeProjectSetting.LINKER_FLAG_KEY, setting.LinkerFlagArray, null);

		//フレームワークがあるディレクトリへのパス設定
		pbxProject.UpdateBuildProperty(targetGuid, XcodeProjectSetting.FRAMEWORK_SEARCH_PATHS_KEY, setting.FrameworkSearchPathArray, null);

		//BitCodeの設定
		pbxProject.SetBuildProperty(targetGuid, XcodeProjectSetting.ENABLE_BITCODE_KEY, setting.EnableBitCode ? "YES" : "NO");

		//如果用到脚本工具打包并且需要兼容xcode8 这块代码需要用上
		//并且脚本代码需要将自动模式改成手动模式
		//sed指令:sed -i '' 's/ProvisioningStyle = Automatic;ProvisioningStyle = Manual;/g'%s
		//SetUpDevelopmentInfo (pbxProject, setting, targetGuid);
		
		//プロジェクトファイル書き出し
		File.WriteAllText(pbxProjPath, pbxProject.WriteToString());

		//URLスキームの設定
		List<string> urlSchemeList = new List<string>(setting.URLSchemeList);
		InfoPlistProcessor.SetURLSchemes (buildPath, setting.URLIdentifier, urlSchemeList);

		//デフォルトで設定されているスプラッシュ画像の設定を消す
		if(setting.NeedToDeleteLaunchiImagesKey){
			InfoPlistProcessor.DeleteLaunchiImagesKey (buildPath);
		}

		//ATSの設定
		InfoPlistProcessor.SetATS (buildPath, setting.EnableATS);

		//ステータスバーの設定
		InfoPlistProcessor.SetStatusBar (buildPath, setting.EnableStatusBar);

	}

	private static void SetUpDevelopmentInfo(PBXProject pbxProject, XcodeProjectSetting setting, string targetGuid)
	{
		string debugConfig = pbxProject.BuildConfigByName (targetGuid, "Debug");
		string releaseConfig = pbxProject.BuildConfigByName (targetGuid, "Release");

		foreach (XcodeProjectSetting.DevelopmentInfo info in setting.developmentInfoList) {
			if (info.tag == DevelopType.Debug) {
				pbxProject.SetBuildPropertyForConfig (debugConfig, XcodeProjectSetting.PROVISIONING_PROFILE_SPECIFIER, info.provisioningProfileName);
				pbxProject.SetBuildPropertyForConfig (debugConfig, XcodeProjectSetting.DEVELOPMENT_TEAM, info.developmentTeam);
				pbxProject.SetBuildPropertyForConfig (debugConfig, "CODE_SIGN_IDENTITY[sdk=iphoneos*]", "iPhone Developer");
			} else {
				pbxProject.SetBuildPropertyForConfig (releaseConfig, XcodeProjectSetting.PROVISIONING_PROFILE_SPECIFIER, info.provisioningProfileName);
				pbxProject.SetBuildPropertyForConfig (releaseConfig, XcodeProjectSetting.DEVELOPMENT_TEAM, info.developmentTeam);
				pbxProject.SetBuildPropertyForConfig (releaseConfig, "CODE_SIGN_IDENTITY[sdk=iphoneos*]", "iPhone Distribution");
			
			}
		}
	}

}
