#!/bin/bash
#######################################################################
	#'''	
	#> File Name: remote_cp.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: 2016年08月26日 星期五 00时15分50秒
	#'''	
#######################################################################
set -x
ssh_host="ubuntu@123.207.167.223"
dst_dir="/home/ubuntu/hylbd/webroot"

#更新代码的目录
#$1=/home/work/cyf/test/
src_dir=$1
#svn up 更新代码并生成content
content_file=$src_dir/content

time=`date +%Y%m%d%H%M%S`

for src in `cat $content_file`
do
	i=$src_dir/$src
	file=${src##*/}
	path=${src%/*}
		
	#判断src_dir是否为目录
	if [ -d $i ]
	then
		#判断远程主机
		if ssh $ssh_host "[[ -d $dst_dir/$src ]]" 
		then
			#备份目录，复制
			ssh $ssh_host "mv $dst_dir/$src $dst_dir/${src}_bk_${time}" 
			scp -r $i $ssh_host:$dst_dir/$src 
		else
			scp -r $i $ssh_host:$dst_dir/$src 
		fi
	else
		if ssh $ssh_host test -e $dst_dir/$src 
		then
			#备份文件，复制
			ssh $ssh_host "mv $dst_dir/$src $dst_dir/${src}_bk_${time}" 
			scp $i $ssh_host:$dst_dir/$path/  
		else
			ssh $ssh_host "[[ -d $dst_dir/$path ]] || mkdir -p $dst_dir/$path" 
			scp $i $ssh_host:$dst_dir/$path/  
		fi
	fi
done
