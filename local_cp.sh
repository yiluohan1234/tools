#!/bin/bash
#######################################################################
	#'''	
	#> File Name: local_cp.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: Thu 25 Aug 2016 09:19:13 PM CST
	#'''	
#######################################################################
set -x
dst_dir="/home/ubuntu/tingapi_lua"

#更新代码的目录
#$1=/home/work/cyf/test/
src_dir=$1

#svn up 更新代码并生成content
content_file=$src_dir/content



time=`date +%Y%m%d%H%M%S`


for src in `cat ${content_file}`
do
	i=$src_dir/$src
	file=${src##*/}
	path=${src%/*}
		
	#判断src_dir是否为目录
	if [ -d $src_dir/$src ]
	then
		#判断目标目录是否存在
		if [ -d $dst_dir/$src ]
		then
			#备份文件，复制
			mv $dst_dir/$src $dst_dir/${src}_bk_${time} 
			cp -r $i $dst_dir/$src
		else
			cp -r $i $dst_dir/$src
		fi
	else
		if [ -f $dst_dir/$src ]
		then
			#备份文件，复制
			mv $dst_dir/$src $dst_dir/${src}_bk_${time} 
			cp $i $dst_dir/$src
		else
			test -e $dst_dir/$path || mkdir -p $dst_dir/$path
			cp $i $dst_dir/$src
		fi
	fi
done
