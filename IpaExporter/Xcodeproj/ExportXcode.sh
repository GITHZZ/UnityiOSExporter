#$1 unity工程路径

#echo "打包信息"
#echo "sdk资源文件路径:"${$2}
#echo "导出路径(xcode工程和ipa):"${$3}
#echo "配置文件路径:"${$5}

unity_project_path=$1

#--------------生成母包工程
pkill Unity
echo "*访问unity工程 目录path="${unity_project_path}
cd ${unity_project_path}

#生成xcode工程
/Applications/Unity/Unity.app/Contents/MacOS/Unity -buildTarget Ios -bacthmode -quit -projectPath ${unity_project_path} -executeMethod IpaExporter.Builder.BuildApp
echo "*导出xcode成功"
