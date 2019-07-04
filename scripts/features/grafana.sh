#!/usr/bin/env bash

# Check If Grafana Has Been Installed

if [ -f /home/vagrant/.homestead-features/grafana ]
then
    echo "Grafana already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/grafana
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list
curl -s https://packages.grafana.com/gpg.key | apt-key add -

apt-get update -y
apt-get install -y grafana

systemctl enable grafana-server
systemctl daemon-reload
systemctl start grafana-server
