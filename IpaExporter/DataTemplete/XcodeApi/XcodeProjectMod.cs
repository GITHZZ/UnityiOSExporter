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
public class XcodeProjectUpdater : MonoBehaviour {

	//設定データのパス
	private const string SETTING_DATA_PATH = "XcodeProjectSetting";

	//ビルド後に呼ばれる
	[PostProcessBuild]
	private static void OnPostprocessBuild(BuildTarget buildTarget, string buildPath){

		//iOS以外にビルドしている場合は更新処理を行わないように
		if (buildTarget != BuildTarget.iOS){
			return;
		}

		//Xcodeの設定データを読み込む
		XcodeProjectSetting setting = Resources.Load<XcodeProjectSetting>(SETTING_DATA_PATH);
		if(setting == null){
			Debug.Log ("Resources/" + SETTING_DATA_PATH + "不存在,请查看文件是否建立");
			//Debug.Log ("Resources/" + SETTING_DATA_PATH + "がありません！");
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

}
