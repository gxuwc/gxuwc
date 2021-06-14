@echo off
set ID=

set PASSWORD=

set WEB_PROVIDER=
rem	移动	cmcc
rem	电信	telecom 
rem	联通	unicom
rem	校园网	似乎留空

curl "http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,0,%ID%@%WEB_PROVIDER%&upass=%PASSWORD%"
