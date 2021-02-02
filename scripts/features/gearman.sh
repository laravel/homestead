#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/gearman ]
then
    echo "gearman already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/gearman
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Gearman Job Server and PHP Extension
sudo apt-get update
sudo apt-get install gearman-job-server php-gearman -y

# Listen on 0.0.0.0
sudo sed -i 's/localhost/0.0.0.0/g' /etc/default/gearman-job-server
sudo service gearman-job-server restart
