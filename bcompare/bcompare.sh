#!/bin/bash
#######################################################################
    #'''
    #> File Name: bcompare.sh
    #> Author: cuiyf
    #> Mail: XXX@qq.com
    #> Created Time: Wed 30 May 2018 12:26:04 PM CST
    #'''
#######################################################################
set -x
# 获取当前目录
CUR=$(cd `dirname $0`;pwd)

. $CUR/conf/global.conf

# log
DEBUG=true
DATE=`date "+%Y%m%d%H"`
# log:log_info
log_info()
{
	local CUR_DIR=`pwd`
	local log_path=$CUR_DIR/log
	local access_log=$log_path/access_shell_$DATE.log
	if ! test -e $log_path
	then
    	mkdir -p $log_path
	fi

	if ! test -e $access_log
	then
		touch $access_log
	fi
	DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
	USER_N=`whoami`
	echo "[INFO] ${DATE_N} ${USER_N} $0 $@" >> $access_log

	if [ "$DEBUG"x = "true"x ]
	then
	    echo "[INFO] ${DATE_N} ${USER_N} $0 $@"
	fi

}

# log:log_error
log_error()
{
	local CUR_DIR=`pwd`
	local log_path=$CUR_DIR/log
	local error_log=$log_path/error_shell_$DATE.log
	if ! test -e $log_path
	then
    	mkdir -p $log_path
	fi
	if ! test -e $error_log
	then
		touch $error_log
	fi
	DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
	USER_N=`whoami`
	echo -e "[ERROR] [${DATE_N} ${USER_N} $0 $@]"  >> $error_log
	if [ "$DEBUG"x = "true"x ]
	then
	    echo -e "[ERROR]\033[41;37m ${DATE_N} ${USER_N} $0 $@ \033[0m"
	fi
}
# the usage of bcompare.sh
usage()
{
    case $1 in
        "")
            echo "Usage: bcompare.sh command [options]"
            echo "      for info on each command: --> bcompare.sh command -h|--help"
            echo "Commands:"
            echo "      bcompare.sh compare_diff_num [options]"
            echo "      bcompare.sh get_diff_list[options]"
            echo ""
            ;;
        compare_diff_num)
            echo "Usage: bcompare.sh compare_diff_num[-h|--help]"
            echo ""
            echo "  This is a quick example of using a bash script to compare ftp file numbers with hdfs file numbers:"
            echo ""
            echo "Params:"
            echo "      -s|--start start date(eg:20180520)"
            echo "      -e|--end end date(eg:20180528)"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./bcompare.sh compare_diff_num -s 20180520 -e 20180528"
            echo ""
            ;;
        get_diff_list)
            echo "Usage: bcompare.sh get_diff_list[-h|--help]"
            echo ""
            echo "  This is a quick example of using a bash script to create a file list between ftp and hdfs difference:"
            echo ""
            echo "Params:"
            echo "      -d|--day day_id(eg:20180528)"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./data_prbcompare.sh get_diff_list -d 20180528"
            echo ""
            ;;
    esac

}
# args for data_process.sh
args()
{
    if [ $# -ne 0 ]; then
        case $1 in
            compare_diff_num)
                shift
                compare_diff_num $@
                ;;
            get_diff_list)
                shift
                get_diff_list $@
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
# the test for parameter to print missing parameter.
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
# 获取两个时间段的列表
# @input:   generate_time_list 20180301 20180304
# @return:  (20180301 20180302 20180303 20180304)
generate_time_list()
{
    local date_beg=$1
    local date_end=$2
    local beg_s=`date -d "$date_beg" +%s`
    local end_s=`date -d "$date_end" +%s`
    while [ "$beg_s" -le "$end_s" ] ;do
            date -d "@$beg_s" +"%Y%m%d"
            beg_s=$((beg_s+86400))
    done
}
# 远程服务器和hadoop集群文件数量的核对
# @input:  compare_diff_num 20180525 20180528
# @return: [INFO] 2018-05-30 10:27:02 root diff.sh 20180526=>hdfs_num:1652, ftp_num:1652
compare_diff_num()
{
    local start_date=""
    local end_date=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -s|--start)
                    shift
                    start_date=$1
                    ;;
                -e|--end)
                    shift
                    end_date=$1
                    ;;
                -h|--help)
                    usage compare_diff_num
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "compare_diff_num"
                    exit
                    ;;
            esac
            shift
        done
    else
        usage compare_diff_num
        exit
    fi

    # determine if any option is missing
    test_parameter $start_date "-s|--start start date(eg:20180520)" compare_diff_num
    test_parameter $end_date "-e|--end end date(eg:20180528)" compare_diff_num
    for day in `generate_time_list $start_date $end_date`
    do
        hdfs_num=`hdfs dfs -ls /user/hdfs/iot/jasper/|grep "JWCC_$day"|wc -l`
        # 由于与FTP_IP建立了互信，所以不需要密码
        ftp_num=`ssh $FTP_NAME@$FTP_IP "ls /data/backup/jasper/jpo/*/$day/*.tar.gz|wc -l"`

        if [ $hdfs_num != $ftp_num ]
        then
            log_error "$day=>hdfs_num:$hdfs_num, ftp_num:$ftp_num"
        else
            log_info "$day=>hdfs_num:$hdfs_num, ftp_num:$ftp_num"
        fi
    done
}
get_diff_list()
{
    local cur_date=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -d|--day)
                    shift
                    cur_date=$1
                    ;;
                -h|--help)
                    usage get_diff_list
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "get_diff_list"
                    exit
                    ;;
            esac
            shift
        done
    else
        usage get_diff_list
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-d|--day day_id(eg:20180528)" get_diff_list
    local remote_dir=/user/hdfs/iot/jasper/
    local ftp_backup_dir=/data/backup/jasper/jpo

    # 远程服务器远程目录文件列表
    ssh $FTP_NAME@$FTP_IP "ls $ftp_backup_dir/*/$cur_date/*.tar.gz"|awk -F "/" '{print $NF}'|awk -F "." '{print $1}'|sort|uniq > $CUR/ftp_"$cur_date".txt

    # 本地HDFS集群文件列表
    hdfs dfs -ls $remote_dir |grep "JWCC_$cur_date"|awk '{print $NF}'|awk -F "/" '{print $NF}'|awk -F "." '{print $1}'| sort| uniq > $CUR/hdfs_"$cur_date".txt

    diff hdfs_"$cur_date".txt ftp_"$cur_date".txt |grep ">"
    rm -rf $CUR/ftp_"$cur_date".txt
    rm -rf $CUR/hdfs_"$cur_date".txt
}
args $@
