using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class Builder_t
{
	static string[] LEVELS = new string[] {
		"Assets/LuaFramework/Scenes/main.unity"
	};

	static void BuildApp()
	{
        PlayerSettings.bundleIdentifier = ${bundleIdentifier}; //"com.4399sy.zzsj.online"
		PlayerSettings.productName = ${productName}; //"测试项目"
		PlayerSettings.strippingLevel = StrippingLevel.Disabled;

		PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
		PlayerSettings.iOS.targetOSVersion = iOSTargetOSVersion.iOS_8_0;
		PlayerSettings.iOS.scriptCallOptimization = ScriptCallOptimizationLevel.SlowAndSafe;

		PlayerSettings.SetPropertyInt ("Architecture", (int)iOSTargetDevice.iPhoneAndiPad, BuildTarget.iOS);
		PlayerSettings.SetPropertyInt ("ScriptingBackend", (int)ScriptingImplementation.IL2CPP, BuildTarget.iOS);

		BuildPipeline.BuildPlayer (LEVELS, "iOSExport/ExportProj_", BuildTarget.iOS, BuildOptions.Il2CPP);
	}
}
