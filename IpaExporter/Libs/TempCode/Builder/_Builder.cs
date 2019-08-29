using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

namespace IpaExporter
{
	public class _Builder
	{
		static void BuildApp()
		{
//理论上不允许修改------------
            string[] LEVELS = new string[]
            {
                ${packScene}
            };
            
            string exportPath = ${exportPath};
            
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
            _CustomBuilder customBuilder = new _CustomBuilder();
            JsonData jsonObj = JsonMapper.ToObject(args);
//理论上不允许修改------------

            bool isPack = customBuilder.BuildApp(jsonObj);
            if(ispack)
                BuildPipeline.BuildPlayer(LEVELS, exportPath, BuildTarget.iOS, BuildOptions.AcceptExternalModificationsToPlayer);
		}
	}
}
