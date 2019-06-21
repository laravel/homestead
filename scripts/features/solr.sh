#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/solr ]
then
    echo "solr already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/solr
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install Java Runtime Enviroment
sudo apt update
sudo apt install default-jre php-solr -y

# Install Solr 7.7.1
wget -q http://archive.apache.org/dist/lucene/solr/7.7.1/solr-7.7.1.tgz
tar xzf solr-7.7.1.tgz solr-7.7.1/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-7.7.1.tgz 
rm solr-7.7.1.tgz install_solr_service.sh

# Install Homestead Core

sudo su -c "/opt/solr/bin/solr create -c homestead" solr
