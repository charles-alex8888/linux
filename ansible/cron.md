# 添加一个定时任务
> ansible all -m cron -a 'minute="*/2" job="/usr/sbin/ntpdate ntp.aliyun.com" name="date" state="present"'
# 删除定时任务
> ansible all -m cron -a 'name=date state="absent"'


# 参数
~~~ 
name：计划任务的名称
minute：设置计划任务执行的分钟值（0-59)
hour：设置计划任务执行的小时值（0-23）
day：设置计划任务执行的日期值(1-31)
month：设置计划任务执行的月值(1-12)
weekday：设置计划任务执行的周值(0-6或者1-7)
special_time：后边可加：reboot（重启后）、yearly（每年）、monthly（每月）、weekly（每周）、daily（每天）、hourly（每小时）
user：设置当前计划任务属于哪个用户，如果不指定，默认为管理员用户。
job：用于指定计划任务中需要实际执行的命令或脚本
stata：设置计划任务的状态，present（添加）、absent（移除）。
disabled：当计划任务执行时，可以注释掉对应的任务。
backup：在修改或者删除计划任务的时，会对计划任务备份，然后进行更改或者删除。cron模块会在远程主机的/tmp/下创建备份文件
~~~ 
