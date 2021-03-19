#!/bin/bash
# 安装maven
cd /usr/local/
wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xf apache-maven-3.6.3-bin.tar.gz 

cat <<'EOF' > /etc/profile.d/maven.sh
export MAVEN_HOME=/usr/local/apache-maven-3.6.3
export PATH=$MAVEN_HOME/bin:$PATH
EOF
source /etc/profile
mvn -version
