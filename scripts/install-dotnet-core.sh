#!/usr/bin/env bash

if [ -f /home/vagrant/.dotnetcore ]
then
    echo "DotNet Core utilities already installed."
    exit 0
fi

touch /home/vagrant/.dotnetcore
chown -Rf vagrant:vagrant /home/vagrant/.dotnetcore

# Install .net core

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get -y install apt-transport-https
sudo apt-get update
sudo apt-get -y install dotnet-sdk-2.1
sudo rm -rf packages-microsoft-prod.deb
