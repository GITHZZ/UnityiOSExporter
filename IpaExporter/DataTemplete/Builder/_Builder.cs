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
			PlayerSettings.productName = ${appName}; //"应用名字"

            //必须参数
			PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
			PlayerSettings.SetPropertyInt ("Architecture", (int)iOSTargetDevice.iPhoneAndiPad, BuildTarget.iOS);
			PlayerSettings.SetPropertyInt ("ScriptingBackend", (int)ScriptingImplementation.IL2CPP, BuildTarget.iOS);

            //获取shell脚本参数
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
				${packScene}
            };

            BuildPipeline.BuildPlayer (LEVELS, exportPath, BuildTarget.iOS, BuildOptions.Il2CPP);
		}
	}
}
