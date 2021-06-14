* GuangXi University Web Connection
** 介绍
	广西大学一键实现校园网络认证脚本

*** 核心 
	http://172.17.0.2:801/eportal/?c=ACSetting&a=Login&wlanacip=210.36.18.65&DDDDD=,硬件架构名,学号@运营商&upass=密码
   
**** 硬件架构名
- 0:电脑
- 1:手机(默认)

**** 运营商
- 留空:校园网(默认)
- cmcc:移动
- telecom:电信
- unicom:联想

** 使用
*** gxuwc.sh文件(保证运行权限)
**** 直接使用
- 方法一：
./gxuwc.sh 学号 密码 运营商

- 方法二：
在gxuwc.sh内输入学号、密码、运营商

./gxuwc.sh或加入PATH
    
**** Networkmanager自动登录
	使用方法二的gxuwc.sh，在curl命令中加入---max-time 3，否则不能使用非校内的wifi

	将gxuwc.sh放入/etc/NetworkManager/dispatcher.d/pre-up.d文件夹中
	
*** gxuwc_openwrt.sh文件
	由[[https://github.com/Atomseek][Atomseek]]提供

	使用方法写在sh文件中
	
*** gxuwc.bat
	在gxuwc.bat内输入入学号，密码及运营商，双击即可运行
