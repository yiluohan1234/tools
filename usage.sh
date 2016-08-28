#!/bin/bash
#######################################################################
	#'''	
	#> File Name: usage.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: Fri 26 Aug 2016 04:52:36 PM CST
	#'''	
#######################################################################
Usage(){
	echo "Usage:"
	echo "    setEnv [options]..."
	echo "Options:"
	echo "    option $1 $2 $3"
	echo "    help                              get the help of setEnv"
	echo "    version                           get the version of setEnv"
	echo "    local  src_dir dst_dir            local copy"
	echo "    remote src_dir dst_dir            remote copy"
	echo "    log    src_dir                    list the log"
}

GetVersion()
{
	return "v1.0.0"
}
main()
{
	
	while getopts "hvl" opt
	do
		case $opt in
			h) Usage ;;
			v) 
				version=GetVersion 
				echo "$version"
				;;
			l) echo "log" ;;
		esac
	done
}
main "$@"
