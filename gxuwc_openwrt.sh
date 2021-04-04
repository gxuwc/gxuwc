#!/bin/bash

###此脚本由atomseek提供
##未修改

#gxuwc_openwrt.sh是一个openwrt系统用的sh脚本，用以路由器自动登录校园网。
#食用方法：首先你需要一个有OpenWrt系统的路由器
#1、按照下方说明输入参数，共4种参数，完成后保存文件
#2、保存文件后，把文件上传到路由器，传文件教程百度搜索：WinSCP如何登陆路由器-百度经验。例如我放到/root目录。
#3、打开路由器openwrt管理主页，在“系统”选项下的“启动项”页面底下文本框处，在exit 0的上一行输入：sh /root/gxuwc_openwrt.sh &  （不要漏掉&符号）
#4、保存设置后，重启路由器。这样，路由器每次开机就会启动脚本，当网络断开时会自动尝试重连。
#5、不想用脚本了就删掉第3步在启动项处输入的那行代码，重启路由器即可。

#--------------------------------参数设置区域开始分界线--------------------------------
#账号即学号,ID1是白天账号；ID2是晚上账号，没有就留空，其余参数同理
ID1=""
ID2=""

#密码
PASSWORD1=""
PASSWORD2=""

#运营商代码
#移动：cmcc
#电信：telecom
#联通：unicom
#校园网似乎是留空的
WEB_PROVIDER1=""
WEB_PROVIDER2=""

#填入wan口的网卡名称
#打开路由器管理页面默认是进入概况页面，找到“IPv4 WAN 状态”一栏有一块参数列表，有网关、DNS等参数
#在参数列表左边有个图标，图标底下的名称就是wan口网卡名称，将其填入下方参数
ETH=""
#--------------------------------参数设置区域结束分界线--------------------------------


#表示当前账号，0表示未登录账号，1表示登录1账号，2表示登录2账号
Account=0
#获取路由器ETH网卡即wan口ip
IP=$(ip -4 addr show dev ${ETH} | awk '/inet / {print $2}' | cut -d/ -f1)

Login()#登录函数，参数依次为：账号、密码、运营商、IP
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&ip=$4&DDDDD=$1%40$3&upass=$2" &> /dev/null
}

Logout()#注销函数，参数只有IP
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Logout&wlanuserip=$1&wlanacip=210.36.18.65&ip=$1" &> /dev/null
}

#运行程序前先注销，然后再重新登录
Logout $IP
sleep 5
blank=""


#设置死循环
while true;do

    #ping百度dns服务器检测网络是否连通
    ping -c 3 180.76.76.76 >/dev/null
    #若不连通则把登录账户设为空，用于重连
    if [ $? != 0 ];then
        #重启wan口并延迟10s等待路由器获取到ip
        ifdown wan && ifup wan && sleep 10
        #获取路由器ETH网卡即wan口ip
        IP=$(ip -4 addr show dev ${ETH} | awk '/inet / {print $2}' | cut -d/ -f1)
        Account=0
    fi

    #获取当前时间
    Time=$(date +%-H%M)
    Week=$(date +%w)

    #（周一到周四 6:00后 与 23:58前）或（周五 6:00后）或（周六全天）或（周日23:58前） 登录账户1
    if [[ $Time -ge 600 && $Time -lt 2358 && $Week -ge 1 && $Week -le 4 ]]||[[ $Time -ge 600 && $Week -eq 5 ]]||[[ $Week -eq 6 ]]||[[ $Time -lt 2358 && $Week -eq 0 ]]&&[[ $Account != 1 ]];then
        Logout $IP
        Login $ID1 $PASSWORD1 $WEB_PROVIDER1
        Account=1

    #（周一到周四 6:00前）或（周一到周四 23:58后）或（周五 6:00前）或（周日23:58后）登录账户2，若账户2为空，啧跳过
    elif [[ $Time -lt 600 && $Week -ge 1 && $Week -le 4 ]]||[[ $Time -ge 2358 && $Week -ge 1 && $Week -le 4 ]]||[[ $Time -lt 600 && $Week -eq 5 ]]||[[ $Time -ge 2358 && $Week -eq 0 ]]&&[[ $Account != 2 ]]&&[ $ID2 != $blank ];then
        Logout $IP
        Login $ID2 $PASSWORD2 $WEB_PROVIDER2
        Account=2
    fi

    #间隔120s再次检测网络是否连通
    sleep 120

done
