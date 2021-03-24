#!/bin/bash
host=`sudo ip a s | grep 172.16.0 | awk '{print $2}' | awk -F "/" '{print $1}'`
hostname=`hostname`
ACTIVE_NAME=${hostname%-*}prod


SRC_PATH=
JAR=
JAR_PATH=
HOST_IP=$host
#MONITOR_PORT=
SERVER_PORT=

# switch into product path
cd $JAR_PATH

if [ ! -d "back" ];then
    mkdir -v back
fi

act=$1
if [ "$act" == "" ];then
    act='update'
fi

function count()
{
    echo `ps -ef | grep java | grep -v grep | grep $SERVER_PORT |grep $JAR | wc -l`
}


function run()
{
nohup java -Djava.rmi.server.hostname=$HOST_IP \
      -jar $JAR \
      --server.port=$SERVER_PORT \
      --spring.profiles.active=$ACTIVE_NAME \
      --spring.cloud.nacos.config.enabled=true \
       > output.log 2>&1 &
#      -Dcom.sun.management.jmxremote \
#      -Dcom.sun.management.jmxremote.port=$MONITOR_PORT \
#      -Dcom.sun.management.jmxremote.authenticate=false \
#      -Dcom.sun.management.jmxremote.ssl=false \
}


function start_process()
{
    ret=`count`
    if [ $ret -ne 0 ];then
        echo "$JAR is running..."
    else
        run
        sleep 2
        ret=`count`
        [[ $ret -ne 0 ]] && echo "$JAR start successfully..." || echo "$JAR start failed..."
    fi
}

function stop_process()
{
    ret=`count`
    if [ $ret -ne 0 ];then
        echo "Stop $JAR..."
        boot_id=`ps -ef | grep java | grep -v grep | grep $SERVER_PORT | grep $JAR| awk '{print $2}'`
        kill -9 $boot_id
    fi
        sleep 2
}

function restart_process()
{
        stop_process
        start_process
}


function update()
{
    \cp -f $JAR back/$JAR-`date +%Y_%m_%d-%H-%M-%S`
    \cp -f $JAR bk-$JAR
    stop_process
    \cp -f $SRC_PATH/$JAR $JAR
    start_process
}

function rollback()
{
    stop_process
    \cp -f bk-$JAR $JAR
    start_process
}

case $act in
        start)
        start_process;;
        stop)
        stop_process;;
        restart)
        restart_process;;
        update)
        update;;
        rollback)
        rollback;;
        *)

        echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status}  {SpringBootJarName} \033[0m
\033[0;31m Example: \033[0m
          \033[0;33m sh  $0  start esmart-test.jar \033[0m"
esac
