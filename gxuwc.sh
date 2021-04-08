#!/bin/bash

#在gxuwc.sh内输入入网卡名（可选）、学号、密码及运营商。 保证gxuwc.sh有执行权限，直接执行即可

#苹果用户可能需要改一下IP地址的获取方式

CARD="" 		#网卡名

ID=""           #学号

PASSWORD=""     #密码

WEB_PROVIDER="cmcc"         #移动
        	#"telecom"      #电信
     	    #"unicom"       #联通
         	#"" 			#校园网

IP=$(ip -4 a show ${CARD} | awk '/inet / {print $2}' | cut -d/ -f1 | grep -v 127.0.0.1 | tail -n1)

GET="c=ACSetting&a=Login&wlanacip=210.36.18.65&ip=${IP}&DDDDD=${ID}@${WEB_PROVIDER}&upass=${PASSWORD}"

curl http://172.17.0.2:801/eportal/?${GET} --insecure
