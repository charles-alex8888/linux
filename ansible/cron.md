# 添加一个定时任务
> ansible all -m cron -a 'minute="*/2" job="/usr/sbin/ntpdate ntp.aliyun.com" name="date" state="present"'
# 删除
> ansible all -m cron -a 'name=date state="absent"'
