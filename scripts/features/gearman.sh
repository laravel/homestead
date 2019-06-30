#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/gearman ]
then
    echo "gearman already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/gearman
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install Gearman Job Server and PHP Extension
sudo apt-get update
sudo apt-get install gearman-job-server php-gearman -y

# Listen on 0.0.0.0
sudo sed -i 's/localhost/0.0.0.0/g' /etc/default/gearman-job-server
sudo service gearman-job-server restart
