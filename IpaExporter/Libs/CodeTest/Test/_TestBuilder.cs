using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using NUnit.Framework;

//理论上不允许修改
namespace IpaExporter
{
	public class _Builder
	{
        [Test]
		public static void BuildApp()
		{
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

            //测试传近进来参数是否正确
            Assert.AreEqual(true, args.StartsWith("{") && args.EndsWith("}"));

            //必须参数
            PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
            _CustomBuilder customBuilder = new _CustomBuilder();
            JsonData jsonObj = JsonMapper.ToObject(args);

            customBuilder.BuildApp(jsonObj, LEVELS, exportPath);
		}
	}
}
