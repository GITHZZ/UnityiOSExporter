#$1 ruby入口文件路径 0
#$2 sdk资源文件路径 1
#$3 导出路径(xcode工程和ipa) 2
#$4 平台名称 3
#$5 配置路径 4
#$6 unity工程路径
#$7 xcode工程名称 目前固定xcodeProj
#$8 开发者teamid（debug）
#$9 开发者签名文件名字（debug）
#$10 开发者teamid（release）
#$11 开发者签名文件名字（release）
#$12 沙盒文件路径
#$13 bundleIdentifier
#$14 是否release包
#$15 缓存文件位置
#$16 需要关联的sdk文件夹
#$17 是否导出ipa
#$18 应用名字

#测试自定义脚本获取简单的json参数
#bundle_res_path=${12}
#isTest=$(cat ${bundle_res_path}'/TempCode/Builder/Users/_CustomConfig.json'| awk -F: '/isVest/{print $2}' | sed 's/,//g')

#运行自定义脚本命令
#project_path=$6
#python $6"/test.py" $1 $2

echo "CUSTOM_RUN_SUCCESS" #标示为成功 不是会被中断
