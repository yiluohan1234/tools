#!/bin/bash
#######################################################################
    #'''
    #> File Name: args.sh
    #> Author: cuiyf
    #> Mail: XXX@qq.com
    #> Created Time: Wed 30 May 2018 01:00:39 PM CST
    #'''
#######################################################################
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
                          start_date=$1
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

      .
      .
      主要逻辑代码
      .
      .


}
args $@
