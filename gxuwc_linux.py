#!/bin/python3
from requests import get

url = 'http://172.17.0.2:801/eportal'

params = {
    'c': 'ACSetting',
    'a': 'Login',
    'wlanacip': '210.36.18.65',
    'DDDDD': ',0,学号@运营商',
    'upass': '密码',
}

get(url,params=params)
