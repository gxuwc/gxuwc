#!/bin/bash

ID="$1"  #学号

KEY="$2" #密码

#运营商
case $3 in
	移动)	 WEB="@cmcc"    ;;
	电信) 	 WEB="@telecom" ;;
	联通)	 WEB="@unicom"  ;;
	cmcc)	 WEB="@cmcc"    ;;
	unicom)  WEB="@unicom"  ;;
	telecom) WEB="@telecom" ;;
esac

#硬件架构名
case $(uname -m) in
	x86_64)	DEVICE="0" ;;
	*)		DEVICE="1" ;;
esac

GET="c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,${DEVICE},${ID}${WEB}&upass=${KEY}"

curl http://172.17.0.2:801/eportal/?${GET}

if [ $? == 0 ] && [ -f "/bin/notify-send" ]
then
	notify-send "成功连接校园网络"
fi
