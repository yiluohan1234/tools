#!/bin/bash
#set -x
usage()
{
    case $1 in
        "")
            echo "Usage: exeflume.sh command [options]"
            echo "      for info on each command: --> exeflume.sh command -h|--help"
            echo "Commands:"
            echo "      exeflume.sh start [options]"
            echo "      exeflume.sh stop"
            echo "      exeflume.sh restart [options]"
            echo ""
            ;;
        start)
            echo "Usage: exeflume.sh start[-h|--help]"
            echo ""
            echo "  This is a quick example of using a bash script to start flume:"
            echo ""
            echo "Params:"
            echo "      -c|--conf use configs in <conf> directory"
            echo "      -f|--conf-file specify a config file (required if -z missing)"
            echo "      -n|--name the name of this agent"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./exeflume.sh start -c conf -f conf/flume.conf -n agent1"
            echo ""
            ;;
        restart)
            echo "Usage: exeflume.sh restart[-h|--help]"
            echo ""
            echo "  This is a quick example of using a bash script to restart flume:"
            echo ""
            echo "Params:"
            echo "      -c|--conf use configs in <conf> directory"
            echo "      -f|--conf-file specify a config file (required if -z missing)"
            echo "      -n|--name the name of this agent"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./exeflume.sh restart -c conf -f conf/flume.conf -n agent1"
            echo ""
            ;;
    esac

}
function start(){
    local conf_path=""
    local conf_file=""
    local agent_name=""

    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
            -c|--conf)
                shift
                conf_path=$1
                ;;
            -f|--conf-file)
                shift
                conf_file=$1
                ;;
            -n|--name)
                shift
                agent_name=$1
                ;;
            -h|--help)
                usage start
                exit
                ;;
            *)
                echo >&2 "Invalid argument: $1"
                usage "start"
                exit
                ;;
            esac
        shift
        done
    else
        usage start
        exit
    fi

    echo "开始启动 ...."
    num=`ps -ef|grep java|grep "flume"|wc -l`
    echo "进程数:$num"
    if [ "$num" = "0" ] ; then
        eval nohup flume-ng agent -c $conf_path -f $conf_file --name $agent_name &
        echo "启动成功...."
    else
        echo "进程已经存在,启动失败,请检查....."
        exit 0
    fi
} 
function stop(){
    echo "开始stop ....."
    num=`ps -ef|grep java|grep "flume"|wc -l`
    if [ "$num" != "0" ] ; then
        #ps -ef|grep java|grep "flume"|awk '{print $2;}'|xargs kill -9
        # 正常停止flume
        ps -ef|grep java|grep "flume"|awk '{print $2;}'|xargs kill
        echo "进程已经关闭..."
    else
        echo "服务未启动,无需停止..."
    fi
}
function restart(){
    local conf_path=""
    local conf_file=""
    local agent_name=""

    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
            -c|--conf)
                shift
                conf_path=$1
                ;;
            -f|--conf-file)
                shift
                conf_file=$1
                ;;
            -n|--name)
                shift
                agent_name=$1
                ;;
            -h|--help)
                usage start
                exit
                ;;
            *)
                echo >&2 "Invalid argument: $1"
                usage "start"
                exit
                ;;
            esac
        shift
        done
    else
        usage start
        exit
    fi
    echo "停止flume..."
    stop
    # 判断程序是否彻底停止
    num=`ps -ef|grep java|grep "flume"|wc -l`
    while [ $num -gt 0 ]; do
        sleep 1
        num=`ps -ef|grep java|grep "flume"|wc -l`
    done
    echo "flume停止,开始重启flume ..."
    start -c $conf_path -f $conf_file -n $agent_name
    echo "已启动 ..."
} 

args()
{
      if [ $# -ne 0 ]; then
            case $1 in
                start)
                    shift
                    start $@
                    ;;
                stop)
                    shift
                    stop
                    ;;
                restart)
                    shift
                    restart $@
                    ;;
                *)
                    echo "Invalid command:$1"
                    usage
                    ;;
            esac
      else
            usage
      fi
}
args $@
