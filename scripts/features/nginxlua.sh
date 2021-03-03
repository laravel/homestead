#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/nginxlua ]
then
    echo "nginx-module-lua already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/nginxlua
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo apt-get update

sudo apt-get install -y libnginx-mod-http-lua libnginx-mod-http-ndk nginx-common

sudo service nginx restart
