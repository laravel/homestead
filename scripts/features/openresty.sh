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
curl -fsSL https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/openresty.gpg
echo "deb [signed-by=/etc/apt/keyrings/openresty.gpg] http://openresty.org/package/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/openresty.list

sudo apt-get update
sudo service nginx stop
sudo apt-get install -y openresty
sudo sed -i "s/listen\s*80;/listen\       8888;/g" /etc/openresty/nginx.conf

# Start Openresty

sudo service openresty restart
sudo service nginx start
