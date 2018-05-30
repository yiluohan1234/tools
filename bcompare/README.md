# README
在从ftp传输文件到本地hdfs的过程中，需要核对远程ftp服务器和本地hadoop集群之间的数据量
本文件提供数据量的比较和数据相差的列表
- compare_diff_num 比较数据量
- get_diff_list 生成相差数据的列表

## 使用方法
```
[root@cdh10 bcompare]# sh bcompare.sh
Usage: bcompare.sh command [options]
      for info on each command: --> bcompare.sh command -h|--help
Commands:
      bcompare.sh compare_diff_num [options]
      bcompare.sh get_diff_list[options]
```

```
[root@cdh10 bcompare]# sh bcompare.sh compare_diff_num
Usage: bcompare.sh compare_diff_num[-h|--help]

  This is a quick example of using a bash script to compare ftp file numbers with hdfs file numbers:

Params:
      -s|--start start date(eg:20180520)
      -e|--end end date(eg:20180528)
      -h|--help: print this help info and exit
Examples:

        ./bcompare.sh compare_diff_num -s 20180520 -e 20180528
```
比较数据量
```
sh bcompare.sh compare_diff_num -s 20180520 -e 20180528
```
生成相差文件列表
```
sh data_prbcompare.sh get_diff_list -d 20180528
```
screen_shot
![](https://github.com/yiluohan1234/tools/blob/master/bcompare/screen_shot_diff.png)
