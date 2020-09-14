@echo off
set ID=

set PASSWORD=

set WEB_PROVIDER=cmcc
rem	移动	cmcc
rem	电信	telecom 
rem	联通	unicom
rem	校园网	似乎留空

SET IP_FILE=
ipconfig /all|FINDSTR "IPv4">ipv4.txt
SETLOCAL EnableDelayedExpansion
FOR /F "delims=" %%a IN (ipv4.txt) DO (
    SET IP_FILE=%%a
    ECHO !IP_FILE:~37,-5!>>ip.txt
)
ENDLOCAL

for /f "delims=" %%i in ('type ip.txt') do set IP=%%i
del ipv4.txt
del ip.txt

curl "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&loginMethod=1&protocol=http%%3A&hostname=172.17.0.2&port=&iTermType=1&wlanuserip=%IP%&wlanacip=210.36.18.65&wlanacname=ME60-1&redirect=null&session=null&vlanid=0&mac=06-6f-bb-d0-bf-cd&ip=%IP%&enAdvert=0&jsVersion=2.4.3&DDDDD=%%2C0%%2C%ID%%%40%WEB_PROVIDER%&upass=%PASSwORD%&R1=0&R2=0&R3=0&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login="
