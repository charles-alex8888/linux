# nfs服务端
~~~ bash
# 安装
yum install -y nfs-utils  rpcbind tcp_wrappers
systemctl start nfs
systemctl enable nfs
# 配置
mkdir /nfs_data
cat <<'EOF' > /etc/exports
/nfs_data *(rw,sync,insecure,no_subtree_check,no_root_squash)
EOF
~~~

# nfs客户端
yum install -y nfs-utils 
