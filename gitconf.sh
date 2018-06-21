#!/bin/bash
#######################################################################
#	'''
#	> File Name: gitconf.sh
#	> Author: cyf
#	> Mail: XXX@qq.com
#	> Created Time: Fri 05 Aug 2016 11:46:47 AM CST
#	'''
#######################################################################
usage()
{
    case $1 in
        "")
            echo "Usage: gitconf.sh command [options]"
            echo "      for info on each command: --> bcompare.sh command -h|--help"
            echo "Commands:"
            echo "      gitconf.sh gitconf [options]"
            echo ""
            ;;
        gitconf)
            echo "Usage: gitconf.sh gitconf[-h|--help]"
            echo ""
            echo "  This is a quick example of using a bash script to configure git:"
            echo ""
            echo "Params:"
            echo "      -m|--mail login mail"
            echo "      -n|--name login name"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./gitconf.sh gitconf -m XX@qq.com -n XXX"
            echo ""
            ;;
    esac

}
# args for data_process.sh
args()
{
    if [ $# -ne 0 ]; then
        case $1 in
              gitconf)
                    shift
                    gitconf $@
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
test_parameter()
{
    local PARAMETER=$1
    local EXPLAIN=$2
    local APP=$3
    if [ x"$PARAMETER" = "x" ]; then
        echo "missing parameter: $EXPLAIN"
        usage $APP
        exit
    fi
}
gitconf()
{
    local mail=""
    local name=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -m|--mail)
                	shift
                	  mail=$1
                	  ;;
                -n|--name)
                	shift
                	name=$1
                	;;
                -h|--help)
                    usage gitconf
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "gitconf"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage gitconf
        exit
    fi

    # determine if any option is missing
    test_parameter $mail "-m|--mail login mail" gitconf
    test_parameter $name "-n|--name login name" gitconf
    #使用ssh-keygen命令生成密钥
    ssh-keygen -t rsa -C "$mail"

    #配置用户名和电子邮件
    git config --global user.name "$name"
    git config --global user.email "$mail"

    #配置默认使用的文本编辑器
    git config --global core.editor vim

    #配置差异分析工具
    git config --global merge.tool vimdiff
}
args $@
