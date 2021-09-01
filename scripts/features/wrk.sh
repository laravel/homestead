#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/wrk ]
then
    echo "wrk already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/wrk
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Wrk
sudo apt-get install -y build-essential libssl-dev git

git clone https://github.com/wg/wrk.git /tmp/wrk

cd /tmp/wrk && sudo make

sudo cp /tmp/wrk/wrk /usr/local/bin

sudo rm -rf /tmp/wrk
