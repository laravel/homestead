#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/couchdb ]
then
    echo "couchdb already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/couchdb
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

curl -fsSL https://couchdb.apache.org/repo/keys.asc | sudo gpg --dearmor -o /etc/apt/keyrings/couchdb.gpg
echo "deb [signed-by=/etc/apt/keyrings/couchdb.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ jammy main" | sudo tee /etc/apt/sources.list.d/couchdb.list

sudo apt-get update
echo "couchdb couchdb/mode select standalone
couchdb couchdb/mode seen true
couchdb couchdb/bindaddress string 127.0.0.1
couchdb couchdb/bindaddress seen true" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y couchdb

sudo chown -R couchdb:couchdb /etc/couchdb
sudo chmod -R 0770 /etc/couchdb

sudo sed -i "s/;bind_address =.*/bind_address = 0.0.0.0/" /opt/couchdb/etc/local.ini

sudo service couchdb restart

sudo service nginx restart

sudo service php5.6-fpm restart
sudo service php7.0-fpm restart
sudo service php7.1-fpm restart
sudo service php7.2-fpm restart
sudo service php7.3-fpm restart
sudo service php7.4-fpm restart
sudo service php8.0-fpm restart
