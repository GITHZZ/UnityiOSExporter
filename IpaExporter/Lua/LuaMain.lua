local ExportIpaUtil = dofile("/Users/apple/Documents/Xcode Project/IpaExporter/IpaExporter/Lua/ExportIpaUtil.lua")

function MainStart(unityPath, exportFolder, profilePath, isRelease)
    if unityPath == "" or exportFolder == "" then -- or profilePath == ""
        print("路径参数不能为空.")
        print("unityPath:" .. unityPath)
        print("exportFolder:" .. exportFolder)
        print("profilePath:" .. profilePath)
        return
    end
    
    local exportInfo = {
        projectPath = unityPath,
        exportPath = exportFolder,
        profile = profilePath,
        exportType = 0,
        ipaName = "test",
    }
    
    ExportIpaUtil.Start(exportInfo)
end
