#!/bin/bash
#######################################################################
	#'''	
	#> File Name: nginx_start.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: Sat 13 Aug 2016 01:01:19 AM CST
	#'''	
#######################################################################
cd `dirname $0`
NGINX_HOME=$(pwd)
NGINX=$NGINX_HOME/sbin/nginx

#export LD_LIBRARY_PATH=$NGINX_HOME/luajit/lib:$LIBRARY_PATH
#/etc/rc.d/init.d/functions

RETVAL=0

start() {
    echo -n $"Starting nginx: "

    #nohup limit -n 65535 $NGINX >/dev/null 2>&1 &
	$NGINX -p $NGINX_HOME -c ./conf/nginx.conf>&1

    RETVAL=$?
    if [ $RETVAL -eq 0 ]
    then
        echo "OK"
    else
        echo "Failed!"
    fi
    return $RETVAL
}

stop() {
    echo -n $"Stopping nginx: "
    
    $NGINX -p $NGINX_HOME -s stop
    echo  $"Stop OK, please check it youself ";
    return $RETVAL
}

restart() {
    stop
    sleep 2
    start
}


case "$1" in
start)
    start
    ;;

stop)
    stop
    ;;

restart)
    restart
    ;;
	
reload)
    $NGINX -s reload
    echo  $"reload OK, please check it youself";
    ;;

chkconfig)
    $NGINX -t
    ;;

*)

echo "Usage: $0 {start|stop|restart|chkconfig|reload}"
echo "-start start nginx"
echo "-stop  stop nginx"
echo "-status return nginx status"
echo "-restart restart nginx"
echo $NGINX
exit 1
esac


