#$1 unity工程路径
#$2 导出路径
#$3 沙盒路径

unity_project_path=$1
export_path=$2
bundle_res_path=$3

pkill Unity
cd ${unity_project_path}
#args_config=$(cat ${bundle_res_path}'/TempCode/Builder/Users/_CustomConfig.json'| sed s/[[:space:]]//g | tr -d '\n')

#生成xcode工程
/Applications/Unity/Unity.app/Contents/MacOS/Unity -runTests -projectPath ${unity_project_path} -testResults ${export_path}/xcodeproj_create_log.xml -args_${args_config} -testPlatform editmode

echo "[配置信息]Unity测试结果路径:"${export_path}
