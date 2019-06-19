using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

//理论上不允许修改
namespace IpaExporter
{
	public class Builder
	{
		static void BuildApp()
		{
            string[] LEVELS = new string[]
            {
                ${packScene}
            };

			//获取shell脚本参数
			string args = "";
			string[] strs = System.Environment.GetCommandLineArgs(); 
			foreach(var s in strs)
			{
				if(s.Contains("-args"))
				{
                    //参数必须是json格式
					args = s.Split('_')[1];
				}
			}
            //必须参数
			PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;

            CustomBuilder customBuilder = new CustomBuilder();
            JsonData jsonObj = JsonMapper.ToObject(args);
            customBuilder.BuildBefore(jsonObj);
            BuildPipeline.BuildPlayer (LEVELS, ${exportPath}, BuildTarget.iOS, BuildOptions.None);
            customBuilder.BuildFinish(jsonObj);
		}
	}
}
