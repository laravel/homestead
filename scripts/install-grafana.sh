#!/usr/bin/env bash

# Check If Grafana Has Been Installed

if [ -f /home/vagrant/.grafana ]
then
    echo "Grafana already installed."
    exit 0
fi

touch /home/vagrant/.grafana

echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" > /etc/apt/sources.list.d/grafana.list
curl -s https://packagecloud.io/gpg.key | apt-key add -

apt-get update
apt-get install -y grafana

systemctl enable grafana-server
systemctl daemon-reload
systemctl start grafana-server
