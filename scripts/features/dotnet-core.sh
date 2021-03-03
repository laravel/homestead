#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/dotnetcore ]
then
    echo "dotnet core already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/dotnetcore
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install .net core

wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -qO /tmp/packages-microsoft-prod.deb
sudo dpkg -i /tmp/packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y dotnet-sdk-5.0
rm -rf /tmp/packages-microsoft-prod.deb
