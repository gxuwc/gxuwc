# <center>Guangxi University Web Connection</center>

## 介绍
	由广西大学校友共同维护的校园网登陆认证的脚本集合

## 使用
### gxuwc.sh文件
```shell
方法一：./gxuwc.sh 学号 密码 运营商
方法二：在脚本内写入入学号、密码和运营商;然后将其加入PATH
```

### gxuwc.bat
```bat
在gxuwc.bat内输入入学号，密码及运营商，双击即可运行
```

### gxuwc_openwrt.sh
```shell
gxuwc_openwrt.sh是一个openwrt系统用的登录脚本，用以路由器自动登录校园网。
食用方法：首先你需要一个有OpenWrt系统的路由器
1、按照文件内说明输入参数，共5个参数，完成后保存文件
2、保存文件后，把文件上传到路由器，传文件教程百度搜索：WinSCP如何登陆路由器-百度经验。把脚本放到/root目录(这是WinSCP登录路由器默认打开的目录)。
3、上传完毕，按Shift+Ctrl+T打开WinSCP的终端，输入该命令：sed -i 's/exit 0/sh \/root\/gxuwc_openwrt.sh \&\nexit 0/' /etc/rc.local
4、点击执行后，关闭窗口，重启路由器。这样，路由器每次开机就会启动脚本，当网络断开时会自动尝试重连。

若要停用脚本
1、WinSCP登录路由器，按Shift+Ctrl+T打开WinSCP的终端输入：sed -i 's/sh \/root\/gxuwc_openwrt.sh \&//' /etc/rc.local  
2、点击执行后，关闭窗口，重启路由器即可。

#可能需要关闭自服务系统中的无感知功能
```

### gxuwc_linux.py
```python
将学号、密码和运营商填入，运营商需要填英文代号，如下
留空:校园网(默认，需要把@号掉)
cmcc:移动
telecom:电信
unicom:联通

然后将其加入PATH
```

## 感谢
[hackzhu](https://github.com/hackzhu)
[Atomseek](https://github.com/Atomseek)
