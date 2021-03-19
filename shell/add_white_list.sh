#!/bin/bash


port=80

inqueryAll(){
   sudo iptables -nL INPUT --line-number | grep dpt:$port
}

inqueryOne(){
   sudo iptables -nL INPUT --line-number | grep dpt:$port | grep $1  > /dev/null
    [[ $? -eq 0 ]] && return 0 || return 1
}

insert(){
   sudo  iptables -I INPUT -p tcp -s $1 --dport $port -j ACCEPT
}

delete(){
    num=`sudo iptables -nL INPUT --line-number | grep dpt:$port | grep $1 | awk '{print $1}'`
    sudo iptables -D INPUT $num
}


if [ $1 == 'insert' ];then
    inqueryOne $2
    [[ $? -eq 1 ]] && insert $2 || echo 'this rule already exists!'
elif [ $1 == 'inquery' ];then
    inqueryAll
elif [ $1  == 'delete' ];then
    inqueryOne $2
    [[ $? -eq 0 ]] && delete $2 || echo 'this rule did not  exists!'
else
    inqueryOne $2
fi


sudo iptables-save > /etc/sysconfig/iptables
