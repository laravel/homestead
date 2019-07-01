#!/usr/bin/env bash

# Check if Openresty has been installed

if [ -f /home/vagrant/.homestead-features/openresty ]
then
    echo "Openresty already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/openresty
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

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
