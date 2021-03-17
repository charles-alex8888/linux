#!/bin/bash

yum install -y java-1.8.0-openjdk
yum install -y java-1.8.0-openjdk-devel.x86_64
URL=`ls -lrt /etc/alternatives/java | awk '{print $NF}'`
PATH=${URL%/jre*}
ls -lrt /usr/bin/java 
cat <<'EOF' > /etc/profile.d/jdk.sh
export JAVA_HOME=$PATH
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$PATH
EOF
source /etc/profile
