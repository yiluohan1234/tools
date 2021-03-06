#!/bin/bash
#######################################################################
	#'''	
	#> File Name: log.sh
	#> Author: cuiyf
	#> Mail: XXX@qq.com
	#> Created Time: Wed 30 May 2018 10:33:54 AM CST
	#'''	
#######################################################################
#set -x
# 当前工作目录
CUR=$(cd `dirname $0`;pwd)

# log
DEBUG=true
DATE=`date "+%Y%m%d%H"`

# log:log_info
log_info()
{	
	local CUR_DIR=`pwd`
	local log_path=$CUR_DIR/log
	local access_log=$log_path/access_shell_$DATE.log
	if ! test -e $log_path
	then
    	mkdir -p $log_path
	fi

	if ! test -e $access_log
	then
		touch $access_log
	fi
	DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
	USER_N=`whoami`
	echo "[INFO] ${DATE_N} ${USER_N} $0 $@" >> $access_log 

	if [ "$DEBUG"x = "true"x ]  
	then
	    echo "[INFO] ${DATE_N} ${USER_N} $0 $@"
	fi

}

# log:log_error
log_error()
{
	local CUR_DIR=`pwd`
	local log_path=$CUR_DIR/log
	local error_log=$log_path/error_shell_$DATE.log
	if ! test -e $log_path
	then
    	mkdir -p $log_path
	fi
	if ! test -e $error_log
	then
		touch $error_log
	fi
	DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
	USER_N=`whoami`
	echo -e "[ERROR] [${DATE_N} ${USER_N} $0 $@]"  >> $error_log 
	if [ "$DEBUG"x = "true"x ]  
	then
	    echo -e "[ERROR]\033[41;37m ${DATE_N} ${USER_N} $0 $@ \033[0m"
	fi
}
