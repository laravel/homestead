#!/usr/bin/env bash

# Check If Influxdb Has Been Installed

if [ -f /home/vagrant/.influxdb ]
then
    echo "InfluxDB already installed."
    exit 0
fi

touch /home/vagrant/.influxdb

apt-get update
apt-get install -y influxdb
apt-get install -y influxdb-client
