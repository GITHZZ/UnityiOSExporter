PROJECT_ROOT_PATH = File.dirname(__FILE__)
PROJECT_RESOURCE_PATH = ARGV.at(0)

# SDK_FOLDER_NAME = "4399" #sdk对应的文件夹名字
# PROJECT_RESOURCE_PATH = "#{PROJECT_ROOT_PATH}/mods/SDK/#{SDK_FOLDER_NAME}"

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
$templete_project_path = "#{$project_folder_path}/Unity-iPhone.xcodeproj"
$project_path = "#{$project_folder_path}/Unity-iPhone-#{$product_name}.xcodeproj"
$base_proj_path = "#{$project_folder_path}/Unity-iPhone.xcodeproj"
$log_file_path = "#{$xcode_proj_root_path}/xcodeproj_log_#{$product_name}.log"

if !(File::exist?($log_file_path))
    File.new($log_file_path, 'w')
end

$stdout.reopen($log_file_path, "w")
$stderr.reopen($log_file_path, "w")

#存在就先删除
if File::exist?($project_path)
    FileUtils.rm_r $project_path
end
FileUtils.cp_r $templete_project_path, $project_path

$project = Xcodeproj::Project.open($project_path)
$base_project = Xcodeproj::Project.open($base_proj_path)

export_main = XcodeProjectUpdater.new()
export_main.start()

$project.save
