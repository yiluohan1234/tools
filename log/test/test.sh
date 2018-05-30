#!/bin/bash
#######################################################################
	#'''	
	#> File Name: test.sh
	#> Author: cuiyf
	#> Mail: XXX@qq.com
	#> Created Time: Wed 30 May 2018 10:41:04 AM CST
	#'''	
#######################################################################
# 当期工作目录
CUR=$(cd `dirname $0`;pwd)

# 引入log.sh 文件
. $CUR/../log.sh

log_info "this is a test!"

log_error " this is a error!"
