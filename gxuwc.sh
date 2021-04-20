#!/bin/bash

ID="$1"  #学号

KEY="$2" #密码

case $3 in
	移动) WEB="@cmcc"    ;;
	电信) WEB="@telecom" ;;
	联通) WEB="@unicom"  ;;
esac	

GET="c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=${ID}${WEB}&upass=${KEY}"

curl http://172.17.0.2:801/eportal/?${GET}
