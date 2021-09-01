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
# zsh zplug
export ZPLUG_HOME=/home/vagrant/.zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME

# myzshrc
sudo ln -s /mnt/c/wsl/.myzshrc /home/vagrant/.myzshrc
printf "\nemulate sh -c 'source ~/.myzshrc'\n" | tee -a /home/vagrant/.zprofile
printf "\nemulate sh -c 'source ~/.profile'\n" | tee -a /home/vagrant/.zprofile

chown -R vagrant:vagrant /home/vagrant/.zsh
chown -R vagrant:vagrant /home/vagrant/.zplug
chown vagrant:vagrant /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zprofile
chsh -s /bin/zsh vagrant

ZPLUG_CONFIG="
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug 'dracula/zsh', as:theme
if ! zplug check --verbose; then
    echo; zplug install
fi
zplug load
"

echo "$ZPLUG_CONFIG" | sudo tee -a /home/vagrant/.zshrc
