#!/bin/bash
CUR=$(cd `dirname $0`;pwd)
day=201801
main()
{
local month=$1
local prov_id=$2
$SPARK_HOME/bin/spark-submit --class com.unicom.cuiyufei.O_statics \
    --master spark://172.18.50.72:7077 \
    --total-executor-cores 225 \
    --executor-memory 6g \
    --executor-cores 3 \
    --driver-memory 1g \
    --conf spark.default.parallelism=500 \
    --conf spark.shuffle.consolidateFiles=true \
    --conf spark.storage.memoryfraction=0.8 \
    --conf spark.shuffle.memoryfraction=0.3 \
    $CUR/IOT.jar \
    $month $prov_id
}
month=201804
prov_id=085
main $month $prov_id

# 资源配置说明
# 参数说明：
#         num-executors：
#                       参数名称：Executor数量
#                       参数调优建议：每个Spark作业的运行一般设置50~100个左右的Executor进程比较合适
#         executor-memory：
#                       参数名称：每个Executor的内存
#                       参数调优建议：每个Executor进程的内存设置4G~8G较为合适。
#         executor-cores：
#                       参数名称：每个Executor进程的CPU core数量
#                       参数调优建议：Executor的CPU core数量设置为2~4个较为合适
#         driver-memory：
#                       参数名称：用于设置Driver进程的内存
#                       参数调优建议：Driver的内存通常来说不设置，或者设置1G左右应该就够了
#         spark.default.parallelism：
#                       参数名称：设置每个stage的默认task数量
#                       参数调优建议：Spark作业的默认task数量为500~1000个较为合适，
#                       Spark官网建议的设置原则是，设置该参数为num-executors * executor-cores的2~3倍较为合适
#         spark.storage.memoryFraction：
#                       参数名称：设置RDD持久化数据在Executor内存中能占的比例，默认是0.6
#                       参数调优建议：如果Spark作业中，有较多的RDD持久化操作，该参数的值可以适当提高一些，
#                       保证持久化的数据能够容纳在内存中。避免内存不够缓存所有的数据，导致数据只能写入磁盘中，
#                       降低了性能。但是如果Spark作业中的shuffle类操作比较多，而持久化操作比较少，
#                       那么这个参数的值适当降低一些比较合适。此外，如果发现作业由于频繁的gc导致运行缓慢（通过spark
#                       web ui可以观察到作业的gc耗时），意味着task执行用户代码的内存不够用，那么同样建议调低这个参数的值。
#         spark.shuffle.memoryFraction：
#                       参数名称：设置shuffle过程中一个task拉取到上个stage的task的输出后，
#                       进行聚合操作时能够使用的Executor内存的比例，默认是0.2
#                       参数调优建议：如果Spark作业中的RDD持久化操作较少，shuffle操作较多时，建议降低持久化操作的内存占比，
#                       提高shuffle操作的内存占比比例，避免shuffle过程中数据过多时内存不够用，必须溢写到磁盘上，降低了性能。
#                       此外，如果发现作业由于频繁的gc导致运行缓慢，意味着task执行用户代码的内存不够用，那么同样建议调低这个参数的值。
#
#
#         上述代码中 total-executor-cores=num-executors*executor-cores(仅供参考)
#         官网地址：http://spark.apache.org/docs/2.1.0/submitting-applications.html
#         博客参考：https://blog.csdn.net/u012102306/article/details/51637366

