#!/usr/bin/env bash

# Check if Openresty has been installed

if [ -f /home/vagrant/.openresty ]
then
    echo "Openresty already installed."
    exit 0
fi

touch /home/vagrant/.openresty
chown -Rf vagrant:vagrant /home/vagrant/.openresty

# Install Openresty

wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get install openresty

# Enable Start Openresty

sudo systemctl enable openresty.service
sudo service openresty start

