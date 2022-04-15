#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/justzsh ]
then
    echo "justzsh already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/justzsh
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install zsh
sudo cp /etc/zsh/newuser.zshrc.recommended /home/vagrant/.zshrc

# Setup zsh plugins
export ZSHPLUGINS_HOME=/home/vagrant/.zshplugins
git clone https://github.com/dracula/zsh.git $ZSHPLUGINS_HOME/dracula
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSHPLUGINS_HOME/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSHPLUGINS_HOME/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSHPLUGINS_HOME/zsh-history-substring-search

# myzshrc
sudo ln -s /mnt/c/wsl/.myzshrc /home/vagrant/.myzshrc
printf "\nemulate sh -c 'source ~/.myzshrc'\n" | tee -a /home/vagrant/.zprofile
printf "\nemulate sh -c 'source ~/.profile'\n" | tee -a /home/vagrant/.zprofile

chown -R vagrant:vagrant /home/vagrant/.zsh
chown -R vagrant:vagrant /home/vagrant/.zplug
chown vagrant:vagrant /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zprofile
chsh -s /bin/zsh vagrant

ZSHPLUGINS_CONFIG="
source $ZSHPLUGINS_HOME/dracula/dracula.zsh-theme
source $ZSHPLUGINS_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSHPLUGINS_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHPLUGINS_HOME/zsh-history-substring-search/zsh-history-substring-search.zsh
ZSH_THEME="dracula"
"

echo "$ZSHPLUGINS_CONFIG" | sudo tee -a /home/vagrant/.zshrc
