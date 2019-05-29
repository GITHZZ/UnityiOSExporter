# ios打包脚本
# ios打包工具主逻辑,用于导出ipa文件"
# author = "hezunzu"

CMD_EXPORT_XCODE = "/Applications/Unity/Unity.app/Contents/MacOS/Unity -buildTarget Ios -batchmode -quit -projectPath %s -executeMethod %s"
CMD_CLEAN_XCODE_PROJ = "xcodebuild clean -scheme %s -configuration %s"
CMD_EXPORT_ARCHIVE = "xcodebuild -project %s.xcodeproj -scheme %s -destination generic/platform=ios archive -archivePath bin/%s.xcarchive -configuration %s"
CMD_EXPORT_IPA = "xcodebuild -exportArchive -archivePath %s -exportPath %s/%s -exportOptionsPlist %s"

# setup pbxproj file
# %s:export project path
CMD_SET_PBXPROJ = "sed -i '' 's/ProvisioningStyle = Automatic;/ProvisioningStyle = Manual;/g' \"%s\""

class IpaExporter
	def initialize()
		
	end

	def start()

	end 
end