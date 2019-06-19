using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

namespace IpaExporter
{
	public class CustomBuilder
	{
		//args 从配置传过来的参数
		public void BuildApp(JsonData args)
		{
        	//自定义扩展代码都写在这里
            //参数获取参考 int t = (int)args["isTest"]
		}
	}
}
