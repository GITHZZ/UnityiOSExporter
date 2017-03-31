local ExportIpaUtil = {
    name = "ios打包脚本",
    description = "ios打包工具主逻辑,用于导出ipa文件",
    author = "hezunzu", 
}

local lfs = require("lfs")
local PWD = lfs.currentdir()

--#############################需要个人配置部分###################################
--unity开发路径
local unity_project_path = PWD
--导出目录路径
local export_folder_path = PWD .. "/build"
--xcode项目名称
local xcode_proj_name = "_ExportProj"
--导出包名称
local app_name = "NoName"
--导出ipa的Xcode项目路径
local export_project_path = "";

local build_config = "Debug" --"Debug"
--############################################################################

--log文件
local log_file_path = export_folder_path .. "/export.log"

local proj_scheme_name = "Unity-iPhone"

--Command
local cmd_export_xcode = "/Applications/Unity/Unity.app/Contents/MacOS/Unity -buildTarget Ios -batchmode -quit -projectPath %s -executeMethod %s"
local cmd_clean_xcode_proj = "xcodebuild clean -scheme %s -configuration %s"
local cmd_export_archive = "xcodebuild -project %s.xcodeproj -scheme %s -destination generic/platform=ios archive -archivePath bin/%s.xcarchive -configuration %s"
--sdk iphoneos build PROVISIONING_PROFILE=%s
local cmd_export_ipa = "xcodebuild -exportArchive -exportFormat ipa -archivePath %s -exportPath %s/%s.ipa"

--setup pbxproj file
--%s export project path
local cmd_set_pbxproj = "sed -i '' 's/ProvisioningStyle = Automatic;/ProvisioningStyle = Manual;/g' \"%s\""

--local function
local function printTip(content)
    print(string.char(0x1b) .. "[30;47;1;7m" .. "**" .. os.date("%Y-%m-%d %H:%M:%S") .. content .. string.char(0x1b) .. "[0m")
end

local function printLine()
    print("------------------------------------------------------------------------------")
end

local function fileExist(path)
    local file = io.open(path, "rb")
    if file then file:close() return true end
    return false
end

--导出ipa包入口
--projPath:需要导出Unity工程路径
--exportFolder:需要导出包的工程目录路径
--exportType:导出包的类型
--ipaName:导出包名字
--profilePath:开发或发布证书路径
ExportIpaUtil.Start = function()
    local startTime = os.time()

    local exportIpaName = app_name .. "_"  .. os.date("%y%m%d_%H%M%S")
    local archivePath = string.format("bin/%s.xcarchive", proj_scheme_name)
    local pbxprojPath = export_project_path .. "/Unity-iPhone.xcodeproj/project.pbxproj"

--需要调用C#的静态方法
--[[
    PS:如果需要传参数参考也有 但是在C#上取代码如下
    string[] strs = System.Environment.GetCommandLineArgs();
    if(s.Contains("-args")){
        string arg = s.Split(':')[1];
        //处理参数//
    }
]]
    local export_func = string.format("IpaExporter.Builder.BuildApp -args:%s", export_project_path)

    --info log
    printLine()
    print("iOS打包信息")
    print("Unity开发工程路径:" .. unity_project_path)
    print("Xcode项目导出路径:" .. export_project_path)
    print("证书类型:" .. build_config)
    print("导出包名字:" .. app_name)
    printLine()

    --导出xcode工程
    print("正在导出Xcode工程...")
    os.execute(string.format(cmd_export_xcode, unity_project_path, export_func, log_file_path))
    print("导出Xcode工程完毕...")

    --处理xcode工程中的pbxproj文件(兼容xcode8)
    print("开始处理pbxproj文件:" .. pbxprojPath)
    os.execute(string.format(cmd_set_pbxproj, pbxprojPath))

    --访问Xcode工程
    printLine()
    print("访问Xcode工程, 访问路径:" .. export_project_path)
    local isSuccess, err = lfs.chdir(export_project_path)
    if not isSuccess and err then
        print("访问Xcode工程失败, 错误信息:" .. err)
        return 0
    end

    --清除Xcode工程
    print("开始清除Xcode项目信息")
    os.execute(string.format(cmd_clean_xcode_proj, proj_scheme_name, build_config))
    print("清除项目成功")

    --创建archive文件
    print("开始创建archive文件")
    os.execute(string.format(cmd_export_archive, proj_scheme_name, proj_scheme_name, proj_scheme_name, build_config))

    --查找生成的archive文件
    if(fileExist(archivePath)) then
        print("创建archive文件成功,路径path=" .. archivePath)
    else
        print("创建archive文件失败")
        return 0
    end

    --开始生成ipa包
    print("开始生成ipa包")
    os.execute(string.format(cmd_export_ipa, archivePath, export_folder_path, exportIpaName))
    print("生成ipa结束,路径:" .. export_folder_path .. "/" .. exportIpaName)
 
    --计算生成时间
    local endTime = os.time()
    local pastTime = endTime - startTime

    print(string.format("导出ipa结束,总共耗时:%s分%s秒", math.fmod(math.floor(pastTime/60), 60), math.fmod(pastTime, 60)))

    return 1;
end

function ExportMain(projPath, exportFolder, appName, buildConfig)
    --set up export info
    unity_project_path = projPath
    export_folder_path = exportFolder
    app_name = appName
    
    if buildConfig == 1 then
        build_config = "Release"
    else
        build_config = "Debug"
    end
    
    --关闭unity
    os.execute("pkill Unity")
    
    export_project_path = export_folder_path .. "/" .. xcode_proj_name
    --start export
    if ExportIpaUtil.Start() == 0 then
        print("导出ipa失败")
        return 0
    end
    
    return 1
end

