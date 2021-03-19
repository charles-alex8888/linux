# sftp
~~~ bash
sftp_dir=
mkdir -p $sftp_dir
groupadd sftp
useradd -g sftp -s /bin/false sftpuser -d $sftp_dir/sftpuser
echo "123456" | passwd --stdin sftpuser
chown root:sftp $sftp_dir # 
chmod 755 $sftp_dir 

mkdir -p $sftp_dir/sftpuser # 为用户建立子目录 
chown sftpuser:sftp $sftp_dir/sftpuser # 修改子目录所属用户和组 
chmod 755 $sftp_dir/sftpuser # 子目录授权 
~~~

# 配置 /etc/ssh/sshd_config
~~~ bash
Subsystem sftp internal-sftp
Match group sftp
ChrootDirectory $sftp_dir
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp
~~~
# 重启sshd服务
~~~ bash
sshd -t
systemctl restart sshd
~~~
