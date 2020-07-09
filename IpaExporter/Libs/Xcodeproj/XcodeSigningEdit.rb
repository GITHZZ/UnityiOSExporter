PROJECT_ROOT_PATH = File.dirname(__FILE__)
PROJECT_RESOURCE_PATH = ARGV.at(0)

#为了兼容开发机不能上网情况 只能本地化 不折腾了
$LOAD_PATH << File.join(PROJECT_ROOT_PATH, "/lib")

require "xcodeproj"
require "fileutils"
require_relative "XcodeProjectUpdater"

$xcode_proj_root_path = ARGV.at(1)
$product_name = ARGV.at(2)
$config_path = ARGV.at(3)
$xcode_proj_name = ARGV.at(5)
$custom_sdk_path = ARGV.at(6)
$is_release = ARGV.at(7)
$app_name = ARGV.at(8)

$project_folder_path = "#{$xcode_proj_root_path}/#{$xcode_proj_name}-#{$product_name}"
$project_path = "#{$project_folder_path}/Unity-iPhone-#{$product_name}.xcodeproj"

print(File::exist?($project_path))
if File::exist?($project_path) == false
	exit
end

# 方法定义
def set_build_setting(target, key, value, build_configuration_name = "All")
	target.build_configurations.each do |config|
		if build_configuration_name == "All" || build_configuration_name == config.to_s then
			build_settings = config.build_settings
			build_settings[key] = value
		end
	end 
end

# xcodeproj必须存在
$project = Xcodeproj::Project.open($project_path)

config = File.read($config_path)
@setting_hash = JSON.parse(config)
@target = $project.targets.first

#设置证书信息
bundle_identifier = @setting_hash["product_bundle_identifier"]
bundle_identifier_release = @setting_hash["product_bundle_identifier_release"]
develop_signing_identity = @setting_hash["develop_signing_identity"]

set_build_setting(@target, "PROVISIONING_PROFILE_SPECIFIER", develop_signing_identity[0], "Debug")
set_build_setting(@target, "DEVELOPMENT_TEAM", develop_signing_identity[1], "Debug")
set_build_setting(@target, "CODE_SIGN_IDENTITY[sdk=iphoneos*]", "iPhone Developer", "Debug")
set_build_setting(@target, "PRODUCT_BUNDLE_IDENTIFIER", bundle_identifier, "Debug")
set_build_setting(@target, "GCC_PREPROCESSOR_DEFINITIONS", "DEBUG=1", "Debug")
                                   
release_signing_identity = @setting_hash["release_signing_identity"]
set_build_setting(@target, "PROVISIONING_PROFILE_SPECIFIER", release_signing_identity[0], "Release")
set_build_setting(@target, "DEVELOPMENT_TEAM", release_signing_identity[1], "Release")
set_build_setting(@target, "CODE_SIGN_IDENTITY[sdk=iphoneos*]", "iPhone Distribution", "Release")
set_build_setting(@target, "PRODUCT_BUNDLE_IDENTIFIER", bundle_identifier_release, "Release")

$project.save
