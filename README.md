## iOS打包工具(IpaExporter) 
### 一.功能简述
#### 主体界面如下,按编号进行逐一解释:
![示例图1](https://github.com/GITHZZ/UnityiOSExporter/blob/master/Doc/doc1.png)
##### 1、Unity工程路径和导出路径
* 工程路径必须选择，否则会无法选择场景等文件，打包会受到影响
* 导出路径，此路径是导出xcode工程和日志文件，注意该路径也是必须选择，否则会导出xcode工程出错。 

##### 2、需要打包平台，该平台列表是根据另一个界面配置显示，如下图:
![示例图1](https://github.com/GITHZZ/UnityiOSExporter/blob/master/Doc/doc2.png)
同样依据编号解释每块功能:
* **1.platformName - 平台名字 该名字用户自定义，用户区分平台。**
* **2.AppName - 应用名字 该名字由用户定义，用于定义包名。**
* **3.Bundle Identifier - 唯一标识符，苹果证书里面的bundleid，该名字直接读取证书获取，在具体配置界面可以填写，后面具体解析。**
* **4.添加新平台信息，会跳到配置界面。**
* **5.删除平台信息，依据用户选择当前行删除。**
* **6.依据用户选择当前行选择进行信息编辑。**

平台具体信息编辑界面如下:   

![857e346ff936adba912b740bd32a11ad.png](https://github.com/GITHZZ/UnityiOSExporter/blob/master/Doc/doc3.png)
![27a276bd1f39c67f5061d902876ca971.png](https://github.com/GITHZZ/UnityiOSExporter/blob/master/Doc/doc4.png)
![1353e16520e015483e7b58c25e0e8b8f.png](https://github.com/GITHZZ/UnityiOSExporter/blob/master/Doc/doc5.png)
![71484fb0fef124f023e183f6fa00c7f9.png](https://github.com/GITHZZ/UnityiOSExporter/blob/master/Doc/doc6.png)  
自上而下的进行参数解析:
* platformName - 平台名字 该名字用户自定义，用户区分平台
* AppName - 应用名字 该名字由用户定义，用于定义包名。
* 证书信息选择 - 选择provisionProfile文件,工具会把相关信息解析出来。（后续会具体解析这块）
* Copy Directory Root Path - 拷贝的sdk代码资源等跟目录。（后续会具体解析这块）
* Copy Folder - 相对上个参数而言，选择具体需要关联的sdk目录。
* Frameworks - 系统库
* Embed Frameworks - 动态库
* Libs - 静态库
* Linker Flag - 链接库额外参数
