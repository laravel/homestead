#!/usr/bin/env bash

# Check if Elasticsearch has been installed

if [ -f /home/vagrant/.homestead-features/elasticsearch ]
then
    echo "Elasticsearch already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/elasticsearch
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Determine version from config

set -- "$1"
IFS=".";

if [ -z "${version}" ]; then
    installVersion="" # by not specifying we'll install latest
    majorVersion="7" # default to version 7
else
    installVersion="=$version"
    majorVersion="$(echo $version | head -c 1)"
fi


echo "Elasticsearch installVersion: $installVersion"
echo "Elasticsearch majorVersion: $majorVersion"


# Install Java & Elasticsearch

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/$majorVersion.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-$majorVersion.x.list

sudo apt-get update
sudo apt-get -y install openjdk-11-jre
sudo apt-get -y install elasticsearch"$installVersion"

# Start Elasticsearch on boot

sudo update-rc.d elasticsearch defaults 95 10

# Update configuration to use 'homestead' as the cluster

sudo sed -i "s/#cluster.name: my-application/cluster.name: homestead/" /etc/elasticsearch/elasticsearch.yml

# Enable Start Elasticsearch

sudo systemctl enable elasticsearch.service
sudo service elasticsearch start
