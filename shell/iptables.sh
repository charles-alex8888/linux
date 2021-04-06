#!/bin/bash

yum -y install iptables
yum install iptables-services
systemctl start iptables
systemctl enable iptables

iptables -P INPUT ACCEPT
iptables -F
  
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


