# nfs服务端
~~~ bash
# 安装
yum install -y nfs-utils  rpcbind tcp_wrappers
systemctl start nfs
systemctl enable nfs
# 配置
mkdir /nfs_data
chown nfsnobody.nfsnobody /nfs_data
cat <<'EOF' > /etc/exports
/nfs_data *(rw,sync,insecure,no_subtree_check,no_root_squash)
EOF
# 重启
systemctl restart nfs
# 重载
systemctl reload nfs
~~~

# nfs客户端
~~~ bash
# 安装
yum install -y nfs-utils 
# 挂载
showmount -e $nfs_server_ip
mount -t nfs $nfs_server_ip:/nfs_data /mnt
~~~

