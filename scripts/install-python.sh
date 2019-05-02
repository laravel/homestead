#!/usr/bin/env bash

# Check If python Has Been Installed

if [ -f /home/vagrant/.pythontools ]
then
    echo "python already installed."
    exit 0
fi

touch /home/vagrant/.pythontools
chown -Rf vagrant:vagrant /home/vagrant/.pythontools

# Install Python

apt install -y python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv python-django
sudo -H -u vagrant bash -c 'pip3 install django'
sudo -H -u vagrant bash -c 'pip3 install numpy'
