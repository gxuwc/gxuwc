#!/bin/bash

ID="$1"           #学号

PASSWORD="$2"     #密码

WEB_PROVIDER="$3"
			#"cmcc"         #移动
        	#"telecom"      #电信
     	    #"unicom"       #联通
         	#"" 			#校园网

GET="c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=${ID}@${WEB_PROVIDER}&upass=${PASSWORD}"

curl http://172.17.0.2:801/eportal/?${GET} --insecure
