#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/chronograf ]
then
    echo "chronograf already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/chronograf
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

chronourl="https://dl.influxdata.com/chronograf/releases/chronograf_1.5.0.1_amd64.deb"

wget -q -O chronograf.deb $chronourl
sudo dpkg -i chronograf.deb
rm chronograf.deb

systemctl enable chronograf
systemctl daemon-reload
systemctl start chronograf
