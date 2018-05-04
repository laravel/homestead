#!/usr/bin/env bash

# Check if Elasticsearch has been installed

if [ -f /home/vagrant/.elasticsearch ]
then
    echo "Elasticsearch already installed."
    exit 0
fi

touch /home/vagrant/.elasticsearch

# Determine version from config

set -- "$1"
IFS="."; declare -a version=($*)

if [ -z "${version[1]}" ]; then
    installVersion=""
else
    installVersion="=$1"
fi

# Install Java 8

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer

# Install Elasticsearch

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/${version[0]}.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-${version[0]}.x.list
sudo apt-get update
sudo apt-get -y install elasticsearch"$installVersion"

# Start Elasticsearch on boot

sudo update-rc.d elasticsearch defaults 95 10

# Update configuration to use 'homestead' as the cluster

sudo sed -i "s/#cluster.name: my-application/cluster.name: homestead/" /etc/elasticsearch/elasticsearch.yml

# Enable Start Elasticsearch

sudo systemctl enable elasticsearch.service
sudo service elasticsearch start
