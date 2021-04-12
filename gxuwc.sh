#!/bin/bash

ID="$1"           #学号

PASSWORD="$2"     #密码

CARD="$3"         #网卡名

WEB_PROVIDER="$4"
			#"cmcc"         #移动
        	#"telecom"      #电信
     	    #"unicom"       #联通
         	#"" 			#校园网

IP=$(ip -4 a show ${CARD} | awk '/inet / {print $2}' | cut -d/ -f1 | grep -v 127.0.0.1 | tail -n1)

GET="c=ACSetting&a=Login&wlanacip=210.36.18.65&ip=${IP}&DDDDD=${ID}@${WEB_PROVIDER}&upass=${PASSWORD}"

curl http://172.17.0.2:801/eportal/?${GET} --insecure
