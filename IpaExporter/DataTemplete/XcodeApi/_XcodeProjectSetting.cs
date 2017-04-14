using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Xcodeのプロジェクトを書き出す際の設定値
/// </summary>
public class XcodeProjectSetting  
{
    public enum DevelopType {
        Debug = 1,
        Release = 2,
    };

	//=================================================================================
	//定数
	//=================================================================================

	//パスを設定する際のプロジェクトのルート
	public const string PROJECT_ROOT = "$(PROJECT_DIR)/";

	//Images.xcassetsが入っているディレクトリ名
	public const string IMAGE_XCASSETS_DIRECTORY_NAME = "Unity-iPhone";

	//プロパティのkey
	public const string LINKER_FLAG_KEY            = "OTHER_LDFLAGS";
	public const string FRAMEWORK_SEARCH_PATHS_KEY = "FRAMEWORK_SEARCH_PATHS";
	public const string LIBRARY_SEARCH_PATHS_KEY   = "LIBRARY_SEARCH_PATHS";
	public const string ENABLE_BITCODE_KEY         = "ENABLE_BITCODE";
	public const string DEVELOPMENT_TEAM           = "DEVELOPMENT_TEAM";
	public const string PROVISIONING_PROFILE_SPECIFIER = "PROVISIONING_PROFILE_SPECIFIER";

    //ipa.plist路径
    public const string IPA_PLIST_PATH = ${ipaPlistPath}
	//情報を設定するplistのファイル名
	public const string INFO_PLIST_NAME = "Info.plist";
	
	//info.plistの各key
	public const string URL_TYPES_KEY      = "CFBundleURLTypes";
	public const string URL_TYPE_ROLE_KEY  = "CFBundleTypeRole";
	public const string URL_IDENTIFIER_KEY = "CFBundleURLName";
	public const string URL_SCHEMES_KEY    = "CFBundleURLSchemes";

	public const string UI_LAUNCHI_IMAGES_KEY          = "UILaunchImages";
	public const string UI_LAUNCHI_STORYBOARD_NAME_KEY = "UILaunchStoryboardName~iphone";

	public const string ATS_KEY                    = "NSAppTransportSecurity";
	public const string ALLOWS_ARBITRARY_LOADS_KEY = "NSAllowsArbitraryLoads";

	public const string APPLICATION_QUERIES_SCHEMES_KEY = "LSApplicationQueriesSchemes";

	public const string STATUS_HIDDEN_KEY         = "UIStatusBarHidden";
	public const string STATUS_BAR_APPEARANCE_KEY = "UIViewControllerBasedStatusBarAppearance";

	//=================================================================================
	//設定値
	//=================================================================================

	//Xcodeへコピーするディレクトリへのパス
    public string CopyDirectoryPath = ${cDirectoryPath};

	//URL identifier
	public string URLIdentifier = "";

	//設定する値のリスト FRAMEWORK_SEARCH_PATHS
	public List<string> URLSchemeList;

	//development info
	public struct DevelopmentInfo
	{
		public string provisioningProfileName;
		public string developmentTeam;
		public DevelopType tag;

		public DevelopmentInfo(DevelopType t, string team, string profile)
		{
			developmentTeam = team;
			provisioningProfileName = profile;
			tag = t;
		}
	}
	public List<DevelopmentInfo> developmentInfoList = new List<DevelopmentInfo>(){
		/*new DevelopmentInfo()*/
        ${developmentInfoDebug}
        ${developmentInfoRelease}
	};

	//framework
	public struct FrameworkSet{
		public string content;
		public bool weak;

		public FrameworkSet(string c, bool w)
		{
			content = c;
			weak = w;
		}
	}
	public List<FrameworkSet> FrameworkList = new List<FrameworkSet>(){
        /*new FrameworkSet("Social.framework", true)*/ //初期設定例
        ${frameworks}
    };

    //libs
	public List<string> LibsList = new List<string>(){
		//libsqlite3.0.tbd
		${libs}
	};
		
	public string[] LinkerFlagArray = new string[]{
		/*"-ObjC", "-all_load"*/ //初期設定例
		${linkerFlag}
	};

    //目前很少要改这个 就固定这样
	public string[] FrameworkSearchPathArray = new string[]{
		"$(inherited)",
		"$(PROJECT_DIR)/Frameworks"
	};

	//コンパイラフラグ
	[System.Serializable]
	public struct CompilerFlagsSet{
		public string Flags;
		public List<string> TargetPathList;

		public CompilerFlagsSet(string flags, List<string> targetPathList){
			Flags = flags;
			TargetPathList = targetPathList;
		}
	}
	public List<CompilerFlagsSet> CompilerFlagsSetList = new List<CompilerFlagsSet> () {
		/*new CompilerFlagsSet ("-fno-objc-arc", new List<string> () {
			"Plugin/Plugin.mm"
		})*/ //初期設定例
	};

	//canOpenURLで判定可能にするスキーム
	public List<string>ApplicationQueriesSchemes = new List<string>(){
        
	};

	//BitCodeを有効にするか
	public bool EnableBitCode = false;

	//ATSを有効にするか
	public bool EnableATS = false;

	//ステータスバーを有効にするか
	public bool EnableStatusBar = false;

	//デフォルトで設定されているスプラッシュ画像の設定を消すか
	public bool NeedToDeleteLaunchiImagesKey = true;

}
