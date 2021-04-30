#!/bin/bash

yum -y install iptables
yum install iptables-services
systemctl start iptables
systemctl enable iptables

iptables -P INPUT ACCEPT
iptables -F
iptables -X
iptables -Z

  
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


iptables -P INPUT DROP
iptables -P OUTPUT DROP
service iptables save



# 安装
> yum -y install ipset

# 创建一个set
## hash:net 指定可以向集合添加ip段或ip地址，
> ipset create blacklist hash:net hashsize 4096 maxelem 100000 timeout 300
## hash:ip 指定可以向集合添加ip地址
> ipset create whitelist hash:net hashsize 4096 maxelem 1000000

# 添加删除、删除ip
> ipset add blacklist 10.10.10.0/24 timeout 60

> ipset del blacklist 10.10.10.0/24

# 查看set内容
> ipset list blacklist

# 创建防火墙规则
> iptabels -A INPUT -m set --match-set blacklist src -j DROP

# 保存
> ipset save blacklist -f blacklist.txt

# 删除ipset
> ipset destroy blacklist

# 清空
> ipset flush blacklist
# 导入ipset规则
> ipset restore -f blacklist.txt

# 封禁多个端口
> iptables -A INPUT -p tcp -m set --match-set blacklist src -m multiport --dports 443,80 -j DROP

