#!/bin/bash

BAIDU=$(curl baidu.com|grep 172.17.0.2)

eval WLANUSERIP=$(echo ${BAIDU}|cut -d "?" -f2|cut -d "&" -f1)

eval WLANACIP=$(echo ${BAIDU}|cut -d "&" -f3)

eval WLANACNAME=$(echo ${BAIDU}|cut -d "&" -f2)

eval MAC=$(echo ${BAIDU}|cut -d "r" -f3|cut -b -16|awk -F "" '{print $1 $2 $3 $4 $5 $6 "-" $7 $8 "-" $9 $ 10 "-" $11 $12 "-" $13 $14 "-" $15 $16}')

eval IP=$(echo ${BAIDU}|cut -d "r" -f2|cut -d "&" -f1)


ID=""				#学号

PASSWORD=""			#密码	有可能需要转化下URL特殊字符

#从中选一个
WEB_PROVIDER="cmcc"		#移动
	    #"telecom" 		#电信		
	    #"unicom"		#联通
	    #校园网似乎是留空的

curl http://172.17.0.2:801/eportal/?c=ACSetting\&a=Login\&loginMethod=1\&protocol=http%3A\&hostname=172.17.0.2\&port=\&iTermType=1\&${WLANUSERIP}\&${WLANACIP}\&${WLANACNAME}\&redirect=null\&session=null\&vlanid=0\&${MAC}\&${IP}\&enAdvert=0\&jsVersion=2.4.3\&DDDDD=%2C0%2C${ID}%40${WEB_PROVIDER}\&upass=${PASSWORD}\&R1=0\&R2=0\&R3=0\&R6=0\&para=00\&0MKKey=123456\&buttonClicked=\&redirect_url=\&err_flag=\&username=\&password=\&user=\&cmd=\&Login=
