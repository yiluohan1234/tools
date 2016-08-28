#!/bin/bash
#######################################################################
	#'''	
	#> File Name: log.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: Sun 28 Aug 2016 12:10:45 PM CST
	#'''	
#######################################################################
#@input:log_file  NOTICE log_module src_dir dst_dir
#@outpu: 0
LOG()
{
	local log_notice=$1/access.log
	local log_error=$1/error.log
	local log_type=$2
	local log_module=$3
	local src_dir=$4
	local dst_dir=$5
	local log_form=[$2][`date '+%Y-%m-%d %H:%M:%S'`][$log_module][src_dir][$src_dir][dst_dir][$dst_dir]
	if ! test -e $log_notice
	then
		touch $log_notice
	fi
	if ! test -e $log_error
	then
		touch $log_error
	fi
	case $2 in
		NOTICE)
			echo $log_form >> $log_notice
			;;
		ERROR)
			echo $log_form >> $log_error
			;;
		?)
			echo "echo input error."
			;;
	esac
	return 0
}
LOG $1 $2 $3 $4 $5
