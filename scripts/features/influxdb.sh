#!/usr/bin/env bash

# Check If Influxdb Has Been Installed

if [ -f /home/vagrant/.homestead-features/influxdb ]
then
    echo "InfluxDB already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/influxdb
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

apt-get update
apt-get install -y influxdb
apt-get install -y influxdb-client
