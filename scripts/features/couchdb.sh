#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/couchdb ]
then
    echo "CouchDB already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/couchdb
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

echo "deb https://apache.bintray.com/couchdb-deb bionic main" \
    | sudo tee -a /etc/apt/sources.list

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
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
