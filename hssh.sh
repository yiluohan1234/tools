#!/bin/bash
#######################################################################
#> File Name: hssh.sh
#> Author: cyf
#> Mail: XXX@qq.com
#> Created Time: Fri 19 Aug 2016 01:12:24 PM CST
#######################################################################
if [ $# != 2 ]
then
	echo "Usage: `basename $0` user ip"
fi

temp_file=/tmp/hssh
name=$1
ip=192.168.$2
case "$2" in
 "217.12"|"207.31"|"205.199") password="1233456";;
 *) password="qita"
esac

sshpass -p $password ssh $name@$ip -o StrictHostKeyChecking=no 2>$temp_file
if [ $? != 0 ];then
    #for some reason,machine had reinstall, we need to delete that IP address in known_hosts file before ssh it.
    grep -q "REMOTE HOST IDENTIFICATION HAS CHANGED" $temp_file
    if [ $? = 0 ];then
       key_file=`grep "Offending key in" $temp_file | cut -d' ' -f 4 | cut -d ':' -f1 2>/dev/null`
       cat $key_file | grep -v "$ip" > $temp_file
       sudo cp -v $temp_file $key_file
       sshpass -p $password ssh $name@$ip -o StrictHostKeyChecking=no 2>$temp_file
    fi
fi

