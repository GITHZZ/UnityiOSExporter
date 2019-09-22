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
* **5.删除平台信息，依据用户选择那行删除。**
