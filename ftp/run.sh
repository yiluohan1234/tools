#!/bin/bash
#set -x
#[ `whoami` != "hdfs" ] && { echo "${CFAILURE}Error: You must be hdfs to run this script${CEND}"; exit 1; }

CUR=$(cd `dirname $0`;pwd)
. $CUR/conf/global.conf
APP="标签数据更新"
usage()
{
    case $1 in
        "")
            echo "Usage: run.sh command [options]"
            echo "      for info on each command: --> run.sh command -h|--help"
            echo "Commands:"
            echo "      run.sh get_list_ftp [options]"
            echo "      run.sh get_file_from_ftp[options]"
            echo "      run.sh del_ftp_file [options]"
            echo "      run.sh upload_hdfs[options]"
            echo "      run.sh get_the_new_file [options]"
            echo "      run.sh generate_time_list [options]"
            echo "      run.sh get_static[options]"
            echo ""
            ;;
        get_list_ftp)
            echo "Usage: run.sh get_list_ftp[-h|--help]"
            echo ""
            echo "  获取远程ftp服务器文件夹中的文件列表:"
            echo ""
            echo "Params:"
            echo "      -s|--ftp_string 远程服务器的相关信息,例如user:password:host"
            echo "      -r|--remote_dir 远程ftp服务器的文件夹路径"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh get_list_ftp -s user:password:host -r /data"
            echo ""
            ;;
        get_file_from_ftp)
            echo "Usage: run.sh get_file_from_ftp[-h|--help]"
            echo ""
            echo "  根据更新文件列表，从远程ftp服务器下载数据到本地文件夹:"
            echo ""
            echo "Params:"
            echo "      -s|--ftp_string 远程服务器的相关信息,例如user:password:host"
            echo "      -r|--remote_dir 远程ftp服务器的文件夹路径"
            echo "      -l|--local_dir 本地保存数据的文件夹"
            echo "      -f|--download_from_file 需要更新的文件列表"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh get_file_from_ftp -s user:password:host -r /data -l /data -f ./update.txt"
            echo ""
            ;;
        del_ftp_file)
            echo "Usage: run.sh del_ftp_file[-h|--help]"
            echo ""
            echo "  从远程ftp服务器删除文件:"
            echo ""
            echo "Params:"
            echo "      -s|--ftp_string 远程服务器的相关信息,例如user:password:host"
            echo "      -r|--remote_dir 远程ftp服务器的文件夹路径"
            echo "      -l|--local_dir 本地保存数据的文件夹"
            echo "      -f|--delete_files 删除文件的列表"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh del_ftp_file -s user:password:host -r /data -l /data -f ./delete.txt"
            echo ""
            ;;
        upload_hdfs)
            echo "Usage: run.sh upload_hdfs[-h|--help]"
            echo ""
            echo "  上传本地文件夹的文件到HDFS上:"
            echo ""
            echo "Params:"
            echo "      -l|--local_dir 本地存储数据的文件夹"
            echo "      -d|--hdfs_dir HDFS文件夹"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh upload_hdfs -l /data -d ./user/yyy/data"
            echo ""
            ;;
        get_the_new_file)
            echo "Usage: run.sh get_the_new_file[-h|--help]"
            echo ""
            echo "  根据远程的ftp文件列表与本地已经更新文件列表相对比，生成更新文件列表:"
            echo ""
            echo "Params:"
            echo "      -l|--list_file 远程服务器文件列表"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh get_the_new_file -l ./list.txt"
            echo ""
            ;;
        get_static)
            echo "Usage: run.sh get_static[-h|--help]"
            echo ""
            echo "  统计从ftp服务器下载文件的情况:"
            echo ""
            echo "Params:"
            echo "      -l|--local_dir 本地数据存储文件加"
            echo "      -t|--diff_time 程序执行的时间"
            echo "      -a|--app_name 下载的是什么类型文件"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh get_static -l ./list.txt -t 20 -a label"
            echo ""
            ;;
        generate_time_list)
            echo "Usage: run.sh generate_time_list[-h|--help]"
            echo ""
            echo "  生成一个日期的列表:"
            echo ""
            echo "Params:"
            echo "      -s|--start_time 开始时间"
            echo "      -e|--end_time 结束时间"
            echo "      -h|--help: print this help info and exit"
            echo "Examples:"
            echo ""
            echo "        ./run.sh generate_time_list -s ./list.txt -e 20"
            echo ""
            ;;
    esac
}
# args for data_process.sh
args()
{
    if [ $# -ne 0 ]; then
        case $1 in
            get_list_ftp)
                shift
                get_list_ftp $@
                ;;
            get_file_from_ftp)
                shift
                get_file_from_ftp $@
                ;;
            del_ftp_file)
                shift
                del_ftp_file $@
                ;;
            upload_hdfs)
                shift
                upload_hdfs $@
                ;;
            get_the_new_file)
                shift
                get_the_new_file $@
                ;;
            generate_time_list)
                shift
                generate_time_list $@
                ;;
            get_static)
                shift
                get_static $@
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
# 获取远程ftp服务器文件夹中的文件列表
# @param: ftp_string remote_dir
# ftp_string->远程服务器的相关信息，格式：user:password:host
# remote_dir->远程ftp服务器的文件夹路径
get_list_ftp()
{
    local ftp_string=""
    local remote_dir=""
    local cur_date=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -s|--ftp_string)
                    shift
                    ftp_string=$1
                    ;;
                -r|--remote_dir)
                    shift
                    remote_dir=$1
                    ;;
                -h|--help)
                    usage get_list_ftp
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "get_list_ftp"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage get_list_ftp
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-s|--ftp_string 远程服务器的相关信息,例如user:password:host" get_list_ftp
    test_parameter $cur_date "-r|--remote_dir 远程ftp服务器的文件夹路径" get_list_ftp

    local user=`echo $ftp_string|awk -F ":" '{print $1}'`
    local password=`echo $ftp_string|awk -F ":" '{print $2}'`
    local host=`echo $ftp_string|awk -F ":" '{print $3}'`
    log_info "$APP开始获取文件..."
    #lftp -e 'ls;quit' ftp://$user:$password@$host/$remote_dir|sed '1,2d'|awk '{print $NF}' > $remote_list
    lftp -e "cd $remote_dir;ls;quit" $user:$password@$host|sed '1,2d'|awk '{print $NF}' > $CUR_DIR/list.txt
    nums_files=`cat $CUR_DIR/list.txt|wc -l`
    if [ $? -ne 0 ]; then
        log_error "[$APP] [获取文件] [error]"
    else
        log_info "[$APP] [获取文件] [文件数量:$nums_files]"
    fi
}

# 根据更新文件列表，从远程ftp服务器下载数据到本地文件夹
# @param：ftp_string remote_dir local_dir download_from_file
# ftp_string->远程服务器的相关信息，格式：user:password:host
# remote_dir->远程ftp服务器的文件夹路径
# local_dir->本地保存数据的文件夹
# download_from_file-> 需要更新的文件列表
# wget --ftp-user=jspftp --ftp-password=qeAD13$ ftp://172.30.107.4//data/cyf_test/1.txt -o wget.log -O /data/cyf/1.txt
get_file_from_ftp()
{
    local ftp_string=""
    local remote_dir=""
    local local_dir=""
    local download_from_file=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -s|--ftp_string)
                    shift
                    ftp_string=$1
                    ;;
                -r|--remote_dir)
                    shift
                    remote_dir=$1
                    ;;
                 -l|--local_dir)
                    shift
                    local_dir=$1
                    ;;
                 -f|--download_from_file)
                    shift
                    download_from_file=$1
                    ;;
                -h|--help)
                    usage get_file_from_ftp
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "get_file_from_ftp"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage get_file_from_ftp
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-s|--ftp_string 远程服务器的相关信息,例如user:password:host" get_file_from_ftp
    test_parameter $cur_date "-r|--remote_dir 远程ftp服务器的文件夹路径" get_file_from_ftp
    test_parameter $cur_date "-l|--local_dir 本地保存数据的文件夹" get_file_from_ftp
    test_parameter $cur_date "-f|--download_from_file 需要更新的文件列表" get_file_from_ftp

    local user=`echo $ftp_string|awk -F ":" '{print $1}'`
    local password=`echo $ftp_string|awk -F ":" '{print $2}'`
    local host=`echo $ftp_string|awk -F ":" '{print $3}'`
    log_info "$APP开始下载文件..."

    test -e $local_dir || mkdir -p $local_dir
    for file in `cat $download_from_file`
    do
        #lftp ftp://$USER:$PASSWORD@$HOST  -e "get $remote_dir/$file -o $local_dir; bye"
        # 通过wget下载文件
        wget --ftp-user=$user --ftp-password=$password ftp://$host/$remote_dir/$file -O $local_dir/$file
        if [ $? -ne 0 ]; then
            log_error "[$APP] [下载文件] [error]"
        else
            log_info "[$APP] [下载文件] [$file]"
        fi
    done
}

# 从远程ftp服务器删除文件
# @param ftp_string remote_dir delete_files
# ftp_string->远程服务器的相关信息，格式：user:password:host
# remote_dir->远程ftp服务器的文件夹路径
# delete_files->删除文件的列表
del_ftp_file()
{
    local ftp_string=""
    local remote_dir=""
    local delete_files=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -s|--ftp_string)
                    shift
                    ftp_string=$1
                    ;;
                -r|--remote_dir)
                    shift
                    remote_dir=$1
                    ;;
                 -f|--delete_files)
                    shift
                    delete_files=$1
                    ;;
                -h|--help)
                    usage del_ftp_file
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "del_ftp_file"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage del_ftp_file
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-s|--ftp_string 远程服务器的相关信息,例如user:password:host" del_ftp_file
    test_parameter $cur_date "-r|--remote_dir 远程ftp服务器的文件夹路径" del_ftp_file
    test_parameter $cur_date "-f|--delete_files 删除文件的列表" del_ftp_file

    local user=`echo $ftp_string|awk -F ":" '{print $1}'`
    local password=`echo $ftp_string|awk -F ":" '{print $2}'`
    local host=`echo $ftp_string|awk -F ":" '{print $3}'`

    for file in `cat $delete_files`
    do
        log_info "$APP开始删除文件..."
        lftp ftp://$user:$password@$host  -e "cd $remote_dir;rm $file;quit"
        if [ $? -ne 0 ]; then
            log_error "[$APP] [删除文件] [error]"
        else
            log_info "[$APP] [删除文件] [$file]"
        fi
    done
}

# 上传本地文件夹的文件到HDFS上
# @parm local_dir hdfs_dir
# local_dir->本地存储数据的文件夹
# hdfs_dir->HDFS文件夹
upload_hdfs()
{
    local local_dir=""
    local hdfs_dir=""
    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -l|--local_dir)
                    shift
                    local_dir=$1
                    ;;
                -d|--hdfs_dir)
                    shift
                    hdfs_dir=$1
                    ;;
                -h|--help)
                    usage upload_hdfs
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "upload_hdfs"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage upload_hdfs
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-l|--local_dir 本地存储数据的文件夹" upload_hdfs
    test_parameter $cur_date "-d|--hdfs_dir HDFS文件夹" upload_hdfs

    log_info "$APP开始上传文件..."
    hdfs dfs -put $local_dir/* $hdfs_dir
    upload_files_nums=`ls -l $local_dir|sed '1d'|wc -l`
    if [ $? -ne 0 ]; then
        log_error "[$APP] [上传文件] [error]"
    else
        log_info "[$APP] [上传文件] [$upload_files_nums]"
    fi
}

# 生成一个日期的列表
# @param date_beg date_end
# date_beg->开始的时间(yyyymmdd)
# date_end->结束的时间(yyyymmdd)
generate_time_list()
{
    local date_beg=""
    local date_end=""
    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -s|--start_time)
                    shift
                    date_beg=$1
                    ;;
                -e|--end_time)
                    shift
                    date_end=$1
                    ;;
                -h|--help)
                    usage generate_time_list
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "generate_time_list"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage generate_time_list
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-s|--start_time 开始时间" generate_time_list
    test_parameter $cur_date "-e|--end_time 结束时间" generate_time_list

    beg_s=`date -d "$date_beg" +%s`
    end_s=`date -d "$date_end" +%s`
    while [ "$beg_s" -le "$end_s" ] ;do
        date -d "@$beg_s" +"%Y%m%d"
        beg_s=$((beg_s+86400))
    done
}

# 根据远程的ftp文件列表与本地已经更新文件列表相对比，生成更新文件列表
# @param list_file
# list_file->远程服务器文件列表
get_the_new_file()
{
    local list_file=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -l|--list_file)
                    shift
                    list_file=$1
                    ;;
                -h|--help)
                    usage get_the_new_file
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "get_the_new_file"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage get_the_new_file
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-l|--list_file 远程服务器文件列表" get_the_new_file

    local done_file=$CUR_DIR/done.txt
    local done_sort_file=$CUR_DIR/done_sort.txt
    local list_sort_file=$CUR_DIR/list_sort.txt
    test -e $done_file || touch $done_file
    test -e $done_sort_file || touch $done_sort_file
    test -e $list_sort_file || touch $list_sort_file
    log_info "$APP生成待更新列表..."
    cat $done_file|sort|uniq > $done_sort_file
    cat $list_file |sort|uniq > $list_sort_file
    diff $done_sort_file $list_sort_file|grep ">"|awk '{print $NF}'>$CUR_DIR/update.txt
    cat $CUR_DIR/update.txt >> $CUR_DIR/done.txt

    # 删除中间文件
    rm -rf $done_sort_file $list_sort_file
}

# 统计从ftp服务器下载文件的情况
# @param local_dir diff app_name
# local_dir->本地数据存储文件加
# diff->程序执行的时间
# app_name->下载的是什么类型文件
get_static()
{
    local local_dir=""
    local diff_time=""
    local app_name=""

    # process args for this block
    if [ $# -ne 0 ]; then
        while test $# -gt 0
        do
            case $1 in
                -l|--local_dir)
                    shift
                    local_dir=$1
                    ;;
                -t|--diff_time)
                    shift
                    diff_time=$1
                    ;;
                 -a|--app_name)
                    shift
                    app_name=$1
                    ;;
                -h|--help)
                    usage get_static
                    exit
                    ;;
                *)
                    echo >&2 "Invalid argument: $1"
                    usage "get_static"
                    exit
                    ;;
            esac
        shift
        done
    else
        usage get_static
        exit
    fi

    # determine if any option is missing
    test_parameter $cur_date "-l|--local_dir 本地数据存储文件加" get_static
    test_parameter $cur_date "-t|--diff_time 程序执行的时间" get_static
    test_parameter $cur_date "-a|--app_name 下载的是什么类型文件" get_static

    local update_d=`date +%Y%m%d`
    local DATA_ROOM=`du -b $local_dir|awk '{SUM += $1} END {printf "%d\n", SUM/(1024*1024)}'`
    local DATA_COUNT=`ls -l $local_dir|sed '1d'|wc -l`
    local local_size=`df -h|grep "/data"|awk '{print $2}'`
    local local_size_d=${local_size%T*}
    local local_used=`df -h|grep "/data"|awk '{print $3}'`
    local local_used_d=${local_used%T*}
    local local_used_p=`df -h|grep "/data"|awk '{print $5}'`
    local local_used_p_d=${local_used_p%\%*}

    log_info "update_time:$update_d,file_type:$app_name,file_nums:$DATA_COUNT,file_disk:$DATA_ROOM,using_time:$diff_time,local_size:$local_size_d,local_used:$local_used_d,local_used_p:$local_used_p_d"
    log_info "
*****************************************************************
*                                                               *
*               探针项目数据更新情况                            *
*****************************************************************
                #更新时间:$update_d
                #数据数量:$DATA_COUNT
                #数据大小:$DATA_ROOM M
                #用    时:$diff_time s
                #HDFS目录:$HDFS_DIR_TANZHEN
                #日志文件:$CUR_DIR/log
**************************数据更新完成！*************************"
    INSERTSQL="INSERT INTO $MYSQL_DB_NAME_O.$MYSQL_TABLE_NAME_O (update_date,file_type,file_num,space_size,filesystem_used,filesystem_size,filesystem_use_percentage,exec_time) VALUES(\"$update_d\",\"$app_name\",$DATA_COUNT,$DATA_ROOM,$local_used_d,$local_size_d,$local_used_p_d,$diff_time);"
    echo $INSERTSQL|$mysqlCMDODS
}
main_execute()
{
    # 设置ftp信息、本地数据保存位置和hdfs的位置等
    local user=$USER_LABEL
    local password=$PASSWORD_LABEL
    local host=$HOST
    local ftp_dir=$FTP_DIR_LABEL
    local ftp_list=$CUR_DIR/list.txt
    local update_files_list=$CUR_DIR/update.txt
    local local_data_diretory=$CUR_DIR/data
    local hdfs_dir=$HDFS_DIR_LABEL
    local app_name="label"

    start_time=`date +%s`
    # 第一个变量为ftp相关的变量，第二个变量为远程ftp的文件夹
    args get_list_ftp -s $user:$password:$host -r $ftp_dir
    # 根据生成的ftp文件夹内的文件列表生成更新文件列表
    args get_the_new_file -l $ftp_list    
    if [ -s $update_files_list ]; then
        # 从ftp上根据更新文件列表，更细你数据到本地
        args get_file_from_ftp -s $user:$password:$host -r $ftp_dir -l $local_data_diretory -f $update_files_list
        # 上传文件到hdfs文件夹
        args upload_hdfs -l $local_data_diretory -d $hdfs_dir
        # 收集汇总数据
        end_time=`date +%s`
        diff=$[ end_time - start_time  ]
        args get_static -l ftp_list -t $diff -a $app_name
        get_static $local_data_diretory $diff $app_name
        rm -rf $ftp_list $local_data_diretory/* $update_files_list
    else
        end_time=`date +%s`
        diff=$[ end_time - start_time  ]
        get_static $local_data_diretory $diff $app_name
        rm -rf $ftp_list $update_files_list
        log_info "[$APP] [数据无更新]"
    fi
}

args $@

