前期准备：
[root@localhost ~]# systemctl stop firewalld
[root@localhost ~]# systemctl stop iptables
[root@localhost ~]# systemctl disable firewalld
[root@localhost ~]# systemctl disable iptables
[root@localhost ~]# getenforce 
Disabled
[root@localhost ~]# grep -Ei 'vmx|svm' /proc/cpuinfo

[root@localhost ~]#yum update -y

安装kvm：
[root@localhost ~]# yum install -y  virt-*  libvirt  bridge-utils qemu-img

安装完kvm后，需要配置一下网卡，增加一个桥接网卡：

[root@localhost ~]# cd /etc/sysconfig/network-scripts/


[root@localhost /etc/sysconfig/network-scripts]# cp ifcfg-eno16777728 ifcfg-br0  # 拷贝当前的网卡文件


[root@localhost /etc/sysconfig/network-scripts]# vim ifcfg-eno16777728  # 修改文件内容如下

TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eno16777728
DEVICE=eno16777728
ONBOOT=yes
BRIDGE=br0

[root@localhost /etc/sysconfig/network-scripts]# vim ifcfg-br0  # 修改文件内容如下
TYPE=Bridge
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=br0
DEVICE=br0
ONBOOT=yes

[root@localhost /etc/sysconfig/network-scripts]# systemctl restart network  # 重启服务


接下来我们就可以启动kvm服务了：
[root@localhost ~]# lsmod |grep kvm  # 检查KVM模块是否加载
kvm_intel             162153  0 
kvm                   525259  1 kvm_intel

[root@localhost ~]# systemctl start libvirtd  # 启动libvirtd服务

[root@localhost ~]# ps aux |grep libvirtd  # 检查服务进程

root       5744  2.2  0.1 614840 14120 ?        Ssl  23:02   0:00 /usr/sbin/libvirtd
root       5872  0.0  0.0 112664   964 pts/1    R+   23:02   0:00 grep --color=auto libvirtd

[root@localhost ~]# brctl show  # 可以看到两个网卡
bridge name bridge id       STP enabled interfaces
br0     8000.000c29f1912c   no      eno16777728  # 我们配置的桥接网卡
virbr0      8000.525400240b50   yes     virbr0-nic  # NAT模式的网卡

创建虚拟机安装Centos7

[root@localhost ~]# cd /tmp/
[root@localhost /tmp]# ls |grep CentOS
CentOS-7-x86_64-DVD-1511.iso
[root@localhost /tmp]# 


[root@localhost ~]# virt-install --name=study01 --memory=512,maxmemory=1024 --vcpus=1,maxvcpus=2 --os-type=linux --os-variant=rhel7 --location=/tmp/CentOS-7-x86_64-DVD-1511.iso --disk path=/kvm_data/study01.img,size=10 --bridge=br0 --graphics=none --console=pty,target_type=serial  --extra-args="console=tty0 console=ttyS0"

virt-install --name=python --memory=4096,maxmemory=4096 --vcpus=2,maxvcpus=2 --os-type=linux --os-variant=rhel7 --location=/tmp/CentOS-7-x86_64-DVD-1810.iso --disk path=/kvm_data/python,size=50 --bridge=br0 --graphics=none --console=pty,target_type=serial  --extra-args="console=tty0 console=ttyS0"


命令说明：

--name 指定虚拟机的名称
--memory 指定分配给虚拟机的内存资源大小
maxmemory 指定可调节的最大内存资源大小，因为KVM支持热调整虚拟机的资源
--vcpus 指定分配给虚拟机的CPU核心数量
maxvcpus 指定可调节的最大CPU核心数量
--os-type 指定虚拟机安装的操作系统类型
--os-variant 指定系统的发行版本
--location 指定ISO镜像文件所在的路径，支持使用网络资源路径，也就是说可以使用URL
--disk path 指定虚拟硬盘所存放的路径及名称，size 则是指定该硬盘的可用大小，单位是G
--bridge 指定使用哪一个桥接网卡，也就是说使用桥接的网络模式
--graphics 指定是否开启图形
--console 定义终端的属性，target_type 则是定义终端的类型
--extra-args 定义终端额外的参数

接着就是一些安装的文本选项

到Installation complete. Press return to quit 界面，回车即可



重启之后会进入一个登陆界面，可以看到我们这里是登录成功的：
CentOS Linux 7 (Core)
Kernel 3.10.0-514.el7.x86_64 on an x86_64

localhost login: 


这时我们是处于一个虚拟终端的，因为安装了虚拟机，如果要退出来的话，应该说是切出来，按 Ctrl + ] 即可。

切出来后，可以看到/kvm_data/目录下多出了一个虚拟机的磁盘目录

[root@localhost ~]# ls /kvm_data/
lost+found  study01.img
[root@localhost ~]#

 
查看kvm进程：
[root@localhost ~]# ps axu |grep kvm
root        880  0.0  0.0      0     0 ?        S<   Mar07   0:00 [kvm-irqfd-clean]
qemu       6528  6.9  9.1 1568008 734216 ?      Sl   00:15   0:40 /usr/libexec/qemu-kvm -name study01 -S -machine pc-i440fx-rhel7.0.0,accel=kvm,usb=off,dump-guest-core=off -cpu Haswell,-hle,-rtm -m 1024 -realtime mlock=off -smp 1,maxcpus=2,sockets=2,cores=1,threads=1 -uuid eeedcd47-1546-4e5f-ab2a-f62deb0838cf -display none -no-user-config -nodefaults -chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/domain-2-study01/monitor.sock,server,nowait -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew -global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 -boot strict=on -device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x4.0x7 -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x4 -device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x4.0x1 -device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x4.0x2 -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x5 -drive file=/kvm_data/study01.img,format=qcow2,if=none,id=drive-virtio-disk0 -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x6,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1 -drive if=none,id=drive-ide0-0-0,readonly=on -device ide-cd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0 -netdev tap,fd=25,id=hostnet0,vhost=on,vhostfd=27 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:65:d3:3f,bus=pci.0,addr=0x3 -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 -chardev socket,id=charchannel0,path=/var/lib/libvirt/qemu/channel/target/domain-2-study01/org.qemu.guest_agent.0,server,nowait -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_agent.0 -device usb-tablet,id=input0,bus=usb.0,port=1 -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x7 -msg timestamp=on
root       6534  0.0  0.0      0     0 ?        S    00:15   0:00 [kvm-pit/6528]
root       6687  0.0  0.0 112668   960 pts/1    S+   00:25   0:00 grep --color=auto kvm

使用以下命令可以列出当前有多少个虚拟机，以及其状态：

[root@localhost ~]# virsh list
 Id    Name                           State
----------------------------------------------------
 2     study01                        running



以上这个命令无法列出关机状态的虚拟机，需要列出关机状态的虚拟机需要加多一个--all参数：

[root@localhost ~]# virsh list --all
 Id    Name                           State
----------------------------------------------------
 2     study01                        running


查看虚拟机配置文件：

[root@localhost ~]# ls /etc/libvirt/qemu/
networks  study01.xml
[root@localhost ~]# ls /etc/libvirt/qemu/networks/
autostart  default.xml
[root@localhost ~]# ls /etc/libvirt/qemu/networks/autostart/
default.xml
[root@localhost ~]# 

以下介绍一下管理虚拟机的一些常用命令：

[root@localhost ~]# virsh console study01  # 进入指定的虚拟机，进入的时候还需要按一下回车
[root@localhost ~]# virsh start study01  # 启动虚拟机
[root@localhost ~]# virsh shutdown study01  # 关闭虚拟机
[root@localhost ~]# virsh destroy study01  # 强制停止虚拟机
[root@localhost ~]# virsh undefine study01  # 彻底销毁虚拟机，会删除虚拟机配置文件，但不会删除虚拟磁盘
[root@localhost ~]# virsh autostart study01  # 设置宿主机开机时该虚拟机也开机
[root@localhost ~]# virsh autostart --disable study01  # 解除开机启动
[root@localhost ~]# virsh suspend study01 # 挂起虚拟机
[root@localhost ~]# virsh resume study01 # 恢复挂起的虚拟机

进入到刚刚安装的虚拟机里配置一下IP：

[root@localhost ~]# virsh console study01
Connected to domain study01
Escape character is ^]


配置好ip后，yum安装一下网络管理工具

yum install -y net-tools  # 获取到IP能联网后安装网络管理工具





