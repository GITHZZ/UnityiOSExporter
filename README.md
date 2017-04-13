iOS打包工具(IpaExporter)
=
*个人分享用的打包用的代码,其实呢,主要的逻辑代码都在Lua文件里面,我的目的也就是为了从打包模块直接隔离出项目中,
然后以后项目直接用这个编辑器导出就好,当然也是因为自己的业余兴趣后期新增而已,项目里面我还是直接用终端去启用lua
代码来执行(PS:也可以通过C#直接在编辑器调用) 

*如果需要的话,或者对打包脚本有兴趣的话,可以找到这个项目下的lua文件->ExportIpaUtil.lua,这个就是打包的主要逻辑代码,
拿过去参考就好,思路就是使用UnityCommand line 和 xcodebuild来进行的,unitycommand就是unity的命令行来执行unity
功能,而xcodebuild就是xcode的命令行了,这个搜索下基本没啥难度.或者你可以参考我lua脚本里面流程.  

*其实iOS打包是可以手动操作进行的,我这边有原因才使用脚本打包的,1.公司是内外网机制,我不能上外网进行打包,所以有些功能是受到限制了
2.为了偷懒(笑)   
第二点确实是,很多时候脚本工具能很好的帮我们做一些重复的事情,作为一个专业偷懒程序员,对于这类工具制作还是停不下来的,当然这看个人了.

###注意:
*本上传的东西还不是完整的,都是个人业余进行进一步优化,分享出来也是为了让有缘人能了解下而已,同时我会有空时候就做,慢慢完善。

*~~这个版里面的lua打包工具逻辑其实是有问题的,当然用还是没问题,就是会导致打包时间会更长而已,由于个人问题目前还不能把完整最好的代码放出来,
以后再说吧.这次我主要是为了增加可视化界面而已.~~(不小心这块就完善了)

*关于在上传XcodeApi有用到一个第三方写的一个插件,是日本人写的,个人感觉还是挺不错的,后面项目也打算用他那套,基本实现思路和XUPorter也差不多,不过配置部分用了.asset文件来搞.它就是再进一步封装了。

XcodeProjectUpdater原项目地址:https://github.com/kankikuchi/XcodeProjectUpdater

我自己也fork一份(https://github.com/GITHZZ/XcodeProjectUpdater) ,后面如果有问题我在我那里改,包括一些说明教程我也打算弄份,毕竟他写的是全日文。

*关于打包工具在Xcode8的问题
如果有习惯用打包工具的会发现到Xcode8后多了个自动管理功能,这就导致了导出来的默认工程会勾上去,结果就导不出工程总会报错,所以
解决思路也就是强制把pbxproj文件内容改了就好,我这里用了sed指令,具体看习惯用啥都可以。
然后就是修改证书和team名字(PROVISIONING_PROFILE_SPECIFIER/DEVELOPMENT_TEAM),可视化设置具体在xcodebuild设置里面。主要就这三个点
稍微和以前不太一样。

###遇到的坑(随笔):  

*Cocoa:坑爹的NSTableView 使用的时候一直显示不了内容 解决方法是:要把属性contentMode改成View Based设置成Cell Based 不是不能显示 还好从这里找到方案了:http://www.07net01.com/2015/10/937976.html
 
*Cocoa:NSComboBoxDelegate中的这个协议回调 -(void)comboBoxSelectionIsChanging:(NSNotification *)notification 理论上返回的对象是修改后的对象,然而它返回的是选择前的 需要新增定时器等待到下一帧取 如下:

```Objective-C
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification  
{  
    //bug:延迟到下一帧取数据  
    [self performSelector:@selector(readComboValue:) withObject:[notification object] afterDelay:0];  
}  
```
```Objective-C
- (void)readComboValue:(id)object  
{  
    //这里取选择后内容  
}  
```  

*Xcode8.3之后 xcodebuild -exportFomrat 这个参数已经没有了 而且要强制使用-exportOptionsPlist 这点注意下  

*2017年4月13日 基本功能差不多了，也在项目上初步使用了下，还有点问题(主要是多次打包会报错)和对拷贝路径还是看怎么进一步支持下

