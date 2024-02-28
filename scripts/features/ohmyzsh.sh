#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/oh-my-zsh ]
then
    echo "oh-my-zsh already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/oh-my-zsh
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$WSL_USER_NAME/.oh-my-zsh
cp /home/$WSL_USER_NAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$WSL_USER_NAME/.zshrc

# Set theme and plugins according to config
if [ -n "${theme}" ]; then
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"${theme}\"/" /home/$WSL_USER_NAME/.zshrc
fi
if [ -n "${plugins}" ]; then
    sed -i "s/^plugins=.*/plugins=(${plugins})/" /home/$WSL_USER_NAME/.zshrc
fi

printf "\nemulate sh -c 'source ~/.bash_aliases'\n" | tee -a /home/$WSL_USER_NAME/.zprofile
printf "\nemulate sh -c 'source ~/.profile'\n" | tee -a /home/$WSL_USER_NAME/.zprofile
chown -R $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.oh-my-zsh
chown $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.zshrc
chown $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.zprofile
chsh -s /bin/zsh $WSL_USER_NAME
