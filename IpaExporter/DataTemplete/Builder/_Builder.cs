using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

namespace IpaExporter
{
	public class Builder
	{
		static void BuildApp()
		{
	        PlayerSettings.bundleIdentifier = ${bundleIdentifier}; //"com.4399sy.zzsj.online"
			PlayerSettings.productName = ${appName}; //"测试项目"
			PlayerSettings.strippingLevel = StrippingLevel.Disabled;

			PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
			PlayerSettings.iOS.targetOSVersion = iOSTargetOSVersion.iOS_8_0;
			PlayerSettings.iOS.scriptCallOptimization = ScriptCallOptimizationLevel.SlowAndSafe;

			PlayerSettings.SetPropertyInt ("Architecture", (int)iOSTargetDevice.iPhoneAndiPad, BuildTarget.iOS);
			PlayerSettings.SetPropertyInt ("ScriptingBackend", (int)ScriptingImplementation.IL2CPP, BuildTarget.iOS);

			string exportPath = "";
			string[] strs =  System.Environment.GetCommandLineArgs(); 
			foreach(var s in strs)
			{
				if(s.Contains("-args"))
				{
					string arg = s.Split(':')[1];
					exportPath = arg;
				}
			}

			string[] LEVELS = new string[] 
			{		
				//${packScene}
            	"Assets/DemoScene.unity"
			};

            BuildPipeline.BuildPlayer (LEVELS, exportPath, BuildTarget.iOS, BuildOptions.Il2CPP);
		}
	}
}
