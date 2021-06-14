#!/bin/bash

###此脚本核心代码由hackzhu提供，Atomseek修改

#gxuwc_openwrt.sh是一个openwrt系统用的sh脚本，用以路由器自动登录校园网。
#食用方法：首先你需要一个有OpenWrt系统的路由器
#1、按照下方说明输入参数，共3个参数，完成后保存文件
#2、保存文件后，把文件上传到路由器，传文件教程百度搜索：WinSCP如何登陆路由器-百度经验。例如我放到/root目录。
#3、打开路由器openwrt管理主页，在“系统”选项下的“启动项”页面底下文本框处，在exit 0的上一行输入：sh /root/gxuwc_openwrt.sh &  （不要漏掉&符号）
#4、保存设置后，重启路由器。这样，路由器每次开机就会启动脚本，当网络断开时会自动尝试重连。
#5、不想用脚本了就删掉第3步在启动项处输入的那行代码，重启路由器即可。

#-------------------参数设置区域开始分界线-------------------
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
#校园网留空
WEB_PROVIDER1=""
WEB_PROVIDER2=""

#登录设备类型0为PC，1为移动设备
Device_type="0"
#-------------------参数设置区域开始分界线-------------------

#--------------------------代码区----------------------------
Logout()#注销函数
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Logout&wlanacip=210.36.18.65" &> /dev/null
}
Login()#登录函数，参数依次为：账号、密码、运营商、登录设备类型
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,$4,$1@$3&upass=$2" &> /dev/null
}
Login1()#账户1登录函数
{
    Logout
    sleep 1
    Account=1
    Login $ID1 $PASSWORD1 $WEB_PROVIDER1 $Device_type
    echo -e "\n\n--------------------- Login Account 1 ---------------------" >>/root/ping.log

}
Login2()#账户2登录函数
{
    Logout
    sleep 1
    Account=2
    Login $ID2 $PASSWORD2 $WEB_PROVIDER2 $Device_type
    echo -e "\n\n--------------------- Login Account 2 ---------------------" >>/root/ping.log
}

#表示当前账号，0表示未登录账号，1表示登录1账号，2表示登录2账号
Account=0
#运行程序前清空日志
rm -f /root/ping.log

#设置死循环
while true;do

    echo -e "\n$(date +%Y-%m-%d) $(date +%H:%M:%S) Account: ${Account} ----------------------------" >>/root/ping.log
    #ping百度dns服务器检测网络是否连通
    ping -c 3 180.76.76.76 >>/root/ping.log
    #若不连通则把登录账户设为0，用于重连
    if [ $? != 0 ];then
        #刷新wan口
        ifup wan
        Account=0
        sleep 10
    fi
    echo "-----------------------------${Account}-----------------------------" >>/root/ping.log

    #获取当前时间
    Time=$(date +%-H%M)

    #按星期判断账号登录时间
    case $(date +%w) in
    #周五：6:00后登录账户1，之后账号2不为空则登录账户2
    5)
        if [ $Time -ge 600 ] && [ $Account -ne 1 ];then
            Login1
        elif [ $Time -lt 600 ] && [ $Account -ne 2 ] && [ ! -z $ID2 ];then
            Login2
        fi
    ;;
    #周六：全天登录账户1
    6)
        if [ $Account -ne 1 ];then
            Login1
        fi
    ;;
    #周日：23:58之前登录账户1，之后账号2不为空则登录账户2
    0)
        if [ $Time -lt 2358 ] && [ $Account -ne 1 ];then
            Login1
        elif [ $Time -ge 2358 ] && [ $Account -ne 2 ] && [ ! -z $ID2 ];then
            Login2
        fi 
    ;;
    #周一至周四：（6:00 至 23:58）登录账户1，（6:00前 或 23:58后）且账号2不为空则登录账户2
    *)
        if [ $Time -ge 600 -a $Time -lt 2358 ] && [ $Account -ne 1 ];then
            Login1
        elif [ $Time -lt 600 -o $Time -ge 2358 ] && [ $Account -ne 2 ] && [ ! -z $ID2 ];then
            Login2
        fi
    esac

    #间隔120s再次检测网络是否连通
    sleep 120

done
