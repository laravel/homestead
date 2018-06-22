#!/usr/bin/env bash

# Check If Chronograf Has Been Installed

if [ -f /home/vagrant/.chronograf ]
then
    echo "Chronograf already installed."
    exit 0
fi

touch /home/vagrant/.chronograf

wget -q https://dl.influxdata.com/chronograf/releases/chronograf_1.5.0.1_amd64.deb
sudo dpkg -i chronograf_1.5.0.1_amd64.deb

systemctl enable chronograf
systemctl daemon-reload
systemctl start chronograf
