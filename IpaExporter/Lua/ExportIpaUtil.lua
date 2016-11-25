local ExportIpaUtil = {
	name = "ios打包脚本",
	description = "ios打包工具主逻辑,用于导出ipa文件",
	author = "hezunzu",	
}

--enum
local ENUM_PROFILE_TYPE = {
    develop = 1,
    publish = 2,
}

--local var
local proj_scheme_name = "Unity-iPhone"

--Command
local cmd_export_xcode = "/Applications/Unity/Unity.app/Contents/MacOS/Unity -buildTarget Ios -batchmode -quit -projectPath %s -executeMethod %s -logFile %s"
local cmd_clean_xcode_proj = "xcodebuild clean -scheme %s"
local cmd_export_archive = "xcodebuild -project %s.xcodeproj -scheme %s -destination generic/platform=ios archive -archivePath bin/%s.xcarchive"
---sdk iphoneos build PROVISIONING_PROFILE=%s
local cmd_export_ipa = "xcodebuild -exportArchive -exportFormat ipa exportProvisioningProfile %s -archivePath %s -exportPath %s/%s.ipa"

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

local function GetProfileNameFormPath(path)
    
end

local function StartExportIpa()

end

--导出ipa包入口
--projPath:需要导出Unity工程路径
--exportFolder:需要导出包的工程目录路径
--exportType:导出包的类型
--ipaName:导出包名字
--profilePath:开发或发布证书路径
ExportIpaUtil.Start = function(exportInfoTbl)
    local startTime = os.time()

    --base
    local projPath = exportInfoTbl.projectPath
    local exportFolder = exportInfoTbl.exportPath
    local exportType = exportInfoTbl.exportType
    local ipaName = exportInfoTbl.ipaName
    local profilePath = "ZZSJDevelopment" --exportInfoTbl.exportPath

    local exportIpaName = ipaName .. os.date("%y%m%d_%H%M%S")
    local profileName = GetProfileNameFormPath(profilePath)
    local archivePath = string.format("bin/%s.xcarchive", proj_scheme_name)
    local xcodePath = exportFolder .. "/ExportProj_"

    --info log
    printLine()
    print("\tiOS打包工具")
    print("\tUnity开发工程路径:" .. projPath)
    print("\tXcode项目导出路径:" .. exportFolder)
    print("\t证书类型:" .. exportType)
    print("\t导出包名字:" .. exportIpaName)
    printLine()

    --导出xcode工程
    print("++++正在导出Xcode工程...")
    os.execute(string.format(cmd_export_xcode, projPath, "IpaExporter.Builder_t.BuildApp", exportFolder))
    print("++++导出Xcode工程完毕...")

    --访问Xcode工程
    printLine()
    print("++++访问Xcode工程, 访问路径:" .. xcodePath)
    local isSuccess, err = lfs.chdir(xcodePath)
    if not isSuccess and err then
        print("++++访问Xcode工程失败, 错误信息:" .. err)
        os.exit(1)
    end

    --清除Xcode工程
    print("++++开始清除Xcode项目信息")
    os.execute(string.format(cmd_clean_xcode_proj, proj_scheme_name))
    print("++++清除项目成功")

    --创建archive文件
    print("++++开始创建archive文件")
    os.execute(string.format(cmd_export_archive, proj_scheme_name, proj_scheme_name, proj_scheme_name))

    --查找生成的archive文件
    if(fileExist(archivePath)) then
        print("++++创建archive文件成功,路径path=" .. archivePath)
    else
        print("++++创建archive文件失败")
        os.exit(1)
    end

    --开始生成ipa包
    print("++++开始生成ipa包")
    os.execute(string.format(cmd_export_ipa, profilePath, archivePath, exportFolder, exportIpaName))
    print("++++生成ipa结束,路径:" .. exportFolder)
 
    --计算生成时间
    local endTime = os.time()
    local pastTime = endTime - startTime
     
    print(string.format("++++导出ipa结束,总共耗时:%s分%s秒", math.fmod(math.floor(pastTime/60), 60), math.fmod(pastTime, 60)))
end

return ExportIpaUtil
