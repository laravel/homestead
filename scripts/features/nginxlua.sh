#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/nginxlua ]
then
    echo "nginxlua already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/nginxlua
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Nginx lua
sudo apt-get update
sudo apt-get install -y libnginx-mod-http-lua libnginx-mod-http-ndk nginx-common

sudo service nginx restart
