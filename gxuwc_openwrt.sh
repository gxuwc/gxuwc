#!/bin/sh

###此脚本由atomseek，hackzhu编写

#gxuwc_openwrt.sh是一个openwrt系统用的sh脚本，用以路由器自动登录校园网。
#食用方法：首先你需要一个有OpenWrt系统的路由器
#1、按照下方说明输入参数，共4个参数，完成后保存文件
#2、保存文件后，把文件上传到路由器，传文件教程百度搜索：WinSCP如何登陆路由器-百度经验。把脚本放到/root目录。
#3、上传完毕，按Shift+Ctrl+T打开WinSCP的终端，输入该命令：sed -i 's/exit 0/sh \/root\/gxuwc_openwrt.sh \&\nexit 0/' /etc/rc.local
#4、点击执行后，关闭窗口，重启路由器。这样，路由器每次开机就会启动脚本，当网络断开时会自动尝试重连。

#5、若要停用脚本，则打开终端输入：sed -i 's/sh \/root\/gxuwc_openwrt.sh \&//' /etc/rc.local  
#6、点击执行后，关闭窗口，重启路由器即可。

#可能需要关闭自服务系统中的无感知功能

#-------------------参数设置区域开始分界线-------------------
#双引号内填入上网账号，即学号
ID=""

#双引号内填入上网密码
PASSWORD=""

#双引号内填入运营商代码
#移动：cmcc
#电信：telecom
#联通：unicom
#校园网留空
WEB_PROVIDER=""

#登录设备类型：0为PC，1为移动设备
Device_type="0"

#重登间隔时间，防止掉线，默认60s
sleep_time="60"
#-------------------参数设置区域开始分界线-------------------

while true;do
    #登录函数
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,${Device_type},${ID}@${WEB_PROVIDER}&upass=${PASSWORD}" &> /dev/null

    #间隔120s再次检测网络是否连通
    sleep $sleep_time
done
