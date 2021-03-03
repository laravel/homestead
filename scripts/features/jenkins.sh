#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/jenkins ]
then
    echo "jenkins already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/jenkins
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install jenkins
sudo apt-get update

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list.d/jenkins.list

sudo apt-get update

sudo apt-get install -y jenkins

sudo systemctl enable jenkins.service

sudo systemctl restart jenkins.service
