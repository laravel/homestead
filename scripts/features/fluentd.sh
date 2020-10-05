#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/fluentd ]
then
    echo "Fluentd already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/fluentd
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo apt-get update

curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-$(lsb_release -cs)-td-agent2.sh | sh

sudo systemctl enable td-agent.service
sudo systemctl restart td-agent.service
