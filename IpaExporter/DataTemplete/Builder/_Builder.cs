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
            //必须参数
			PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
			PlayerSettings.SetPropertyInt ("Architecture", (int)iOSTargetDevice.iPhoneAndiPad, BuildTarget.iOS);
			PlayerSettings.SetPropertyInt ("ScriptingBackend", (int)ScriptingImplementation.IL2CPP, BuildTarget.iOS);

			string[] LEVELS = new string[] 
			{		
				${packScene}
            };

            BuildPipeline.BuildPlayer (LEVELS, ${exportPath}, BuildTarget.iOS, BuildOptions.Il2CPP);
		}
	}
}
