#!/bin/bash

###此脚本由atomseek提供，hackzhu修改

#gxuwc_openwrt_log.sh是一个openwrt系统用的sh脚本，用以路由器自动登录校园网。
#食用方法：首先你需要一个有OpenWrt系统的路由器，且剩余空间应大于3MB
#1、按照下方说明输入参数，共4个参数，完成后保存文件
#2、保存文件后，把文件上传到路由器，传文件教程百度搜索：WinSCP如何登陆路由器-百度经验。把脚本放到/root目录。
#3、上传完毕，按Shift+Ctrl+T打开WinSCP的终端，输入该命令：sed -i 's/exit 0/sh \/root\/gxuwc_openwrt_log.sh \&\nexit 0/' /etc/rc.local
#4、点击执行后，关闭窗口，重启路由器。这样，路由器每次开机就会启动脚本，当网络断开时会自动尝试重连。在/root目录下的ping.log记录了连接日志。

#5、若要停用脚本，则打开终端输入：sed -i 's/sh \/root\/gxuwc_openwrt_log.sh \&//' /etc/rc.local  
#6、点击执行后，关闭窗口，重启路由器即可。

#可能需要关闭自服务系统中的无感知功能

#-------------------参数设置区域开始分界线-------------------
#账号即学号
#ID1填本科生学号，ID2填研究生学号，没有就留空，其余参数同理
#本科生账号晚上断网后不会尝试重连，研究生账号会在任意时刻断网重连
#可以同时输入两个账号，默认白天登录本科生账号，夜晚登录研究生账号
ID1=""
ID2=""

#密码
PASSWORD1=""
PASSWORD2=""

#运营商代码
#移动：cmcc
#电信：telecom
#联通：unicom
#校园网留空
WEB_PROVIDER1=""
WEB_PROVIDER2=""

#登录设备类型：0为PC，1为移动设备
Device_type1="0"
Device_type2="0"
#-------------------参数设置区域开始分界线-------------------

#-------------------------代码区--------------------------
Logout()#注销函数
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Logout&wlanacip=210.36.18.65" &> /dev/null
}
Login()#登录函数，参数依次为：账号、密码、运营商、登录设备类型
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,$4,$1@$3&upass=$2" &> /dev/null
}
Login1()#本科生账号登录函数
{
    Logout
    sleep 1
    Account=1
    Login $ID1 $PASSWORD1 $WEB_PROVIDER1 $Device_type1
    echo -e "\n\n--------------------- Login Account 1 ---------------------" >/root/temp
    #时间倒序输出结果
    sed -i '/#/r /root/temp' /root/ping.log

}
Login2()#研究生账号登录函数
{
    Logout
    sleep 1
    Account=2
    Login $ID2 $PASSWORD2 $WEB_PROVIDER2 $Device_type2
    echo -e "\n\n--------------------- Login Account 2 ---------------------" >/root/temp
    #时间倒序输出结果
    sed -i '/#/r /root/temp' /root/ping.log
}


#表示当前账号，0表示未登录账号，1表示登录本科生账号，2表示登录研究生账号
Account=0
#日志计数
count="10000"
#运行程序前清空日志
echo "#" >/root/ping.log

#设置死循环
while true;do

    let count++
    echo -e "\n$(date +%Y-%m-%d) $(date +%H:%M:%S) Account: ${Account} ------------------------${count:1}" >/root/temp
    #ping百度dns服务器检测网络是否连通
    ping -c 3 180.76.76.76 >>/root/temp
    #若不连通则把登录账户设为空，用于重连
    if [ $? != 0 ];then
        ifup wan
        Account=0
        sleep 10
    fi
    echo -e "-----------------------------${Account}-----------------------------" >>/root/temp

    #时间倒序输出结果
    sed -i '/#/r /root/temp' /root/ping.log

    #获取当前时间
    Time=$(date +%-H%M)

    #若填有本科生账号，优先登录本科生账号
    if [ ! -z $ID1 ];then
        #按星期判断账号登录时间
        case $(date +%w) in
        #周五：6:00后登录本科生账号，之后若填有研究生账号则登录研究生账号
        5)
            if [ $Time -ge 600 ] && [ $Account -ne 1 ];then
                Login1
            elif [ $Time -lt 600 ] && [ $Account -ne 2 ] && [ ! -z $ID2 ];then
                Login2
            fi
        ;;
        #周六：全天登录本科生账号
        6)
            if [ $Account -ne 1 ];then
                Login1
            fi
        ;;
        #周日：23:58之前登录本科生账号，之后若填有研究生账号则登录研究生账号
        0)
            if [ $Time -lt 2358 ] && [ $Account -ne 1 ];then
                Login1
            elif [ $Time -ge 2358 ] && [ $Account -ne 2 ] && [ ! -z $ID2 ];then
                Login2
            fi 
        ;;
        #周一至周四：（6:00 至 23:58）登录本科生账号，（6:00前 或 23:58后）且填有研究生账号则登录研究生账号
        *)
            if [ $Time -ge 600 -a $Time -lt 2358 ] && [ $Account -ne 1 ];then
                Login1
            elif [ $Time -lt 600 -o $Time -ge 2358 ] && [ $Account -ne 2 ] && [ ! -z $ID2 ];then
                Login2
            fi
        esac

    #本科生账号为空，且填有研究生账号，则任意时刻都尝试登录研究生账号
    elif [ ! -z $ID2 ];then
        Login2
    fi

    #当断网检测5000次时清空日志
    if [ $count -ge 15000 ];then
        echo "#" >/root/ping.log
        count="10000"
    fi

    #间隔120s再次检测网络是否连通
    sleep 120

done