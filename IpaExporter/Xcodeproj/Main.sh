#$1 ruby入口文件路径
#$2 sdk资源文件路径

echo "打包信息"
echo "sdk资源文件路径:"
echo $2
echo "导出路径(xcode工程和ipa):"
echo $3

ruby -w $1 $2 $3
