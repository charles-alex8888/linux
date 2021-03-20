# 编译安装nodejs
~~~ bash
install_dir={path}
wget https://npm.taobao.org/mirrors/node/v11.0.0/node-v11.0.0.tar.gz
tar -xf node-v11.0.0.tar.gz
cd node-v11.0.0
./configure  --prefix=$install_dir
make && make install

cat <<'EOF' > /etc/profile.d/nodejs.sh

export NODE_HOME=$install_dir
export PATH=$PATH:$NODE_HOME/bin 
export NODE_PATH=$NODE_HOME/lib/node_modules
EOF

source /etc/profile
~~~

# yum安装 
~~~ bash
# 安装源
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
yum -y install nodejs
# 验证
node -v  
npm -v 
# 查看镜像地址
npm get registry

# 替换成淘宝的：
npm config set registry http://registry.npm.taobao.org/
# 恢复成原来的镜像地址：
npm config set registry https://registry.npmjs.org/
# 使用淘宝定制的cnpm工具来代替默认的npm：
npm install -g cnpm --registry=https://registry.npm.taobao.org
~~~
