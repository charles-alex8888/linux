# 安装nodejs
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
