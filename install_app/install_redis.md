# 安装redis
~~~ bash
INSTALL_DIR={path}
RELEASE_VERSION=5.0.0
IP_SEGMENT={}
useradd redis
mkdir -pv $INSTALL_DIR/redis/{conf,logs,data}

wget http://download.redis.io/releases/redis-$RELEASE_VERSION.tar.gz
tar -xf redis-$RELEASE_VERSION.tar.gz
cd redis-$RELEASE_VERSION
make install PREFIX=$INSTALL_DIR/redis
cp redis.conf $INSTALL_DIR/redis/conf/
chown -R redis.redis $INSTALL_DIR/redis

cd $INSTALL_DIR/redis
sed -i 's/appendonly no/appendonly yes/' conf/redis.conf
sed -i '/^dir/d' conf/redis.conf
echo "dir $INSTALL_DIR/redis/data" >> conf/redis.conf
echo "requirepass `< /dev/urandom tr -cd _A-Z-a-z-0-9@#^ | head -c ${1:-20}; echo`"  >> conf/redis.conf

sed -i 's/bind 127.0.0.1/bind 127.0.0.1 $IP_SEGMENT/' conf/redis.conf
sed -i 's/protected-mode yes/protected-mode no/' conf/redis.conf
~~~

# 配置成系统服务
~~~ bash
cat <<'EOF' > /usr/lib/systemd/system/redis.service
[Unit]
Description=Redis Server Manager
After=syslog.target
After=network.target

[Service]
Type=simple
User=redis
Group=redis
PIDFile=/var/run/redis_6379.pid
ExecStart=$INSTALL_DIR/redis/bin/redis-server $INSTALL_DIR/redis/conf/redis.conf
ExecStop=$INSTALL_DIR/redis/bin/redis-cli shutdown
Restart=always
#ReadWriteDirectories=$INSTALL_DIR/redis/data
[Install]
WantedBy=multi-user.target
EOF
~~~
# 启动
~~~ bash
systemctl start redis
systemctl enable redis
~~~
