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
$platform_name = ARGV.at(2)

$project_folder_path = "#{$xcode_proj_root_path}/XGPushTest"
$templete_project_path = "#{$project_folder_path}/Unity-iPhone.xcodeproj"
$project_path = "#{$project_folder_path}/Unity-iPhone-#{$platform_name}.xcodeproj"

puts "开始修改xcode工程"

if !(File::exist?($project_path))
	FileUtils.cp_r $templete_project_path, $project_path
end

$project = Xcodeproj::Project.open($project_path)

export_main = XcodeProjectUpdater.new()
export_main.start()

$project.save
