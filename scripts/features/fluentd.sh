#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/fluentd ]
then
    echo "fluentd already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/fluentd
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Fluentd
sudo apt-get update

curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-$(lsb_release -cs)-td-agent2.sh | sh

sudo systemctl enable td-agent.service
sudo systemctl restart td-agent.service
