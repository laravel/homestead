#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/openresty ]
then
    echo "openresty already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/openresty
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Openresty

wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
sudo apt-get update
sudo service nginx stop
sudo apt-get install -y openresty
sudo sed -i "s/listen\s*80;/listen\       8888;/g" /etc/openresty/nginx.conf

# Start Openresty

sudo service openresty restart
sudo service nginx start
