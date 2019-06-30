#!/usr/bin/env bash

# Check If python Has Been Installed

if [ -f /home/vagrant/.homestead-features/pythontools ]
then
    echo "python already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/pythontools
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install Python

apt install -y python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv python-django
sudo -H -u vagrant bash -c 'pip3 install django'
sudo -H -u vagrant bash -c 'pip3 install numpy'
