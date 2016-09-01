#!/bin/bash
#######################################################################
	#'''	
	#> File Name: setEnv.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: Fri 19 Aug 2016 12:57:06 PM CST
	#'''	
#######################################################################
#Usage:"
#    setEnv [options]...
#Options:
#	help                              get the help of setEnv
#	version                           get the version of setEnv
#	local  src_dir dst_dir            local copy
#	remote src_dir dst_dir            remote copy
#	log    src_dir                    list the log
#	svnup  src_dir                    svn up
#local=>dst_dir:/home/ubuntu/api_lua(default)
#remote=>dst_dir:ubuntu@123.167.207.223:/home/ubuntu/remote/webroot(default)

#set -x

#创建日志文件
#@input:log_file  NOTICE log_module src_dir dst_dir
#@outpu: 0
LOG()
{
	local log_notice=$1/access.log
	#local log_error=$1/error.log
	local log_type=$2
	local log_module=$3
	local src_dir=$4
	local dst_dir=$5
	local log_form="[$2] `date '+%Y-%m-%d %H:%M:%S'` [$log_module] src_dir [$src_dir] dst_dir [$dst_dir]"
	if ! test -e $log_notice
	then
		touch $log_notice
	fi
	#if ! test -e $log_error
	#then
	#	touch $log_error
	#fi
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

#显示日志更新内容
#    @input:src_dir
#    @output 0
show_log()
{
	local log_file=$1/access.log
	cat $log_file
	return 0
}

#显示日志更新列表
#    @input:src_dir
#    @output 0
show_content()
{
	local content_file=$1/content
	cat $content_file
	return 0
}
#更新svn并将更新的文件或目录写入content文件
#    @input:svn_path
#    @output: 0
svn_up()
{
	local svn_path=$1
	if [ -d $svn_path ]
	then
		cd $svn_path
	else
		echo "the svn path not exists."
		exit 1
	fi
	svn up > tmp
	cat tmp | sed '$d' | sed '1d' | grep '^[A,U]' | awk -F ' ' '{print $2}' > content
	return 0

}

#更新本地api_lua里边的文件
#    @input: src_dir dst_dir
#    @output:0
local_cp()
{
#更新代码的目录
#$1=/home/work/cyf/test/
local src_dir=$1
local dst_dir=$2

#默认本地dst_dir目录
if [ "X${dst_dir}" = "X" ]
then
	dst_dir="/home/ubuntu/api_lua/"
fi

#svn up 更新代码并生成content
local content_file=$src_dir/content

local time=`date +%Y%m%d%H%M%S`

for src in `cat ${content_file}`
do
	if [ ! $src ]
	then
		echo "error"
	fi
	local i=$src_dir/$src
	local file=${src##*/}
	local path=${src%/*}
		
	#判断src_dir是否为目录
	if [ -d $src_dir/$src ]
	then
		#判断目标目录是否存在
		if [ -d $dst_dir/$src ]
		then
			#备份文件，复制
			mv $dst_dir/$src $dst_dir/${src}_bk_${time} 
			cp -r $i $dst_dir/$src
			LOG $src_dir NOTICE $FUNCNAME $i $dst_dir/$src
		else
			cp -r $i $dst_dir/$src
			LOG $src_dir NOTICE $FUNCNAME $i $dst_dir/$src
		fi
	else
		if [ -f $dst_dir/$src ]
		then
			#备份文件，复制
			mv $dst_dir/$src $dst_dir/${src}_bk_${time} 
			cp $i $dst_dir/$src
			LOG $src_dir NOTICE $FUNCNAME $i $dst_dir/$src
		else
			test -e $dst_dir/$path || mkdir -p $dst_dir/$path
			cp $i $dst_dir/$src
			LOG $src_dir NOTICE $FUNCNAME $i $dst_dir/$src
		fi
	fi
done
return 0
}
#更新远程主机上目录的文件
#    @input:src_dir dst_dir
#    @output: 0
scp_ip()
{
#更新代码的目录
#$1=/home/work/cyf/test/
local src_dir=$1
local dst=$2
local ssh_host=${dst%:*}
local dst_dir=${dst#*:}

if [ "X${dst}" = "X" ]
then
	ssh_host="ubuntu@123.207.167.223"
	dst_dir="/home/ubuntu/remote/webroot"
fi
#svn up 更新代码并生成content
local content_file=$src_dir/content

local time=`date +%Y%m%d%H%M%S`

for src in `cat $content_file`
do
	local i=$src_dir/$src
	local file=${src##*/}
	local path=${src%/*}
		
	#判断src_dir是否为目录
	if [ -d $i ]
	then
		#判断远程主机
		if ssh $ssh_host "[[ -d $dst_dir/$src ]]" 
		then
			#备份目录，复制
			ssh $ssh_host "mv $dst_dir/$src $dst_dir/${src}_bk_${time}" 
			scp -r $i $ssh_host:$dst_dir/$src 
			LOG $src_dir NOTICE $FUNCNAME $i $ssh_host:$dst_dir/$src
		else
			scp -r $i $ssh_host:$dst_dir/$src 
			LOG $src_dir NOTICE $FUNCNAME $i $ssh_host:$dst_dir/$src
		fi
	else
		if ssh $ssh_host test -e $dst_dir/$src 
		then
			#备份文件，复制
			ssh $ssh_host "mv $dst_dir/$src $dst_dir/${src}_bk_${time}" 
			scp $i $ssh_host:$dst_dir/$path/  
			LOG $src_dir NOTICE $FUNCNAME $i $ssh_host:$dst_dir/$src
		else
			ssh $ssh_host "[[ -d $dst_dir/$path ]] || mkdir -p $dst_dir/$path" 
			scp $i $ssh_host:$dst_dir/$path/  
			LOG $src_dir NOTICE $FUNCNAME $i $ssh_host:$dst_dir/$src
		fi
	fi
done
return 0
}
#用法的介绍
Usage()
{
	echo "Usage:"
	echo "    setEnv [options]..."
	echo "Options:"
	echo "    help                              get the help of setEnv"
	echo "    version                           get the version of setEnv"
	echo "    local  src_dir dst_dir            local copy"
	echo "    remote src_dir dst_dir            remote copy"
	echo "    log    src_dir                    list the log"
	echo "    svnup  src_dir                    svn up"
	echo "    content src_dir                   list content"
}
#判断一个变量是否为空
judge_null()
{
	local var=$1
	if [ "x${var}" = "x" ]
	then
		return 1
	else
		return 0
	fi
}

#主函数
#    @input : options src_dir dst_dir
#    @output: 0
main()
{
	#local/remote/svnup/help/log
	local options=$1
	local src_dir=$2
	if [ "X${src_dir}" = "X" ]
	then
		Usage
	fi
	local dst_dir=$3

	case $options in
		local)
			local_cp $src_dir $dst_dir
			;;
		remote)
			scp_ip $src_dir $dst_dir
			;;
		svnup)
			svn_up $src_dir
			;;
		log)
			show_log $src_dir
			;;
		version)
			echo "v1.0.0"
		content)
			show_content $src_dir
			;;
	esac
	return 0
}

if [ $# -eq 1 ]
then
	main $1 
elif [ $# -eq 2 ]
then
	main $1 $2 
elif [ $# -eq 3 ]
then
	main $1 $2 $3
else
	Usage
fi
