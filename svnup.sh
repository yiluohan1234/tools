#!/bin/bash
#######################################################################
	#'''	
	#> File Name: svnup.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: Fri 26 Aug 2016 02:44:33 PM CST
	#'''	
#######################################################################
function svn_up()
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

}
svn_up $1
