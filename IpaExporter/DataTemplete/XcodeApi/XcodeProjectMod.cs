using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.Collections;
using System.IO;

namespace IpaExporter
{
	public class XcodeProjectMod
	{
		private static void CopyAndReplaceDirectory(string srcPath, string dstPath)
		{
			if(Directory.Exists(dstPath))
				Directory.Delete(dstPath);

			if(File.Exists(dstPath))
				File.Delete(dstPath);

			Directory.CreateDirectory(dstPath);

			foreach(var file in Directory.GetFiles(srcPath))
				File.Copy(file, Path.Combine(dstPath, Path.GetFileName(file)));

			foreach(var dir in Directory.GetDirectories(srcPath))
				CopyAndReplaceDirectory(dir, Path.Combine(dstPath, Path.GetFileName(dir)));
		}

		[PostProcessBuild]
		public static void OnPostprocessBuild(BuildTarget buildTarget, string path)
		{
			if (buildTarget != BuildTarget.iOS)
				return;

			string projPath = PBXProject.GetPBXProjectPath(path);
			PBXProject proj = new PBXProject();

			string pbxProjStr = File.ReadAllText(projPath);
			proj.ReadFromString(pbxProjStr);
			string target = proj.TargetGuidByName(PBXProject.GetUnityTargetName());

			//add custom code
			proj.SetBuildProperty(target, "ENABLE_BITCODE", "NO");
			proj.SetBuildProperty(target, "PROVISIONING_PROFILE_SPECIFIER", "ZZSJDevelopment");
	        proj.SetBuildProperty(target, "CODE_SIGN_IDENTITY", "iPhone Developer: he zunzu (2R43QP4H5A)");
	            
	        File.WriteAllText(projPath, proj.WriteToString());
		}	
	}
}