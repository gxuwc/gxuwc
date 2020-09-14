#!/bin/bash

#IP=$(ip -4 a|grep inet|grep -v 127.0.0.1|cut -d "/" -f1|awk '{print $2}')
IP=$(hostname -I)

ID=""					#学号

PASSWORD=""			#密码	有可能需要转化下URL特殊字符


WEB_PROVIDER="cmcc"		#移动
	 #"telecom" 		#电信		
   	 #"unicom"		#联通
	 #校园网似乎是留空的

GET="c=ACSetting&a=Login&loginMethod=1&protocol=http%3A&hostname=172.17.0.2&port=&iTermType=1&wlanuserip=${IP}&wlanacip=210.36.18.65&wlanacname=ME60-1&redirect=null&session=null&vlanid=0&mac=06-6f-bb-d0-bf-cd&ip=${IP}&enAdvert=0&jsVersion=2.4.3&DDDDD=%2C0%2C${ID}%40${WEB_PROVIDER}&upass=${PASSWORD}&R1=0&R2=0&R3=0&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login="

curl http://172.17.0.2:801/eportal/?${GET} --insecure
