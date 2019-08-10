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

echo "Main.sh脚本执行log"
custom_sdk_path=$2
export_path=$3 #export path
platform_name=$4
json_path=$5
unity_proj_path=$6
xcode_proj_name=$7
debug_team_id=$8
debug_provisioning_profile=$9
release_provisioning_profile=${11}
release_team_id=${10}
main_bundle_res_path=${12}
bundleIdentifier=${13}
is_release=${14}
pack_folder_path=${15}
sdk_folder_path=${16}
is_export_ipa=${17}
app_name=${18}

provisioning_profile=${debug_provisioning_profile}
team_id=${debug_team_id}
configuration="Debug"
method="development"
signingCertificate='iPhone Developer'
current_time=`date "+%Y%m%d%H%M%S"`

xcode_proj_path=${export_path}"/"${xcode_proj_name}

export_folder=${export_path}"/export"
ipa_folder_path=${export_folder}"/Unity-iPhone-"${app_name}

if [ ! -d ${export_folder} ]; then
    mkdir ${export_folder}
fi

#导出ipa目录
if [ -d ${ipa_folder_path} ]; then
    rm -r ${ipa_folder_path}
fi
mkdir ${ipa_folder_path}

if [ ${is_release} == "1" ]; then
    provisioning_profile=${release_provisioning_profile}
    team_id=${release_team_id}
    configuration="Release"
    method="app-store"
    signingCertificate='iPhone Distribution'
fi

#修改xcode工程
#替换optionsplist信息
copy_folder_path=${custom_sdk_path}"/Copy"
if [ ! -d ${copy_foler_path}]; then
    mkdir ${copy_foler_path}
fi

#修改导出配置
res_path=${main_bundle_res_path}"/Xcodeproj/ExportOptions.plist"
dst_path=${pack_folder_path}"/"${app_name}"/ExportOptions.plist"
cp -f ${res_path} ${dst_path}
sed -i '' 's/:bundleIdentifier:/'${bundleIdentifier}'/g' ${dst_path}
sed -i '' 's/:profileName:/'${provisioning_profile}'/g' ${dst_path}
sed -i '' 's/:developTeam:/'${team_id}'/g' ${dst_path}
sed -i '' 's/:method:/'${method}'/g' ${dst_path}
sed -i '' "s/:certificate:/${signingCertificate}/g" ${dst_path}

#参数从$2开始
ruby -w $1 ${custom_sdk_path} ${export_path} ${app_name} ${json_path} ${unity_proj_path} ${xcode_proj_name} ${sdk_folder_path} ${is_release}

#如果不导出ipa就中断
if [ ${is_export_ipa} != "1" ]; then
    echo "** EXPORT XCODE PROJECT SUCCESS **"
    exit 0
fi

sed -i '' 's/ProvisioningStyle = Automatic;/ProvisioningStyle = Manual;/g' ${xcode_proj_path}"/Unity-iPhone-"${app_name}".xcodeproj/project.pbxproj"

#处理scheme内容
project_scheme_path=${export_path}"/"${xcode_proj_name}"/Unity-iPhone-"${app_name}".xcodeproj/xcshareddata/xcschemes/Unity-iPhone.xcscheme"
#echo ${project_scheme_path}

#修改scheme配置
sed -i '' 's/container:Unity-iPhone.xcodeproj/container:Unity-iPhone-'${app_name}'.xcodeproj/g' ${project_scheme_path}

#生成ipa包 并备份dsym文件
#进入xcode工程目录
cd ${xcode_proj_path}

#如果是release模式 不重新生成archive 请务必在debug模式下生成一次
archive_path=${xcode_proj_path}/"bin/Unity-iPhone-"${app_name}".xcarchive"
#if [ ${is_release} != "1" -o ! -d ${archive_path} ]; then
echo "清除xcode工程信息"
xcodebuild \
    clean \
    -scheme "Unity-iPhone" \
    -configuration ${configuration} \
    -project "Unity-iPhone-"${app_name}".xcodeproj" \
    > ${ipa_folder_path}"/xcodebuild_clean_log_"${app_name}".log"

echo "生成arvhive工程"
xcodebuild \
    archive \
    -project "Unity-iPhone-"${app_name}".xcodeproj" \
    -scheme "Unity-iPhone" \
    -sdk iphoneos \
    -configuration ${configuration} \
    -archivePath ${ipa_folder_path}/Unity-iPhone-${app_name}.xcarchive \
    PROVISIONING_PROFILE_SPECIFIER=${provisioning_profile} \
    DEVELOPMENT_TEAM=${team_id} \
    -allowProvisioningUpdates \
    > ${ipa_folder_path}"/xcodebuild_archive_log_"${app_name}".log"
#fi

echo "生成ipa包"
# 将app打包成ipa
xcodebuild \
    -exportArchive \
    -archivePath ${ipa_folder_path}/Unity-iPhone-${app_name}.xcarchive \
    -exportOptionsPlist ${dst_path} \
    -exportPath ${ipa_folder_path}

#将ipa拷贝到固定目录下
dst_folder_path=${export_folder}"/ipa"
if [ ! -d ${dst_folder_path} ]; then
    mkdir ${dst_folder_path}
fi

src_path=${ipa_folder_path}"/Unity-iPhone.ipa"
dst_path=${dst_folder_path}"/"${app_name}"_"${current_time}"_"${configuration}".ipa"
cp -f ${src_path} ${dst_path}
