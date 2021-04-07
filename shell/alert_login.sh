chatID="-575723894"
token="1698400332:AAH0i4K-UJYPZHgSEQXpNRg9gNvF3MLOj9I"
curl -d "chat_id=$chatID&text=登陆主机`hostname`
用户     终端         时间                        登陆ip
who " "https://api.telegram.org/bot$token/sendMessage" >/dev/null 2>&1 &
