#!/usr/bin/env bash

# Check if Wrk has been installed

if [ -f /home/vagrant/.homestead-features/wrk ]
then
    echo "wrk already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/wrk
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo apt-get install -y build-essential libssl-dev git

git clone https://github.com/wg/wrk.git /tmp/wrk

cd /tmp/wrk && sudo make

sudo cp /tmp/wrk/wrk /usr/local/bin

sudo rm -rf /tmp/wrk
