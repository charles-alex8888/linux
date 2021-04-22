
# 安装
~~~ bash
## yum
yum -y install git zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

## apt-get
apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
~~~

# 切换到 zsh
> chsh -s /bin/zsh

# 查看可用主题
> ls ~/.oh-my-zsh/themes

# 切换主题
> sed -i 's/ZSH_THEME="gnzh"/ZSH_THEME="steeef"/g'  .zshrc
