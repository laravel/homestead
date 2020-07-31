#!/usr/bin/env bash

set -e

if [ -f /home/vagrant/.homestead-features/pythontools ]
then
    echo "pythontools already installed."
    exit 0
fi

apt-get update
apt-get install -y python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv python3-django
sudo -H -u vagrant bash -c 'pip3 install django'
sudo -H -u vagrant bash -c 'pip3 install numpy'
sudo -H -u vagrant bash -c 'pip3 install masonite'

sudo -g vagrant -u vagrant touch /home/vagrant/.homestead-features/pythontools
