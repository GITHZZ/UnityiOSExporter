using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using NUnit.Framework;

namespace IpaExporter
{
	public class _CustomBuilder
	{
		//args 从配置传过来的参数
        public void BuildApp(JsonData args, string[] levels, string exportPath)
		{
        	//自定义扩展代码都写在这里
            //参数获取参考 int t = (int)args["isTest"]
            
            //自己扩展代码写在这里
            
            //打包代码 不能修改
            BuildPipeline.BuildPlayer(levels, exportPath, BuildTarget.iOS, BuildOptions.AcceptExternalModificationsToPlayer);
            
		}
	}
}
