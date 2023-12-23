#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/sonarqube ]
then
    echo "Sonarqube already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/sonarqube
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Java Runtime Enviroment
sudo apt update
sudo apt install unzip openjdk-17-jre -y

# Install Sonarqube
sudo mkdir /opt/sonarqube && cd /opt/sonarqube
sudo wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$1.zip
sudo unzip sonarqube-*.zip && sudo rm sonarqube-*.zip
sudo rm -rf /opt/sonarqube/sonarqube-$1.zip
