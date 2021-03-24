# rocketmq部署
##  1.下载
> wget https://apache.claz.org/rocketmq/4.8.0/rocketmq-all-4.8.0-source-release.zip

##  2.解压、打包
~~~ bash
unzip rocketmq-all-4.8.0-source-release.zip
cd rocketmq-all-4.8.0/
mvn -Prelease-all -DskipTests clean install -U
cd distribution/target/rocketmq-4.8.0/rocketmq-4.8.0
~~~

## 3. Start Name Server
> nohup sh bin/mqnamesrv &

## 4. Start Broker
> nohup sh bin/mqbroker -n localhost:9876 &
#### 关闭 
~~~ bash
sh bin/mqshutdown broker
sh bin/mqshutdown namesrv
~~~

# web console部署
## 1. 下载
> git clone  https://github.com/apache/rocketmq-externals.git

## 2. 配置
~~~ bash
cd rocketmq-externals/rocketmq-console/
sed -i s/rocketmq.config.namesrvAdd/rocketmq.config.namesrvAddr=localhost:9876/g src/main/resources/application.properties
~~~

## 3. 打包
mvn clean package -Dmaven.test.skip=true

## 4. 运行
> java -jar target/rocketmq-console-ng-1.0.0.jar [--rocketmq.config.namesrvAddr='localhost:9876']


# 配置外网访问
~~~ bash
cat <<'EOF' >> conf/broker.conf
namesrvAddr={ip}:9876
brokerIP1={ip}
brokerIP1={ip}
autoCreateTopicEnable=true 
EOF

# 停止broker
sh bin/mqshutdown broker
# 启动broker
nohup sh bin/mqbroker -c conf/broker.conf &
~~~



