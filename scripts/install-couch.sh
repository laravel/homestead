#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.couch ]
then
    echo "CouchDB already installed."
    exit 0
fi

touch /home/vagrant/.couch

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:couchdb/stable

sudo apt-get update
sudo apt-get install -y couchdb

sudo chown -R couchdb:couchdb /usr/bin/couchdb /etc/couchdb /usr/share/couchdb
sudo chmod -R 0770 /usr/bin/couchdb /etc/couchdb /usr/share/couchdb

sudo sed -i "s/;bind_address =.*/bind_address = 0.0.0.0/" /etc/couchdb/local.ini

sudo systemctl restart couchdb

sudo service nginx restart

sudo service php7.1-fpm restart
sudo service php7.2-fpm restart
sudo service php7.3-fpm restart
