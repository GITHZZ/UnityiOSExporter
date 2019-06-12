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

echo "Main.sh脚本执行log"
#echo "sdk资源文件路径:"${$2}
#echo "导出路径(xcode工程和ipa):"${$3}
#echo "配置文件路径:"${$5}

xcode_proj_name=$7
xcode_proj_root_path=$3
xcode_proj_path=${xcode_proj_root_path}"/"${xcode_proj_name}
platform_name=$4
debug_provisioning_profile=$9
debug_team_id=$8
release_provisioning_profile=${11}
release_team_id=${10}
unity_proj_path=$6
main_bundle_res_path=${12}
custom_sdk_path=$2
bundleIdentifier=${13}

#修改xcode工程
#替换optionsplist信息
res_path=${main_bundle_res_path}"/Xcodeproj/ExportOptions.plist"
dst_path=${custom_sdk_path}"/Copy/ExportOptions.plist"
cp -f ${res_path} ${dst_path}
sed -i '' 's/:bundleIdentifier:/'${bundleIdentifier}'/g' ${dst_path}
sed -i '' 's/:profileName:/'${release_provisioning_profile}'/g' ${dst_path}
sed -i '' 's/:developTeam:/'${release_team_id}'/g' ${dst_path}

#参数从$2开始
ruby -w $1 $2 $3 $4 $5 $6 $7

sed -i '' 's/ProvisioningStyle = Automatic;/ProvisioningStyle = Manual;/g' ${xcode_proj_path}"/Unity-iPhone-"${platform_name}".xcodeproj/project.pbxproj"

#处理scheme内容
project_scheme_path=${xcode_proj_root_path}"/"${xcode_proj_name}"/Unity-iPhone-"${platform_name}".xcodeproj/xcshareddata/xcschemes/Unity-iPhone.xcscheme"
#echo ${project_scheme_path}

#修改scheme配置
sed -i '' 's/container:Unity-iPhone.xcodeproj/container:Unity-iPhone-'${platform_name}'.xcodeproj/g' ${project_scheme_path}

#生成ipa包 并备份dsym文件
#进入xcode工程目录
cd ${xcode_proj_path}

echo "清除xcode工程信息"
xcodebuild \
    clean \
    -scheme "Unity-iPhone" \
    -configuration "Release" \
    -project "Unity-iPhone-"${platform_name}".xcodeproj" \
    > ${unity_proj_path}"/xcodebuild_clean_log_"${platform_name}".txt"

echo "生成arvhive工程"
xcodebuild \
    archive \
    -project "Unity-iPhone-"${platform_name}".xcodeproj" \
    -scheme "Unity-iPhone" \
    -sdk iphoneos \
    -configuration "Release" \
    -archivePath bin/Unity-iPhone-${platform_name}.xcarchive \
    PROVISIONING_PROFILE_SPECIFIER=${release_provisioning_profile} \
    DEVELOPMENT_TEAM=${release_team_id} \
    -allowProvisioningUpdates \
    > ${unity_proj_path}"/xcodebuild_archive_log_"${platform_name}".txt"

echo "生成ipa包"
# 将app打包成ipa
xcodebuild \
    -exportArchive \
    -archivePath bin/Unity-iPhone-${platform_name}.xcarchive \
    -exportOptionsPlist ${xcode_proj_path}/ExportOptions.plist \
    -exportPath "$PWD"
