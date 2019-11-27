# DecryptApp
动态砸壳，主动加载所有动态库（framework，dylib）

# 对应文章
[iOS逆向(11)-砸壳原理剖析，主动加载所有framework]()  

其中包含主动加载所有framework的framework，只需利用`DYLD_INSERT_LIBRARIES`注入即可,解决砸壳时，有部分动态库不启动的问题。

# 使用方式：  
1、下载本工程到本地     

2、如果你的手机是arm64架构的，可以直接使用本工程下的libAllFramework.framework。如果不是，就需要xcode连接手机，Build后获取对应的framework 

3、将libAllFramework.framework拷贝到候机的home目录下   
```
> scp -r -P 12345 libAllFramework.framework root@localhost:~/  
```  

4、利用```DYLD_INSERT_LIBRARIES```执行```libAllFramework```  

```
// 后面的地址可以利用ps -ax | greh Facebook 的命令查询得到，前提是App已经正常启动
> DYLD_INSERT_LIBRARIES=libAllFramework.framework/libAllFramework /var/containers/Bundle/Application/B4217EF2-9F16-453F-B1DE-9EC5D0E69B60/Facebook.app/Facebook
```


![效果图](https://github.com/dengbin9009/DecryptApp/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE.png?raw=true)
