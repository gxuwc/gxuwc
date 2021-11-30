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
#-------------------参数设置区域开始分界线-------------------


#-------------------更多的高级参数设置区域-------------------
Login()#登录函数，参数依次为：账号、密码、运营商
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,${Device_type},${ID}@${WEB_PROVIDER}&upass=${PASSWORD}" &> /dev/null
}

Logout()#注销函数
{
    wget -qO- "http://172.17.0.2:801/eportal/?c=ACSetting&a=Logout&wlanacip=210.36.18.65" &> /dev/null
}

#日志大小限制，默认为0，即不输出日志。单位为B，1K=1024B，1M=1048576B 
log_limit="0"
#ping次数大小限制，当脚本运行期间ping次数到达限制，清空日志。脚本每次重启会重置次数
count_limit="5000"
#ping测试间隔时间，默认为120s
sleep_time="120"
#日志路径
path="/root/ping.log"
#--------------------------------------------------------


#-------------------下方为代码区，无需改动-------------------
#表示当前账号，0表示未登录账号，1表示已登录账号
Account=0

if [ $log_limit != 0 ];then
    #日志文件大小
    log_size="0"
    #ping次数计数
    count="100000"
    let count_limit+=$count
    #检测日志文件是否存在，不存在则新建一个日志文件
    if [ ! -f $path ];then
        echo "#" >$path
    fi
    #向日志输出启动信息
    echo -e "\n\n\n$(date +%Y-%m-%d) $(date +%H:%M:%S)------------------------------------------------------------ Script Start\n\n" >/tmp/gxuwc_temp
    sed -i '/#/r /tmp/gxuwc_temp' $path
fi

#设置死循环
while true;do
    if [ $log_limit != 0 ];then
        #测速日志计数+1
        let count++
        echo -e "\n$(date +%Y-%m-%d) $(date +%H:%M:%S) Account: ${Account} -----------------------${count:1}"   >/tmp/gxuwc_temp
        #ping百度dns服务器检测网络是否连通
        ping -c 3 180.76.76.76 >>/tmp/gxuwc_temp
        #若不连通则把登录账户设为空，用于重连
        if [ $? != 0 ];then
            ifup wan
            Account=0
            sleep 10
        fi
        echo -e "-----------------------------${Account}-----------------------------" >>/tmp/gxuwc_temp
        #时间倒序输出结果
        sed -i '/#/r /tmp/gxuwc_temp' $path
    else
        ping -c 3 180.76.76.76 >/dev/null
        #若不连通则把登录账户设为空，用于重连
        if [ $? != 0 ];then
            ifup wan
            Account=0
            sleep 10
        fi
    fi

    
    #账号重连
    if [ $Account -ne 1 ];then
        Logout
        sleep 5
        Login
        Account=1
        
        if [ $log_limit != 0 ];then
            echo -e "\n\n\n$(date +%Y-%m-%d) $(date +%H:%M:%S)--------------------------------------------------------- Login Account 1\n\n" >/tmp/gxuwc_temp
            #时间倒序输出结果
            sed -i '/#/r /tmp/gxuwc_temp' $path
        fi
    fi

    if [ $log_limit != 0 ];then
        #当断网检测次数达上限时
        if [ $count -ge $count_limit ];then
            echo "#" >$path
            count="100000"
        fi
        #日志文件过大时清空日志
        log_size=$(wc -c $path | awk '{print $1}')
        if [ $log_size -ge $log_limit ];then
            echo "#" >$path
        fi
    fi
    #间隔120s再次检测网络是否连通
    sleep $sleep_time

done
