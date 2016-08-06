#!/bin/bash
#######################################################################
#	'''	
#	> File Name: start.sh
#	> Author: cyf
#	> Mail: XXX@qq.com
#	> Created Time: Fri 05 Aug 2016 11:46:47 AM CST
#	'''	
#######################################################################

#使用ssh-keygen命令生成密钥
ssh-keygen -t rsa -C "1097819275@qq.com"

#配置用户名和电子邮件
git config --global user.name "yiluohan1234"
git config --global user.email "1097189275@qq.com"

#配置默认使用的文本编辑器
git config --global core.editor vim

#配置差异分析工具
git config --global merge.tool vimdiff
