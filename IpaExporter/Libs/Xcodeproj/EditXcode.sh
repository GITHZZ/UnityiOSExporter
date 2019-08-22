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

ruby -w $1 ${custom_sdk_path} ${export_path} ${app_name} ${json_path} ${unity_proj_path} ${xcode_proj_name} ${sdk_folder_path} ${is_release}

echo "** EXPORT XCODE PROJECT SUCCESS **"
