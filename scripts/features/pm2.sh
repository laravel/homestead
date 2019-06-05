#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/pm2 ]
then
    echo "pm2 already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/pm2

# Install pm2

npm install -g pm2
