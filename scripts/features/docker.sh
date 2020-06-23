#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/docker ]
then
    echo "docker already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/docker
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install docker-ce
curl -fsSL https://get.docker.com | bash -s

# Enable vagrant user to run docker commands
usermod -aG docker vagrant

# Install docker-compose
curl \
    -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
