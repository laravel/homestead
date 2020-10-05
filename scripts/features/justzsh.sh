#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/just-zsh ]
then
    echo "zsh already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/just-zsh
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

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

cat ZPLUG_CONFIG > /home/vagrant/.zshrc

