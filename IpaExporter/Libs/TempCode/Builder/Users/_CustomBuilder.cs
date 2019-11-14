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
            //具体设置是在界面中的 设置参数 按钮中 在plist中配置就ok了
            
            //自己扩展代码写在这里
            
            //打包代码 如果自己逻辑里面就带了这个方法 就可以注释
            //levels和exportPath两个参数是必须要用打包工具传入的
            BuildPipeline.BuildPlayer(levels, exportPath, BuildTarget.iOS, BuildOptions.AcceptExternalModificationsToPlayer);
            
		}
	}
}
