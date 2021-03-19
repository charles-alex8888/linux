# /bin/bash

# 日志保存位置
base_path=$NGINX_HOME/logs

# 获取当前年信息和月信息
log_path=$(date -d"+1 day ago" +"%F")
echo $log_path

# 获取昨天的日信息
#day=$(date -d"+1 day ago" +"%F")
#echo $day

# 按年月创建文件夹
mkdir -p $base_path/$log_path

# 备份昨天的日志到当月的文件夹
cd $base_path
for logfile in `ls -l *.log|awk '{print $NF}'`
do
    echo $logfile
    mv $base_path/$logfile $base_path/$log_path/$logfile
done
# 通过Nginx信号量控制重读日志
kill -USR1 `cat nginx.pid`
