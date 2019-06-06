#$1 ruby入口文件路径 0
#$2 sdk资源文件路径 1
#$3 导出路径(xcode工程和ipa) 2
#$4 平台名称 3
#$5 配置路径 4
#$6 unity工程路径

#echo "sdk资源文件路径:"${$2}
#echo "导出路径(xcode工程和ipa):"${$3}
#echo "配置文件路径:"${$5}

#--------------修改xcode工程
platformName=$4
echo "*开始打包 平台:"${platformName}
#参数从$2开始
ruby -w $1 $2 $3 $4 $5

#--------------生成ipa包 并备份dsym文件
