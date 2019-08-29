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
        public bool BuildApp(JsonData args)
		{
        	//自定义扩展代码都写在这里
            //参数获取参考 int t = (int)args["isTest"]
            return true;
		}
	}
}
