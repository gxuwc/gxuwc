#!/bin/bash

#该脚本可用于学习c语言的过程中，vim保存文件后使用:! command中，无需退出vim即可编译当前c文件

FILE=$(ls -c *.c|head -1|cut -d . -f1)  

gcc -o ${FILE}.exe ${FILE}.c
./${FILE}.exe
