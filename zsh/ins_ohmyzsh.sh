#!/bin/bash

yum install zsh git -y  && \
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
chsh -s /bin/zsh && sleep 2&& \
sleep 3 && \
sed -i "s/ZSH_THEME=.*/ZSH_THEME=\"agnoster\"/g" /root/.zshrc 


